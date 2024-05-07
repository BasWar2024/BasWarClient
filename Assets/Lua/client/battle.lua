local net = {}

function net.S2C_Player_StartBattle(args)
    BattleData.S2C_Player_StartBattle(args)
end

function net.S2C_Player_EndBattle(args)
    BattleData.S2C_Player_EndBattle(args)
end

function net.S2C_Player_EndBattle_NotCompletely(args)
    BattleData.S2C_Player_EndBattle_NotCompletely(args)
end

function net.S2C_Player_UploadBattle(args)
    BattleData.S2C_Player_UploadBattle(args)
end

function net.S2C_Player_LookBattlePlayBack(args)
    -- local file = io.open("C:\\Users\\czl\\Desktop\\output.lua", "a")
    -- file:write(gg.table2Str(args))
    -- file:close()

    BattleData.S2C_Player_LookBattlePlayBack(args)
end

return net