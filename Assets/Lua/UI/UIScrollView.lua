UIBaseItem = UIBaseItem or class("UIBaseItem")

function UIBaseItem:ctor(obj)
    self.obj = obj
    self.gameObject = obj.gameObject
    self.transform = obj.transform
    self.releaseEventList = {}
    self:onInit()
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
    if not self.gameObject then
        return
    end
    for index, value in ipairs(self.releaseEventList) do
        CS.UIEventHandler.Clear(value)
    end
    self.releaseEventList = {}
    self:onRelease()
end

function UIBaseItem:setOnClick(gameObject, callBack)
    CS.UIEventHandler.Get(gameObject.gameObject):SetOnClick(callBack)
    table.insert(self.releaseEventList, gameObject)
end

function UIBaseItem:Find(path, component)
    local go = self.transform:Find(path).gameObject
    if component then
        go = go.transform:GetComponent(component)
    end
    return go
end

function UIBaseItem:setActive(isActive)
    self.gameObject:SetActiveEx(isActive)
end

--override
function UIBaseItem:onInit()
end

function UIBaseItem:onRelease()
end
-------------------------------------------------------------------
UIScrollView = UIScrollView or class("UIScrollView")

function UIScrollView:ctor(obj, itemName, releaseItemList, isNotUsePool)
    self.itemName = itemName
    self.releaseItemList = releaseItemList or {}
    self.isUsePool = not isNotUsePool
    self.gameObject = obj.gameObject
    self.transform = obj.transform
    self.component = obj.transform:GetComponent(typeof(UnityEngine.UI.ScrollRect))
    self.content = self.component.content
    self.itemPool = {}
end

function UIScrollView:setRenderHandler(handler)
    self.renderHandler = handler
end

function UIScrollView:setItemCount(count)
    self.isLoad = false
    local loadingCount = count - self.content.transform.childCount

    if loadingCount == 0 then
        self:refresh()
    elseif loadingCount < 0 then
        for i = 1, -loadingCount do
            local go = self.content.transform:GetChild(0)
            go.transform:SetParent(nil, false)
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

        self.isLoad = true
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
            return
        end

        for i = 1, loadingCount do
            ResMgr:LoadGameObjectAsync(self.itemName, function(go)
                go.transform:SetParent(self.content.transform, false)
                go.gameObject:SetActiveEx(true)
                loadingCount = loadingCount - 1

                if self.isLoad then
                    refreshIndex = refreshIndex + 1
                    self:refreshOne(refreshIndex, go.gameObject)
                end
                -- if loadingCount == 0 and self.isLoad then
                --     self:refresh()
                -- end

                return self.isLoad
            end)
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
        end
    end
    self.releaseItemList = {}
    for key, value in pairs(self.itemPool) do
        UnityEngine.GameObject.Destroy(value.gameObject)
    end
end
--------------------------------------------------------------------------------------
UILoopScrollView = UILoopScrollView or class("UILoopScrollView")

function UILoopScrollView:ctor(obj, releaseItemList)
    self.gameObject = obj.gameObject
    self.transform = obj.transform
    self.component = self.transform:GetComponent("LoopScrollView")
    self.releaseItemList = releaseItemList or {}
end

function UILoopScrollView:setRenderHandler(func)
    self.component:SetRenderHandler(func)
end

function UILoopScrollView:setRenderSizeHandler(func)
    self.component:SetRenderSizeHandler(func)
end

function UILoopScrollView:setDataCount(count)
    self.component:SetDataCount(count)
end

function UILoopScrollView:release()
    for key, value in pairs(self.releaseItemList) do
        if value.release then
            value:release()
        end
    end
    self.releaseItemList = {}
end