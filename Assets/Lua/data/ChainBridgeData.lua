ChainBridgeData = {}

ChainBridgeData.launchBridgeRecrods = {}

ChainBridgeData.launchBridgeFees = {}
ChainBridgeData.chainBridgeData = {}

ChainBridgeData.chainIdToChainInfo = {}
ChainBridgeData.chainIdToChainInfo[1] = {chainId = 1, chainName = "Ethereum"}
ChainBridgeData.chainIdToChainInfo[4] = {chainId = 4, chainName = "Rinkeby"}
ChainBridgeData.chainIdToChainInfo[56] = {chainId = 56, chainName = "BSCMainNet"}
ChainBridgeData.chainIdToChainInfo[97] = {chainId = 97, chainName = "BSCTestNet"}
ChainBridgeData.chainIdToChainInfo[2] = {chainId = 2, chainName = "AptosTest"}
ChainBridgeData.chainIdToChainInfo[32] = {chainId = 32, chainName = "AptosDevnet"}
ChainBridgeData.chainIdToChainInfo[1030] = {chainId = 1030, chainName = "CFXMainNet"}
ChainBridgeData.chainIdToChainInfo[71] = {chainId = 71, chainName = "CFXTestNet"}
ChainBridgeData.chainIdToChainInfo[324] = {chainId = 324, chainName = "ZKSYNCMainNet"}
ChainBridgeData.chainIdToChainInfo[280] = {chainId = 280, chainName = "ZKSYNCTestNet"}

function ChainBridgeData.getChainNameByChainId(chainId)
    local chainInfo = ChainBridgeData.chainIdToChainInfo[chainId]
    if chainInfo then
        return " [" .. chainInfo.chainName .. "]"
    end
    return ""
end

function ChainBridgeData.C2S_Player_LaunchToBridge(chainId, warShipId, mit, hyt, tokenIds, tokenKinds)
    gg.client.gameServer:send("C2S_Player_LaunchToBridge",{
        chainId = chainId,
        warShipId = warShipId,
        mit = mit,
        hyt = hyt,
        tokenIds = tokenIds,
        tokenKinds = tokenKinds,
    })
end

-- ""
function ChainBridgeData.C2S_Player_ChainBridgeInfo()
    gg.client.gameServer:send("C2S_Player_ChainBridgeInfo")
end

-- ""
function ChainBridgeData.C2S_Player_GetLaunchBridgeRecrods()
    gg.client.gameServer:send("C2S_Player_GetLaunchBridgeRecrods")
end


function ChainBridgeData.S2C_Player_ChainBridgeInfo(args)
    
end

-- ""
function ChainBridgeData.S2C_Player_LaunchBridgeFees(args)
    ChainBridgeData.launchBridgeFees = args.fees
    ChainBridgeData.chainBridgeData = {
        lastTick = args.lastTick,
        needShip = args.needShip
    }
end

function ChainBridgeData.S2C_Player_GetLaunchBridgeRecrods(args)
    local records = args.records
    ChainBridgeData.launchBridgeRecrods = {}
    ChainBridgeData.launchBridgeRecrods = records

    gg.event:dispatchEvent("onSetViewRecord")
end

return ChainBridgeData