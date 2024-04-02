PnlDrawCardInfo = class("PnlDrawCardInfo", ggclass.UIBase)

PnlDrawCardInfo.NOTICE = 1
PnlDrawCardInfo.RULE = 2
PnlDrawCardInfo.RECORD = 3

function PnlDrawCardInfo:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onLoadBoxCardRecord"}
end

function PnlDrawCardInfo:onAwake()
    self.view = ggclass.PnlDrawCardInfoView.new(self.pnlTransform)

    self.leftBtnList = {
        [PnlDrawCardInfo.NOTICE] = self.view.btnNotice,
        [PnlDrawCardInfo.RULE] = self.view.btnRule,
        [PnlDrawCardInfo.RECORD] = self.view.btnRecord
    }
    self.viewType = PnlDrawCardInfo.RULE
    
end

function PnlDrawCardInfo:onShow()
    self:bindEvent()

    self:setView(self.viewType)
end

function PnlDrawCardInfo:onHide()
    self:releaseEvent()

    self:releaseBoxCardRecord()
end

function PnlDrawCardInfo:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnNotice):SetOnClick(function()
        self:onBtnNotice()
    end)
    CS.UIEventHandler.Get(view.btnRule):SetOnClick(function()
        self:onBtnRule()
    end)
    CS.UIEventHandler.Get(view.btnRecord):SetOnClick(function()
        self:onBtnRecord()
    end)
end

function PnlDrawCardInfo:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnNotice)
    CS.UIEventHandler.Clear(view.btnRule)
    CS.UIEventHandler.Clear(view.btnRecord)

end

function PnlDrawCardInfo:onDestroy()
    local view = self.view

    self.leftBtnList = nil
end

function PnlDrawCardInfo:onBtnClose()
    self:close()
end

function PnlDrawCardInfo:onBtnNotice()
    self:setView(PnlDrawCardInfo.NOTICE)
end

function PnlDrawCardInfo:onBtnRule()
    self:setView(PnlDrawCardInfo.RULE)
end

function PnlDrawCardInfo:onBtnRecord()
    self:setView(PnlDrawCardInfo.RECORD)
end

function PnlDrawCardInfo:setView(type)
    self.viewType = type

    for k, v in pairs(self.leftBtnList) do
        if k == type then
            v.transform:Find("Image").gameObject:SetActiveEx(true)
            v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(1, 1, 1, 1)
        else
            v.transform:Find("Image").gameObject:SetActiveEx(false)
            v.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x3d / 0xff, 0x97 / 0xff, 1, 1)
        end
    end

    if type == PnlDrawCardInfo.NOTICE then
        self.view.viewNotice:SetActiveEx(true)
        self.view.viewRule:SetActiveEx(false)
        self.view.vIewRecord:SetActiveEx(false)
    elseif type == PnlDrawCardInfo.RULE then
        self.view.viewNotice:SetActiveEx(false)
        self.view.viewRule:SetActiveEx(true)
        self.view.vIewRecord:SetActiveEx(false)
    elseif type == PnlDrawCardInfo.RECORD then
        self.view.viewNotice:SetActiveEx(false)
        self.view.viewRule:SetActiveEx(false)
        self.view.vIewRecord:SetActiveEx(true)
        self:releaseBoxCardRecord()

        DrawCardData.C2S_Player_GetDrawCardRecord()
    end
end

PnlDrawCardInfo.QUALITY_ICON = {
    [0] = "quality_icon_1B",
    [1] = "quality_icon_1B",
    [2] = "quality_icon_2B",
    [3] = "quality_icon_3B",
    [4] = "quality_icon_4",
    [5] = "quality_icon_5"
}


function PnlDrawCardInfo:onLoadBoxCardRecord(args, data)
    self.boxCardRecordList = {}
    for k, v in ipairs(data) do
        ResMgr:LoadGameObjectAsync("BoxCardRecord", function(go)
            go.transform:SetParent(self.view.content, false)
            local cardCfg = cfg.getCfg("item", v.itemCfgId)
            local poolCfg = cfg.getCfg("cardPool", v.cfgId)
            local drawTime = gg.time.utcDate(v.drawTime)
            go.transform:Find("TitelTime"):GetComponent(UNITYENGINE_UI_TEXT).text = drawTime
            go.transform:Find("TitelCard"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(cardCfg.languageNameID)
            go.transform:Find("TitelPool"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(poolCfg.name)
            local iconQuality = go.transform:Find("IconQuality"):GetComponent(UNITYENGINE_UI_IMAGE)
            local iconName = gg.getSpriteAtlasName("PersonalArmyIcon_Atlas", PnlDrawCardInfo.QUALITY_ICON[cardCfg.quality])
            gg.setSpriteAsync(iconQuality, iconName, nil, nil, true)

            table.insert(self.boxCardRecordList, go)
            return true
        end, true)
    end
end

function PnlDrawCardInfo:releaseBoxCardRecord()
    if self.boxCardRecordList then
        for k, v in pairs(self.boxCardRecordList) do
            ResMgr:ReleaseAsset(v)
        end
        self.boxCardRecordList = nil
    end
end

return PnlDrawCardInfo
