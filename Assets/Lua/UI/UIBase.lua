local UIBase = class("UIBase")

UIBase.CLOSE_TYPE_NONE = 0
UIBase.CLOSE_TYPE_BG = 1
UIBase.CLOSE_TYPE_FORK = 2

UIBase.INFOMATION_NORMAL = 0
UIBase.INFOMATION_HIDE = 1
UIBase.INFOMATION_RES = 2
UIBase.INFOMATION_BASE_RES = 3

-----------------------"" ""ctor"" ""self""
UIBase.openTweenType = nil -- ""
UIBase.closeType = nil
UIBase.layer = 0 -- ""

UIBase.infomationType = UIBase.INFOMATION_HIDE

UIBase.showViewAudio = nil

UIBase.needFitSafeArea = false

UIBase.canvasBgColor = CS.UnityEngine.Color(0x00/0xff, 0x00/0xff, 0x00/0xff, 0.8)

--------------------------------------------
function UIBase:ctor(args, onOpen, isLoadCanvas)
    self.onOpen = onOpen
    self.name = self.__name
    self.status = UIState.loading
    self.monoView = nil -- monoGameObject
    -- self.layer = 0 -- ""
    self.assetHandle = nil -- "" ""
    self.events = self.events or {}
    self.prevWindow = nil
    self.nextWindow = nil
    self.destroyTime = 5 -- ""(""),-1=""
    self:setArgs(args)
    self.transform = nil
    self.pnlTransform = nil
    self.pnlGameObject = nil
    self.releaseEventList = nil
    self.destroyReleaseEventList = nil

    self.needBlurBG = false
    self.blurBG = nil
    self.rawImage = nil
    self.blurBgRt = nil
    if isLoadCanvas and self.openTweenType == nil then
        -- self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_SCALE
    end

    gg.uiManager:setUITouch(false)

    local prefabPath = self.name
    if isLoadCanvas then
        prefabPath = "PnlCanvas"
        ResMgr:LoadGameObjectAsync(self.name, function(pnlGameObject)
            self.pnlGameObject = pnlGameObject
            self.pnlTransform = pnlGameObject.transform
            if self.transform then
                self.pnlTransform:SetParent(self.transform, false)
                self:awakeOnLoad()
            end
            return true
        end)
    end

    ResMgr:LoadGameObjectAsync(prefabPath, function(go)
        if (self.status == UIState.destroy) then
            gg.uiManager:setUITouch(true)
            return false
        end

        self.canvasBg = go.transform:Find("canvasBg")
        self.closeType = self.closeType or UIBase.CLOSE_TYPE_BG
        -- if self.closeType == UIBase.CLOSE_TYPE_BG and self.canvasBg then

        if self.canvasBg then
            self:setOnClick(self.canvasBg.gameObject, function()
                if self.closeType == UIBase.CLOSE_TYPE_BG then
                    self:close()
                end
            end, true)

            self.canvasBg.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = self.canvasBgColor

            -- if self.needFitSafeArea then
            --     self.canvasBg.transform:GetComponent(UNITYENGINE_UI_IMAGE).color =  CS.UnityEngine.Color(0x00/0xff, 0x00/0xff, 0x00/0xff, 1)
            -- else
            --     self.canvasBg.transform:GetComponent(UNITYENGINE_UI_IMAGE).color =  CS.UnityEngine.Color(0x00/0xff, 0x00/0xff, 0x00/0xff, 0.8)
            -- end
        end

        -- gg.bind(self.close, self)
        -- end

        local b = go.transform:TryGetComponent(typeof(UnityEngine.CanvasGroup))

        if b then
            self.canvasGroup = go.transform:GetComponent("CanvasGroup")
        else
            self.canvasGroup = go:AddComponent(typeof(UnityEngine.CanvasGroup))
        end

        go.gameObject.layer = 5
        -- go.transform:SetParent(self:getUILayer(window),false)
        if (self.layer == UILayer.scene) then
            go.transform:SetParent(gg.uiManager.uiRoot.sceneNode, false)
        elseif (self.layer == UILayer.main) then
            go.transform:SetParent(gg.uiManager.uiRoot.mainNode, false)
        elseif (self.layer == UILayer.normal) then
            go.transform:SetParent(gg.uiManager.uiRoot.normalNode, false)
        elseif (self.layer == UILayer.information) then
            go.transform:SetParent(gg.uiManager.uiRoot.informationNode, false)
        elseif (self.layer == UILayer.popup) then
            go.transform:SetParent(gg.uiManager.uiRoot.popUpNode, false)
            -- elseif(self.layer == UIEnum.tips) then
        else
            go.transform:SetParent(gg.uiManager.uiRoot.tipsNode, false)
        end
        self.transform = go.transform
        -- self.transform:SetActiveEx(false)
        self.gameObject = go
        self.monoView = go.transform:GetComponent("MonoView")
        self.gameObject.name = self.name
        if isLoadCanvas then
            if self.pnlTransform then
                self.pnlTransform:SetParent(self.transform, false)
                self:awakeOnLoad()
            end
        else
            self.pnlTransform = self.transform
            self:awakeOnLoad()
        end

        return true
    end)
end

function UIBase:fitArea()
    if not (CS.Appconst.platform == "iosAppstore" or CS.Appconst.platform == "iosGB") then
        return
    end

    local safeAreaWidth = CS.UnityEngine.Screen.safeArea.width
    local screenWidth = CS.UnityEngine.Screen.width

    local fitW = (screenWidth - safeAreaWidth) * 0.9
    -- fitW = 100

    self.pnlTransform.anchoredPosition = UnityEngine.Vector2(fitW / 2, 0)
    self.pnlTransform:SetRectSizeX(-fitW)
end

function UIBase:awakeOnLoad()
    if self.needFitSafeArea then
        self:fitArea()
    end

    self.tweenObjectsMove = self.pnlTransform:GetComponent("TweenObjectsMove")
    if self.tweenObjectsMove then
        self.tweenObjectsMove.canvasGroup = self.canvasGroup
        self.tweenObjectsMove.isTest = false
    end
    -- print(table.dump(self.pnlTransform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).offsetMin))
    -- self.pnlTransform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).offsetMin =
    --     Vector2.New(60, self.pnlTransform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).offsetMin.y)
    -- self.pnlTransform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).offsetMax =
    --     Vector2.New(-60, self.pnlTransform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).offsetMax.y)

    -- self.tweenObjectsMove = self.pnlTransform:TryGetComponent(typeof(UnityEngine.TweenObjectsMove))

    -- local b = go.transform:TryGetComponent(typeof(UnityEngine.CanvasGroup))

    -- if b then
    --     self.canvasGroup = go.transform:GetComponent("CanvasGroup")
    -- else
    --     self.canvasGroup = go:AddComponent(typeof(UnityEngine.CanvasGroup))
    -- end

    if (self.status == UIState.hide) then
        self.gameObject:SetActiveEx(false)
        self:awake()
    else
        self.gameObject:SetActiveEx(true)
        self.status = UIState.loaded
        self:awake()
        if self.monoView then
            self.monoView.onStart = self:start()
        else
            self:start()
        end
    end
end

----------------- "" --------------
function UIBase:awake()
    gg.uiManager:setUITouch(true)

    if (self.onAwake) then
        self:onAwake()
    end
end

-- ""untiy""start"", ""
function UIBase:start()
    if (self.status == UIState.loaded) then
        self:show()
    end
end

function UIBase:setBlurImage(rt)
    if self.gameObject ~= nil then
        self.blurBgRt = rt;
        self.rawImage.texture = self.blurBgRt;
        -- self.gameObject:SetActive(true);
        self.rawImage.color = CS.UnityEngine.Color(1, 1, 1, 1);
    else
        CS.UnityEngine.RenderTexture:ReleaseTemporary(rt)
    end
end

function UIBase:show()
    gg.event:dispatchEvent("onHideBoxResDetailed")
    self.gameObject:SetActive(true)
    if self.needBlurBG then
        self.gameObject:SetActive(false)
        self.blurBG = CS.UnityEngine.GameObject('blurBg')
        self.blurBG.transform:SetParent(self.transform)
        self.blurBG.transform.localScale = CS.UnityEngine.Vector3.one
        self.blurBG.transform:SetAsFirstSibling()
        self.blurBG:AddComponent(typeof(CS.UnityEngine.RectTransform))
        self.blurBG.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = CS.UnityEngine.Vector2(0, 0)
        self.blurBG.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchorMin = CS.UnityEngine.Vector2(0, 0)
        self.blurBG.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchorMax = CS.UnityEngine.Vector2(1, 1)
        self.blurBG.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).offsetMin = CS.UnityEngine.Vector2(0, 0)
        self.blurBG.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).offsetMax = CS.UnityEngine.Vector2(0, 0)
        -- self.blurBG.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).localScale = CS.UnityEngine.Vector3(1, -1, 1)

        self.rawImage = self.blurBG:AddComponent(typeof(CS.UnityEngine.UI.RawImage))
        self.rawImage.color = CS.UnityEngine.Color(1, 1, 1, 0);
        gg.uiManager.uiRoot.UIBlurEffectVolume.Blur_callback = function(rt)
            self:setBlurImage(rt)
            gg.event:dispatchEvent("onViewOpenOrHide", self)
            self.gameObject:SetActive(true)
            self:playOpenAnim()
        end

        -- gg.uiManager.uiRoot.uIBlurEffect:EnableBlurRender()
        gg.uiManager.uiRoot.UIBlurEffectVolume.Render_blur_screenShot = CS.UnityEngine.Rendering.BoolParameter(true)
        if self.closeType == UIBase.CLOSE_TYPE_BG then
            self:setOnClick(self.blurBG.gameObject, gg.bind(self.close, self))
        end

        if self.canvasBg then
            -- self.canvasBg.gameObject:SetActiveEx(false)
            self.canvasBg.gameObject:SetActiveEx(true)
        end
    else
        if self.canvasBg then
            self.canvasBg.gameObject:SetActiveEx(true)
        end
    end

    self.status = UIState.show

    if not typeof(self.canvasGroup) then
        self.canvasGroup.alpha = 1
    end

    -- normal ""push""
    if (self.layer == UILayer.normal) then
        gg.uiManager:pushWindow(self)
    end

    self.transform:SetAsLastSibling()
    self:stopDestroyTimer()

    for i, eventName in ipairs(self.events) do
        gg.event:addListener(eventName, self)
    end

    self:playOpenAnim()

    if self.showViewAudio then
        -- AudioFmodMgr:PlaySFX(self.showViewAudio.event)
        -- AudioFmodMgr:Play2DOneShot(self.showViewAudio.event, self.showViewAudio.bank)
    end

    if (self.onShow) then
        self:onShow()
    end

    if self.onOpen then
        self.onOpen(self.gameObject)
    end

    gg.event:dispatchEvent("onViewOpenOrHide", self)
end

function UIBase:playOpenAnim()
    if not self.isNotPlayOpenAni and self.transform.gameObject.activeSelf then
        if self.openTweenType then
            UiTweenUtil.playTweenByType(self.openTweenType, self, self.pnlTransform)
        end
        if self.tweenObjectsMove and self.tweenObjectsMove.isActiveAndEnabled then
            self.tweenObjectsMove:startTween()
        end
    end
end

function UIBase:hide()
    gg.event:dispatchEvent("onHideBoxResDetailed")
    self.status = UIState.hide
    if (self.gameObject == nil) then
        return
    end

    self.gameObject:SetActive(false)

    for i, eventName in ipairs(self.events) do
        gg.event:removeListener(eventName, self)
    end

    self:startDestroyTimer()

    if (self.onHide) then
        self:onHide()
    end
    self:clearEvent()

    if self.needBlurBG then
        if self.blurBG ~= nil then
            CS.UnityEngine.Object.Destroy(self.blurBG)
            self.blurBG = nil
            self.rawImage = nil
        end

        if self.blurBgRt ~= nil then
            CS.UnityEngine.RenderTexture:ReleaseTemporary(self.blurBgRt)
            self.blurBgRt = nil
        end
    end

    gg.event:dispatchEvent("onViewOpenOrHide", self)
end

function UIBase:refresh(...)
    self:onRefresh(...)
end

-- overide
function UIBase:onRefresh(...)
end

function UIBase:destroy()
    self:stopDestroyTimer()
    self:clearEvent(self.destroyReleaseEventList)
    if self.view and self.onDestroy then
        self:onDestroy()
    end

    self.status = UIState.destroy
    -- UnityEngine.GameObject.Destroy(self.gameObject)
    if self.pnlGameObject then
        ResMgr:ReleaseAsset(self.pnlGameObject)
    end
    ResMgr:ReleaseAsset(self.gameObject)
    self.pnlGameObject = nil
    self.gameObject = nil
    self.transform = nil
    self.pnlTransform = nil
    self.view = nil

end

function UIBase:startDestroyTimer()
    if self.destroyTime < 0 then
        return
    end
    self:stopDestroyTimer()

    self.destroyEndTime = os.time() + self.destroyTime
    self.destroyTimer = gg.timer:startLoopTimer(0, 1, -1, function()
        if self.destroyEndTime <= os.time() then
            gg.uiManager:destroyWindow(self.name)
        end
    end)

    -- self.destroyTimer = gg.timer:startTimer(self.destroyTime, function()
    --     gg.uiManager:destroyWindow(self.name)
    -- end)
end

function UIBase:stopDestroyTimer()
    local destroyTimer = self.destroyTimer
    self.destroyTimer = nil
    if destroyTimer then
        gg.timer:stopTimer(destroyTimer)
    end
end

-- ""

function UIBase:isLoading()
    return self.status == UIState.loading
end

function UIBase:isLoaded()
    return self.status == UIState.loaded
end

function UIBase:isShow()
    return self.status == UIState.show
end

function UIBase:isHide()
    return self.status == UIState.hide
end

function UIBase:isDestroy()
    return self.status == UIState.destroy
end

-- uinanager""
function UIBase:setArgs(args)
    self.args = args
end

function UIBase:close()
    gg.uiManager:closeWindow(self.name)
end

-- ""
function UIBase:getComponent(type, path)
    if not self.monoView then
        return nil
    end
    -- ""tryGetComponent ""
    if not path then
        local result, component = self.monoView.gameObject:TryGetComponent(type)
        return component
    else
        local result, component = self.monoView.gameObject.transform:Find(path):TryGetComponent(type)
        return component
    end
end

UIBase.DEFAULT_AUDIO = "event:/UI_button_click"
UIBase.DEFAULT_BANK = "se_UI"

function UIBase:setOnClick(gameObject, callBack, isDestroyRelease, audioName, bank, isDelay)
    self.releaseEventList = self.releaseEventList or {}
    self.destroyReleaseEventList = self.destroyReleaseEventList or {}

    if isDelay == nil then
        isDelay = true
    end

    audioName = audioName or UIBase.DEFAULT_AUDIO
    bank = bank or UIBase.DEFAULT_BANK
    CS.UIEventHandler.Get(gameObject):SetOnClick(callBack, audioName, bank, isDelay)

    if isDestroyRelease then
        table.insert(self.destroyReleaseEventList, gameObject)
    else
        table.insert(self.releaseEventList, gameObject)
    end
end

function UIBase:clearEvent(list)
    if not list then
        list = self.releaseEventList
    end
    if not list then
        return
    end

    for index, value in ipairs(list) do
        CS.UIEventHandler.Clear(value)
    end

    table.clear(list)
end

function UIBase:setIsNotPlayOpenAni(isNotPlay)
    self.isNotPlayOpenAni = isNotPlay
end

-- ""
function UIBase:getText(path)
    return self:getComponent(typeof(UnityEngine.UI.Text), path)
end

function UIBase:getImage(path)
    return self:getComponent(typeof(UnityEngine.UI.Image), path)
end

function UIBase:getButton(path)
    return self:getComponent(typeof(UnityEngine.UI.Button), path)
end

function UIBase:getInput(path)
    return self:getComponent(typeof(UnityEngine.UI.InputField), path)
end

function UIBase:getSlider(path)
    return self:getComponent(typeof(UnityEngine.UI.Slider), path)
end

function UIBase:getScrollRect(path)
    return self:getComponent(typeof(UnityEngine.UI.ScrollRect), path)
end

function UIBase:getRectTransfrom(path)
    return self:getComponent(typeof(UnityEngine.RectTransform), path)
end

-- guide
-- ""ui
-- override
function UIBase:getGuideRectTransform(guideCfg)
    if self.view then
        return self.view[guideCfg.gameObjectName]
    end
end

-- override
function UIBase:triggerGuideClick(guideCfg)
    if self[guideCfg.viewFuncName] then
        self[guideCfg.viewFuncName](self, gg.unPackArgs(guideCfg.eventArgs))
    end
end

return UIBase
