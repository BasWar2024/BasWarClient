

PnlSettingDeleteAccount = class("PnlSettingDeleteAccount", ggclass.UIBase)

function PnlSettingDeleteAccount:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlSettingDeleteAccount:onAwake()
    self.view = ggclass.PnlSettingDeleteAccountView.new(self.pnlTransform)

end

function PnlSettingDeleteAccount:onShow()
    self:bindEvent()

end

function PnlSettingDeleteAccount:onHide()
    self:releaseEvent()

end

function PnlSettingDeleteAccount:bindEvent()
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

function PnlSettingDeleteAccount:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnCancel)
    CS.UIEventHandler.Clear(view.btnConfirm)
    CS.UIEventHandler.Clear(view.btnConfirmGet)

end

function PnlSettingDeleteAccount:onDestroy()
    local view = self.view

end

function PnlSettingDeleteAccount:onBtnCancel()
    self:close()
end

function PnlSettingDeleteAccount:onBtnConfirm()
    local args = {
        txtTitel = Utils.getText("universal_Ask_Title"),
        txtTips = Utils.getText("setting_TipsTwo"),
        txtYes = Utils.getText("universal_DetermineButton"),
        callbackYes = function()
            local account = gg.playerMgr.localPlayer:getAccount()
            local password = self.view.inputField.text
            gg.client.loginServer:deleteAccount(account, password)
        end,
        txtNo = Utils.getText("universal_Ask_BackButton")
    }
    gg.uiManager:openWindow("PnlAlertNew", args)
end

function PnlSettingDeleteAccount:onBtnConfirmGet()

end

return PnlSettingDeleteAccount