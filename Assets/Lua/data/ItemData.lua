ItemData = {}

ItemData.maxSpace = 50
ItemData.expandSpace = 0

ItemData.itemBagData = {}
ItemData.composeItemData = {}
ItemData.repairData = {}

--
function ItemData.C2S_Player_ExpandItemBag()
    gg.client.gameServer:send("C2S_Player_ExpandItemBag",{

    })
end

--
function ItemData.C2S_Player_DestoryItem(id)
    gg.client.gameServer:send("C2S_Player_DestoryItem",{
        id = id,
    })
end

--
function ItemData.C2S_Player_Move2ItemBag(id, itemType)
    gg.client.gameServer:send("C2S_Player_Move2ItemBag",{
        id = id,
        itemType = itemType
    })
end

--
function ItemData.C2S_Player_MoveOutItemBag(id, pos)
    gg.client.gameServer:send("C2S_Player_MoveOutItemBag",{
        id = id,
        pos = {x = pos.x, y = pos.y, z = pos.z}
    })
end

--
function ItemData.C2S_Player_ItemCompose(id, hour)
    gg.client.gameServer:send("C2S_Player_ItemCompose", {
        id = id,
        hour = hour
    })
end

--
function ItemData.C2S_Player_ItemComposeCancel(id)
    gg.client.gameServer:send("C2S_Player_ItemComposeCancel", {
        id = id
    })
end

--
function ItemData.C2S_Player_ItemComposeSpeed(id)
    gg.client.gameServer:send("C2S_Player_ItemComposeSpeed", {
        id = id
    })
end

--
function ItemData.C2S_Player_Repair(ids)
    gg.client.gameServer:send("C2S_Player_Repair", {
        ids = ids
    })
end

--
function ItemData.C2S_Player_RepairSpeed(id)
    gg.client.gameServer:send("C2S_Player_RepairSpeed", {
        id = id,
    })
end

function ItemData.S2C_Player_ItemBag(maxSpace, expandSpace, itemData)
    ItemData.maxSpace = maxSpace
    ItemData.expandSpace = expandSpace
    ItemData.itemBagData = {}
    for _, item in ipairs(itemData) do
        ItemData.itemBagData[item.id] = item
    end
end

function ItemData.S2C_Player_ExpandItemBag(expandSpace)
    gg.uiManager:showTip("Upgrade Success!")
    ItemData.expandSpace = expandSpace
    gg.event:dispatchEvent("onRefreshItemBag")
end

function ItemData.S2C_Player_ItemAdd(item)
    ItemData.refreshData(item)
end

function ItemData.S2C_Player_ItemDel(id)
    ItemData.itemBagData[id] = nil
    gg.event:dispatchEvent("onItemSort")
end

function ItemData.S2C_Player_ItemUpdate(item)
    ItemData.refreshData(item)
end

function ItemData.refreshData(item)
    ItemData.itemBagData[item.id] = item
    gg.event:dispatchEvent("onItemSort")
end

function ItemData.S2C_Player_ItemComposeAdd(composeItem)
    ItemData.updateComposeItem(composeItem)
    gg.event:dispatchEvent("onItemComposeChange")
end

function ItemData.S2C_Player_ComposeItemData(composeItems)
    for _, composeItem in pairs(composeItems) do
        ItemData.updateComposeItem(composeItem)
    end
    gg.event:dispatchEvent("onItemComposeChange")
end

function ItemData.updateComposeItem(composeItem)
    ItemData.composeItemData[composeItem.item.id] = composeItem
    composeItem.lessTickEnd = os.time() + composeItem.lessTick
end

function ItemData.S2C_Player_ItemCompose(item)
    ItemData.composeItemData[item.id] = nil
    gg.event:dispatchEvent("onItemComposeChange")
end

function ItemData.S2C_Player_ItemComposeCancel(item)
    ItemData.composeItemData[item.id] = nil
    gg.event:dispatchEvent("onItemComposeChange")
end

function ItemData.S2C_Player_RepairItems(repairItems)
    for _, repairItem in pairs(repairItems) do
        ItemData.updateRepairItem(repairItem)
    end
    gg.event:dispatchEvent("onItemRepareChange")
end

--
function ItemData.S2C_Player_RepairReturn(succItems, totalCost)
    for _, repairItem in pairs(succItems) do
        ItemData.updateRepairItem(repairItem)
    end
    gg.event:dispatchEvent("onItemRepareChange")
end

--
function ItemData.S2C_Player_RepairItemAdd(repairItem)
    ItemData.updateRepairItem(repairItem)
    gg.event:dispatchEvent("onItemRepareChange")
end

--
function ItemData.S2C_Player_RepairItemUpdate(repairItem)
    ItemData.updateRepairItem(repairItem)
    gg.event:dispatchEvent("onItemRepareChange")
end

function ItemData.S2C_Player_RepairItemDel(id)
    ItemData.repairData[id] = nil
    gg.event:dispatchEvent("onItemRepareChange")
end

function ItemData.updateRepairItem(repairItem)
    repairItem.endTime = os.time() + repairItem.lessTick
    ItemData.repairData[repairItem.id] = repairItem
end

return ItemData