ItemUtil = ItemUtil or {}

function ItemUtil:isFixing(id)
    for key, value in pairs(ItemData.repairData) do
        if value.id == id then
            return true
        end
    end
    return false
end

function ItemUtil:getFixingData(id)
    for key, value in pairs(ItemData.repairData) do
        if value.id == id then
            return value
        end
    end
    return nil
end