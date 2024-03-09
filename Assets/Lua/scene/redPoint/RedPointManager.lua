RedPointManager = RedPointManager or {} --class("RedPointManager")
-- onRedPointChange

RedPointManager.HERO_UPGRADE = "HERO_UPGRADE"
RedPointManager.TEST2 = "TEST2"
RedPointManager.TEST3 = "TEST3"

function RedPointManager:init()
    self.redPointMap = {}
    self.redPointMap = {
        -- [RedPointManager.HERO_UPGRADE] = RedPointHeroUpgrade.new(),
        -- [RedPointManager.TEST2] = RedPointTest2.new(),
        -- [RedPointManager.TEST3] = RedPointTest3.new(),
    }
end

function RedPointManager:setSubRed(id, childId, isRed)
    if self.redPointMap[id] then
        self.redPointMap[id]:setRed(childId, isRed)
    end
end

function RedPointManager:getIsRed(id)
    if self.redPointMap[id] then
        return self.redPointMap[id].isRed
    end
    return false
end

function RedPointManager:setRedPoint(gameObject, isRed)
    self.redPointMap[gameObject] = self.redPointMap[gameObject] or {}
    self.redPointMap[gameObject].isRed = isRed

    local go = gameObject.transform:Find("ImgCommonRedPoint(Clone)")
    if go ~= nil then
        go:SetActiveEx(isRed)
        return
    end

    if not self.redPointMap[gameObject].loading then
        self.redPointMap[gameObject].loading = true
        ResMgr:LoadGameObjectAsync("ImgCommonRedPoint",function (go)
            self.redPointMap[gameObject].loading = false
            go.transform:SetParent(gameObject.transform, false)
            go.transform.anchoredPosition = CS.UnityEngine.Vector2(0, 0)
            go:SetActiveEx(self.redPointMap[gameObject].isRed)
            return true
        end)
    end
end
