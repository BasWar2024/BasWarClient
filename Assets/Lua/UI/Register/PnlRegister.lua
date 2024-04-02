PnlRegister = class("PnlRegister", ggclass.UIBase)
PnlRegister.closeType = ggclass.UIBase.CLOSE_TYPE_NONE
function PnlRegister:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}

    self.consentIsOn = false

    self.lessTick = 0
    self.destroyTime = 60

end

function PnlRegister:onAwake()
    self.view = ggclass.PnlRegisterView.new(self.transform)

end

function PnlRegister:onShow()
    self:bindEvent()

    if self.lessTick > 0 then
        self.startTime = self.lessTick
        self:loopTimer()
    end

end

function PnlRegister:onHide()
    -- print("aaaaaaaaaaaonHide")
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
    CS.UIEventHandler.Get(view.toggleEncryption):SetOnClick(function()
        self:onToggleEncryption(1)
    end)
    CS.UIEventHandler.Get(view.toggleEncryptionConfirm):SetOnClick(function()
        self:onToggleEncryption(2)
    end)

    self:setOnClick(view.txtService.gameObject, gg.bind(self.onClickTxtService, self))

    view.inputAccount.onValueChanged:AddListener(gg.bind(self.checkFormat, self, 1))
    view.inputPassword.onValueChanged:AddListener(gg.bind(self.checkFormat, self, 2))
    view.inputConfirmPassword.onValueChanged:AddListener(gg.bind(self.checkFormat, self, 3))

end

function PnlRegister:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSendCode)
    CS.UIEventHandler.Clear(view.btnRegistration)
    CS.UIEventHandler.Clear(view.toggleConsent.gameObject)
    CS.UIEventHandler.Clear(view.toggleEncryption)
    CS.UIEventHandler.Clear(view.toggleEncryptionConfirm)

    view.inputAccount.onValueChanged:RemoveAllListeners()
    view.inputPassword.onValueChanged:RemoveAllListeners()
    view.inputConfirmPassword.onValueChanged:RemoveAllListeners()

end

function PnlRegister:onDestroy()
    local view = self.view

end

function PnlRegister:onBtnClose()
    gg.uiManager:openWindow("PnlLogin")
    self:close()
end

function PnlRegister:onBtnSendCode()
    local account = self.view.inputAccount.text
    if account ~= "" then
        if self.lessTick <= 0 then
            gg.client.loginServer:sendCode(account)
            self.lessTick = 60
            self.startTime = self.lessTick
            self:loopTimer()
        end
    else
        gg.uiManager:showTip("Please enter Email")
    end

end

function PnlRegister:loopTimer()
    self:stopLessTickTimer()
    local startTime = os.time()
    self.lessTickTimer = gg.timer:startLoopTimer(0, 1, -1, function()
        self.lessTick = self.startTime - (os.time() - startTime)
        if self.lessTick <= 0 then
            self.lessTick = 0
        end
        self.view.txtSend.text = self.lessTick .. "s"
        if self.lessTick == 0 then
            self.view.txtSend.text = "send"
            self:stopLessTickTimer()
        end

    end)
end

function PnlRegister:stopLessTickTimer()
    if self.lessTickTimer then
        gg.timer:stopTimer(self.lessTickTimer)
        self.lessTickTimer = nil
    end
end

function PnlRegister:onBtnRegistration()
    local account = self.view.inputAccount.text
    local password = self.view.inputPassword.text
    local passwordAgain = self.view.inputConfirmPassword.text
    local verifyCode = self.view.inputEmailCode.text
    local inviteCode = self.view.inputInviteCode.text
    if #account < 6 then
        gg.uiManager:showTip(Utils.getText("login_EmailWrong"))
        return
    end
    if #account > 40 then
        gg.uiManager:showTip("The account contains more than 40 characters")
        return
    end
    if not self:checkPassword() then
        return
    end

    if #verifyCode ~= 6 then
        gg.uiManager:showTip("The verify code error")
        return
    end
    if self.consentIsOn then
        if password == passwordAgain then
            gg.uiManager:openWindow("PnlConnect")
            gg.client.loginServer:bind(account, password)
            gg.client.loginServer:register(verifyCode, inviteCode)
        else
            gg.uiManager:showTip("Passwords enter are not the same")
        end

    else
        gg.uiManager:showTip(Utils.getText("login_Agree"))
    end
end

function PnlRegister:onToggleConsent()
    -- print("onToggleConsent")
    if self.consentIsOn then
        self.consentIsOn = false
    else
        self.consentIsOn = true
    end
    -- self.view.toggleConsent:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = self.consentIsOn
end

function PnlRegister:onClickTxtService()
    -- gg.uiManager:openWindow("PnlService", {hideViewName = "PnlRegister"})

    gg.uiManager:openWindow("PnlServiceSmall")
end

function PnlRegister:onToggleEncryption(type)
    local input = self.view.inputPassword
    local toggleEncryption = self.view.toggleEncryption.transform:Find("Background").gameObject
    local encry = self.encryptionIsOn

    if type == 2 then
        input = self.view.inputConfirmPassword
        toggleEncryption = self.view.toggleEncryptionConfirm.transform:Find("Background").gameObject
        encry = self.encryptionConfirmIsOn
    end

    local inputText = input.text
    if encry then
        encry = false
        -- ""***
        input.contentType = 7 -- CS.UnityEngine.InputField.ContentType.Password
        toggleEncryption:SetActive(true)
    else
        -- ""
        encry = true
        input.contentType = 1 -- CS.UnityEngine.InputField.ContentType.Autocorrected      
        toggleEncryption:SetActive(false)
    end
    -- ""
    input.text = ""
    input.text = inputText

    if type == 1 then
        self.encryptionIsOn = encry
    else
        self.encryptionConfirmIsOn = encry
    end
end

function PnlRegister:checkPassword()
    local password = self.view.inputPassword.text
    if #password < 6 or #password > 16 then
        self.view.txtPasswordTips.transform:GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText("login_LengthWrong")
        return false
    end

    -- ""
    local temp = string.match(password, "[A-Za-z0-9@#$^&*_.%%]+")
    if temp ~= password then
        self.view.txtPasswordTips.transform:GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText("login_LengthWrong")
        return false
    end

    -- ""
    local haveLetter = string.match(password, "[A-Za-z]+")
    local haveNum = string.match(password, "[0-9]+")
    if not haveLetter or not haveNum then
        self.view.txtPasswordTips.transform:GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText("login_PasswordTips")
        return false
    end

    return true
end

function PnlRegister:checkFormat(type)
    if type == 1 then
        local account = self.view.inputAccount.text
        account = string.lower(account)
        self.view.inputAccount.text = account
        if string.match(account, "[%w%.%%%+%-%?%^%_]+@[%w%%%+%-%?%^%_]+%.%w%w%w?%w?") then
            self.view.txtAccountTips:SetActiveEx(false)
        else
            self.view.txtAccountTips:SetActiveEx(true)
        end
    elseif type == 2 or type == 3 then
        if self:checkPassword() then
            self.view.txtPasswordTips:SetActiveEx(false)
        else
            self.view.txtPasswordTips:SetActiveEx(true)
        end
        local password = self.view.inputPassword.text
        local passwordAgain = self.view.inputConfirmPassword.text
        if password == passwordAgain then
            self.view.txtPasswordAgainTips:SetActiveEx(false)
        else
            self.view.txtPasswordAgainTips:SetActiveEx(true)
        end
    end
end

return PnlRegister
