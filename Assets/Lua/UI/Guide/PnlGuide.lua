
PnlGuide = class("PnlGuide", ggclass.UIBase)

function PnlGuide:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    -- self.layer = UILayer.normal
    self.layer = UILayer.information
    self.events = {"onUpData" }
    self.layer = UILayer.popup
end

function PnlGuide:onAwake()
    self.view = ggclass.PnlGuideView.new(self.pnlTransform)

    local color = self.view.mask.color
    color.a = 0
    self.view.mask.color = color
    -- self.view.mask.gameObject:SetActiveEx(false)

    self.biasX = gg.guideManager.biasX
    self.biasY = gg.guideManager.biasY
end

PnlGuide.MASK_STATUS_PLAYING = 1
PnlGuide.MASK_STATUS_FINISH = 2

function PnlGuide:onUpData()
    local view = self.view
    local guideCfg = self.guideCfg

    if guideCfg.targetType == gg.guideManager.TARGET_TYPE_BUILDING or guideCfg.targetType == gg.guideManager.TARGET_TYPE_BATTLE_BUILDING then
        local pos

        if guideCfg.targetType == gg.guideManager.TARGET_TYPE_BUILDING then
            pos = self.followGo.transform.position
        elseif guideCfg.targetType == gg.guideManager.TARGET_TYPE_BATTLE_BUILDING then
            pos = Vector3(self.followPos.x, self.followPos.y, self.followPos.z)
        end

        if guideCfg.buildingEvent == GuideManager.BUILDING_EVENT_SELF  then
            --pos.x = pos.x + gg.guideManager.guidingBuild.buildCfg.width / 2
            -- pos.y = pos.y + self.guideNode.guidingBuild.buildCfg.length / 2
            pos.y = pos.y + self.guideNode.guidingBuild.buildCfg.length
        end

        local screenPos = UnityEngine.Camera.main:WorldToScreenPoint(pos)
        screenPos.x = screenPos.x * self.biasX
        screenPos.y = screenPos.y * self.biasY
        self.view.transReplace.transform.anchoredPosition = UnityEngine.Vector2(screenPos.x, screenPos.y) + UnityEngine.Vector2(self.posOffset.x, self.posOffset.y)
    end

    if guideCfg.targetType == gg.guideManager.TARGET_TYPE_BUILDING 
        or guideCfg.targetType == gg.guideManager.TARGET_TYPE_VIEW 
        or self.targetType == gg.guideManager.TARGET_TYPE_BATTLE_BUILDING then
            if view.mask.Status == PnlGuide.MASK_STATUS_FINISH then
                view.layourArrow:SetActiveEx(true)
                local pos = self.view.btn.transform.anchoredPosition
                local btnWidth = view.btn.transform.rect.width
                local btnHeight = view.btn.transform.rect.height
                
                pos.y = pos.y + btnHeight / 2 + view.layourArrow.transform.rect.height / 2
                view.layourArrow.transform.anchoredPosition = pos

                if guideCfg.descText and guideCfg.descText ~= "" then
                    view.layourDesc:SetActiveEx(true)
                    local descDir = guideCfg.descDir or 1
                    pos = view.btn.transform.anchoredPosition
                    if descDir == 1 then
                        pos.y = pos.y + btnHeight / 2 + view.layourDesc.transform.rect.height / 2 + view.layourArrow.transform.rect.height + 20
                    elseif descDir == 2 then
                        pos.y = pos.y - btnHeight / 2 - view.layourDesc.transform.rect.height / 2 - 20
                    elseif descDir == 3 then
                        pos.x = pos.x - btnWidth / 2 - view.layourDesc.transform.rect.width / 2 - 20
                    elseif descDir == 4 then
                        pos.x = pos.x + btnWidth / 2 + view.layourDesc.transform.rect.width / 2 + 20
                    end

                    local screenHeight = UnityEngine.Screen.height * self.biasX
                    local screenWidth = UnityEngine.Screen.width * self.biasY

                    pos.y = math.min(screenHeight / 2 - view.layourDesc.transform.rect.height / 2 - 5, pos.y)
                    pos.y = math.max(-screenHeight / 2 + view.layourDesc.transform.rect.height / 2 + 5, pos.y)
                    pos.x = math.min(screenWidth / 2 - view.layourDesc.transform.rect.width / 2 - 5, pos.x)
                    pos.x = math.max(-screenWidth / 2 + view.layourDesc.transform.rect.width / 2 + 5, pos.x)

                    view.layourDesc.transform.anchoredPosition = pos
                end
            else
                view.layourArrow:SetActiveEx(false)
                view.layourDesc:SetActiveEx(false)
            end
    end
end

PnlGuide.GUIDE_DESC_MAX_WIDTH = 400

-- args = {isPlayAnim = , guideCfg = , guideNode}
function PnlGuide:onShow()
    self:bindEvent()

    self.openTime = os.time()

    local view = self.view
    view.imgSlider.fillAmount = 0

    self.guideCfg = self.args.guideCfg
    self.guideNode = self.args.guideNode

    view.mask:SetAnimPopulateMeshCallBack(gg.bind(self.animPopulateMeshCallBack, self))

    view.imgBtn.color = UnityEngine.Color(0xaa/0xff, 0xaa/0xff, 0xaa/0xff, 130 / 255)
    view.imgBtnInside.gameObject:SetActiveEx(false)
    view.layourArrow:SetActiveEx(false)
    view.layourDesc:SetActiveEx(false)
    view.layoutTalk:SetActiveEx(false)

    local guideCfg = self.guideCfg
    if guideCfg.descText and guideCfg.descText ~= "" then
        view.textDesc:SetLanguageKey(guideCfg.descText)

        local textWidth = math.min(view.textDesc.preferredWidth, PnlGuide.GUIDE_DESC_MAX_WIDTH)
        view.textDesc.transform:SetRectSizeX(textWidth)
        local textHeight = view.textDesc.preferredHeight
        view.layourDesc.transform.sizeDelta = CS.UnityEngine.Vector2(textWidth + 10 , textHeight + 10)
    end

    self.posOffset = UnityEngine.Vector3(0, 0, 0)
    local sizeOffset = UnityEngine.Vector3(10, 10, 0)

    if guideCfg.posOffset then
        self.posOffset.x = guideCfg.posOffset[1]
        self.posOffset.y = guideCfg.posOffset[2]
        self.posOffset.z = guideCfg.posOffset[3]
    end

    if guideCfg.sizeOffset then
        sizeOffset.x = guideCfg.sizeOffset[1]
        sizeOffset.y = guideCfg.sizeOffset[2]
        sizeOffset.z = guideCfg.sizeOffset[3]
    end

    view.imgBtn.raycastTarget = true
    self.targetType = guideCfg.targetType
    if self.targetType == gg.guideManager.TARGET_TYPE_ONLY_TALK then
        view.layoutTalk:SetActiveEx(true)

        view.imgBtn.color = UnityEngine.Color(0xaa/0xff, 0xaa/0xff, 0xaa/0xff, 0)
        view.imgBtnInside.gameObject:SetActiveEx(true)

        view.mask:SetTargetObj(self.view.transReplace, self.posOffset, sizeOffset)
        local screenWidth = UnityEngine.Screen.width
        local screenHeight = UnityEngine.Screen.height
        
        self.view.transReplace.transform.sizeDelta = UnityEngine.Vector2(screenWidth * 10, screenHeight * 10)
        self.view.transReplace.transform.anchoredPosition = UnityEngine.Vector2(screenWidth / 2, screenHeight/ 2)

        if guideCfg.talkLeftText ~= "" then
            view.layoutLeft:SetActiveEx(true)
            view.layoutRight:SetActiveEx(false)
            view.txtLeftTalk:SetLanguageKey(guideCfg.talkLeftText)
        elseif guideCfg.talkRightText ~= "" then
            view.layoutLeft:SetActiveEx(false)
            view.layoutRight:SetActiveEx(true)
            
        end

        if guideCfg.talkLeftText ~= "" or guideCfg.talkRightText ~= "" then
            if guideCfg.talkLeftText ~= "" then
                view.layoutLeft:SetActiveEx(true)
                view.txtLeftTalk:SetLanguageKey(guideCfg.talkLeftText)
            else
                view.layoutLeft:SetActiveEx(false)
            end

            if guideCfg.talkRightText ~= "" then
                view.layoutRight:SetActiveEx(true)
                view.txtRightTalk:SetLanguageKey(guideCfg.talkRightText)
            else
                view.layoutRight:SetActiveEx(false)
            end
        end

    elseif self.targetType == gg.guideManager.TARGET_TYPE_VIEW then
        view.layourArrow:SetActiveEx(view.mask.Status == PnlGuide.MASK_STATUS_FINISH)
        local guidingView = self.guideNode.guidingView
        view.mask:SetTargetObj(guidingView:getGuideRectTransform(guideCfg).transform, self.posOffset, sizeOffset)

    elseif self.targetType == gg.guideManager.TARGET_TYPE_BUILDING then
        view.layourArrow:SetActiveEx(view.mask.Status == PnlGuide.MASK_STATUS_FINISH)
        view.mask:SetTargetObj(self.view.transReplace, UnityEngine.Vector3(0, 0, 0), UnityEngine.Vector3(0, 0, 0))

        local guidingBuild = self.guideNode.guidingBuild

        local go, size = guidingBuild:getGuideGameObject(guideCfg)
        self.followGo = go
        self.view.transReplace.transform.sizeDelta = size + UnityEngine.Vector2(sizeOffset.x, sizeOffset.y)

    elseif self.targetType == gg.guideManager.TARGET_TYPE_BATTLE_BUILDING then
        view.imgBtn.raycastTarget = false
        view.layourArrow:SetActiveEx(view.mask.Status == PnlGuide.MASK_STATUS_FINISH)
        
        self.followPos = self.guideNode.guidingBuild.buildCfg.pos

        if guideCfg.otherArgs and guideCfg.otherArgs[2] == "deployArea" then
            self.view.transReplace.transform.sizeDelta = UnityEngine.Vector2(70, 70) + UnityEngine.Vector2(sizeOffset.x, sizeOffset.y)
            
        elseif guideCfg.otherArgs and guideCfg.otherArgs[2] == "SigninPos" then
            self.view.transReplace.transform.sizeDelta = UnityEngine.Vector2(110, 110) + UnityEngine.Vector2(sizeOffset.x, sizeOffset.y)

        elseif guideCfg.otherArgs and guideCfg.otherArgs[2] == "needCureSoldier" then
            view.imgBtn.raycastTarget = true
            self.view.transReplace.transform.sizeDelta = UnityEngine.Vector2(50, 50) + UnityEngine.Vector2(sizeOffset.x, sizeOffset.y)

        elseif guideCfg.otherArgs and guideCfg.otherArgs[2] == "findHurtBuild" then
            view.imgBtn.raycastTarget = true
            self.view.transReplace.transform.sizeDelta = UnityEngine.Vector2(100, 100) + UnityEngine.Vector2(sizeOffset.x, sizeOffset.y)

        else
            self.view.transReplace.transform.sizeDelta = UnityEngine.Vector2(382, 340) + UnityEngine.Vector2(sizeOffset.x, sizeOffset.y)
        end

        view.mask:SetTargetObj(self.view.transReplace, UnityEngine.Vector3(0, 0, 0), UnityEngine.Vector3(0, 0, 0))
    end

    if self.args.isPlayAnim then
        view.mask:PlayAnim(0.5)

        local color = view.mask.color
        local sequence = CS.DG.Tweening.DOTween.Sequence()
    
        local beginValue = 0
        local endValue = 0.5
        local duration = 0.2
    
        local getter = function ()
            return beginValue
        end
        local setter = function (value)
            color.a = value
            view.mask.color = color
        end
        sequence:Append(CS.DG.Tweening.DOTween.To(getter, setter, endValue, duration))
    else
        local color = view.mask.color
        color.a = 0.5
        view.mask.color = color
    end
end

function PnlGuide:animPopulateMeshCallBack(targetMin, targetMax)
    local view = self.view
    view.btn.transform.anchoredPosition = UnityEngine.Vector2(targetMin.x + (targetMax.x - targetMin.x) / 2, targetMin.y + (targetMax.y - targetMin.y) / 2)
    view.btn.transform.sizeDelta = UnityEngine.Vector2(targetMax.x - targetMin.x + 10, targetMax.y - targetMin.y + 10)
end

function PnlGuide:onHide()
    self:releaseEvent()
    self.followGo = nil
end

function PnlGuide:bindEvent()
    local view = self.view
    self:setOnClick(view.btn, gg.bind(self.onBtn, self), nil, nil, nil, false)
    self:setOnClick(view.mask.gameObject, gg.bind(self.onBtnMask, self), nil, nil, nil, false)
    CS.UIEventHandler.Get(view.btnSkip):SetOnPointerDown(gg.bind(self.onSkipDown, self))
    CS.UIEventHandler.Get(view.btnSkip):SetOnPointerUp(gg.bind(self.onSkipUp, self))
end

function PnlGuide:onBtn()
    if os.time() - self.openTime < 1 then
        return
    end

    if self.view.mask.Status == 1 then
        return
    end
    -- self:close()
    self.guideNode:triggerGuide()
end

function PnlGuide:onBtnMask()
    if self.guideNode.otherGuideType then
        self.guideNode:skipGuide()
        self:close()
    end
end

function PnlGuide:onSkipDown()
    -- local time = 0
    -- self.addTimer = gg.timer:startLoopTimer(0, 0.1, -1, function()
    --     time = time + 0.1
    --     if time >= 0.8 then
    --         self.guideNode:skipGuide()
    --         self:close()
    --     end
    -- end)
    local view = self.view

    view.imgSlider.fillAmount = 0
    self.skipSequence = CS.DG.Tweening.DOTween.Sequence()
    self.skipSequence:Append(view.imgSlider:DOFillAmount(1, 0.6):SetEase(CS.DG.Tweening.Ease.Linear))
    self.skipSequence:AppendCallback(function()
        gg.guideManager:addGuide(2003, true)
        self.guideNode:skipGuide()
        self:close()
    end)
end

function PnlGuide:onSkipUp()
    -- gg.timer:stopTimer(self.addTimer)
    self.view.imgSlider.fillAmount = 0
    if self.skipSequence then
        self.skipSequence:Kill()
    end
end

function PnlGuide:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(self.view.btnSkip)
    gg.timer:stopTimer(self.addTimer)
    if self.skipSequence then
        self.skipSequence:Kill()
    end
end

function PnlGuide:onDestroy()
    local view = self.view
end

return PnlGuide