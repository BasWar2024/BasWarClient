ItemData = {}

ItemData.maxSpace = 50
ItemData.expandSpace = 0

ItemData.itemBagData = {}
ItemData.composeItemData = {}
ItemData.repairData = {}

local cjson = require "cjson"

--""
function ItemData.C2S_Player_ExpandItemBag()
    gg.client.gameServer:send("C2S_Player_ExpandItemBag",{

    })
end

--""
function ItemData.C2S_Player_ResolveItem(id, count)
    gg.client.gameServer:send("C2S_Player_ResolveItem",{
        id = id,
        count = count,
    })
end

--""
function ItemData.C2S_Player_UseItem(id, count)
    gg.client.gameServer:send("C2S_Player_UseItem",{
        id = id,
        count = count,
    })
end

--""
function ItemData.C2S_Player_ItemCompose(id, hour)
    gg.client.gameServer:send("C2S_Player_ItemCompose", {
        id = id,
        hour = hour
    })
end

--""
function ItemData.C2S_Player_ItemComposeCancel(id)
    gg.client.gameServer:send("C2S_Player_ItemComposeCancel", {
        id = id
    })
end

--""
function ItemData.C2S_Player_ItemComposeSpeed(id)
    gg.client.gameServer:send("C2S_Player_ItemComposeSpeed", {
        id = id
    })
end

--  ""
function ItemData.C2S_Player_DismantleSkillCard(skillCardData)
    gg.client.gameServer:send("C2S_Player_DismantleSkillCard", {
        skillCardData = skillCardData
    })
end

--  ""
function ItemData.C2S_Player_SellItem(itemData)
    gg.client.gameServer:send("C2S_Player_SellItem", {
        itemData = itemData
    })
end


---------------------------------------------------------------------------
function ItemData.S2C_Player_ItemBag(maxSpace, expandSpace, itemData)
    ItemData.maxSpace = maxSpace
    ItemData.expandSpace = expandSpace
    ItemData.itemBagData = {}
    for _, item in ipairs(itemData) do
        item.lessLaunchEnd = (item.lessLaunch or 0) + os.time()
        ItemData.itemBagData[item.id] = item

        if item.entity and item.entity ~= "" then
            item.entity = cjson.decode(item.entity)
            item.entity.repairLessTick = item.entity.repairLessTick or 0
            item.entity.repairLessTickEnd = item.entity.repairLessTick + os.time()
        end
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
    gg.event:dispatchEvent("onRefreshBoxDaoArtifact", 1, id)

end

function ItemData.S2C_Player_ItemUpdate(item)
    ItemData.refreshData(item)
    gg.event:dispatchEvent("onRefreshBoxDaoArtifact", 2, item.id, item)
end

function ItemData.refreshData(item)
    ItemData.itemBagData[item.id] = item
    gg.event:dispatchEvent("onItemSort")
    gg.event:dispatchEvent("onSetTopRes")
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

function ItemData.updateRepairItem(repairItem)
    repairItem.endTime = os.time() + repairItem.lessTick
    ItemData.repairData[repairItem.id] = repairItem
end

function ItemData.S2C_Player_UseItem(args)
    local rewardList = ShopUtil.parseItemEffect(args.cfgId)
    if next(rewardList) then
        for key, value in pairs(rewardList) do
            value.count = value.count or 1
            value.count = value.count * args.count
        end
        gg.uiManager:openWindow("PnlTaskReward", {reward = rewardList})
    end

    -- gg.uiManager:openWindow("PnlAlertShowGift", args)
end

return ItemData