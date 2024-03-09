

PnlRegister = class("PnlRegister", ggclass.UIBase)

function PnlRegister:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }

    self.consentIsOn = false 
end

function PnlRegister:onAwake()
    self.view = ggclass.PnlRegisterView.new(self.transform)

end

function PnlRegister:onShow()
    self:bindEvent()

end

function PnlRegister:onHide()
    self:releaseEvent()

end

function PnlRegister:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnSendCode):SetOnClick(function()
        self:onBtnSendCode()
    end)
    CS.UIEventHandler.Get(view.btnRegistration):SetOnClick(function()
        self:onBtnRegistration()
    end)
    CS.UIEventHandler.Get(view.toggleConsent.gameObject):SetOnClick(function()
        self:onToggleConsent()
    end)
end

function PnlRegister:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSendCode)
    CS.UIEventHandler.Clear(view.btnRegistration)
    CS.UIEventHandler.Clear(view.toggleConsent.gameObject)

end

function PnlRegister:onDestroy()
    local view = self.view

end

function PnlRegister:onBtnClose()
    gg.uiManager:openWindow("PnlLogin")
    self:close()
end

function PnlRegister:onBtnSendCode()
    print("onBtnSendCode")
end

function PnlRegister:onBtnRegistration()
    print("onBtnRegistration")
    local account = self.view.inputAccount.text
    local password = self.view.inputPassword.text
    if self.consentIsOn then
        gg.client.loginServer:bind(account, password)
        gg.client.loginServer:register()
    else
        gg.uiManager:showTip("Please tick")
    end
    
end

function PnlRegister:onToggleConsent()
    print("onToggleConsent")
    if self.consentIsOn then 
        self.consentIsOn = false
    else 
        self.consentIsOn = true
    end   
    --self.view.toggleConsent:GetComponent("Toggle").isOn = self.consentIsOn
end

return PnlRegister