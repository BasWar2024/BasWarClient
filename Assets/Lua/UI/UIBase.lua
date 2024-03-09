local UIBase = class("UIBase")

function UIBase:ctor(args, onOpen)
    self.onOpen = onOpen
    self.name = self.__name
    self.status =  UIState.loading
    self.monoView = nil -- monoGameObject
    self.layer = 0 -- 
    self.assetHandle = nil --  
    self.events = self.events or {}
    self.prevWindow = nil
    self.nextWindow = nil
    self.destroyTime = 30     -- (),-1=
    self:setArgs(args)

    gg.uiManager:setUITouch(false)
    ResMgr:LoadGameObjectAsync(self.name, function (go)
        if (self.status == UIState.destroy) then
            gg.uiManager:setUITouch(true)
            return false
        end

        go.gameObject.layer = 5

        --go.transform:SetParent(self:getUILayer(window),false)
        if (self.layer == UILayer.scene) then
            go.transform:SetParent(gg.uiManager.uiRoot.sceneNode, false)
        elseif(self.layer == UILayer.main) then
            go.transform:SetParent(gg.uiManager.uiRoot.mainNode, false)
        elseif(self.layer == UILayer.normal) then
            go.transform:SetParent(gg.uiManager.uiRoot.normalNode, false)
        elseif(self.layer == UILayer.information) then
            go.transform:SetParent(gg.uiManager.uiRoot.informationNode, false)
        elseif(self.layer == UILayer.popup) then
            go.transform:SetParent(gg.uiManager.uiRoot.popUpNode, false)
        --elseif(self.layer == UIEnum.tips) then
        else
            go.transform:SetParent(gg.uiManager.uiRoot.tipsNode, false)
        end

        self.transform = go.transform
        self.gameObject = go
        self.monoView = go.transform:GetComponent("MonoView")

        if (self.status == UIState.hide) then
            self.gameObject:SetActive(false)
            self:awake()
        else
            self.status = UIState.loaded
            self:awake()
            self.monoView.onStart = self:start()
        end

        return true
    end)
end

-----------------  --------------
function UIBase:awake()
    gg.uiManager:setUITouch(true)

    if (self.onAwake) then
        self:onAwake()
    end
end

--untiystart, 
function UIBase:start()
    if (self.status == UIState.loaded) then
        self:show()
    end
end

function UIBase:show()
    self.status = UIState.show
    self.gameObject:SetActive(true)
    -- normal push
    if (self.layer == UILayer.normal) then
        gg.uiManager:pushWindow(self)
    end

    self.transform:SetAsLastSibling()
    self:stopDestroyTimer()

    for i, eventName in ipairs(self.events) do
        gg.event:addListener(eventName,self)
     end

    if (self.onShow) then
        self:onShow()
    end

    if self.onOpen then
        self.onOpen(self.gameObject)
    end
end

function UIBase:hide()
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
end

function UIBase:destroy()
    if (self.onDestroy) then
        self:onDestroy()
    end

    self.status = UIState.destroy
    UnityEngine.GameObject.Destroy(self.gameObject)
    ResMgr:ReleaseAsset(self.gameObject)
end

function UIBase:startDestroyTimer()
    if self.destroyTime < 0 then
        return
    end
    self:stopDestroyTimer()
    self.destroyTimer = gg.timer:startTimer(self.destroyTime,function ()
        gg.uiManager:destroyWindow(self.name)
    end)
end

function UIBase:stopDestroyTimer()
    local destroyTimer = self.destroyTimer
    self.destroyTimer = nil
    if destroyTimer then
        gg.timer:stopTimer(destroyTimer)
    end
end

-- 

function UIBase:isLoading()
    return self.status ==  UIState.loading
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

--uinanager
function UIBase:setArgs(args)
    self.args = args
end

function UIBase:close()
    gg.uiManager:closeWindow(self.name)
end

--
function UIBase:getComponent(type,path)
    if not self.monoView then
        return nil
    end
    --tryGetComponent 
    if not path then
        local result, component = self.monoView.gameObject:TryGetComponent(type)
        return component
    else
        local result, component = self.monoView.gameObject.transform:Find(path):TryGetComponent(type)
        return component
    end
end

function UIBase:setOnClick(gameObject, callBack)
    self.releaseEventList = self.releaseEventList or {}
    CS.UIEventHandler.Get(gameObject):SetOnClick(callBack)
    table.insert(self.releaseEventList, gameObject)
end

function UIBase:clearEvent()
    if not self.releaseEventList then
        return
    end
    for index, value in ipairs(self.releaseEventList) do
        CS.UIEventHandler.Clear(value)
    end
    self.releaseEventList = {}
end

-- 
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

return UIBase
