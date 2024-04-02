RedPointDrawCard = class("RedPointDrawCard", ggclass.RedPointBase)

function RedPointDrawCard:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointMainMenu}, {"onDrawCardDataChange"})

    gg.timer:startLoopTimer(0, 2, -1, function ()
        self:check()
        -- self:onCheck()
    end)
end

function RedPointDrawCard:onCheck()
    if not DrawCardData.cardPoolData then
        return false
    end

    local curTime = Utils.getServerSec()
    for k, v in ipairs(cfg.cardPool) do
        local drawCardPoolData = DrawCardData.cardPoolData[v.cfgId]
        if v.available == 1 and drawCardPoolData  then
            local lastTime = drawCardPoolData.drawTime

            if v.freeTime > 0 and curTime - lastTime >= v.freeTime then
                return true
            end
        end
    end

    return false
end
