Utils = Utils or {}

-- exchangeInfo = {extraExchangeCost = ， text = }
function Utils.checkIsEnoughtLevelUpRes(curCfg, isOpenExchangeView, exchangeCallback, exchangeInfo)
    local needResList = {}
    for key, value in pairs(constant.RES_2_CFG_KEY) do
        local costRes = curCfg[value.levelUpKey]
        if key ~= constant.RES_MIT and costRes and costRes > 0 then
            local haveRes = ResData.getRes(key)
            if haveRes < costRes then
                if not isOpenExchangeView then
                    return false
                end
                table.insert(needResList, {
                    resId = key,
                    needCount = costRes - haveRes
                })
            end
        end
    end

    if #needResList > 0 then
        gg.uiManager:openWindow("PnlQuickExchange", {
            needResList = needResList,
            exchangeCallback = exchangeCallback,
            exchangeInfo = exchangeInfo
        })
        return false
    end

    return true
end

function Utils.checkAndAlertEnoughtMit(needMit, isAlert)
    if needMit then
        if needMit > ResData.getMit() then
            if isAlert then
                -- args.txt = string.format("need more %s mit,please Go to dapp for more", Utils.getShowRes((needMit - ResData.getMit())))
                -- gg.uiManager:openWindow("PnlAlert", args)

                gg.uiManager:showTip(string.format("need more %s mit,please Go to dapp for more",
                    Utils.getShowRes((needMit - ResData.getMit()))))
            end
            return false
        else
            return true
        end
    else
        -- args.txt = "not enought MIT,\nplease Go to dapp for more"
        -- gg.uiManager:openWindow("PnlAlert", args)
        gg.uiManager:showTip("need more %s mit,please Go to dapp for more")
        return false
    end
end

function Utils.checkAndAlertEnoughtRes(resCfgId, needCount, isAlert)
    local res = ResData.getRes(resCfgId)
    if res >= needCount then
        return true
    else
        if isAlert then
            local args = {
                btnType = PnlAlert.BTN_TYPE_SINGLE,
                txtYes = "confirm"
            }
            args.txt = string.format("not enought %s", constant.RES_2_CFG_KEY[resCfgId].name)
            gg.uiManager:openWindow("PnlAlert", args)
        end
        return false
    end
end

function Utils.getCurVipCfgByMit(mit)
    local pledgeMit = mit
    for index, value in pairs(cfg.vip) do
        if pledgeMit >= value.minMit and (pledgeMit <= value.maxMit or value.maxMit == -1) then
            return value
        end
    end
    return cfg.vip[0]
end

function Utils.getPlayerHeadIcon(playerId)
    if PlayerData.playerInfoMap[playerId] then
        return Utils.getHeadIcon(PlayerData.playerInfoMap[playerId].headIcon)
    else
        return Utils.getHeadIcon()
    end
end

function Utils.getHeadIcon(head)
    if head == nil or head == "" then
        return Utils.getDefultHeadIcon()
    end
    head = string.format("Head_Atlas[%s]", head)
    return head
end

function Utils.getDefultHeadIconName()
    return cfg.PlayerHead[1].iconName
end

function Utils.getDefultHeadIcon()
    local head = Utils.getDefultHeadIconName()
    head = string.format("Head_Atlas[%s]", head)
    return head
end

function Utils.getShowRes(temp, isMainRes)
    return Utils.scientificNotationInt(temp / 1000)
    -- if isMainRes == nil then
    --     isMainRes = true
    -- end

    -- if isMainRes then
    --     return temp / 1000
    -- else
    --     return math.floor(temp / 1000)
    -- end
end

function Utils.isMainRes(resId)
    return resId == constant.RES_MIT or resId == constant.RES_CARBOXYL
end

function Utils.scientificNotation(temp, isNotK)
    local tempString = ""
    local deci = 3
    local getDeci = function(num)
        if num == 0 then
            return 0
        end
        local numString = tostring(math.floor(num * 1000))
        local numChar = {}
        for char in string.gmatch(numString, "[%d]") do
            table.insert(numChar, char)
        end
        local numCount = #numChar
        if numChar[numCount] ~= "0" then
            return 3
        end
        if numChar[numCount - 1] ~= "0" then
            return 2
        end
        if numChar[numCount - 2] ~= "0" then
            return 1
        end
        return 0
    end
    if temp >= 10000 and not isNotK then
        local args = temp / 1000
        deci = getDeci(args)
        tempString = string.format("%." .. deci .. "fK", args)
    else
        deci = getDeci(temp)
        tempString = string.format("%." .. deci .. "f", temp)
    end

    return tempString
end

function Utils.scientificNotationInt(temp)
    if temp >= 10000 then
        local args = math.floor(temp / 1000)
        temp = string.format("%.0fK", args)
    else
        temp = string.format("%.0f", temp)
    end
    return temp
end

function Utils.buyPvpCount()
    local pvpBuyCostCfg = cfg.pvpBuyCost
    local maxCost = pvpBuyCostCfg[#pvpBuyCostCfg].tesseractCost
    local dataCount = #pvpBuyCostCfg

    -- local maxCount = math.min(BattleData.pvpData.battleTotal - BattleData.pvpData.battleNum,
    --  dataCount - BattleData.pvpData.battleNumPurchased)
    local maxCount = 10
    -- local maxCount = BattleData.pvpData.battleTotal - BattleData.pvpData.battleNum
    if maxCount <= 0 then
        gg.uiManager:showTip(Utils.getText("pvp_BuyTimesMax"))
        return
    end

    local args = {
        minCount = 1,
        maxCount = maxCount,
        startCount = 1,
        resId = constant.RES_TESSERACT,
        title = Utils.getText("pvp_AddTimes_Title"),
        title2 = string.format(Utils.getText("pvp_AddTimes_MaxAdd"), maxCount)
    }

    args.yesCallback = function(count)
        BattleData.C2S_Player_BuyBattleNum(count)
    end

    args.changeCallback = function(count)
        local cost = 0
        for i = 1, count, 1 do
            local index = BattleData.pvpData.battleNumPurchased + i
            if index <= dataCount then
                cost = cost + pvpBuyCostCfg[index].tesseractCost
            else
                cost = cost + maxCost
            end
        end
        return cost
    end

    gg.uiManager:openWindow("PnlBuyCount", args)
end

function Utils.checkPvpFightCount(isAlertBuy)
    -- if BattleData.pvpData and BattleData.pvpData.battleNum <= 0 then
    --     if isAlertBuy then
    --         Utils.buyPvpCount()
    --     end
    --     return false
    -- else
    --     return true
    -- end

    return BattleData.pvpData and BattleData.pvpData.battleNum > 0
end

function Utils.checkIsCanPvp(isAlertBan, isAlertBuy, isAlertWarship)
    if BattleData.pvpData and BattleData.pvpData.banLessTimeEnd > os.time() then
        if isAlertBan then
            local txt = "you are banned from Pvp"
            local callbackYes = function()
                -- shutdown()
            end
            local args = {
                txt = txt,
                callbackYes = callbackYes,
                btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
                txtYes = "CONFIRM",
                sliderLessTick = BattleData.pvpData.banLessTimeEnd - os.time(),
                sliderLessTotal = BattleData.pvpData.banTotalTime
            }
            gg.uiManager:openWindow("PnlAlert", args)
        end

        return false
    end

    if not gg.warShip.warShipData then
        if isAlertWarship then
            gg.uiManager:showTip("you don't have warship to jump")
        end

        return false
    end

    return true

    -- return Utils.checkPvpFightCount(isAlertBuy)
end

function Utils.setMultipleBgSize(root, left, mid, right, width)
    if width then
        root.transform:SetRectSizeX(width)
    else
        width = root.transform.sizeDelta.x
    end

    local midAnchorPos = mid.transform.anchoredPosition
    local leftWidth = (width - mid.transform.sizeDelta.x) / 2 + midAnchorPos.x
    local rightWidth = width - mid.transform.sizeDelta.x - leftWidth
    left.transform:SetRectSizeX(leftWidth)
    right.transform:SetRectSizeX(rightWidth)
end

function Utils.checkIsInstituteBusy(isAlertAndUpgrade, upgradeType, instituteType, upgradeId)
    local mitCost = 0
    local isBusy = false
    local upgradeingType
    -- local cfgId = 0

    for key, value in pairs(BuildData.soliderLevelData) do
        if value.lessTick > 0 then
            local time = value.lessTickEnd - os.time()
            isBusy = true
            mitCost = math.ceil(time / 60) * cfg.global.SpeedUpPerMinute.intValue
            upgradeingType = constant.INSTITUE_TYPE_SOLDIER
            -- cfgId = value.cfgId
            break
        end
    end

    if not isBusy then
        for key, value in pairs(BuildData.mineLevelData) do
            if value.lessTick > 0 then
                local time = value.lessTickEnd - os.time()
                isBusy = true
                mitCost = math.ceil(time / 60) * cfg.global.SpeedUpPerMinute.intValue
                upgradeingType = constant.INSTITUE_TYPE_MINE
                -- cfgId = value.cfgId
            end
        end
    end

    if isAlertAndUpgrade and isBusy then
        local args = {
            btnType = PnlAlert.BTN_TYPE_SINGLE
        }
        -- args.txt = string.format("upgradeing, cost %s Tesseract to finish and start upgrade", mitCost / 1000 )
        args.txt = Utils.getText("universal_Ask_FinishAndUpgrade")
        args.callbackYes = function()
            if upgradeType == constant.INSTITUE_UPGRADE_TYPE_LEVEL then
                if instituteType == constant.INSTITUE_TYPE_SOLDIER then
                    BuildData.C2S_Player_SoliderLevelUp(upgradeId, 0)
                elseif instituteType == constant.INSTITUE_TYPE_MINE then
                    BuildData.C2S_Player_MineLevelUp(upgradeId, 0)
                end
            elseif upgradeType == constant.INSTITUE_UPGRADE_TYPE_QUALITY then
                if instituteType == constant.INSTITUE_TYPE_SOLDIER then
                    BuildData.C2S_Player_SoliderQualityUpgrade(upgradeId, 0)
                end
            end
        end
        args.yesCostList = {{
            cost = mitCost,
            resId = constant.RES_TESSERACT
        }}
        args.callbackNo = function()
        end
        gg.uiManager:openWindow("PnlAlert", args)
    end
    return isBusy, upgradeingType, mitCost
end

function Utils.checkNftTowerBusy(isAlertAndUpgrade, upgradeId)
    local cost = 0

    for key, value in pairs(BuildData.nftBuildData) do
        if value.lessTick > 0 then
            local time = value.lessTickEnd - os.time()
            cost = math.ceil(time / 60) * cfg.global.SpeedUpPerMinute.intValue

            if isAlertAndUpgrade then
                local args = {
                    btnType = PnlAlert.BTN_TYPE_SINGLE
                }
                args.txt = "upgradeing, finish and start upgrade"
                args.callbackYes = function()
                    BuildData.C2S_Player_BuildLevelUp(upgradeId, 0)
                end
                args.yesCostList = {{
                    cost = cost,
                    resId = constant.RES_CARBOXYL
                }}
                gg.uiManager:openWindow("PnlAlert", args)
            end

            return true, cost
        end
    end

    return false, cost
end

-- Utils.getText("chat_Empty")
function Utils.getText(key, language)
    language = language or LanguageMgr.LanguageTypeKey

    if not cfg.language[key] then
        return ""
    end

    if not cfg.language[key][language] or cfg.language[key][language] == "" then
        return cfg.language[key]["english"]
    else
        return cfg.language[key][language]
    end
end

function Utils.deepSetLayer(layer, transform)
    transform.gameObject.layer = layer
    if transform.childCount > 0 then
        for i = 1, transform.childCount do
            Utils.deepSetLayer(layer, transform:GetChild(i - 1))
        end
    end
end

-- function Utils.getServerTime()
--     return gg.client.gameServer.time + os.time() - gg.client.lastPongTime
-- end

function Utils.getServerSec()
    if gg.client.gameServer and gg.client.gameServer.secTime then
        return gg.client.gameServer.secTime + os.time() - gg.client.lastPongTime
    end

    return os.time()
    -- return gg.client.gameServer.secTime + os.time() - gg.client.lastPongTime
end

function Utils.checkUnionsloiderDefenseWhiteList(type, cfgId)
    local global = cfg.global
    local whiteList = {}
    if type == 1 then
        whiteList = global.UnionSoliderWhiteList.tableValue
    else
        whiteList = global.UnionDefenseWhiteList.tableValue
    end

    for k, v in pairs(whiteList) do
        if v == cfgId then
            return true
        end
    end
    return false
end

function Utils.fixUiResolutionW(ui)
    local w = 1920
    local h = 1080

    -- local match = 1

    local nowW = UnityEngine.Screen.width / UnityEngine.Screen.height * h

    -- local ratio = UnityEngine.Screen.width / normalScreenW
    -- rect.localScale

    ui.transform.localScale = ui.transform.localScale * nowW / w
end

function Utils.getwarshipCount()
    local count = 0

    for key, value in pairs(WarShipData.warShipData) do
        count = count + 1
    end

    return count
end

function Utils.getHeroCount()
    local count = 0

    for key, value in pairs(HeroData.heroDataMap) do
        count = count + 1
    end

    return count
end

function Utils.getNftBuildCount()
    local count = 0

    for key, value in pairs(BuildData.buildData) do
        if value.chain > 0 then
            count = count + 1
        end
    end

    return count
end