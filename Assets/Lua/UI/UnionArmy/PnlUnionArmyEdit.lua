

PnlUnionArmyEdit = class("PnlUnionArmyEdit", ggclass.UIBase)

function PnlUnionArmyEdit:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onUpdateUnionData" }
end

PnlUnionArmyEdit.TYPE_WARSHIP = 1
PnlUnionArmyEdit.TYPE_HERO = 2
PnlUnionArmyEdit.TYPE_SOLDIER = 3

PnlUnionArmyEdit.SUB_ITEM_COUNT = 4

function PnlUnionArmyEdit:onAwake()
    self.view = ggclass.PnlUnionArmyEditView.new(self.pnlTransform)
    local view = self.view

    self.commonItemWarship = CommonItemItem.new(view.commonItemWarship)
    self.commonItemWarship:initInfo()
    self.commonItemItem = CommonItemItem.new(view.commonItemItem)
    self.commonItemItem:initInfo()

    self.commonHeroItem = CommonHeroItem.new(view.commonHeroItem)

    self.unionArmyEditItemList = {}
    for index, value in ipairs(view.unionArmyEditItemList) do
        local item = UnionArmyEditItem.new(value, self)
        item:setIndex(index)
        table.insert(self.unionArmyEditItemList, item)
    end

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))

    self.skillItemList = {}
    self.skillScrollView = UIScrollView.new(self.view.skillScrollView, "EditUnionArmySkillItem", self.skillItemList)
    self.skillScrollView:setRenderHandler(gg.bind(self.onRenderSkill, self))

    self.warshipItemList = {}
    self.warshipScrollView = UILoopScrollView.new(view.warshipScrollView, self.warshipItemList)
    self.warshipScrollView:setRenderHandler(gg.bind(self.onRenderWarship, self))

    self.heroItemList = {}
    self.heroScrollView = UILoopScrollView.new(view.heroScrollView, self.heroItemList)
    self.heroScrollView:setRenderHandler(gg.bind(self.onRenderHero, self))

    self.soldierItemList = {}
    self.soldierScrollView = UILoopScrollView.new(view.soldierScrollView, self.soldierItemList)
    self.soldierScrollView:setRenderHandler(gg.bind(self.onRenderSoldier, self))

    self.messageMap = {
        [PnlUnionArmyEdit.TYPE_WARSHIP] = {
            layout = view.layoutWarShip,
            func = gg.bind(self.refreshWarship, self),
        },

        [PnlUnionArmyEdit.TYPE_HERO] = {
            layout = view.layoutHero,
            func = gg.bind(self.refreshHero, self),
        },

        [PnlUnionArmyEdit.TYPE_SOLDIER] = {
            layout = view.layoutSoldier,
            func = gg.bind(self.refreshSoldier, self),
        },
    }
end

-- args = {data = , type = }
function PnlUnionArmyEdit:onShow()
    self:bindEvent()

    self.type = self.args.type

    if self.type == constant.UNION_TYPE_ARMY_UNION then
        UnionData.C2S_Player_StartEditUnionArmys()
        UnionData.C2S_Player_QueryUnionSoliders()
        UnionData.C2S_Player_QueryUnionNfts()
        UnionData.C2S_Player_QueryUnionTechs()
    end

    self.data = nil
    if self.args then
        self.data = gg.deepcopy(self.args.data)
    end

    self:refreshArmys()
    self:refreshWarshipInfo()
    self:refresh(PnlUnionArmyEdit.TYPE_WARSHIP, 0)

    -- self:refresh(PnlUnionArmyEdit.TYPE_SOLDIER, 0)
end

function PnlUnionArmyEdit:refreshArmys()
    self.data = self.data or {}
    self.data.battleArmy = self.data.battleArmy or {}
    self.data.battleArmy.teams = self.data.battleArmy.teams or {}

    for i = 1, 5, 1 do
        self.unionArmyEditItemList[i]:setData(self.data.battleArmy.teams[i])
    end
end

function PnlUnionArmyEdit:refreshWarshipInfo()
    if self.data.battleArmy.warShipId and self.data.battleArmy.warShipId > 0 then
        self.commonItemWarship:setActive(true)
        self.view.btnSetWarship:SetActiveEx(false)

        -- local warshipData = UnionData.unionData.items[self.data.battleArmy.warShipId]
        local warshipCfg = WarshipUtil.getWarshipCfg(self.data.warship.cfgId, self.data.warship.quality, self.data.warship.level)

        -- self.commonItemWarship:setIcon()
        self.commonItemWarship:setIcon(string.format("Warship_A_Atlas[%s]", warshipCfg.icon .. "_A"))
        self.commonItemWarship:setQuality(self.data.warship.quality)
    else
        self.commonItemWarship:setActive(false)
        self.view.btnSetWarship:SetActiveEx(true)
        -- self.commonItemWarship:setIcon(false)
        -- self.commonItemWarship:setQuality(0)
    end
end

function PnlUnionArmyEdit:refresh(armyType, editArmyIndex)
    self.armyType = armyType
    self.editArmyIndex = editArmyIndex or 0
    self:setSubInfo(nil)

    for key, value in pairs(self.view.titlesMap) do
        if key == armyType then
            value.imgSelect:SetActiveEx(true)
            value.txtSelect.gameObject:SetActiveEx(true)
            value.txtBtn.gameObject:SetActiveEx(false)
        else
            value.imgSelect:SetActiveEx(false)
            value.txtSelect.gameObject:SetActiveEx(false)
            value.txtBtn.gameObject:SetActiveEx(true)
        end
    end

    for key, value in pairs(self.messageMap) do
        if key == armyType then
            value.layout:SetActiveEx(true)
            value.func()
        else
            value.layout:SetActiveEx(false)
        end
    end
end

function PnlUnionArmyEdit:onUpdateUnionData()
    if self.type == constant.UNION_TYPE_ARMY_UNION then
        self:refresh(self.armyType, self.editArmyIndex)
    end
end

function PnlUnionArmyEdit:setSubInfo(data)
    local view = self.view
    self.subArmyInfo = data

    if not data then
        view.layoutInfo:SetActiveEx(false)
        return
    end

    view.layoutInfo:SetActiveEx(true)
    view.layoutSkills:SetActiveEx(false)

    self.commonItemItem:setActive(false)
    self.commonHeroItem:setActive(false)

    if self.armyType == PnlUnionArmyEdit.TYPE_SOLDIER then
        local subCfg = SoliderUtil.getSoliderCfgMap()[data.cfgId][data.level]
        view.txtInfoName.text = Utils.getText(subCfg.languageNameID)
        view.txtInfoLevel.text = data.level
        self.attrDataList = constant.SOLDIER_SHOW_ATTR
        self.attrMap = subCfg
        self.attrScrollView:setItemCount(#self.attrDataList)

        self.commonHeroItem:setActive(true)
        self.commonHeroItem:setIcon("Soldier_A_Atlas", subCfg.icon)
        self.commonHeroItem:setQuality(0)

        for key, value in pairs(self.soldierItemList) do
            value:refreshSelect()
        end

    elseif self.armyType == PnlUnionArmyEdit.TYPE_HERO then
        view.layoutSkills:SetActiveEx(true)

        local subCfg = HeroUtil.getHeroCfgMap()[data.cfgId][data.quality][data.level]
        view.txtInfoName.text = Utils.getText(subCfg.languageNameID)

        view.txtInfoLevel.text = data.level

        self.commonHeroItem:setActive(true)
        self.commonHeroItem:setIcon("Hero_A_Atlas", subCfg.icon)
        self.commonHeroItem:setQuality(0)

        self.attrDataList = constant.HERO_SHOW_ATTR
        self.attrMap = subCfg
        self.attrScrollView:setItemCount(#self.attrDataList)

        self.skillDataList = {}
        for i = 1, 3, 1 do
            local skillId = data["skill" .. i]
            local skillLevel = data["skillLevel" .. i]
            if skillId and skillId > 0 then
                table.insert(self.skillDataList, {cfgId = skillId, level = skillLevel, index = i})
            end
        end
        self.skillScrollView:setItemCount(#self.skillDataList)

        for key, value in pairs(self.heroItemList) do
            value:refreshSelect()
        end

    elseif self.armyType == PnlUnionArmyEdit.TYPE_WARSHIP then
        view.layoutSkills:SetActiveEx(true)

        local warshipCfg = WarshipUtil.getWarshipCfg(data.cfgId, data.quality, data.level)

        self.commonItemItem:setActive(true)
        self.commonItemItem:setIcon(string.format("Warship_A_Atlas[%s]", warshipCfg.icon .. "_A"))
        self.commonItemItem:setQuality(data.quality)
        view.txtInfoName.text = Utils.getText(warshipCfg.languageNameID)

        view.txtInfoLevel.text = data.level

        self.attrDataList = {
            cfg.attribute.power,
            cfg.attribute.skillPoint,
            cfg.attribute.tonnage,
            cfg.attribute.flyTime,
        }
        self.attrMap = warshipCfg
        self.attrScrollView:setItemCount(#self.attrDataList)

        self.skillDataList = {}
        for i = 1, 5, 1 do
            local skillId = data["skill" .. i]
            local skillLevel = data["skillLevel" .. i]
            if skillId and skillId > 0 then
                table.insert(self.skillDataList, {cfgId = skillId, level = skillLevel, index = i})
            end
        end
        self.skillScrollView:setItemCount(#self.skillDataList)

        for key, value in pairs(self.warshipItemList) do
            value:refreshSelect()
        end
    end
end

function PnlUnionArmyEdit:onRenderHeroAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    -- local attrShowType = item:setAttrShowType(CommonAttrItem.TYPE_NORMAL)
    -- if self.showingType == PnlHeroHut.SHOWING_TYPE_INFO then
    --     attrShowType = CommonAttrItem.TYPE_SINGLE_TEXT
    -- end
    item:setData(index, self.attrDataList, self.attrMap)
end

function PnlUnionArmyEdit:onRenderSkill(obj, index)
    local item = EditUnionArmySkillItem:getItem(obj, self.skillItemList)
    item:setData(self.skillDataList[index])
end

function PnlUnionArmyEdit:onBtnQuickEdit()

end

-- warhsip
function PnlUnionArmyEdit:refreshWarship()
    self.warshowDataList = {}

    if self.type == constant.UNION_TYPE_ARMY_UNION then
        if UnionData.unionData.items then
            for key, value in pairs(UnionData.unionData.items) do
                if value.itemType == constant.ITEM_ITEMTYPE_WARSHIP and value.ref == 4 then
                    local warship = {
                        id = value.id,
                        cfgId = value.cfgId,
                        level = value.level,
                        quality = value.quality,
                    }
    
                    for i = 1, 5 do
                        local skillKey = "skill" .. i
                        local skillLevelKey = "skillLevel" .. i
                        warship[skillKey] = value[skillKey]
                        warship[skillLevelKey] = value[skillLevelKey]
                    end
    
                    table.insert(self.warshowDataList, warship)
                end
            end
        end
    elseif self.type == constant.UNION_TYPE_ARMY_SELF then
        for key, value in pairs(WarShipData.warShipData) do
            if value.ref == constant.REF_NONE then
                table.insert(self.warshowDataList, value)
            end
        end
    end

    local dataCount = math.ceil(#self.warshowDataList / PnlUnionArmyEdit.SUB_ITEM_COUNT)
    self.warshipScrollView:setDataCount(dataCount)
end

function PnlUnionArmyEdit:onRenderWarship(obj, index)
    for i = 1, PnlUnionArmyEdit.SUB_ITEM_COUNT, 1 do
        local subObj = obj.transform:GetChild(i - 1)
        local item = UnionArmyWarshipItem:getItem(subObj, self.warshipItemList, self)
        local subIndex = (index - 1) * PnlUnionArmyEdit.SUB_ITEM_COUNT + i
        item:setData(self.warshowDataList[subIndex])
    end
end

-- hero
function PnlUnionArmyEdit:refreshHero()
    self.heroDataList = {}

    if self.type == constant.UNION_TYPE_ARMY_UNION then
        if UnionData.unionData.items then
            for _, value in pairs(UnionData.unionData.items) do
                if value.itemType == constant.ITEM_ITEMTYPE_HERO and value.ref == 4 then
                    local hero = {
                        id = value.id,
                        cfgId = value.cfgId,
                        level = value.level,
                        quality = value.quality,
                    }

                    for i = 1, 3 do
                        local skillKey = "skill" .. i
                        local skillLevelKey = "skillLevel" .. i
                        hero[skillKey] = value[skillKey]
                        hero[skillLevelKey] = value[skillLevelKey]
                    end
                    table.insert(self.heroDataList, hero)
                end
            end
        end
    elseif self.type == constant.UNION_TYPE_ARMY_SELF then
        for _, value in pairs(HeroData.heroDataMap) do
            if value.ref == constant.REF_NONE then
                table.insert(self.heroDataList, value)
            end
        end
    end

    local dataCount = math.ceil(#self.heroDataList / PnlUnionArmyEdit.SUB_ITEM_COUNT)
    self.heroScrollView:setDataCount(dataCount)
end

function PnlUnionArmyEdit:onRenderHero(obj, index)
    for i = 1, PnlUnionArmyEdit.SUB_ITEM_COUNT, 1 do
        local subObj = obj.transform:GetChild(i - 1)
        local item = UnionArmyHeroItem:getItem(subObj, self.heroItemList, self)
        local subIndex = (index - 1) * PnlUnionArmyEdit.SUB_ITEM_COUNT + i
        item:setData(self.heroDataList[subIndex])
    end
end

-- soldier
function PnlUnionArmyEdit:refreshSoldier()
    self.soldierDataList = {}

    if self.type == constant.UNION_TYPE_ARMY_UNION then
        if UnionData.unionData.soliders then
            for key, value in pairs(UnionData.unionData.soliders) do

                local soldierCfg = SoliderUtil.getSoliderCfgMap()[value.cfgId][value.level]
                if soldierCfg.belong == 2 then
                    local soldier = {
                        level = value.level,
                        cfgId = value.cfgId,
                    }
                    table.insert(self.soldierDataList, soldier)
                end
            end
        end
    elseif self.type == constant.UNION_TYPE_ARMY_SELF then

        for key, value in pairs(BuildData.buildData) do
            if value.cfgId == constant.BUILD_LIBERATORSHIP and value.soliderCfgId > 0 then
                local soldierData = BuildData.soliderLevelData[value.soliderCfgId]

                local soldier = {
                    level = soldierData.level,
                    cfgId = value.soliderCfgId,
                    build = value,
                }

                table.insert(self.soldierDataList, soldier)
            end
        end

        -- for _, value in pairs(BuildData.soliderLevelData) do
        --     table.insert(self.soldierDataList, value)
        -- end
    end

    local dataCount = math.ceil(#self.soldierDataList / PnlUnionArmyEdit.SUB_ITEM_COUNT)
    self.soldierScrollView:setDataCount(dataCount)
end

function PnlUnionArmyEdit:onRenderSoldier(obj, index)
    for i = 1, PnlUnionArmyEdit.SUB_ITEM_COUNT, 1 do
        
        local subObj = obj.transform:GetChild(i - 1)
        local item = UnionArmySoldierItem:getItem(subObj, self.soldierItemList, self)
        local subIndex = (index - 1) * PnlUnionArmyEdit.SUB_ITEM_COUNT + i
        item:setData(self.soldierDataList[subIndex])
    end
end

---------------------------------------------------------

function PnlUnionArmyEdit:onHide()
    self:releaseEvent()

end

function PnlUnionArmyEdit:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnRealLevel):SetOnClick(function()
        self:onBtnRealLevel()
    end)
    CS.UIEventHandler.Get(view.btnUse):SetOnClick(function()
        self:onBtnUse()
    end)

    self:setOnClick(view.commonItemWarship.gameObject, gg.bind(self.refresh, self, PnlUnionArmyEdit.TYPE_WARSHIP, 0))
    self:setOnClick(view.btnSetWarship.gameObject, gg.bind(self.refresh, self, PnlUnionArmyEdit.TYPE_WARSHIP, 0))
    self:setOnClick(view.btnClose, gg.bind(self.close, self))

    self:setOnClick(view.btnQuickEdit, gg.bind(self.onBtnQuickEdit, self))
    self:setOnClick(view.btnSave, gg.bind(self.onBtnSave, self))
end

function PnlUnionArmyEdit:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnRealLevel)
    CS.UIEventHandler.Clear(view.btnUse)
end

function PnlUnionArmyEdit:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    self.soldierScrollView:release()
    self.warshipScrollView:release()
    self.heroScrollView:release()
    self.commonItemWarship:release()
    self.commonItemItem:release()
    self.skillScrollView:release()
    self.commonHeroItem:release()

    for key, value in pairs(self.unionArmyEditItemList) do
        value:release()
    end
end

function PnlUnionArmyEdit:onBtnClose()
    self:close()
end

function PnlUnionArmyEdit:onBtnRealLevel()

end

function PnlUnionArmyEdit:onBtnUse()
    -- self.data = self.data or {}
    -- self.data.battleArmy = self.data.battleArmy or {}
    -- self.data.battleArmy.teams = self.data.battleArmy.teams or {}
    self.data.battleArmy.teams[self.editArmyIndex] = self.data.battleArmy.teams[self.editArmyIndex] or {}
    if self.armyType == PnlUnionArmyEdit.TYPE_SOLDIER then
        local lessCount = 0
        local isCanUsed = true

        if self.type == constant.UNION_TYPE_ARMY_UNION then
            lessCount = UnionUtil.getUnionSoldierLessCount(self.subArmyInfo.cfgId, self.data)
        else
            lessCount, isCanUsed = UnionUtil.getSelfSoldierLessCount(self.subArmyInfo, self.data)
        end

        if lessCount <= 0 then
            gg.uiManager:showTip("not enought soldier")
            return
        end

        if not isCanUsed then
            gg.uiManager:showTip("used")
            return
        end

        local team = self.data.battleArmy.teams[self.editArmyIndex]

        local space = UnionUtil.getUnionArmySoldierSpace(team.heroId, self.type)
        local soldierCfg = SoliderUtil.getSoliderCfgMap()[self.subArmyInfo.cfgId][self.subArmyInfo.level]
        local maxCount = math.floor(space / soldierCfg.trainSpace)

        team.solider = self.subArmyInfo
        team.soliderCfgId = self.subArmyInfo.cfgId
        -- team.soliderCount = self.subArmyInfo.count
        team.soliderCount = math.min(lessCount, maxCount)
        self.unionArmyEditItemList[self.editArmyIndex]:setData(team)

    elseif self.armyType == PnlUnionArmyEdit.TYPE_HERO then
        if UnionUtil.checkHeroUsed(self.subArmyInfo.id, self.data) then
            return
        end
        self.data.battleArmy.teams[self.editArmyIndex].heroId = self.subArmyInfo.id
        self.data.battleArmy.teams[self.editArmyIndex].hero = self.subArmyInfo
        self.unionArmyEditItemList[self.editArmyIndex]:setData(self.data.battleArmy.teams[self.editArmyIndex])

    elseif self.armyType == PnlUnionArmyEdit.TYPE_WARSHIP then
        if UnionUtil.checkWarshipUsed(self.subArmyInfo.id, self.data) then
            return
        end

        self.data.battleArmy.warShipId = self.subArmyInfo.id
        self.data.warship = self.subArmyInfo

        self:refreshWarshipInfo()
    end

    self:refresh(self.armyType, self.editArmyIndex)
end

function PnlUnionArmyEdit:onBtnSave()
    -- UnionData.updateUnionArmy(self.data)

    for key, value in pairs(self.data.battleArmy.teams) do
        if value.heroId and value.heroId > 0 or value.soliderCfgId and value.soliderCfgId > 0 then
            UnionData.updateUnionArmy(self.data)
            self:close()
            return
        end
    end

    gg.uiManager:showTip("set a hero or soldier first")


    -- if self.data.battleArmy.warShipId and self.data.battleArmy.warShipId > 0 then
    --     for key, value in pairs(self.data.battleArmy.teams) do
    --         if value.heroId and value.heroId > 0 then
    --             UnionData.updateUnionArmy(self.data)
    --             self:close()
    --             return
    --         end
    --     end
    --     gg.uiManager:showTip("set a hero first")
    -- else
    --     gg.uiManager:showTip("set a warship first")
    -- end
end

return PnlUnionArmyEdit