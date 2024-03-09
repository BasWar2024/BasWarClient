Utils = Utils or {}

-- function Utils:checkIsOpen(cfg, func)
--     gg.uiManager:openWindow("PnlExchange")
-- end

function Utils:checkIsEnoughtLevelUpRes(cfg, isOpenExchangeView)
    -- ResData.C2S_Player_Exchange_Rate()
    for key, value in pairs(constant.RES_2_CFG_KEY) do
        if cfg[value.levelUpKey] then
            if ResData.getRes(key) < cfg[value.levelUpKey] then
                if isOpenExchangeView then
                    local callbackYes = function ()
                        ResData.C2S_Player_Exchange_Rate()
                    end
                    local txt = "not enought resource, go to exchange"
                    gg.uiManager:openWindow("PnlAlert", {callbackYes = callbackYes, txt = txt})
                end
                return false
            end
        end
    end
    return true
end

function Utils:GetAttrByCfg(attrCfg, targetCfg)
    if not targetCfg or not attrCfg then
        return
    end

    local attr = nil
    if attrCfg.isProperty == 1 and targetCfg.property then
        attr = targetCfg.property[attrCfg.cfgKey]
    else
        attr = targetCfg[attrCfg.cfgKey]
    end

    return attr
end
