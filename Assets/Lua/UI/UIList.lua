

-- UIListItem
UIListItem = class("UIListItem")

function UIListItem:ctor(transform)
    self.dataIndex = -1
end

function UIListItem:refresh()

end

function UIListItem:onSelected(selected)

end

-- gameObejct
function UIListItem:reset()

end

function UIListItem:release()
    self:reset()

end


-- UIList
UIList = class("UIList")

-- componentDynamicList
function UIList:ctor(component, uiItem, usePool)
    self.items = {}
    self.component = nil
    self.usePool = usePool

    self.createItem = function (self, transform)
        local item = ggclass[uiItem].new(transform)
        return item
    end

    self:initComponent(component, usePool)
end

function UIList:ResetItemDatas(component, uiItem, usePool)
    return self.component:ResetItemDatas()
end

function UIList:RefreshData(itemDataList)
    self.component:RefreshData(itemDataList)
end

function UIList:RefreshItem(index)
    self.component:RefreshItem(index)
end

function UIList:ResetRenderRect()
    self.component:ResetRenderRect()
end

function UIList:release()
    if self.component then
        self.component:Release()
        self.component = nil
    end
end
--------------------------------------------------------------private function-----------------------------------------------------------

function UIList:initComponent(component, usePool)
    self.component = component
    -- 
    component.onInitItem = function (index, transform)
        local item = self:createItem(transform)
        --item.index = index
        self.items[index] = item
    end

    component.onUpdateItem = function (itemIndex, dataIndex)
        self:updateItemView(itemIndex, dataIndex)
    end

    component.onItemSelected = function (dataIndex)
        self:onItemSelected(dataIndex)
    end

    component.onRelease = function ()
        self:onRelease()
    end

    component:SetUseItemPool(usePool and true or false)
    component:InitRendererList()
end

function UIList:updateItemView(itemIndex, dataIndex)
    local item = self.items[itemIndex]
    if item ~= nil then
        item.dataIndex = dataIndex
        item:refresh()
    end
end

function UIList:onItemSelected(dataIndex)
    -- 
    for _, item in pairs(self.items) do
        if item.dataIndex == dataIndex then
            item:onSelected(true)
        else
            item:onSelected(false)
        end
    end
end

function UIList:releaseItems()
    self:onRelease()

    if self.component then
        self.component:ReleaseListItems()
    end
end

function UIList:restoreItems()
    if self.component then
        self.component:RestoreListItems()
    end
end

-- called when need to release resources
function UIList:onRelease()
    -- item.releasefunction UIList:release
    for _, item in pairs(self.items) do
        item:release()
    end

    self.items = {}
end
