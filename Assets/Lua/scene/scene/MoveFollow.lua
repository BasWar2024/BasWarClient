local MoveFollow = class("MoveFollow")

-- MoveFollow.SCREENHEIGHT = 1080
-- MoveFollow.SCREENWIDTH = 1920

function MoveFollow:ctor(uiObj, targetObj, offset, overScreen, isDeformation, isUpdata)
    self.uiObj = uiObj
    self.targetObj = targetObj
    self.offset = offset or Vector2.zero
    self.overScreen = overScreen
    self.width = UnityEngine.Screen.width
    self.height = UnityEngine.Screen.height
    self.isDeformation = isDeformation
    self.isShow = true

    -- local newScreenWidth = UnityEngine.Screen.width
    -- local newScreenHeight = UnityEngine.Screen.height

    -- local referenceProportion = MoveFollow.SCREENWIDTH / MoveFollow.SCREENHEIGHT
    -- local newProportion = newScreenWidth / newScreenHeight

    -- local referenceHeight = 0
    -- local referenceWidth = 0
    -- if newProportion >= referenceProportion then
    --     referenceHeight = MoveFollow.SCREENHEIGHT
    --     referenceWidth = newProportion * MoveFollow.SCREENHEIGHT
    -- else
    --     newProportion = newScreenHeight / newScreenWidth
    --     referenceWidth = MoveFollow.SCREENWIDTH
    --     referenceHeight = newProportion * MoveFollow.SCREENWIDTH
    -- end

    -- self.biasX = referenceWidth / newScreenWidth
    -- self.biasY = referenceHeight / newScreenHeight

    self.biasX = gg.sceneManager.biasX
    self.biasY = gg.sceneManager.biasY

    self:bindEvent(isUpdata)
    self:onMoveFollow()
end

function MoveFollow:bindEvent(isUpdata)
    gg.event:addListener("onMoveFollowHide", self)
    if isUpdata then
        gg.event:addListener("onUpdataMove", self)
    else
        gg.event:addListener("onMoveFollow", self)
    end
end

function MoveFollow:releaseEvent()
    gg.event:removeListener("onUpdataMove", self)
    gg.event:removeListener("onMoveFollowHide", self)
    gg.event:removeListener("onMoveFollow", self)
end

function MoveFollow:onMoveFollow(args, isUnLock)
    if self then
        self:moveFollow(isUnLock)
    end
end

function MoveFollow:onUpdataMove(args, isUnLock)
    if self then
        self:moveFollow(isUnLock)
    end
end

function MoveFollow:onMoveFollowHide(args, isLock)
    if self then
        self.isLock = isLock
        self.uiObj:SetActive(false)
    end
end

function MoveFollow:showRes(bool)
    self.uiObj:SetActive(bool)
    self.isShow = bool
end

function MoveFollow:moveFollow(isUnLock)
    if isUnLock then
        self.isLock = false
    end
    if not UnityEngine.Camera.main or not self.targetObj or not self.uiObj or self.isLock then
        return
    end
    if self.isShow then
        self.uiObj:SetActive(true)
    end
    local targetScreenPoint = UnityEngine.Camera.main:WorldToScreenPoint(self.targetObj.transform.position)
    local uiPoint = Vector3(targetScreenPoint.x + self.offset.x, targetScreenPoint.y + self.offset.y, 0)
    local fleld = UnityEngine.Camera.main.fieldOfView
    if fleld > 15 then
        fleld = 15
    end
    local scale = (15 - fleld) / (15 - 4) * 0.6 + 0.4
    local size = 1
    if not self.overScreen then
        local vecX = 0.5
        local vecY = 0.5
        if uiPoint.x < 0 then
            uiPoint.x = 0
            vecX = 0
            size = 0.8
        end
        if uiPoint.x > self.width then
            uiPoint.x = self.width
            vecX = 1
            size = 0.8
        end
        if uiPoint.y < 0 then
            uiPoint.y = 0
            vecY = 0.15
            size = 0.8
        end
        if uiPoint.y > self.height then
            uiPoint.y = self.height
            vecY = 1
            size = 0.8
        end
        self:boxDeformation(Vector2.New(vecX, vecY))
    end

    uiPoint.x = uiPoint.x * self.biasX
    uiPoint.y = uiPoint.y * self.biasY
    local newScale = scale * size
    self.uiObj.transform.localScale = Vector3(newScale, newScale, newScale)
    self.uiObj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosX(uiPoint.x)
    self.uiObj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(uiPoint.y)
    self.uiObj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetLocalPosZ(0)
end

function MoveFollow:boxDeformation(pivot)
    if self.isDeformation then
        local bg = self.uiObj.transform:Find("Bg")
        local bg1 = self.uiObj.transform:Find("Bg/Bg1")
        local bg2 = self.uiObj.transform:Find("Bg/Bg2")
        local bgWidth = bg.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.width
        local bg1Width = bg1.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.width
        local bg2Width = bg2.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.width
        self.uiObj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).pivot = pivot
        if pivot == Vector2.New(0.5, 0.5) then
            if bgWidth == 0 then
                bgWidth = 42
                bg1Width = bg1.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.width - 21
                bg2Width = bg2.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.width - 21
            end
        else
            if bgWidth == 42 then
                bgWidth = 0
                bg1Width = bg1.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.width + 21
                bg2Width = bg2.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).rect.width + 21
            end
        end

        bg:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(bgWidth, 84)
        bg1:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(bg1Width, 84)
        bg2:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(bg2Width, 84)
    end
end

return MoveFollow
