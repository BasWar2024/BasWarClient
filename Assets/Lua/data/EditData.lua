EditData = {}
EditData.TYPE_BUILDING = 1
EditData.TYPE_WARSHIP = 2
EditData.TYPE_HERO = 3
EditData.TYPE_SOLDIER = 4
EditData.TYPE_NFT = 5

EditData.isEditMode = false

EditData.unionSelfAutoBattleCount = 0
EditData.unionSelfAutoBattleLessCount = 0

EditData.gridGround = nil


--goType 1"", 2""，3""，4"", 5NFT
-- op -- 1""，2""，3"" 4""
function EditData.C2S_Player_ResetGOLevel(goType, op, id, cfgId, level, skillIdx, skillLv, quality)
    gg.client.gameServer:send("C2S_Player_ResetGOLevel", {
        goType = goType,
        id = id,
        cfgId = cfgId,
        op = op,
        level = level,
        skillIdx = skillIdx,
        skillLv = skillLv,
        quality = quality,
    })
end

-- builds = {{cfgId = , pos = , level = }}
function EditData.C2S_Player_GMBuildBatchCreate(builds)
    gg.client.gameServer:send("C2S_Player_GMBuildBatchCreate", {
        builds = builds,
    })
end

-- goType "",1"", 2""，3""，4""，5nft""
function EditData.C2S_Player_GOChangeSkill(goType, id, skillIdx, skillId)
    gg.client.gameServer:send("C2S_Player_GOChangeSkill", {
        goType = goType,
        id = id,
        skillIdx = skillIdx,
        skillId = skillId,
    })
end

-- goType "",1"", 2""，3""，4""，5nft""
function EditData.C2S_Player_OPLandShipSoldier(id, soliderCfgId, soliderCount)
    gg.client.gameServer:send("C2S_Player_OPLandShipSoldier", {
        id = id,
        soliderCfgId = soliderCfgId,
        soliderCount = soliderCount,
    })
end

-- ""
function EditData.changeEditMode()
    EditData.isEditMode = not EditData.isEditMode

    if EditData.isEditMode then
        if not EditData.gridGround then
            -- ResMgr:LoadGameObjectAsync("EditGridGround", function(go)
            --     EditData.gridGround = go
            --     go.transform.rotation = UnityEngine.Quaternion.Euler(90, 0, 0)
            --     go.transform.position = UnityEngine.Vector3(25.5, 0.5, 25.5)
            --     go.transform.localScale = Vector3(39.5, 39.5, 1)
            --     -- EditData.gridGround.
            --     return true
            -- end, true)
        else
            -- EditData.gridGround:SetActiveEx(true)
        end
    else
        -- if EditData.gridGround then
        --     EditData.gridGround:SetActiveEx(false)
        -- end
    end

    gg.event:dispatchEvent("onEditModeChange", args)
end

function EditData.startUnionSelfAutoBattle(isReset, curPlanetCfgId)
    if isReset then
        EditData.curPlanetCfgId = curPlanetCfgId
        EditData.unionSelfAutoBattleLessCount = EditData.unionSelfAutoBattleCount
    end

    if EditData.unionSelfAutoBattleLessCount <= 0 then
        gg.uiManager:showTip(string.format("""", EditData.unionSelfAutoBattleLessCount))
        return
    end

    gg.uiManager:showTip(string.format("""%s""", EditData.unionSelfAutoBattleLessCount))

    EditData.unionSelfAutoBattleLessCount = EditData.unionSelfAutoBattleLessCount - 1
    local army = UnionUtil.quickGetSelfOneArmy()
    UnionData.updateUnionArmy(army)
    local signPosId = 3
    local armys = UnionUtil.getUnionBattleArmys()
    BattleData.StartUnionBattle(BattleData.ARMY_TYPE_SELF, EditData.curPlanetCfgId, armys, signPosId, CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(signPosId), BattleData.BATTLE_TYPE_SELF_EDIT_AUTO)

    UnionData.clearUnionArmy()
end

-- ""
function EditData.C2S_Player_EditedArmyFormation(armyId, armyName, index, teams)
    gg.client.gameServer:send("C2S_Player_EditedArmyFormation", {
        armyId = armyId,
        armyName = armyName,
        index = index,
        teams = teams,
    })
end

-- //""("")
-- // @id=1370
-- message C2S_Player_OPLandShipSoldier {
--     int64 id = 1;            // ""id
--     int32 soliderCfgId = 2;     // ""id
--     int32 soliderCount = 3;     // ""
-- }
