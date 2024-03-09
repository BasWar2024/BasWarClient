PnlLogin = class("PnlLogin", ggclass.UIBase)
local cjson = require "cjson"

function PnlLogin:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.encryptionIsOn = false
    self.okLogin = true
    self.account = ""
    self.password = ""
end

function PnlLogin:onAwake()

    self.view = ggclass.PnlLoginView.new(self.transform)
    --
    -- ResMgr:LoadSpriteAsync("background", function (spr)
    --     self.view.transform:Find("bg"):GetComponent("Image").sprite = spr
    -- end)

end

function PnlLogin:onShow()
    self:bindEvent()

    self:refresh()   
end

function PnlLogin:refresh()
    self.account = UnityEngine.PlayerPrefs.GetString(constant.BASE_LOGIN_ACCOUNT, "")
    self.password = UnityEngine.PlayerPrefs.GetString(constant.BASE_LOGIN_PASSWORD, "")
    local arr = {}
    string.gsub(self.account, '[^' .. "_" ..']+', function(w) 
        table.insert(arr, w) 
    end)    
    if arr[1] ~= "random" and self.account ~= "" then
        self.view.inputAccount.text = self.account
        self.view.inputPassword.text = self.password
        self.view.btnTourist.gameObject:SetActive(false)
        self.view.btnEnterGame:GetComponent("RectTransform"):SetLocalPosX(-100)
        self.view.btnRegister:GetComponent("RectTransform"):SetLocalPosX(100)
    end    

    self.view.version.text = "App:" .. CS.Appconst.AppVersion .. " Res:" .. CS.Appconst.instance.RemoteVersion
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
end

function PnlLogin:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnEnterGame.gameObject)
    CS.UIEventHandler.Clear(view.btnRegister.gameObject)
    CS.UIEventHandler.Clear(view.btnTourist.gameObject)
    CS.UIEventHandler.Clear(view.btnFaceBook.gameObject)
    CS.UIEventHandler.Clear(view.btnTwitter.gameObject)
    CS.UIEventHandler.Clear(view.btnYouTube.gameObject)
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
    if self.okLogin then
        self.account = self.view.inputAccount.text
        self.password = self.view.inputPassword.text
        gg.client.loginServer:bind(self.account, self.password)
        gg.client.loginServer:login()    
        self.okLogin = false
        self:onClickColdTimer()
        self.coldTimer = gg.timer:addTimer(3, function ()
            self.okLogin = true
        end)
    end
end

function PnlLogin:onBtnRegister()
    gg.uiManager:openWindow("PnlRegister")
    self:close()
end

function PnlLogin:onBtnTourist()
    if self.account == "" then
        gg.client.loginServer:bind()
        gg.client.loginServer:vistorLogin()
    else
        gg.client.loginServer:bind(self.account, self.password)        
        gg.client.loginServer:vistorLogin()
    end
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
        --***
        self.view.inputPassword.contentType = 7 --CS.UnityEngine.InputField.ContentType.Password
        self.view.toggleEncryption:Find("Background").gameObject:SetActive(true)       
    else
        --
        self.encryptionIsOn = true
        self.view.inputPassword.contentType = 1 --CS.UnityEngine.InputField.ContentType.Autocorrected      
        self.view.toggleEncryption:Find("Background").gameObject:SetActive(false)
    end
    --
    self.view.inputPassword.text = ""
    self.view.inputPassword.text = inputText  
end

return PnlLogin