RedPointPve = class("RedPointPve", ggclass.RedPointBase)

function RedPointPve:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointMainMenu}, {})
end

function RedPointPve:onCheck()
    return false
end

--------------------------------------------------------------------

RedPointPveDailyRewardFetch = class("RedPointPveDailyRewardFetch", ggclass.RedPointBase)

function RedPointPveDailyRewardFetch:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointPve}, {"onPveChange"})
end

function RedPointPveDailyRewardFetch:onCheck()
    local isCanFetch, _ = PveUtil.checkIsCanFetchDaily()
    -- return true
    return isCanFetch
end
