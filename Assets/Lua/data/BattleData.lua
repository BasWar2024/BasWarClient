BattleData = {}

--
function BattleData.C2S_Player_StartBattle(battleType, enemyId)
    gg.client.gameServer:send("C2S_Player_StartBattle",{
        battleType = battleType,
        enemyId = enemyId,
    })
end

--
function BattleData.C2S_Player_EndBattle(battleId, bVersion, ret, signinPosId, operate, result)
    gg.client.gameServer:send("C2S_Player_EndBattle",{
        battleId = battleId,
        bVersion = bVersion,
        ret = ret,
        signinPosId = signinPosId,
        operate = operate,
        result = result,
    })
end


function BattleData.S2C_Player_StartBattle(args)
    local battleId = args.battleId
    local battleInfo = args.battleInfo

    --
    gg.sceneManager:enterBattleScene(battleId, battleInfo)
end

function BattleData.S2C_Player_EndBattle(args)
    local battleId = args.battleId
    local starCoin = args.starCoin
    local ice = args.ice
    local carboxyl = args.carboxyl
    local titanium = args.titanium
    local gas = args.gas
end




