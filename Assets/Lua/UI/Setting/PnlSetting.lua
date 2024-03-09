

PnlSetting = class("PnlSetting", ggclass.UIBase)

function PnlSetting:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }

    self.isMusicOn = true
    self.isSoundEffectOn = true
end

function PnlSetting:onAwake()
    self.view = ggclass.PnlSettingView.new(self.transform)

end

function PnlSetting:onShow()
    self:bindEvent()

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
        returnLogin()

    elseif key == "music" then
        if self.isMusicOn then
            self.isMusicOn = false
            box.txtBtn.text = "Off"
            AudioMgr:SetBGVolume(0)
            gg.setSpriteAsync(box.imgBtn, "button_select_gray")
        else
            self.isMusicOn = true
            box.txtBtn.text = "On"
            AudioMgr:SetBGVolume(1)
            gg.setSpriteAsync(box.imgBtn, "button_select_yellow")
        end

    elseif key == "soundEffect" then
        if self.isSoundEffectOn then
            self.isSoundEffectOn = false
            box.txtBtn.text = "Off"
            AudioMgr:SetAudioVolume(0)

            gg.setSpriteAsync(box.imgBtn, "button_select_gray")
        else
            self.isSoundEffectOn = true
            box.txtBtn.text = "On"
            AudioMgr:SetAudioVolume(1)
            gg.setSpriteAsync(box.imgBtn, "button_select_yellow")
        end

    else
        print(key)
    end
end

return PnlSetting