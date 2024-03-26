BuildingTimeBarBox = BuildingTimeBarBox or class("BuildingTimeBarBox", ggclass.UIBaseItem)

function BuildingTimeBarBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BuildingTimeBarBox:onInit()
    self.bg = self:Find("Bg").transform
    self.slider = self.bg:Find("Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtTime = self.bg:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.bgIcon = self.bg:Find("BgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgIcon = self.bgIcon.transform:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.btnSpeedUp = self.bg:Find("BtnSpeedUp").gameObject
    self.txtCost = self.btnSpeedUp.transform:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self:setOnClick(self.btnSpeedUp, gg.bind(self.onClickSpeedUp, self))
end

function BuildingTimeBarBox:onRelease()
    self:stopTimer()
end

function BuildingTimeBarBox:setMessage(totalTime, endTime, id, runCallback, finishCallback)
    self:stopTimer()
    self.transform:SetActiveEx(true)
    local less = 0
    local tick = endTime - os.time()
    if id then
        less = gg.timer:getLessTick(id, tick)
        gg.timer:saveLessTick(id, tick)
    end
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = endTime - os.time() - less
        if time <= 0 then
            if id then
                gg.timer:releaseLessTick(id)
            end
            self:stopTimer()
            self.transform:SetActiveEx(false)
            if finishCallback then
                finishCallback()
            end
            return
        end
        self.slider.value = ((totalTime - time) / totalTime)
        local str = gg.time:dhms_string(time)
        self.txtTime.text = str

        local speedUpCost = cfg.global.SpeedUpPerMinute.intValue * math.ceil(time / 60)
        self.txtCost.text = Utils.getShowRes(speedUpCost)

        if runCallback then
            runCallback(time)
        end
    end)
end

function BuildingTimeBarBox:setStatickMessage(totalTime, icon)
    self:setIcon(icon)
    self.txtTime.text = gg.time:dhms_string(totalTime)
    self.slider.value = 1

    local speedUpCost = cfg.global.SpeedUpPerMinute.intValue * math.ceil(totalTime / 60)
    self.txtCost.text = Utils.getShowRes(speedUpCost)
end

function BuildingTimeBarBox:stopTimer()
    if self.timer then
        gg.timer:stopTimer(self.timer)
        self.timer = nil
    end
end

function BuildingTimeBarBox:setIcon(icon)
    if icon == nil or icon == "" then
        self.bgIcon.transform:SetActiveEx(false)
        return
    end
    self.bgIcon.transform:SetActiveEx(true)

    local defaultLenth = 76
    gg.setSpriteAsync(self.imgIcon, icon, function(image, sprite)
        local persent = defaultLenth / sprite.bounds.size.y
        image.transform.sizeDelta = CS.UnityEngine.Vector2(sprite.bounds.size.x * persent, defaultLenth)
        image.sprite = sprite
    end)
end

function BuildingTimeBarBox:setBtnSpeedUpCallBack(callback)
    self.btnSpeedUpCallback = callback
end

function BuildingTimeBarBox:onClickSpeedUp()
    if self.btnSpeedUpCallback then
        self.btnSpeedUpCallback()
    end
end
