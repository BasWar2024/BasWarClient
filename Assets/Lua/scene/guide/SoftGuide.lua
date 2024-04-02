SoftGuide = SoftGuide or class("SoftGuide")
function SoftGuide:ctor()
    self.isRelease = false
    self.biasX = gg.guideManager.biasX
    self.biasY = gg.guideManager.biasY

    ResMgr:LoadGameObjectAsync("SoftGuideNode", function(go)
        self.gameObject = go
        self.transform = go.transform

        self.btn = self.transform:Find("btn").gameObject
        self.layoutDesc = self.transform:Find("LayoutDesc")
        self.textDesc = self.layoutDesc:Find("TextDesc"):GetComponent(typeof(CS.TextYouYU))
        self.layoutArrow = self.transform:Find("LayoutArrow")
        self.transform:SetParent(gg.guideManager.softGuideRoot, false)

        if not self.isRelease then
            CS.UIEventHandler.Get(self.btn):SetOnClick(gg.bind(self.onBtn, self))
            self:initData()
        end
        return not self.isRelease
    end, true)
end

function SoftGuide:setData(guideNode)
    self.guideNode = guideNode
    if not self.gameObject then
        return
    end
    self.gameObject:SetActiveEx(true)

    self:initData()
end

function SoftGuide:initData()
    if not self.guideNode then
        return
    end

    local guideCfg = self.guideNode.guideCfg
    if guideCfg.targetType == GuideManager.TARGET_TYPE_VIEW then
        local guidingView = self.guideNode.guidingView
        self.targetTrans = guidingView:getGuideRectTransform(guideCfg).transform

        self.posOffset = UnityEngine.Vector3(0, 0)
        if guideCfg.posOffset then
            self.posOffset.x = guideCfg.posOffset[1]
            self.posOffset.y = guideCfg.posOffset[2]
            self.posOffset.z = guideCfg.posOffset[3]
        end

        self.sizeOffset = UnityEngine.Vector3(0, 0, 0)
        if guideCfg.sizeOffset then
            self.sizeOffset.x = guideCfg.sizeOffset[1]
            self.sizeOffset.y = guideCfg.sizeOffset[2]
            self.sizeOffset.z = guideCfg.sizeOffset[3]
        end
    end
    if guideCfg.descText and guideCfg.descText ~= "" then
        self.layoutDesc:SetActiveEx(true)
        self.textDesc:SetLanguageKey(guideCfg.descText)

        local textWidth = math.min(self.textDesc.preferredWidth, PnlGuide.GUIDE_DESC_MAX_WIDTH)
        self.textDesc.transform:SetRectSizeX(textWidth)
        local textHeight = self.textDesc.preferredHeight
        self.layoutDesc.transform.sizeDelta = CS.UnityEngine.Vector2(textWidth + 10 , textHeight + 10)
        
    else
        self.layoutDesc:SetActiveEx(false)
    end
end

function SoftGuide:close()
    if self.gameObject then
        self.guideNode = nil
        self.gameObject:SetActiveEx(false)
    end
end

function SoftGuide:update()
    if not self.btn then
        return
    end

    local guideCfg = self.guideNode.guideCfg
    if guideCfg.targetType == GuideManager.TARGET_TYPE_VIEW then
        local bounds = CS.UnityEngine.RectTransformUtility.CalculateRelativeRectTransformBounds(self.transform, self.targetTrans)
        local boundsMin = bounds.min
        local boundsMax = bounds.max

        boundsMin = boundsMin + self.posOffset
        boundsMax = boundsMax + self.posOffset
        boundsMin.x =  boundsMin.x - self.sizeOffset.x / 2;
        boundsMin.y = boundsMin.y - self.sizeOffset.y / 2;
        boundsMax.x = boundsMax.x + self.sizeOffset.x / 2;
        boundsMax.y = boundsMax.y + self.sizeOffset.y / 2;

        self.btn.transform.anchoredPosition = UnityEngine.Vector2(boundsMin.x + (boundsMax.x - boundsMin.x) / 2, boundsMin.y + (boundsMax.y - boundsMin.y) / 2)
        self.btn.transform.sizeDelta = UnityEngine.Vector2(boundsMax.x - boundsMin.x + 10, boundsMax.y - boundsMin.y + 10)
    end
    self:updatePos()
end

function SoftGuide:updatePos()
    local guideCfg = self.guideNode.guideCfg

    local pos = self.btn.transform.anchoredPosition
    pos.y = pos.y + self.btn.transform.rect.height / 2 + self.layoutArrow.transform.rect.height / 2
    self.layoutArrow.transform.anchoredPosition = pos

    if guideCfg.descText and guideCfg.descText ~= "" then
        local descDir = guideCfg.descDir or 1
        pos = self.btn.transform.anchoredPosition

        local btnHeight = self.btn.transform.rect.height

        if descDir == 1 then
            pos.y = pos.y + btnHeight / 2 + self.layoutDesc.transform.rect.height / 2 + self.layoutArrow.transform.rect.height + 20
        elseif descDir == 2 then
            pos.y = pos.y - btnHeight / 2 - self.layoutDesc.transform.rect.height / 2 - 20
        elseif descDir == 3 then
            pos.x = pos.x - btnWidth / 2 - self.layoutDesc.transform.rect.width / 2 - 20
        elseif descDir == 4 then
            pos.x = pos.x + btnWidth / 2 + self.layoutDesc.transform.rect.width / 2 + 20
        end

        local screenHeight = UnityEngine.Screen.height * self.biasX
        local screenWidth = UnityEngine.Screen.width * self.biasY

        pos.y = math.min(screenHeight / 2 - self.layoutDesc.transform.rect.height / 2 - 5, pos.y)
        pos.y = math.max(-screenHeight / 2 + self.layoutDesc.transform.rect.height / 2 + 5, pos.y)
        pos.x = math.min(screenWidth / 2 - self.layoutDesc.transform.rect.width / 2 - 5, pos.x)
        pos.x = math.max(-screenWidth / 2 + self.layoutDesc.transform.rect.width / 2 + 5, pos.x)

        self.layoutDesc.transform.anchoredPosition = pos
    end
end

function SoftGuide:onBtn()
    self.guideNode:triggerGuide()
end

function SoftGuide:release()
    self.isRelease = true
    self.guideNode = nil

    if self.gameObject then
        CS.UIEventHandler.Clear(self.btn)
        ResMgr:ReleaseAsset(self.gameObject)
        self.gameObject = nil
    end
end
