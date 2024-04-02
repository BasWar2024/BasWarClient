PnlSettingCdKey = class("PnlSettingCdKey", ggclass.UIBase)

function PnlSettingCdKey:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onGetGift"}
end

function PnlSettingCdKey:onAwake()
    self.view = ggclass.PnlSettingCdKeyView.new(self.pnlTransform)

end

function PnlSettingCdKey:onShow()
    self:bindEvent()
    self.view.ViewGetGift:SetActiveEx(false)

end

function PnlSettingCdKey:onHide()
    self:releaseEvent()

end

function PnlSettingCdKey:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnCancel):SetOnClick(function()
        self:onBtnCancel()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
    CS.UIEventHandler.Get(view.btnConfirmGet):SetOnClick(function()
        self:onBtnConfirmGet()
    end)

end

function PnlSettingCdKey:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnCancel)
    CS.UIEventHandler.Clear(view.btnConfirm)
    CS.UIEventHandler.Clear(view.btnConfirmGet)

end

function PnlSettingCdKey:onDestroy()
    local view = self.view

end

function PnlSettingCdKey:onBtnCancel()
    self:close()
end

function PnlSettingCdKey:onBtnConfirm()
    local cdKey = self.view.inputField.text

    if cdKey and cdKey ~= "" then
        GiftData.C2S_Player_UseGiftCode(cdKey)
    end
end
function PnlSettingCdKey:onBtnConfirmGet()
    self.view.ViewGetGift:SetActiveEx(false)
end

function PnlSettingCdKey:onGetGift()
    self.view.ViewGetGift:SetActiveEx(true)
    self.view.inputField.text = ""
end

return PnlSettingCdKey
