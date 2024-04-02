PnlSetting = class("PnlSetting", ggclass.UIBase)

function PnlSetting:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {}
    self.needBlurBG = true
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlSetting:onAwake()
    self.view = ggclass.PnlSettingView.new(self.pnlTransform)
end

function PnlSetting:onShow()
    self:bindEvent()
    self:initVolume()

    self:refreshAudit()
end

function PnlSetting:refreshAudit()
    local view = self.view
    if IsAuditVersion() then
        for key, value in pairs(self.view.settingMap) do
            if key == "dapp" or key == "wallet" or key == "invite" then
                value.item:SetActiveEx(false)
            end
            if key == "service" or key == "language" or key == "quit" then
                local pos = value.item.localPosition
                value.item.localPosition = Vector3.New(pos.x, -271.5, pos.z)
            end
            if key == "deleteAccount" and CS.Appconst.platform == "iosAppstore" then
                value.item:SetActiveEx(true)
            end
        end
    end
end

function PnlSetting:onHide()
    self:releaseEvent()

end

function PnlSetting:bindEvent()
    local view = self.view

    for key, value in pairs(view.settingMap) do
        self:setOnClick(value.btn, gg.bind(self.onBtnSet, self, key))
    end

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)
    CS.UIEventHandler.Get(view.btnVeryLow):SetOnClick(function()
        self:onBtnVeryLow()
    end)
    CS.UIEventHandler.Get(view.btnLow):SetOnClick(function()
        self:onBtnLow()
    end)
    CS.UIEventHandler.Get(view.btnMid):SetOnClick(function()
        self:onBtnMid()
    end)
    CS.UIEventHandler.Get(view.btnHigh):SetOnClick(function()
        self:onBtnHigh()
    end)
    CS.UIEventHandler.Get(view.btnVeryHigh):SetOnClick(function()
        self:onBtnVeryHigh()
    end)

end

function PnlSetting:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlSetting:onDestroy()
    local view = self.view
end

function PnlSetting:onBtnSet(key)
    local view = self.view
    local box = view.settingMap[key]
    if key == "quit" then
        -- CS.UnityEditor.EditorApplication.isPlaying = false
        -- CS.UnityEngine.Application.Quit()
        -- shutdown()
        MailData.mailBriefData = {}
        gg.client.loginServer.isPlayerExitGame = true
        returnLogin()
    elseif key == "Allsound" then
        local isMute = AudioFmodMgr:GetBgMute() or AudioFmodMgr:GetAudioMute()
        AudioFmodMgr:SetBgMute(not isMute)
        AudioFmodMgr:SetAudioMute(not isMute)

    elseif key == "music" then
        local isMute = AudioFmodMgr:GetBgMute()
        AudioFmodMgr:SetBgMute(not isMute)

        if isMute then
            box.btn.transform:Find("On").gameObject:SetActiveEx(true)
            box.btn.transform:Find("Off").gameObject:SetActiveEx(false)
            box.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x34 / 0xff,
                0xd0 / 0xff, 0xff / 0xff)
            box.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x11 / 0xff,
                0x4d / 0xff, 0x6a / 0xff)
        else
            box.btn.transform:Find("Off").gameObject:SetActiveEx(true)
            box.btn.transform:Find("On").gameObject:SetActiveEx(false)
            box.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x34 / 0xff,
                0xd0 / 0xff, 0xff / 0xff)
            box.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x11 / 0xff,
                0x4d / 0xff, 0x6a / 0xff)
        end

    elseif key == "soundEffect" then
        local isMute = AudioFmodMgr:GetAudioMute()
        AudioFmodMgr:SetAudioMute(not isMute)

        if isMute then
            box.btn.transform:Find("On").gameObject:SetActiveEx(true)
            box.btn.transform:Find("Off").gameObject:SetActiveEx(false)
            box.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x34 / 0xff,
                0xd0 / 0xff, 0xff / 0xff)
            box.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x11 / 0xff,
                0x4d / 0xff, 0x6a / 0xff)
        else
            box.btn.transform:Find("Off").gameObject:SetActiveEx(true)
            box.btn.transform:Find("On").gameObject:SetActiveEx(false)
            box.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x34 / 0xff,
                0xd0 / 0xff, 0xff / 0xff)
            box.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x11 / 0xff,
                0x4d / 0xff, 0x6a / 0xff)
        end

    elseif key == "service" then
        -- gg.uiManager:openWindow("PnlSettingService")
        -- gg.uiManager:openWindow("PnlService")
        -- gg.uiManager:showTip(Utils.getText("srtting_NotUsable"))
        gg.uiManager:openWindow("PnlServiceSmall")
    elseif key == "productionStaff" then
        -- gg.uiManager:openWindow("PnlSettingproducer")
        gg.uiManager:showTip(Utils.getText("srtting_NotUsable"))
    elseif key == "dapp" then
        CS.UnityEngine.Application.OpenURL(AutoPushData.getMarketUrl())
    elseif key == "invite" then
        -- CS.UnityEngine.GUIUtility.systemCopyBuffer = gg.playerMgr.localPlayer:getName()
        -- gg.uiManager:showTip("url copy succeed")
        gg.uiManager:openWindow("PnlSettingCdKey")
    elseif key == "wallet" then
        gg.uiManager:openWindow("PnlSettingWallet")

    elseif key == "language" then
        gg.uiManager:openWindow("PnlSettingLanguage")
    elseif key == "deleteAccount" then
        gg.uiManager:openWindow("PnlSettingDeleteAccount")
    else
        print(key)
        gg.uiManager:showTip(Utils.getText("srtting_NotUsable"))
    end
end

function PnlSetting:initVolume()
    local isBgMute = AudioFmodMgr:GetBgMute()

    local bgBox = self.view.settingMap["music"]
    if isBgMute then
        bgBox.btn.transform:Find("Off").gameObject:SetActiveEx(true)
        bgBox.btn.transform:Find("On").gameObject:SetActiveEx(false)
        bgBox.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x34 / 0xff, 0xd0 / 0xff, 0xff / 0xff)
        bgBox.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x11 / 0xff, 0x4d / 0xff, 0x6a / 0xff)
    else
        bgBox.btn.transform:Find("On").gameObject:SetActiveEx(true)
        bgBox.btn.transform:Find("Off").gameObject:SetActiveEx(false)
        bgBox.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x34 / 0xff, 0xd0 / 0xff, 0xff / 0xff)
        bgBox.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x11 / 0xff, 0x4d / 0xff, 0x6a / 0xff)
    end

    local isEffectMute = AudioFmodMgr:GetAudioMute()
    local effectBox = self.view.settingMap["soundEffect"]
    if isEffectMute then
        effectBox.btn.transform:Find("Off").gameObject:SetActiveEx(true)
        effectBox.btn.transform:Find("On").gameObject:SetActiveEx(false)
        effectBox.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x34 / 0xff,
            0xd0 / 0xff, 0xff / 0xff)
        effectBox.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x11 / 0xff,
            0x4d / 0xff, 0x6a / 0xff)
    else
        effectBox.btn.transform:Find("On").gameObject:SetActiveEx(true)
        effectBox.btn.transform:Find("Off").gameObject:SetActiveEx(false)
        effectBox.btn.transform:Find("TxtOn"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x34 / 0xff,
            0xd0 / 0xff, 0xff / 0xff)
        effectBox.btn.transform:Find("TxtOff"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(0x11 / 0xff,
            0x4d / 0xff, 0x6a / 0xff)
    end
end

function PnlSetting:onBtnVeryLow()
    UnityEngine.QualitySettings.SetQualityLevel(1, true);
end

function PnlSetting:onBtnLow()
    UnityEngine.QualitySettings.SetQualityLevel(2, true);
end

function PnlSetting:onBtnMid()
    UnityEngine.QualitySettings.SetQualityLevel(3, true);
end

function PnlSetting:onBtnHigh()
    UnityEngine.QualitySettings.SetQualityLevel(4, true);
end

function PnlSetting:onBtnVeryHigh()
    UnityEngine.QualitySettings.SetQualityLevel(5, true);
end

function PnlSetting:getGuideRectTransform(guideCfg)
    if not self.view then
        return
    end
    local name = guideCfg.gameObjectName

    if self.view.settingMap[name] ~= nil then
        return self.view.settingMap[name].item
    end
    -- if name == "wallet" then
    --     return self.view.settingMap[name].item
    -- end

    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

return PnlSetting
