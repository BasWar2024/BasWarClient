ResEffectManager = class("ResEffectManager")

ResEffectManager.res2Data = {
    [constant.RES_STARCOIN] = {
        id = constant.RES_STARCOIN,
        assetName = "StarCoin3D",
        firstMoveOffsetPos = CS.UnityEngine.Vector3(-1, 0.3, 0),
        audio = constant.AUDIO_STAR_COIN_COLLECT
    },

    [constant.RES_GAS] = {
        id = constant.RES_GAS,
        assetName = "Gas3D",
        firstMoveOffsetPos = CS.UnityEngine.Vector3(-0.5, 0.3, 0),
        audio = constant.AUDIO_GAS_COLLECT
    },
    [constant.RES_TITANIUM] = {
        id = constant.RES_TITANIUM,
        assetName = "Titanium3D",
        firstMoveOffsetPos = CS.UnityEngine.Vector3(0, 0.3, 0),
        audio = constant.AUDIO_TITANIUM_COLLECT
    },
    [constant.RES_ICE] = {
        id = constant.RES_ICE,
        assetName = "Ice3D",
        firstMoveOffsetPos = CS.UnityEngine.Vector3(0.5, 0.3, 0),
        audio = constant.AUDIO_ICE_COLLECT
    },
    [constant.RES_CARBOXYL] = {
        id = constant.RES_CARBOXYL,
        assetName = "Carboxyl3D",
        firstMoveOffsetPos = CS.UnityEngine.Vector3(1, 0.3, 0),
        audio = constant.AUDIO_HYDROXYL_COLLECT
    },
    [constant.RES_MIT] = {
        id = constant.RES_MIT,
        assetName = "Mit3D",
        firstMoveOffsetPos = CS.UnityEngine.Vector3(1, 0.3, 0),
        audio = constant.AUDIO_HYDROXYL_COLLECT
    }
}

function ResEffectManager:ctor()
    -- gg.event:addListener("onFetchRes", self)
    self.aniObjMap = {}
    self.fly3dRes2TargetOnPnlPlayerInformationId = 0
    self.flyAnimEndTime = 0
    self.flyAnimEndTimer = nil
end

function ResEffectManager:getFlyId()
    self.fly3dRes2TargetOnPnlPlayerInformationId = self.fly3dRes2TargetOnPnlPlayerInformationId + 1
    return self.fly3dRes2TargetOnPnlPlayerInformationId
end

function ResEffectManager:getAnchoredPositionByScreenPos(screenPos)
    screenPos.x = screenPos.x * gg.guideManager.biasX --self.scaleX
    screenPos.y = screenPos.y * gg.guideManager.biasY --self.scaleY
    return screenPos
end

function ResEffectManager:getLoadCount(resChangeCount)
    local loadCount = math.min(15, math.ceil(resChangeCount / 100000))
    local resPerObj = math.ceil(resChangeCount / loadCount)
    return loadCount, resPerObj
end

ResEffectManager.FLY_2_TARGET_Inteval = 0.2
-- beginObj""TiltCamera""Obj ""PnlPlayerInformation""
function ResEffectManager:fly3dRes2TargetOnPnlPlayerInformation(beginObj, resType, resChangeCount, is2D)
    local data = ResEffectManager.res2Data[resType]
    if not data then
        return
    end
    local window = gg.uiManager:getWindow("PnlPlayerInformation")
    if not window then
        return
    end

    local resAniData = ResEffectManager.res2Data[resType]
    AudioFmodMgr:Play2DOneShot(resAniData.audio.event, resAniData.audio.bank)

    local flyId = self:getFlyId()
    local targetPos = window:getResFlyTargetObj(resType).transform.position -- window.view.resFlyTargetMap[resType].transform.position
    local tiltCamera = UnityEngine.Camera.main.transform:Find("TiltCamera"):GetComponent("Camera")
    local loadCount, resPerObj = self:getLoadCount(resChangeCount)
    local index = 0

    gg.timer:startLoopTimer(math.random(0, 4) / 10, ResEffectManager.FLY_2_TARGET_Inteval, loadCount, function()
        self.flyAnimEndTime = math.max(self.flyAnimEndTime,  os.time() + ResEffectManager.flyAniMoveDuration + ResEffectManager.flyAniJumpDuration + PnlPlayerInformation.lastDuration)
        if not self.flyAnimEndTimer then
            self.flyAnimEndTimer = gg.timer:startLoopTimer(0, 0.5, -1, function ()
                if os.time() >= self.flyAnimEndTime then
                    gg.event:dispatchEvent("onFlyResAnimEnd")
                    gg.timer:stopTimer(self.flyAnimEndTimer)
                    self.flyAnimEndTimer = nil
                end
            end)
        end

        ResMgr:LoadGameObjectAsync(data.assetName, function(obj)
            index = index + 1
            -- obj.transform:SetParent(window.transform, false)
            obj.transform:SetParent(gg.uiManager.uiRoot.tipsNode.transform, false)

            if not beginObj or beginObj:Equals(nil) then
                ResMgr:ReleaseAsset(obj)
                return false
            end

            local beginScreenPos = tiltCamera:WorldToScreenPoint(beginObj.transform.position)
            -- print("beginScreenPos", table.dump(beginScreenPos))
            beginScreenPos = self:getAnchoredPositionByScreenPos(beginScreenPos)
            beginScreenPos.z = -10

            obj.transform.pivot = CS.UnityEngine.Vector2(0, 0)
            obj.transform.anchorMin = CS.UnityEngine.Vector2(0, 0)
            obj.transform.anchorMax = CS.UnityEngine.Vector2(0, 0)

            if is2D then
                obj.transform.position = beginObj.transform.position
            else
                obj.transform.anchoredPosition3D = beginScreenPos
            end
            targetPos.z = targetPos.z - 0.1
            self:startResFlyAni(obj, targetPos, resType, resPerObj, index, loadCount, flyId)
            return true
        end, true)
    end)
end

ResEffectManager.flyAniMoveDuration = 0.1
ResEffectManager.flyAniJumpDuration = 2

-- targetPos""
function ResEffectManager:startResFlyAni(obj, targetWorldPos, resType, resPerObj, index, loadCount, flyId)
    self.aniObjMap[obj] = true
    local pos = obj.transform.position
    local sequence = CS.DG.Tweening.DOTween.Sequence()

    if resType and ResEffectManager.res2Data[resType] then
        local data = ResEffectManager.res2Data[resType]
        sequence:Append(obj.transform:DOMove(CS.UnityEngine.Vector3(pos.x + data.firstMoveOffsetPos.x,
            pos.y + data.firstMoveOffsetPos.y, pos.z + data.firstMoveOffsetPos.z), ResEffectManager.flyAniMoveDuration):SetEase(CS.DG.Tweening.Ease
                                                                                                    .InQuad))
    end

    local jumpPower = (math.random(-2, 1) + math.random()) / 3
    sequence:Append(obj.transform:DOJump(targetWorldPos, jumpPower, 1, ResEffectManager.flyAniJumpDuration):SetEase(CS.DG.Tweening.Ease.InSine))
    sequence:AppendCallback(function()
        self.aniObjMap[obj] = nil
        ResMgr:ReleaseAsset(obj.gameObject)
        gg.event:dispatchEvent("onResAniFinishOnce", resType, resPerObj, index, loadCount, flyId)
    end)
end

local explodeJumpTime = 1

function ResEffectManager:explodeUiRes2PnlPlayerInformation(beginPos, resType, resChangeCount)
    local pnlPlayerInformation = gg.uiManager:getWindow("PnlPlayerInformation")

    if pnlPlayerInformation and pnlPlayerInformation:isShow()  then
        local targetPos = pnlPlayerInformation:getResFlyTargetObj(resType).transform.position
        self:explodeUiRes(beginPos, targetPos, resType, resChangeCount)
    end
end

-- beginPos""。""uiCamera""ui
function ResEffectManager:explodeUiRes(beginPos, targetPos, resType, resChangeCount)
    local assetName
    if resType then
        local data = ResEffectManager.res2Data[resType]
        assetName = data.assetName
    end
    assetName = assetName or "StarCoin3D"

    local midDelayTime = 0
    local loadCount, resPerObj = self:getLoadCount(resChangeCount)

    for i = 1, loadCount do
        ResMgr:LoadGameObjectAsync(assetName, function(obj)
            obj.transform:SetParent(gg.uiManager.uiRoot.tipsNode.transform, false)
            obj.transform.position = beginPos
            self:startResExplodeAni(obj, targetPos, midDelayTime, resType, i, loadCount, resPerObj)
            midDelayTime = midDelayTime + 0.1
            return true
        end, true)
    end
end

local explodeTime = 1.5
-- targetPos""
function ResEffectManager:startResExplodeAni(obj, targetWorldPos, midDelayTime, resType, index, loadCount, resPerObj)
    self.aniObjMap[obj] = true

    local explodePos = CS.UnityEngine.Vector3(0, 0, 0)
    explodePos.x = math.random(-1, 1)
    explodePos.y = math.random(-1, 1)
    explodePos = explodePos.normalized * math.random(30, 150) + obj.transform.position

    local sequence = CS.DG.Tweening.DOTween.Sequence()

    local jumpPower = (math.random(-2, 1) + math.random()) / 5
    sequence:Append(obj.transform:DOJump(explodePos, jumpPower, 1, explodeTime):SetEase(CS.DG.Tweening.Ease.OutQuart))

    jumpPower = (math.random(-2, 1) + math.random()) / 5

    local jumpStartTime = explodeTime / 3 + midDelayTime
    sequence:Insert(jumpStartTime, obj.transform:DOJump(targetWorldPos, jumpPower, 1, explodeJumpTime)
        :SetEase(CS.DG.Tweening.Ease.InSine))

    local image = obj.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    if image then
        local color = image.color
        color.a = 1
        image.color = color
        sequence:Insert(jumpStartTime + explodeJumpTime / 2,
            image:DOFade(0, explodeJumpTime / 2):SetEase(CS.DG.Tweening.Ease.InSine))
    end

    sequence:AppendCallback(function()
        ResMgr:ReleaseAsset(obj.gameObject)

        gg.event:dispatchEvent("onResAniFinishOnce", resType, resPerObj, index, loadCount, self:getFlyId())
    end)
end
