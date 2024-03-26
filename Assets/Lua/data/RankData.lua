RankData = {}

RankData.rankMap = {}
RankData.RANK_TYPE_PVP = 4
RankData.RANK_TYPE_HY_INDIVDUAL = 5
RankData.RANK_TYPE_HY_GUILD = 6

-- RankData.RANK_TYPE_LEAGUE = 2

--""   rankType:1"",2mit"",3"",4"",5""
function RankData.C2S_Player_Rank_Info(rankType)
    local version = 0
    if RankData.rankMap[rankType] then
        version = RankData.rankMap[rankType].version
    end

    gg.client.gameServer:send("C2S_Player_Rank_Info",{
        rankType = rankType,
        version = version,
    })
end

function RankData.S2C_Player_Rank_Info(args)
    local rankType = args.rankType
    local version = args.version
    local rank = args.rank

    RankData.rankMap[rankType] = {version = version, dataList = {}, selfRank = args.selfRank}
    for k,v in ipairs(rank) do
        table.insert(RankData.rankMap[rankType].dataList, v)
    end

    gg.event:dispatchEvent("onRankChange", rankType, version)
end

--------------------------------------------------

function RankData.C2S_Player_FirstGetGridRank()
    gg.client.gameServer:send("C2S_Player_FirstGetGridRank",{})

end

function RankData.S2C_Player_FirstGetGridRank(args)
    RankData.FirstGetGridRankData = args
    gg.event:dispatchEvent("onFirstGetGridRankChange", rankType, version)
end

return RankData
