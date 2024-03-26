BattleManager = class("BattleManager")
local cjson = require "cjson"

function BattleManager:ctor()
    self.battleMono = nil
    self.newBattleData = nil
    self.isInBattle = false
    self.isInBattleServer = false
    self.proloadHandleList = nil

    self.scene = ggclass.BattleScene.new()
end
-- type 0:"" 1：""  
-- extension 0""，""0""
function BattleManager:initBattleLogic(battleId, battleInfo, type)
    self.battleInfo = battleInfo
    -- gg.warCameraCtrl:setCameraPos(Vector3.zero)
    self.isInBattleServer = true
    self.battleMono.StartSurface = function(length, width, pos, id, type, subType, count, extension)
        SurfaceUtil.startSurface(length, width, pos, id, type, subType, count, extension)
    end
    gg.buildingManager:swichOwner(BuildingManager.OWNER_OTHER)
    self.battleMono:InitBattleLogic(battleId, battleInfo, type)
    self.newBattleData = CS.NewGameData

    self.battleMono.ChangeSlot = function(entity)
        self:ChangeSlot(entity)
    end
end

function BattleManager:setBattleMono(battleMono)
    self.battleMono = battleMono
end

function BattleManager:readyBattle()
    if string.match(tostring(self.newBattleData._BattleType ), "0") ~= nil then --PVP PVE
        self.battleMono.BattleLogic.Stage = 2
        self.battleMono:WarShipSignin(3)
    else
        self.battleMono:WarShipSignin(self.newBattleData._SigninPosId)
    end

end

function BattleManager:ChangeSlot(entity)
    local buildData = cfg.getCfg("build", entity.CfgId, 1)
    if buildData.type == constant.BUILD_CLUTTER then
        local attachmentName = "res/" .. buildData.slot
        entity.SpineAnim:ChangeSlots("bin", attachmentName)
    end
end

function BattleManager:onFingerUp(pos)
    gg.event:dispatchEvent("onBattleFingerUp")
    self.battleMono:OnFingerUp(UnityEngine.Vector3(pos.x, pos.y, 0))
end

function BattleManager:setAtkCard(cardId)
    self.atkCardId = cardId
    gg.event:dispatchEvent("onSetBattleAtkCard")
end

function BattleManager:uploadBattle(args)
    if self.battleMono ~= nil and self.battleMono.BattleLogic.IsBattlePause == false and gg.battleManager.isInBattle then -- ""，""，""
        return
    end
    if CS.UnityEngine.PlayerPrefs.HasKey(tostring(args.battleId)) then
        local battleId = tostring(args.battleId)
        local signinPosId = CS.UnityEngine.PlayerPrefs.GetInt(battleId .. "_signinid")
        local operates = {}
        if CS.UnityEngine.PlayerPrefs.HasKey(battleId .. "_operates") then
            local operatesStr = CS.UnityEngine.PlayerPrefs.GetString(battleId .. "_operates")
            local operateStrs = string.split(operatesStr, ",", -1)

            for k, operateStr in pairs(operateStrs) do
                local values = string.split(operateStr, "_", -1)
                operates[k] = {}
                operates[k].GameFrame = values[1]
                operates[k].Order = values[2]
                operates[k].X = values[3]
                operates[k].Y = values[4]
                operates[k].Z = values[5]
            end
        end

        BattleData.C2S_Player_UploadBattle(args.battleId, signinPosId, CS.Appconst.BattleVersion, operates)
    end
end

function BattleManager:lookBattlePlayBack(args, guideNode)
    local bVersion = args.bVersion

    if bVersion ~= CS.Appconst.BattleVersion then
        return
    end
    -- for k, v in pairs(args.battleInfo) do
    --     print("aaa", k, table.dump(v))
    -- end
    gg.sceneManager:enterBattleScene(0, args, 1, guideNode)
end

--""
function BattleManager:clearAllBattleGameObj()
    ResMgr:ClearAllBattleGameObj()

    if self.proloadHandleList ~= nil then
        ResMgr:ReleaseAssetAsyncOperationHandle(self.proloadHandleList)
        self.proloadHandleList = nil
    end
end

function BattleManager:openBattleMessage()
    self.battleMono:OpenMessageView()
end
