ResUtil = ResUtil or {}

--resList = {{resId = , count = }}
function ResUtil.getExchangeResCostTesseract(resList)
    local totalCost = 0

    local exchangeInfo = ResData.exchangeData[constant.RES_TESSERACT]

    for key, value in pairs(resList) do

        local exchangeResKey = constant.RES_2_CFG_KEY[value.resId].exchangeKey
        local exchangeRatio = exchangeInfo[exchangeResKey]
        if value.resId == constant.RES_TESSERACT then
            exchangeRatio = 1
        end

        if exchangeRatio then
            local cost = value.count / exchangeRatio -- math.ceil(value.count / exchangeRatio)
            totalCost = totalCost + cost
        end
    end
    totalCost = math.floor(totalCost) --math.ceil(totalCost)

    return totalCost
end

function ResUtil.getLevelUpNeedResCostTesseract(cfg)
    local resList = {}
    for key, value in pairs(constant.RES_2_CFG_KEY) do
        if key ~= constant.RES_MIT then
            local levelUpNeedCost = cfg[value.levelUpKey]
            if levelUpNeedCost and levelUpNeedCost > 0 then
                table.insert(resList, {resId = key, count = levelUpNeedCost})
            end
        end
    end
    return ResUtil.getExchangeResCostTesseract(resList)
end

function ResUtil.getSpeedUpCost(lessTick)
    return math.ceil(lessTick / 60) * cfg.global.SpeedUpPerMinute.intValue
end
