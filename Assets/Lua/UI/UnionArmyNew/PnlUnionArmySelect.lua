

PnlUnionArmySelect = class("PnlUnionArmySelect", ggclass.UIBase)

function PnlUnionArmySelect:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onUpdateUnionData", "onUpdateUnionNft" }
end

PnlUnionArmySelect.TYPE_SELECT_UNION_HERO = 1
PnlUnionArmySelect.TYPE_SELECT_UNION_SOLDIER = 2

function PnlUnionArmySelect:onAwake()
    self.view = ggclass.PnlUnionArmySelectView.new(self.pnlTransform)
    self.commonHeroItem = CommonHeroItem.new(self.view.commonHeroItem)

    self.itemList = {}
    self.scrollView = UILoopScrollView.new(self.view.scrollView, self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

    self.skillItemList = {}

    for i = 1, 3, 1 do
        -- local skillTrans = 
        local item = {}
        item.transform = self.view.layoutSkills:GetChild(i - 1)
        item.commonNormalItem = CommonNormalItem.new(item.transform:Find("CommonNormalItem"))
        self.skillItemList[i] = item
    end

    self.commonfilterBox = CommonfilterBox.new(self.view.commonfilterBox)

    self.commonfilterBox:setFilterCB(gg.bind(self.onFilter, self))
end

-- args = {selectType = , useCallBack = , removeCallBack = , teamData = }
function PnlUnionArmySelect:onShow()
    self:bindEvent()

    if self.args.selectType == PnlUnionArmySelect.TYPE_SELECT_UNION_HERO then
        UnionData.C2S_Player_QueryUnionNfts()
        self.commonfilterBox:setData({CommonfilterBox.QualityData, CommonfilterBox.RaceData})

    elseif self.args.selectType == PnlUnionArmySelect.TYPE_SELECT_UNION_SOLDIER then
        UnionData.C2S_Player_QueryUnionSoliders()
        self.commonfilterBox:setData({CommonfilterBox.RaceData})
    end

    -- self:refresh()
end

function PnlUnionArmySelect:onFilter(filterMap)
    -- gg.printData(filterMap)

    self.filterMap = filterMap
    self:refresh()
end

function PnlUnionArmySelect:refresh()
    self.dataList = {}

    self:setSelect(nil)
    local removeData = nil

    if self.args.selectType == PnlUnionArmySelect.TYPE_SELECT_UNION_HERO then
        if UnionData.unionData.items then
            for key, value in pairs(UnionData.unionData.items) do
                if value.itemType == constant.ITEM_ITEMTYPE_HERO then
                    if UnionArmyUtil.checkHero(value) then
                        local heroCfg = HeroUtil.getHeroCfg(value.cfgId, value.level, value.quality)
                        if value.id == self.args.teamData.heroId then
                            removeData = {itemType = UnionArmySelectItem.TYPE_HERO, hero = value}
                        else
                            if not self:checkFilter(heroCfg) then
                                table.insert(self.dataList, {itemType = UnionArmySelectItem.TYPE_HERO, hero = value})
                            end
                        end
                    end
                end
            end
        end

        table.sort(self.dataList, function (a, b)
            return a.hero.quality > b.hero.quality
        end)

    elseif self.args.selectType == PnlUnionArmySelect.TYPE_SELECT_UNION_SOLDIER then
        for key, value in pairs(UnionData.unionData.soliders) do
            if value.level > 0 and Utils.checkUnionsloiderDefenseWhiteList(1, value.cfgId) then

                local soldierCfg = SoliderUtil.getSoliderCfgMap()[value.cfgId][1]
                if value.cfgId == self.args.teamData.soliderCfgId then
                    removeData = {itemType = UnionArmySelectItem.TYPE_SOLDIER, soldier = value}
                else
                    if not self:checkFilter(soldierCfg) then
                        table.insert(self.dataList, {itemType = UnionArmySelectItem.TYPE_SOLDIER, soldier = value})
                    end
                end
            end
        end
    end

    if removeData then
        table.insert(self.dataList, 1, removeData)
    end

    local itemCount = math.ceil(#self.dataList / 4)
    self.scrollView:setDataCount(itemCount)
end

function PnlUnionArmySelect:checkFilter(cfg)
    local isFilter = false

    for _, value in pairs(self.filterMap) do
        if value.filterAttr then
            for k, v in pairs(value.filterAttr) do
                if cfg[k] ~= v then
                    isFilter = true
                end
            end
        end
    end

    return isFilter
end

function PnlUnionArmySelect:setSelect(data)
    local view = self.view
    self.selectingData = data

    for key, value in pairs(self.itemList) do
        value:refreshSelect()
    end

    if not self.selectingData then
        view.layoutInfo:SetActiveEx(false)
        return
    end

    view.layoutInfo:SetActiveEx(true)

    local quality = 0
    local atlas
    local icon
    local name

    view.layoutSkills:SetActiveEx(false)
    view.btnUse:SetActiveEx(true)

    if self.selectingData.itemType == UnionArmySelectItem.TYPE_HERO then
        view.layoutSkills:SetActiveEx(true)

        local heroData = data.hero
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
        atlas = "Hero_A_Atlas"
        icon = heroCfg.icon

        name = Utils.getText(heroCfg.languageNameID)

        self.attrList = constant.HERO_SHOW_ATTR
        self.attrCfg = heroCfg
        for i = 1, 3, 1 do
            local item = self.skillItemList[i]

            local skillCfgId = data.hero["skill" .. i]
            local skillLevel = data.hero["skillLevel" .. i]

            if skillCfgId and skillCfgId > 0 then
                local skillCfg = SkillUtil.getSkillCfgMap()[skillCfgId][skillLevel]
                item.commonNormalItem:setQuality(skillCfg.quality)
                item.commonNormalItem:setIcon(string.format("Skill_A1_Atlas[%s_A1]", skillCfg.icon))
            else
                item.commonNormalItem:reset()
            end
        end

        local isInArmy, index, army = UnionArmyUtil.checkHeroUsed(data.hero.id)

        if isInArmy then
            view.btnUse:SetActiveEx(false)
        end

    elseif self.selectingData.itemType == UnionArmySelectItem.TYPE_SOLDIER then
        local soldierData = data.soldier
        local soldierCfg = SoliderUtil.getSoliderCfgMap()[soldierData.cfgId][soldierData.level]

        atlas = "Soldier_A_Atlas"
        icon = soldierCfg.icon
        quality = 0
        name = Utils.getText(soldierCfg.languageNameID)

        self.attrList = constant.INSTITUE_SOLDIER_SHOW_ATTR
    end

    self.commonHeroItem:setQuality(quality)
    self.commonHeroItem:setIcon(atlas, icon)

    view.txtName.text = name

    self.attrScrollView:setItemCount(#self.attrList)
end

function PnlUnionArmySelect:remove()
    if self.args.removeCallBack then
        self.args.removeCallBack()
        self:close()
    end
end

function PnlUnionArmySelect:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)

    item:setData(index, self.attrList, self.attrCfg)
end

function PnlUnionArmySelect:onRenderItem(obj, index)
    for i = 1, 4, 1 do
        local idx = (index - 1) * 4 + i
        local item = UnionArmySelectItem:getItem(obj.transform:GetChild(i - 1), self.itemList, self)
        item:setData(self.dataList[idx])
    end
end

function PnlUnionArmySelect:onUpdateUnionData(_ , dataType, subDataType)
    if subDataType == PnlUnion.WAREHOUSE_SOLIDIER then
        if self.args.selectType == PnlUnionArmySelect.TYPE_SELECT_UNION_SOLDIER then
            self:refresh()
        end

    -- elseif subDataType == PnlUnion.WAREHOUSE_NFT then
    --     if self.args.selectType == PnlUnionArmySelect.TYPE_SELECT_UNION_HERO then
    --         self:refresh()
    --     end
    end
end

function PnlUnionArmySelect:onUpdateUnionNft()
    if self.args.selectType == PnlUnionArmySelect.TYPE_SELECT_UNION_HERO then
        self:refresh()
    end
end

function PnlUnionArmySelect:onHide()
    self:releaseEvent()

end

function PnlUnionArmySelect:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnUse):SetOnClick(function()
        self:onBtnUse()
    end)
end

function PnlUnionArmySelect:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnUse)

end

function PnlUnionArmySelect:onDestroy()
    local view = self.view
    self.commonHeroItem:release()
    self.scrollView:release()

    for key, value in pairs(self.skillItemList) do
        value.commonNormalItem:release()
    end

    self.commonfilterBox:release()
end

function PnlUnionArmySelect:onBtnClose()
    self:close()
end

function PnlUnionArmySelect:onBtnUse()
    if self.args.useCallBack then
        self.args.useCallBack(self.selectingData)
        self:close()
    end
end

-----------------------------------------------------------

UnionArmySelectItem = UnionArmySelectItem or class("UnionArmySelectItem", ggclass.UIBaseItem)

function UnionArmySelectItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function UnionArmySelectItem:onInit()
    self.layoutSelect = self:Find("LayoutSelect").transform

    self:setOnClick(self.layoutSelect.gameObject, gg.bind(self.onClickSelect, self))
    self.imgSelect = self:Find("LayoutSelect/ImgSelect")
    self.commonHeroItem = CommonHeroItem.new(self.layoutSelect:Find("CommonHeroItem"))

    self.bgIndex = self:Find("LayoutSelect/BgIndex")
    self.txtIndex = self:Find("LayoutSelect/BgIndex/TxtIndex", UNITYENGINE_UI_TEXT)

    self.layoutRemove = self:Find("LayoutRemove")
    self:setOnClick(self.layoutRemove.gameObject, gg.bind(self.onClickRemove, self))
end

UnionArmySelectItem.TYPE_HERO = 1
UnionArmySelectItem.TYPE_SOLDIER = 2

function UnionArmySelectItem:setData(data)
    self.data = data

    if not data then
        self.gameObject:SetActiveEx(false)
        return
    end

    self:refreshSelect()

    self.layoutRemove:SetActiveEx(false)
    self.layoutSelect:SetActiveEx(false)

    self.gameObject:SetActiveEx(true)
    self.bgIndex:SetActiveEx(false)

    local quality = 0
    local atlas
    local icon

    local teamData = self.initData.args.teamData

    if data.itemType == UnionArmySelectItem.TYPE_HERO then
        local heroData = data.hero
        if teamData.heroId == heroData.id then
            self.layoutRemove:SetActiveEx(true)
            return
        end

        self.layoutSelect:SetActiveEx(true)
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
        atlas = "Hero_A_Atlas"
        icon = heroCfg.icon
        quality = heroData.quality

        local isInArmy, index, army = UnionArmyUtil.checkHeroUsed(data.hero.id)

        if isInArmy then
            self.bgIndex:SetActiveEx(true)
            self.txtIndex.text = index
        end
    elseif data.itemType == UnionArmySelectItem.TYPE_SOLDIER then
        local soldierData = data.soldier

        if teamData.soliderCfgId == soldierData.cfgId then
            self.layoutRemove:SetActiveEx(true)
            return
        end

        self.layoutSelect:SetActiveEx(true)
        
        local soldierCfg = SoliderUtil.getSoliderCfgMap()[soldierData.cfgId][soldierData.level]

        atlas = "Soldier_A_Atlas"
        icon = soldierCfg.icon
        quality = 0
    end

    self.commonHeroItem:setQuality(quality)
    self.commonHeroItem:setIcon(atlas, icon)
end

function UnionArmySelectItem:refreshSelect()
    if self.data then
        self.imgSelect:SetActiveEx(self.initData.selectingData == self.data)
    end
end

function UnionArmySelectItem:onClickSelect()
    self.initData:setSelect(self.data)
end

function UnionArmySelectItem:onClickRemove()
    self.initData:remove()
end

function UnionArmySelectItem:onRelease()
    self.commonHeroItem:release()
end

return PnlUnionArmySelect