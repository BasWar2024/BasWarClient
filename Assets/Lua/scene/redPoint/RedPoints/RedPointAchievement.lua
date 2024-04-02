RedPointAchievement = class("RedPointAchievement", ggclass.RedPointBase)

function RedPointAchievement:ctor()
    ggclass.RedPointBase.ctor(self, {}, {})
end

function RedPointAchievement:onCheck()
    return false
end

------------------------------------------------

