local cjson = require "cjson"

PlayerData = {}
PlayerData.myInfo = nil

PlayerData.enterGameInfo = nil

PlayerData.playerInfoMap = {}

PlayerData.MAX_NAME_LENTH = 16
PlayerData.MIN_NAME_LENTH = 2

-- PlayerData.guides = {}
PlayerData.guidesMap = {}
PlayerData.ownerAddress = nil
PlayerData.chainId = 0

-- PlayerData.armyData = {armyId = , armyName = , warShipId = , teams = ,{number = , heroId = , soliderCfgId = , soliderCount = }}

PlayerData.MAX_ARMY_TEAM = 5
PlayerData.armyData = nil


PlayerData.isNotAlertLittleTesCost = false

PlayerData.payChannelInfo = nil

--------------------

function PlayerData.clear()
    PlayerData.armyData = nil
end

function PlayerData.setPlayerHeadIcon(playerId, headIcon)
    PlayerData.playerInfoMap[playerId] = PlayerData.playerInfoMap[playerId] or {}
    PlayerData.playerInfoMap[playerId].headIcon = headIcon
end

-- ""
function PlayerData.C2S_Player_QueryPlayerInfo()
    gg.client.gameServer:send("C2S_Player_QueryPlayerInfo", {
    })
end

-- ""
function PlayerData.C2S_Player_ModifyPlayerName(name)
    gg.client.gameServer:send("C2S_Player_ModifyPlayerName", {
        name = name,
    })
end

-- "", zh_CN="",en_US="",zh_TW=""
function PlayerData.C2S_Player_ModifyPlayerLanguage(language)
    gg.client.gameServer:send("C2S_Player_ModifyPlayerLanguage", {
        language = language,
    })
end

-- ""
function PlayerData.C2S_Player_ModifyPlayerInfo(canInvite, canVisit, text, headIcon)
    gg.client.gameServer:send("C2S_Player_ModifyPlayerInfo", {
        canInvite = canInvite,
        canVisit = canVisit,
        text = text,
        headIcon = headIcon,
    })
end

-- ""
function PlayerData.C2S_Player_ChatVisitFoundation(playerId)
    gg.client.gameServer:send("C2S_Player_ChatVisitFoundation", {
        playerId = playerId,
    })
    gg.uiManager:onOpenPnlLink("Player_ChatVisitFoundation")

end

-- ""dao""
--skipOthers = 0"" 1""
--guides = {{guideId = , skipOthers = },}
function PlayerData.C2S_Player_finishGuides(guides)
    gg.client.gameServer:send("C2S_Player_finishGuides", {
        guides = guides,
    })
end

-- ""
function PlayerData.C2S_Player_UnionVisitFoundation(playerId)
    gg.client.gameServer:send("C2S_Player_UnionVisitFoundation", {
        playerId = playerId,
    })
    gg.uiManager:onOpenPnlLink("Player_UnionVisitFoundation")
end

function PlayerData.getName()
    if PlayerData.myInfo then
        return PlayerData.myInfo.name
    else
        return gg.playerMgr.localPlayer:getName()
    end
end

-- ""
function PlayerData.C2S_Player_QueryWallet()
    gg.client.gameServer:send("C2S_Player_QueryWallet")
end

------------------------------------------------------------
-- ""
function PlayerData.S2C_Player_PlayerInfo(args)
    -- local window = gg.uiManager:getWindow("PnlPlayerDetailed")
    -- if not window or not window:isShow() then
    --     gg.uiManager:openWindow("PnlPlayerDetailed", args)
    -- end

    if args.pid == gg.playerMgr.localPlayer:getPid() then
        PlayerData.myInfo = args
    end
    gg.event:dispatchEvent("onPlayerInfoChange", args)
end

-- ""id
function PlayerData.S2C_Player_NextGuides(args)
    -- PlayerData.guides = args.guides

    PlayerData.guidesMap = {}
    for key, value in pairs(args.guides) do
        PlayerData.guidesMap[value.guideId] = value
    end
    gg.event:dispatchEvent("onGuideChange", args)
end

-- ""
function PlayerData.S2C_Player_Wallet(ownerAddress, chainId)
    PlayerData.ownerAddress = ownerAddress
    PlayerData.chainId = chainId
    gg.event:dispatchEvent("onWalletChange", args)
end

---army

-- ""
-- message ArmyTeamType {
--     int32 number = 1;                 //""，""
--     int64 heroId = 2;                 //""id
--     int32 soliderCfgId = 3;           //""Id
--     int32 soliderCount = 4;           //""
-- }

-- ""
function PlayerData.C2S_Player_ArmyFormationQuery()
    gg.client.gameServer:send("C2S_Player_ArmyFormationQuery")
end

-- ""
function PlayerData.C2S_Player_ArmyFormationAdd(armyId, armyName, teams)
    gg.client.gameServer:send("C2S_Player_ArmyFormationAdd", {
        armyId = armyId,
        armyName = armyName,
        teams = teams,
    })
end

-- ""
function PlayerData.C2S_Player_CleanAllArmy()
    gg.client.gameServer:send("C2S_Player_CleanAllArmy", {
    })
end

-- ""
function PlayerData.C2S_Player_ArmyFormationUpdate(armyId, armyName, index, teams)
    gg.client.gameServer:send("C2S_Player_ArmyFormationUpdate", {
        armyId = armyId,
        armyName = armyName,
        index = index,
        teams = teams,
    })
end

-- ""
function PlayerData.C2S_Player_ArmyFormationDelete(armyId)
    gg.client.gameServer:send("C2S_Player_ArmyFormationDelete", {
        armyId = armyId,
    })
end

-- ""|""
function PlayerData.C2S_Player_automaticForces(autoStatus)
    gg.client.gameServer:send("C2S_Player_automaticForces", {
        autoStatus = autoStatus,
    })
end

function PlayerData.C2S_Player_OneKeyFillUpSoliders(armyIds)
    gg.client.gameServer:send("C2S_Player_OneKeyFillUpSoliders", {
        armyIds = armyIds,
    })
end

function PlayerData.S2C_Player_ArmysQuery(args)
    PlayerData.autoStatus = args.autoStatus
    PlayerData.armyData = args.data

    gg.event:dispatchEvent("onPersonalArmyChange")
end

--PlayerData.armyData = {{armyId = , armyName = , warShipId = , teams = {heroId = , soliderCfgId = , soliderCount = }}}
function PlayerData.getDefaultArmyData()
    local armyId = 1
    if PlayerData.armyData and next(PlayerData.armyData) then
        armyId = PlayerData.armyData[#PlayerData.armyData].armyId + 1
    end
    return {armyId = armyId, armyName = "fleet" .. armyId, teams = {}}
end

--""
function PlayerData.C2S_Player_PayChannelInfo()
    if CS.Appconst.platform ~= constant.PLATFORM_4 and CS.Appconst.platform ~= constant.PLATFORM_5 then
        gg.client.gameServer:send("C2S_Player_PayChannelInfo", {
            platform = CS.Appconst.platform
        })
    end
end

function PlayerData.S2C_Player_PayChannelInfo(args)
    local info = args.info
    local payChannelInfo = cjson.decode(info)

    -- print("ssssssssss:")
    -- print(table.dump(payChannelInfo))
    PlayerData.payChannelInfo = {}
    PlayerData.payChannelInfo = payChannelInfo
end
