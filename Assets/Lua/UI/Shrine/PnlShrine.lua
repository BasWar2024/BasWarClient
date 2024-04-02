

PnlShrine = class("PnlShrine", ggclass.UIBase)

function PnlShrine:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onSanctuaryHerosChange", "onFingerUp" }
end

function PnlShrine:onAwake()
    self.view = ggclass.PnlShrineView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "ShrineItems", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))


    self.selectItemList = {}
    self.selectScrollView = UIScrollView.new(self.view.selectScrollView, "ShrineSelectItems", self.selectItemList)
    self.selectScrollView:setRenderHandler(gg.bind(self.onRenderSelectItem, self))

    self.buildingBoundItemList = {}
    self.buildingBoundScrollView = UIScrollView.new(self.view.buildingBoundScrollView, "ShrineBuildingBoundItem", self.buildingBoundItemList)
    self.buildingBoundScrollView:setRenderHandler(gg.bind(self.onRenderbuildingBoundItem, self))
end

local itemCount = 5

-- args = {buildId = }
function PnlShrine:onShow()
    self:bindEvent()

    self.buildId = self.args.buildId

    self:showSelect(false)
    self:refresh()
    self.buildingBoundScrollView:setItemCount(#cfg.ShrineBuildingBoundsDesc)
end

function PnlShrine:onBtnDesc()
    self.view.boxDesc:SetActiveEx(true)
end

function PnlShrine:onBtnDescBuilding()
    self.view.boxDescBuilding:SetActiveEx(true)
end

function PnlShrine:onFingerUp()
    self.view.boxDesc:SetActiveEx(false)
    self.view.boxDescBuilding:SetActiveEx(false)
end

function PnlShrine:onRenderbuildingBoundItem(obj, index)
    local item = ShrineBuildingBoundItem:getItem(obj, self.buildingBoundItemList)
    item:setData(index)
end

function PnlShrine:refresh()
    self.buildData = BuildData.buildData[self.buildId]
    self.buildCfg = BuildUtil.getCurBuildCfg(self.buildData.cfgId, self.buildData.level, self.buildData.quality)
    self.maxCount = 0

    for key, value in pairs(BuildUtil.getBuildCfgMap()[self.buildData.cfgId][self.buildData.quality]) do
        if value.cfgId == constant.BUILD_SHRINE and value.heroNum > self.maxCount then
            self.maxCount = value.heroNum
        end
    end

    local count = math.ceil(self.maxCount / itemCount)
    self.scrollView:setItemCount(count)

    local shrineData = ShrineData.ShrineMap[self.buildId]
    -- shrineData = ShrineData.ShrineMap[0]

    local addAtk = 0
    local addHp = 0
    for key, value in pairs(shrineData.data) do
        local heroData = HeroData.heroDataMap[value.id]
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
        addAtk = addAtk + heroCfg.atk
        addHp = addHp + heroCfg.maxHp
    end

    self.view.txtAddAtk.text = math.floor(addAtk / 1000 * self.buildCfg.translationRatio)
    self.view.txtAddBlood.text = math.floor(addHp * self.buildCfg.translationRatio)
    self.view.txtRatio.text = self.buildCfg.translationRatio * 100 .. "%"
end

function PnlShrine:onSanctuaryHerosChange()
    self:refresh()
end

function PnlShrine:onRenderItem(obj, index)
    for i = 1, itemCount do
        local idx = (index - 1) * itemCount + i
        local item = ShrineItem:getItem(obj.transform:GetChild(i - 1), self.itemList, self)
        item:setData(idx, self.maxCount, self.buildData, self.buildCfg)
    end
end

local selectItemCount = 5
function PnlShrine:showSelect(isShow, selectIndex)
    self.selectingIndex = selectIndex

    if not isShow then
        self.view.layoutSelect:SetActiveEx(false)
        return
    end

    local shrineData = ShrineData.ShrineMap[self.buildId]

    self.view.layoutSelect:SetActiveEx(true)
    self.selectDataList = {}

    for key, value in pairs(HeroData.heroDataMap) do
        -- if value.ref == constant.REF_NONE then
            -- local heroCfg = HeroUtil.getHeroCfg(value.cfgId, value.level, value.quality)

            local isSet = true
            for _, shrineHero in pairs(shrineData.data) do
                if shrineHero.id == value.id then
                    isSet = false
                    break
                end
            end

            if isSet then
                table.insert( self.selectDataList, value)
            end
        -- end
    end

    table.sort( self.selectDataList, function (a, b)
        if a.level ~= b.level then
            return a.level > b.level
        end

        if a.quality ~= b.quality then
            return a.quality > b.quality
        end

        return a.id > b.id
    end)

    local count = math.ceil(#self.selectDataList / selectItemCount)
    self.selectScrollView:setItemCount(count)
end

function PnlShrine:onRenderSelectItem(obj, index)
    for i = 1, selectItemCount do
        local idx = (index - 1) * selectItemCount + i
        local item = ShrineSelectItem:getItem(obj.transform:GetChild(i - 1), self.itemList, self)
        item:setData(self.selectDataList[idx])
    end
end

function PnlShrine:onHide()
    self:releaseEvent()

end

function PnlShrine:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    self:setOnClick(view.btnReturnSelect, gg.bind(self.onBtnReturnSelect, self))

    self:setOnClick(view.btnDesc, gg.bind(self.onBtnDesc, self))
    self:setOnClick(view.btnDescBuilding, gg.bind(self.onBtnDescBuilding, self))
end

function PnlShrine:onBtnReturnSelect()
    self:showSelect(false)
end

function PnlShrine:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlShrine:onDestroy()
    local view = self.view

end

function PnlShrine:onBtnClose()
    self:close()
end

return PnlShrine