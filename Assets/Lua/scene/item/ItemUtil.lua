ItemUtil = ItemUtil or {}

function ItemUtil.getTargetCfgByItemData(data)
    local itemCfg = cfg.item[data.cfgId]
    local entity = data.entity

    if itemCfg.itemType == constant.ITEM_ITEMTYPE_WARSHIP then
        WarshipUtil.getWarshipCfg(entity.cfgId, entity.quality, entity.level)

    elseif itemCfg.itemType == constant.ITEM_ITEMTYPE_HERO then
        return HeroUtil.getHeroCfg(entity.cfgId, entity.level, entity.quality)

    elseif itemCfg.itemType == constant.ITEM_ITEMTYPE_TURRET then
        return BuildUtil.getCurBuildCfg(entity.cfgId, entity.level, entity.quality)

    elseif itemCfg.itemType == constant.ITEM_ITEMTYPE_NFT_STAR then
        return cfg.resPlanet[entity.index]
    end
end

function ItemUtil.getItemIcon(cfgId)
    local itemCfg = cfg.item[cfgId]

    local icon

    if itemCfg.itemType == constant.ITEM_ITEMTYPE_SKILL_PIECES then
        icon = string.format("Skill_A1_Atlas[%s_A1]", itemCfg.icon)

    elseif itemCfg.itemType == constant.ITEM_ITEMTYPE_WARSHIP then
        icon = string.format("Warship_A_Atlas[%s_A]", itemCfg.icon)

    elseif itemCfg.itemType == constant.ITEM_ITEMTYPE_HERO then
        icon = string.format("Hero_A_Atlas[%s_A]", itemCfg.icon)

    elseif itemCfg.itemType == constant.ITEM_ITEMTYPE_TURRET or itemCfg.itemType == constant.ITEM_ITEMTYPE_RESPLANETBUILD then
        icon = string.format("Build_A_Atlas[%s_A]", itemCfg.icon)

    else
        icon = string.format("Item_Atlas[%s]", itemCfg.icon)
    end

    return icon
end

function ItemUtil.getItemQualityByItemData(data)
    if data.entity and data.entity.quality then
        return data.entity.quality

    else
        local itemCfg = cfg.item[data.cfgId]
        if itemCfg.itemType == constant.ITEM_ITEMTYPE_DAO_ITEM then
            return 5
        elseif itemCfg.itemType == constant.ITEM_ITEMTYPE_NFT_STAR then
            return 5
        else
            return 0
        end
    end
end
