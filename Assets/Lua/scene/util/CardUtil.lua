CardUtil = CardUtil or {}

function CardUtil.getCardGroupData(index, groupType)
    local data = nil
    if groupType == constant.CARD_GROUP_TYPE_ATK then
        data = CardData.attaCardGroupsMap[index]
    elseif groupType == constant.CARD_GROUP_TYPE_DEF then
        data = CardData.defCardGroupsMap[index]
    end
    if data and not next(data.group.cardIds) then
        data = nil
    end
    return data
end