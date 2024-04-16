ShrineData = {}

ShrineData.ShrineMap = {}

function ShrineData.clear()
    ShrineData.ShrineMap = {}
end

-- ""
function ShrineData.C2S_Player_UpdateSanctuaryHero(buildId, index, heroId)
    gg.client.gameServer:send("C2S_Player_UpdateSanctuaryHero", {
        buildId = buildId,
        index = index,
        heroId = heroId,
    })
end

function ShrineData.S2C_Player_SanctuaryHeros(args)
    ShrineData.ShrineMap[args.buildId] = args
    gg.event:dispatchEvent("onSanctuaryHerosChange")
end