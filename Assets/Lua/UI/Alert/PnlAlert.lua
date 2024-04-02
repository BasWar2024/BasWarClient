PnlAlert = class("PnlAlert", ggclass.UIBase)
PnlAlert.layer = UILayer.tips
PnlAlert.closeType = ggclass.UIBase.CLOSE_TYPE_FORK

-- args = {
--     btnType = , 
--     bgType =  
--     txtYes = , 
--     callbackYes = , 
--     txtNo = , 
--     callbackNo = , 
--     txt = , 
--     toggleText = , 
--     toggleIsOn , 
--     closeLessTick, 
--     title, 
--     sliderLessTick, 
--     sliderLessTotal, 
--     yesCostList = {{cost = , resId = }, }
--     autoCloseRequirement = {type, param1, param2...}
--     autoCloseLessTick,
-- }

PnlAlert.CLOSE_REQUIREMENT_TYPE_BUILD = 1

function PnlAlert:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.openTweenType = nil
    self.events = {"onUpdateBuildData"}
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

PnlAlert.BG_TYPE_SPECIAL = 1
PnlAlert.BG_TYPE_NORMAL = 2
PnlAlert.BG_TYPE_TITLE = 3
PnlAlert.BG_TYPE_RECYCLE = 4

PnlAlert.BTN_TYPE_SINGLE = 1
PnlAlert.BTN_TYPE_PAIR = 2

function PnlAlert:onAwake()
    self.view = ggclass.PnlAlertView.new(self.pnlTransform)
end

function PnlAlert:onShow()
    local view = self.view

    if self:checkToggleAlertTesCost() then
        return
    end

    if self.args.title then
        self.args.bgType = PnlAlert.BG_TYPE_TITLE
    end

    gg.timer:stopTimer(self.autoCloseLessTick)
    if self.args.autoCloseLessTick then
        self.autoCloseTimer = gg.timer:startTimer(self.args.autoCloseLessTick, function()
            self:close()
        end)
    end

    self:bindEvent()
    self:setType()
    self:showTip()

    if self.args.yesCostList and #self.args.yesCostList > 0 then
        view.layoutResCost:SetActiveEx(true)
        for i = 1, #view.yesCostItemList do
            if self.args.yesCostList[i] then
                view.yesCostItemList[i].transform:SetActiveEx(true)
                view.yesCostItemList[i].text.text = Utils.getShowRes(self.args.yesCostList[i].cost,
                    Utils.isMainRes(self.args.yesCostList[i].resId))
                view.yesCostItemList[i].text.transform:SetRectSizeX(view.yesCostItemList[i].text.preferredWidth)
                gg.setSpriteAsync(view.yesCostItemList[i].image,
                    constant.RES_2_CFG_KEY[self.args.yesCostList[i].resId].icon)
            else
                view.yesCostItemList[i].transform:SetActiveEx(false)
            end
        end
    else
        view.layoutResCost:SetActiveEx(false)
    end

    if self.args.toggleText then
        local isOn = true
        if not self.args.toggleIsOn then
            isOn = false
        end
        view.toggle.transform:SetActiveEx(true)
        view.toggle.isOn = isOn
        view.txtToggle.text = self.args.toggleText
    else
        view.toggle.transform:SetActiveEx(false)
    end
    gg.timer:stopTimer(self.closeTimer)
    if self.args.closeLessTick ~= nil then
        self.view.txtTime.transform:SetActiveEx(true)
        local endLessTick = self.args.closeLessTick + os.time()

        self.closeTimer = gg.timer:startLoopTimer(0, 0.3, -1, function()
            local time = endLessTick - os.time()
            view.txtTime.text = time .. "s"
            if time <= 0 then
                self:onBtnNo()
                gg.timer:stopTimer(self.closeTimer)
            end
        end)
    else
        self.view.txtTime.transform:SetActiveEx(false)
    end

    gg.timer:stopTimer(self.sliderTimer)
    if self.args.sliderLessTick ~= nil then
        self.view.slider.transform:SetActiveEx(true)
        local endLessTick = self.args.sliderLessTick + os.time()

        self.sliderTimer = gg.timer:startLoopTimer(0, 0.3, -1, function()
            local time = endLessTick - os.time()
            local hms = gg.time.dhms_time({
                day = false,
                hour = 1,
                min = 1,
                sec = 1
            }, time)
            view.txtSlider.text = string.format("%sH%sM%sS", hms.hour, hms.min, hms.sec)
            view.slider.value = time / self.args.sliderLessTotal

            if time <= 0 then
                self:onBtnNo()
                gg.timer:stopTimer(self.sliderTimer)
            end
        end)
    else
        self.view.slider.transform:SetActiveEx(false)
    end
end

function PnlAlert:checkToggleAlertTesCost()
    self.view.txtAlertLable.transform:SetActiveEx(false)
    -- self.view.toggleAlertTesCost:SetActiveEx(false)
    if self.args.yesCostList and #self.args.yesCostList == 1 then
        for key, value in pairs(self.args.yesCostList) do
            if value.resId == constant.RES_TESSERACT and value.cost <= 100000 then
                if PlayerData.isNotAlertLittleTesCost then
                    self:close()
                    if self.args.callbackYes then
                        self.args.callbackYes(self.view.toggle.isOn)
                    end
                    return true
                else
                    -- self.view.toggleAlertTesCost:SetActiveEx(true)
                    self.view.txtAlertLable.transform:SetActiveEx(true)
                    self.view.toggleAlertTesCost.isOn = PlayerData.isNotAlertLittleTesCost
                end
            end
        end
    end
end

function PnlAlert:onToggleAlertTesCost(isOn)
    PlayerData.isNotAlertLittleTesCost = isOn
end

function PnlAlert:setType()
    local view = self.view
    local bgType = self.args.bgType or PnlAlert.BG_TYPE_NORMAL

    if bgType == PnlAlert.BG_TYPE_SPECIAL then
        gg.setSpriteAsync(view.btnYes.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Button_Atlas[Button 05_button_C]")
        gg.setSpriteAsync(view.btnNo.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Button_Atlas[Button 05_button_C]")
        gg.setSpriteAsync(view.btnClose.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Button_Atlas[Close_icon_B]")
    else
        gg.setSpriteAsync(view.btnYes.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Button_Atlas[Button 06_button_B]")
        gg.setSpriteAsync(view.btnNo.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Button_Atlas[Button 05_button_A]")
        gg.setSpriteAsync(view.btnClose.transform:GetComponent(UNITYENGINE_UI_IMAGE), "Button_Atlas[Close_icon]")
    end
    if bgType == PnlAlert.BG_TYPE_RECYCLE then
        view.root:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(880, 500)
        view.txtTip.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = CS.UnityEngine.Vector2(
            view.txtTip.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition.x, -130)

    else
        view.root:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(1250, 668)
        view.txtTip.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = CS.UnityEngine.Vector2(
            view.txtTip.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition.x, -206)
    end

    for index, value in ipairs(view.bgList) do
        if index == bgType then
            value.transform:SetActiveEx(true)
        else
            value.transform:SetActiveEx(false)
        end
    end

    local btnType = self.args.btnType or PnlAlert.BTN_TYPE_SINGLE
    local closeType = self.args.closeType or 1

    if btnType == PnlAlert.BTN_TYPE_PAIR then
        view.btnNo:SetActiveEx(true)
    else
        view.btnNo:SetActiveEx(false)
    end

    if closeType == 1 then
        view.btnClose:SetActiveEx(true)
    else
        view.btnClose:SetActiveEx(false)
    end

    local txtYes = self.args.txtYes or Utils.getText("name_Change_Yes")
    view.txtBtnYes.text = txtYes

    local txtNo = self.args.txtNo or "no"
    view.txtBtnNo.text = txtNo
end

function PnlAlert:onHide()
    self:releaseEvent()
    gg.timer:stopTimer(self.closeTimer)
    gg.timer:stopTimer(self.sliderTimer)
    gg.timer:stopTimer(self.autoCloseLessTick)
end

function PnlAlert:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)

    self:setOnClick(view.btnClose, gg.bind(self.onBtnNo, self))

    self.view.toggleAlertTesCost.onValueChanged:AddListener(gg.bind(self.onToggleAlertTesCost, self))
end

function PnlAlert:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnYes)
    CS.UIEventHandler.Clear(view.btnNo)
    self.view.toggleAlertTesCost.onValueChanged:RemoveAllListeners()
end

function PnlAlert:onDestroy()
    local view = self.view
end

function PnlAlert:onBtnYes()
    self:close()
    if self.args.callbackYes then
        self.args.callbackYes(self.view.toggle.isOn)
    end
end

function PnlAlert:onBtnNo()
    self:close()
    if self.args.callbackNo then
        self.args.callbackNo()
    end
end

function PnlAlert:showTip()
    self.view.txtTip.text = self.args.txt
    if self.args.title then
        self.view.txtTitle.text = self.args.title
    end
end

function PnlAlert:onUpdateBuildData(_, buildData)
    if self.args.autoCloseRequirement and self.args.autoCloseRequirement[1] == PnlAlert.CLOSE_REQUIREMENT_TYPE_BUILD then
        if buildData.id == self.args.autoCloseRequirement[2] then
            self:close()
        end
    end
end

return PnlAlert
