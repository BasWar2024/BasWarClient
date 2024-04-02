RedPointNewPlayerLogin = class("RedPointNewPlayerLogin", ggclass.RedPointBase)

function RedPointNewPlayerLogin:ctor()
    ggclass.RedPointBase.ctor(self, {}, {"onLoginActivityInfoChange"})

    gg.timer:startLoopTimer(0, 2, -1, function ()
        self:onCheck()
    end)
end

function RedPointNewPlayerLogin:onCheck()
    if ActivityUtil.checkGiftActivitiesOpen(constant.NEW_PLAYER_LOGIN) then
        for key, value in pairs(ActivityData.loginActivityInfo.data) do
            if value.baseStatus == 0 or value.advStatus == 0 then
                return true
            end
        end
        
    end
    return false
end
