UIBaseItem = UIBaseItem or class("UIBaseItem")

-- "" ""ctor"" ""self""
UIBaseItem.events = {}
--
UIBaseItem.STAGE_INIT = 1
UIBaseItem.STAGE_RELEASE = 2
function UIBaseItem:ctor(obj, ...)
    self.obj = obj
    self.gameObject = obj.gameObject
    self.transform = obj.transform
    self.releaseEventList = {}
    self.stage = UIBaseItem.STAGE_INIT

    -- self:addAllListener(true)
    self:onInit(...)
    -- self:open()
end

function UIBaseItem:open(...)
    self:setActive(true)
    self:addAllListener(true)
    self:onOpen(...)
end

function UIBaseItem:close()
    self:setActive(false)
    self:addAllListener(false)
    self:onClose()
end

function UIBaseItem:addAllListener(isAdd)
    if isAdd then
        for i, eventName in ipairs(self.events) do
            gg.event:addListener(eventName, self)
        end
    else
        for i, eventName in ipairs(self.events) do
            gg.event:removeListener(eventName, self)
        end
    end
end

function UIBaseItem:getItem(obj, list, ...)
    if not obj then
        return
    end

    if list and list[obj] then
        return list[obj]
    end
    local item = self.new(obj, ...)
    if list then
        list[obj] = item
    end
    return item
end

function UIBaseItem:release()
    self.stage = UIBaseItem.STAGE_RELEASE
    if not self.gameObject then
        return
    end
    for index, value in ipairs(self.releaseEventList) do
        CS.UIEventHandler.Clear(value)
    end
    self.initData = nil
    self.releaseEventList = {}
    self:close()
    self:onRelease()
    self.obj = nil
    self.gameObject = nil
    self.transform = nil

end

function UIBaseItem:setOnClick(gameObject, callBack, audioName, bank, isDelay)
    if isDelay == nil then
        isDelay = true
    end
    audioName = audioName or ggclass.UIBase.DEFAULT_AUDIO
    bank = bank or ggclass.UIBase.DEFAULT_BANK

    CS.UIEventHandler.Get(gameObject):SetOnClick(callBack, audioName, bank, isDelay)
    table.insert(self.releaseEventList, gameObject)
end

function UIBaseItem:setOnLongPress(gameObject, callBack)
    CS.UIEventHandler.Get(gameObject.gameObject):SetOnLongPress(callBack)
end

function UIBaseItem:Find(path, component)
    if component then
        return self.transform:Find(path):GetComponent(component)
    else
        return self.transform:Find(path).gameObject
    end
end

function UIBaseItem:setActive(isActive)
    self.gameObject:SetActiveEx(isActive)
end

-- override
function UIBaseItem:onInit(...)
end

function UIBaseItem:onOpen(...)
end

function UIBaseItem:onClose()
end

function UIBaseItem:onRelease()
end
-------------------------------------------------------------------
UIScrollView = UIScrollView or class("UIScrollView")

function UIScrollView:ctor(obj, itemName, releaseItemList, isNotUsePool, isUseSystemPool)
    self.itemName = itemName
    self.releaseItemList = releaseItemList or {}
    self.isUsePool = not isNotUsePool
    self.gameObject = obj.gameObject
    self.transform = obj.transform
    self.component = obj.transform:GetComponent(typeof(UnityEngine.UI.ScrollRect))
    self.content = self.component.content
    self.itemPool = {}

    self.loadingIndex = 0
    self.loadingAsyncMap = {}
    if not isUseSystemPool then
        isUseSystemPool = false
    end
    self.isUseSystemPool = isUseSystemPool
end

function UIScrollView:setRenderHandler(handler)
    self.renderHandler = handler
end

function UIScrollView:setRenderFinishCallback(callback)
    self.finishCallBack = callback
end

function UIScrollView:renderFinish()
    self.isRenderFinish = true
    if self.finishCallBack then
        self.finishCallBack()
    end
end

function UIScrollView:setContentAnchoredPosition(x, y)
    x = x or self.content.anchoredPosition.x
    y = y or self.content.anchoredPosition.y

    local pos = CS.UnityEngine.Vector2(x, y)
    self.content.transform.anchoredPosition = pos
end

function UIScrollView:setItemCount(count)
    self.itemCount = count

    self.component:StopMovement()
    self.isRenderFinish = false
    local loadingCount = count - self.content.transform.childCount
    self.loadingAsyncMap = {}

    if loadingCount == 0 then
        self:refresh()
    elseif loadingCount < 0 then
        for i = 1, -loadingCount do
            local go = self.content.transform:GetChild(0)
            go.transform:SetParent(self.transform, false)
            go.gameObject:SetActiveEx(false)

            if self.isUsePool then
                table.insert(self.itemPool, go)
            else
                UnityEngine.GameObject.Destroy(go.gameObject)
            end
        end
        self:refresh()
    else
        local refreshIndex = 0
        for i = 1, count - loadingCount do
            refreshIndex = refreshIndex + 1
            self:refreshOne(refreshIndex)
        end
        for i = 1, #self.itemPool do
            if loadingCount > 0 then
                local go = table.remove(self.itemPool, 1)
                go.transform:SetParent(self.content.transform, false)
                go.gameObject:SetActiveEx(true)
                loadingCount = loadingCount - 1
                refreshIndex = refreshIndex + 1
                self:refreshOne(refreshIndex, go.gameObject)
            else
                break
            end
        end

        if loadingCount <= 0 then
            self:renderFinish()
            return
        end

        for i = 1, loadingCount do
            self.loadingIndex = self.loadingIndex + 1
            self.loadingAsyncMap[self.loadingIndex] = true
            local index = self.loadingIndex

            ResMgr:LoadGameObjectAsync(self.itemName, function(go)
                go.transform:SetParent(self.content.transform, false)
                go.gameObject:SetActiveEx(true)
                loadingCount = loadingCount - 1

                if self.loadingAsyncMap[index] then
                    refreshIndex = refreshIndex + 1
                    self:refreshOne(refreshIndex, go.gameObject)
                    if loadingCount == 0 then
                        self.loadingAsyncMap = {}
                        self.loadingIndex = 0
                        self:renderFinish()
                    end
                    return true
                end
                return false
            end, self.isUseSystemPool)
        end
    end
end

function UIScrollView:refresh()
    if not self.renderHandler or self.content.transform.childCount == 0 then
        return
    end
    for i = 1, self.content.transform.childCount do
        local obj = self.content.transform:GetChild(i - 1).gameObject
        self.renderHandler(obj, i)
    end
    self:renderFinish()
end

function UIScrollView:refreshOne(index, gameObject)
    if not self.renderHandler then
        return
    end
    gameObject = gameObject or self.content.transform:GetChild(index - 1).gameObject
    self.renderHandler(gameObject, index)
end

function UIScrollView:release()
    for key, value in pairs(self.releaseItemList) do
        if value.release then
            value:release()
            ResMgr:ReleaseAsset(value.gameObject)
        end
    end
    table.clear(self.releaseItemList)
    -- self.releaseItemList = {}
    -- for key, value in pairs(self.itemPool) do
    --     UnityEngine.GameObject.Destroy(value.gameObject)
    -- end
end
--------------------------------------------------------------------------------------
UILoopScrollView = UILoopScrollView or class("UILoopScrollView")

function UILoopScrollView:ctor(obj, releaseItemList)
    self.gameObject = obj.gameObject
    self.transform = obj.transform
    self.component = self.transform:GetComponent("LoopScrollView")
    self.component:Init()
    self.releaseItemList = releaseItemList or {}
end

-- ""(gameObject, dataIndex)
function UILoopScrollView:setRenderHandler(func)
    self.component:SetRenderHandler(func)
end

-- "" (dataIndex) "" vector2 size
function UILoopScrollView:setRenderSizeHandler(func)
    self.component:SetRenderSizeHandler(func)
end

function UILoopScrollView:setDataCount(count, isInitContentPosition)
    if not isInitContentPosition then
        self.component:SetDataCount(count, false)
    else
        self.component:SetDataCount(count, true)
    end
end

function UILoopScrollView:release()
    for key, value in pairs(self.releaseItemList) do
        if value.release then
            value:release()
        end
    end
    table.clear(self.releaseItemList)
    -- self.releaseItemList = {}
    self.component:Release()
end
