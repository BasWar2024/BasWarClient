ActivityManager = class("ActivityManager")

function ActivityManager:ctor()
    self.timer = gg.timer:startLoopTimer(0, 2, -1, function()
        if gg.client.gameServer and gg.client.gameServer.secTime then
            for key, value in pairs(ActivityData.activityOpenMap) do
                if not ActivityUtil.checkGiftActivitiesOpen(key) then
                    gg.event:dispatchEvent("onActivityClose", key)
                    ActivityData.activityOpenMap[key] = nil
                end
            end
        end
    end)
end