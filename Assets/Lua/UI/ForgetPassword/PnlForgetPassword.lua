PnlForgetPassword = class("PnlForgetPassword", ggclass.UIBase)
PnlForgetPassword.closeType = ggclass.UIBase.CLOSE_TYPE_NONE

function PnlForgetPassword:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}

    self.encryptionIsOn = false
    self.encryptionConfirmIsOn = false
    self.lessTick = 0
    self.destroyTime = 60

end

function PnlForgetPassword:onAwake()
    self.view = ggclass.PnlForgetPasswordView.new(self.pnlTransform)

end

function PnlForgetPassword:onShow()
    self:bindEvent()
    if self.lessTick > 0 then
        self.startTime = self.lessTick
        self:loopTimer()
    end

end

function PnlForgetPassword:onHide()
    -- self:stopLessTickTimer()
    self:releaseEvent()
end

function PnlForgetPassword:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnSendCode):SetOnClick(function()
        self:onBtnSendCode()
    end)
    CS.UIEventHandler.Get(view.btnReset):SetOnClick(function()
        self:onBtnReset()
    end)
    CS.UIEventHandler.Get(view.toggleEncryption):SetOnClick(function()
        self:onToggleEncryption(1)
    end)
    CS.UIEventHandler.Get(view.toggleEncryptionConfirm):SetOnClick(function()
        self:onToggleEncryption(2)
    end)

    view.inputAccount.onValueChanged:AddListener(gg.bind(self.checkFormat, self))


end

function PnlForgetPassword:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnSendCode)
    CS.UIEventHandler.Clear(view.btnReset)
    CS.UIEventHandler.Clear(view.toggleEncryption)
    CS.UIEventHandler.Clear(view.toggleEncryptionConfirm)

    view.inputAccount.onValueChanged:RemoveAllListeners()

end

function PnlForgetPassword:onDestroy()
    local view = self.view

end

function PnlForgetPassword:onBtnClose()
    self:close()
end

function PnlForgetPassword:onBtnSendCode()
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

function PnlForgetPassword:loopTimer()
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

function PnlForgetPassword:stopLessTickTimer()
    if self.lessTickTimer then
        gg.timer:stopTimer(self.lessTickTimer)
        self.lessTickTimer = nil
    end
end

function PnlForgetPassword:onBtnReset()
    local account = self.view.inputAccount.text
    local password = self.view.inputPassword.text
    local passwordAgain = self.view.inputConfirmPassword.text
    local verifyCode = self.view.inputEmailCode.text

    verifyCode = verifyCode or 0

    if #password < 6 or #password > 16 then
        -- gg.uiManager:showTip("The password contains less than 6 characters")
        gg.uiManager:showTip("Password must contain at least 6 characters and no more than 16 characters")
        return
    end

    -- ""
    local temp = string.match(password, "[A-Za-z0-9@#$^&*_.%%]+")
    if temp ~= password then
        gg.uiManager:showTip("Password can't contain illegal characters")
        return
    end

    -- ""
    local haveLetter = string.match(password, "[A-Za-z]+")
    local haveNum = string.match(password, "[0-9]+")
    if not haveLetter or not haveNum then
        gg.uiManager:showTip("Password must contain numbers and letters")
        return
    end

    if #verifyCode ~= 6 then
        gg.uiManager:showTip("The verify code error")
        return
    end

    if password == passwordAgain then
        gg.client.loginServer:resetPassword(account, password, verifyCode)
    else
        gg.uiManager:showTip("Passwords enter are not the same")
    end
end

function PnlForgetPassword:onToggleEncryption(type)
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

function PnlForgetPassword:checkFormat()
    local account = self.view.inputAccount.text
    account = string.lower(account)
    self.view.inputAccount.text = account

end

return PnlForgetPassword
