PnlItemInfo = class("PnlItemInfo", ggclass.UIBase)

function PnlItemInfo:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlItemInfo:onAwake()
    self.view = ggclass.PnlItemInfoView.new(self.pnlTransform)
    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttrItem, self))
    self.view.commonUpgradeNewBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    self.view.commonUpgradeNewBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
end

PnlItemInfo.TYPE_INFO = 1
PnlItemInfo.TYPE_UPGRADE = 2
PnlItemInfo.TYPE_SOLDIER_INFO = 101

-- PnlItemInfo.TYPE_INSTITUTE_SOLDIER_UPGRADE = 101
-- PnlItemInfo.TYPE_INSTITUTE_SOLDIER_ASCEND = 102
-- PnlItemInfo.TYPE_INSTITUTE_MINE_UPGRADE = 102

-- args = {type, cfg, arrtInfo, compareAttrInfo, attrDataList, lessTickEnd, upgradeCallback, instantCallback}
function PnlItemInfo:onShow()
    self:bindEvent()
    self.view.commonUpgradeNewBox:open()
    self:initShow()

    self.showingType = self.args.type

    self.attrDataList = self.args.attrDataList or {cfg.attribute.maxHp}

    if self.showingType == PnlItemInfo.TYPE_INFO then
        self:refreshMessage(PnlItemInfo.MESSAGE_TYPE_INFO)

    elseif self.showingType == PnlItemInfo.TYPE_UPGRADE then
        self:refreshMessage(PnlItemInfo.MESSAGE_TYPE_UPGRADE)

    elseif self.showingType == PnlItemInfo.TYPE_SOLDIER_INFO then
        self:refreshSoldierInfo()
    end
end

PnlItemInfo.MESSAGE_TYPE_INFO = 1
PnlItemInfo.MESSAGE_TYPE_UPGRADE = 2

function PnlItemInfo:onBtnInstant()
    if self.args.instantCallback then
        self.args.instantCallback()
    end
end

function PnlItemInfo:onBtnUpgrade()
    if self.args.upgradeCallback then
        self.args.upgradeCallback()
    end
end

function PnlItemInfo:refreshMessage(messageType)
    local view = self.view

    if not self.args then
        return
    end
    local curCfg = self.args.cfg
    -- view.txtTitle.text = curCfg.name

    view.txtTitle:SetLanguageKey(curCfg.languageNameID)
    local iconC = curCfg.icon .. "_C"
    
    gg.setSpriteAsync(view.imgIcon, iconC)

    messageType = messageType or PnlItemInfo.MESSAGE_TYPE_INFO
    if messageType == PnlItemInfo.MESSAGE_TYPE_INFO then
        view.txtLevel.text = "Lv." .. curCfg.level
        view.layoutInfo:SetActiveEx(true)
        -- view.txtDesc.text = curCfg.desc
        view.txtDesc:SetLanguageKey(curCfg.desc)
    elseif messageType == PnlItemInfo.MESSAGE_TYPE_UPGRADE then
        view.txtLevel.text = "Lv." .. curCfg.level
        view.layoutUpgrade:SetActiveEx(true)
        view.commonUpgradeNewBox:setMessage(curCfg, self.args.lessTickEnd)
    end

    self.attrInfo = self.args.arrtInfo or curCfg
    self.compareAttrInfo = self.args.compareAttrInfo
    self.attrScrollView:setItemCount(#self.attrDataList)
end

function PnlItemInfo:refreshSoldierInfo()
    local view = self.view
    local soldierCfg = self.args.cfg
    self.attrDataList = constant.SOLDIER_INFO_ATTR
    self:refreshMessage(PnlItemInfo.MESSAGE_TYPE_INFO)
    -- self.attrScrollView:setItemCount(#self.attrDataList)
end

function PnlItemInfo:refreshUpgrade()
    -- self.layoutUpgrade:SetActiveEx(true)
    self:refreshMessage(PnlItemInfo.MESSAGE_TYPE_UPGRADE)
end

function PnlItemInfo:initShow()
    local view = self.view
    view.layoutInfo:SetActiveEx(false)
    view.layoutUpgrade:SetActiveEx(false)
end

function PnlItemInfo:onRenderAttrItem(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    if self.compareAttrInfo then
        item:setData(index, self.attrDataList, self.attrInfo, self.compareAttrInfo, CommonAttrItem.TYPE_NORMAL)
    else
        item:setData(index, self.attrDataList, self.attrInfo, self.compareAttrInfo, CommonAttrItem.TYPE_SINGLE_TEXT)
    end
end

function PnlItemInfo:onHide()
    self:releaseEvent()
    self.view.commonUpgradeNewBox:close()
end

function PnlItemInfo:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlItemInfo:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlItemInfo:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    self.view.commonUpgradeNewBox:release()
end

function PnlItemInfo:onBtnClose()
    self:close()
end

return PnlItemInfo
