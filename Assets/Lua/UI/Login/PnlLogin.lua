PnlLogin = class("PnlLogin", ggclass.UIBase)
local cjson = require "cjson"
PnlLogin.closeType = ggclass.UIBase.CLOSE_TYPE_NONE
function PnlLogin:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    self.layer = UILayer.normal
    self.events = {"onShowBanTips", "onSaveAccountChange"}

    self.encryptionIsOn = false
    self.okLogin = true
    self.account = ""
    self.password = ""
end

function PnlLogin:onAwake()

    self.view = ggclass.PnlLoginView.new(self.transform)
    -- ""
    -- ResMgr:LoadSpriteAsync("background", function (spr)
    --     self.view.transform:Find("bg"):GetComponent(UNITYENGINE_UI_IMAGE).sprite = spr
    -- end)

    self.accountItemList = {}
    self.accountsScrollView = UIScrollView.new(self.view.accountsScrollView, "LoginAccountItem", self.accountItemList)
    self.accountsScrollView:setRenderHandler(gg.bind(self.onRenderAccount, self))
end

function PnlLogin:onShow()
    self:bindEvent()
    self:refresh()
    self.view.transform:Find("InputField").gameObject:SetActive(false)
    self.view.txtUrl.gameObject:SetActive(false)
    self.logCount = 0
    self.logBool = true

    self.accountsScrollView.transform:SetActiveEx(false)

    gg.client.loginServer.accounts = util.getAccounts()
    self.accountsScrollView:setItemCount(#gg.client.loginServer.accounts)
end

function PnlLogin:refresh()
    self.account, self.password = util.loadAccountPassword()
    local arr = {}
    string.gsub(self.account, '[^' .. "_" .. ']+', function(w)
        table.insert(arr, w)
    end)
    if arr[1] ~= "random" and self.account ~= "" then
        self.view.inputAccount.text = self.account
        self.view.inputPassword.text = self.password
        self.view.btnTourist.gameObject:SetActive(false)
        -- self.view.btnEnterGame:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetLocalPosX(-190)
        -- self.view.btnRegister:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetLocalPosX(190)
    end
    local version = CS.Appconst.instance.RemoteVersion

    self.view.version.text = "App:" .. CS.Appconst.AppVersion .. " Res:" .. version

    local appVerTable = string.split(version, ".")

    local txtVersionTips = self.view.transform:Find("TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)

    txtVersionTips.gameObject:SetActiveEx(false)
    local verTxt = ""
    if appVerTable[3] == "2" then
        -- txtVersionTips.text = "Beta"
        verTxt = "Beta"
        txtVersionTips.gameObject:SetActiveEx(false)
    elseif appVerTable[3] == "1" then
        txtVersionTips.text = "Alpha"
        verTxt = "Alpha"
    elseif appVerTable[3] == "0" then
        txtVersionTips.text = "Main"
        verTxt = "Main"
    end

    self.view.version.text = verTxt .. " App:" .. CS.Appconst.AppVersion .. " Res:" .. version

    self.view.toggleRemember.isOn = util.loadRemember()
end

function PnlLogin:onHide()
    self:releaseEvent()
end

function PnlLogin:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnEnterGame.gameObject):SetOnClick(function()
        self:onBtnEnterGame()
    end)
    CS.UIEventHandler.Get(view.btnRegister.gameObject):SetOnClick(function()
        self:onBtnRegister()
    end)

    CS.UIEventHandler.Get(view.btnTourist.gameObject):SetOnClick(function()
        self:onBtnTourist()
    end)
    CS.UIEventHandler.Get(view.btnFaceBook.gameObject):SetOnClick(function()
        self:onBtnFaceBook()
    end)
    CS.UIEventHandler.Get(view.btnTwitter.gameObject):SetOnClick(function()
        self:onBtnTwitter()
    end)
    CS.UIEventHandler.Get(view.btnYouTube.gameObject):SetOnClick(function()
        self:onBtnYouTube()
    end)
    CS.UIEventHandler.Get(view.toggleEncryption.gameObject):SetOnClick(function()
        self:onToggleEncryption()
    end)
    CS.UIEventHandler.Get(view.btnForgetPassword.gameObject):SetOnClick(function()
        self:onBtnForgetPassword()
    end)
    CS.UIEventHandler.Get(view.btnLogSwich):SetOnClick(function()
        self:onBtnLogSwich()
    end, "event:/UI_button_click", "se_UI", false)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)

    self:setOnClick(view.btnLanguege, gg.bind(self.onBtnLanguage, self))
    self:setOnClick(view.btnAccount, gg.bind(self.onBtnAccount, self))

    view.inputAccount.onValueChanged:AddListener(gg.bind(self.checkFormat, self))

end

function PnlLogin:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnEnterGame.gameObject)
    CS.UIEventHandler.Clear(view.btnRegister.gameObject)
    CS.UIEventHandler.Clear(view.btnTourist.gameObject)
    CS.UIEventHandler.Clear(view.btnFaceBook.gameObject)
    CS.UIEventHandler.Clear(view.btnTwitter.gameObject)
    CS.UIEventHandler.Clear(view.btnYouTube.gameObject)
    CS.UIEventHandler.Clear(view.btnForgetPassword.gameObject)
    CS.UIEventHandler.Clear(view.toggleEncryption.gameObject)
    CS.UIEventHandler.Clear(view.btnConfirm)

    view.inputAccount.onValueChanged:RemoveAllListeners()

end

function PnlLogin:onDestroy()
    local view = self.view
end

function PnlLogin:onClickColdTimer()
    if self.coldTimer then
        gg.timer:stopTimer(self.coldTimer)
        self.coldTimer = nil
    end
end

function PnlLogin:onBtnEnterGame()
    

    if not self.view.ToggleConsent.isOn then
        gg.uiManager:showTip(Utils.getText("login_Agree"))
        return
    end

    if #self.view.inputPassword.text == 0 then
        gg.uiManager:showTip("Please enter your password")
        return
    end

    if self.okLogin then
        self.account = self.view.inputAccount.text
        self.password = self.view.inputPassword.text
        gg.client.loginServer.isSavePasswd = self.view.toggleRemember.isOn
        util.saveRemember(self.view.toggleRemember.isOn)
        gg.uiManager:openWindow("PnlConnect")
        gg.client.loginServer:bind(self.account, self.password)
        gg.client.loginServer:login()
        self.okLogin = false
        self:onClickColdTimer()
        self.coldTimer = gg.timer:addTimer(5, function()
            self.okLogin = true
        end)

        local accountMd5 = string.lower(CryptUtil.MD5Encrypt16(self.account))
        if accountMd5 == "61976639d79753f6" then
            -- print("aaaabbb", accountMd5)
            gg.galaxyManager.showCfgId = true
        end
    end
end

function PnlLogin:onBtnRegister()
    gg.uiManager:openWindow("PnlRegister")
    self:close()
end

function PnlLogin:onBtnTourist()
    --[[
    if self.account == "" then
        gg.client.loginServer:bind()
        gg.client.loginServer:vistorLogin()
    else
        gg.client.loginServer:bind(self.account, self.password)
        gg.client.loginServer:vistorLogin()
    end
    --]]
end

function PnlLogin:onBtnFaceBook()
    print("onBtnFaceBook")
end

function PnlLogin:onBtnTwitter()
    print("onBtnTwitter")
end

function PnlLogin:onBtnYouTube()
    print("onBtnYouTube")
end

function PnlLogin:onToggleEncryption()
    local inputText = self.view.inputPassword.text
    if self.encryptionIsOn then
        self.encryptionIsOn = false
        -- ""***
        self.view.inputPassword.contentType = 7 -- CS.UnityEngine.InputField.ContentType.Password
        self.view.toggleEncryption:Find("Background").gameObject:SetActive(true)
    else
        -- ""
        self.encryptionIsOn = true
        self.view.inputPassword.contentType = 1 -- CS.UnityEngine.InputField.ContentType.Autocorrected      
        self.view.toggleEncryption:Find("Background").gameObject:SetActive(false)
    end
    -- ""
    self.view.inputPassword.text = ""
    self.view.inputPassword.text = inputText
end

function PnlLogin:onBtnForgetPassword()
    gg.uiManager:openWindow("PnlForgetPassword")
end

function PnlLogin:onBtnLanguage()
    gg.uiManager:openWindow("PnlSettingLanguage")
end

function PnlLogin:onBtnLogSwich()
    self.logCount = self.logCount + 1
    if self.logCount >= 10 then
        self.view.transform:Find("InputField").gameObject:SetActive(true)
        local input = self.view.transform:Find("InputField/Text"):GetComponent(UNITYENGINE_UI_TEXT).text
        if self.logBool and input == "openlog" then
            self.logBool = false
            self.view.transform:Find("InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD).text = ""
            gg.showDebugLog.enabled = true
            gg.galaxyManager.showCfgId = true
        -- else
        --     if input == "yu#you@321" then
        --         gg.showDebugLog.enabled = true
        --         self.view.transform:Find("InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD).text = ""
        --     end
        elseif input == "opendetail" then
            self.view.transform:Find("InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD).text = ""
            gg.uiManager:showTip("opendetail success")
            util.setDetail(1)
        elseif input == "closedetail" then
            self.view.transform:Find("InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD).text = ""
            gg.uiManager:showTip("closedetail success")
            util.setDetail(0)
        elseif input == "openhotfixtest" then
            UnityEngine.PlayerPrefs.SetInt("isHotFixTest", 1)
            gg.client.loginServer.api.url = CS.Appconst.instance.loginServerTestUrl
            gg.uiManager:showTip("open hotfix test " .. UnityEngine.PlayerPrefs.GetInt("isHotFixTest"))
        elseif input == "closehotfixtest" then
            UnityEngine.PlayerPrefs.SetInt("isHotFixTest", 0)
            gg.client.loginServer.api.url = CS.Appconst.instance.loginServerUrl
            gg.uiManager:showTip("close hotfix test " .. UnityEngine.PlayerPrefs.GetInt("isHotFixTest"))
        elseif input == "showurl" then
            self.view.txtUrl.gameObject:SetActive(true)
            self.view.txtUrl.text = string.format("branch: %s\nplatform: %s\nAppVersion: %s\nLocalVersion: %s\nRemoteVersion: %s\nsdk: %s\nloginServerUrl: %s\nGameVersionUrl: %s\nGameVersionTestUrl: %s\nRemoteLoadPath: %s\nLoginServerTestUrl: %s\n",
            CS.Appconst.branch, CS.Appconst.platform, CS.Appconst.AppVersion, CS.Appconst.instance.LocalVersion, CS.Appconst.instance.RemoteVersion, 
            CS.Appconst.sdk, CS.Appconst.instance.loginServerUrl, CS.Appconst.instance.GameVersionUrl, CS.Appconst.instance.GameVersionTestUrl, CS.Appconst.RemoteLoadPath, CS.Appconst.instance.loginServerTestUrl) 
        end
    end
end

function PnlLogin:onBtnConfirm()
    self.view.banTips:SetActiveEx(false)
end

function PnlLogin:onShowBanTips()
    self.view.banTips:SetActiveEx(true)
end

function PnlLogin:checkFormat()
    local account = self.view.inputAccount.text
    account = string.lower(account)
    self.view.inputAccount.text = account

end

function PnlLogin:onBtnAccount()
    self.accountsScrollView.transform:SetActiveEx(not self.accountsScrollView.gameObject.activeSelf)
end

function PnlLogin:onSaveAccountChange()
    self.accountsScrollView:setItemCount(#gg.client.loginServer.accounts)
end

function PnlLogin:onRenderAccount(obj, index)
    -- print("onFingerUp")
    local item = LoginAccountItem:getItem(obj, self.accountItemList, self)
    item:setData(gg.client.loginServer.accounts[index])
end

function PnlLogin:setAccount(account)
    self.view.inputAccount.text = account.account
    self.view.inputPassword.text = account.password
end

---------------------------
LoginAccountItem = LoginAccountItem or class("LoginAccountItem", ggclass.UIBaseItem)
function LoginAccountItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function LoginAccountItem:onInit()
    self.txtAccount = self:Find("TxtAccount", UNITYENGINE_UI_TEXT)

    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))

    self.btnRemove = self:Find("BtnRemove").gameObject
    self:setOnClick(self.btnRemove, gg.bind(self.onBtnRemove, self))
end

function LoginAccountItem:setData(account)
    self.account = account
    self.txtAccount.text = account.account
end

function LoginAccountItem:onClickItem()
    self.initData:setAccount(self.account)
    self.initData.accountsScrollView.transform:SetActiveEx(false)
end

function LoginAccountItem:onBtnRemove()

    util.removeOneSaveAccount(self.account.account)
end

return PnlLogin
