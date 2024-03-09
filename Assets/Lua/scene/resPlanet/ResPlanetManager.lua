ResPlanetManager = class("ResPlanetManager")

function ResPlanetManager:ctor()
    self.resPlanetTable = {}
    self:bindEvent()
end

function ResPlanetManager:bindEvent()
    gg.event:addListener("onRefreshResPlanetData", self)
    gg.event:addListener("onLookResPlanetData", self)
end

function ResPlanetManager:releaseEvent()
    gg.event:removeListener("onRefreshResPlanetData", self)
    gg.event:removeListener("onLookResPlanetData", self)
end

function ResPlanetManager:onRefreshResPlanetData()
    for k, brief in pairs(ResPlanetData.resPlanetBrief) do
        if self.resPlanetTable[brief.index] then
            self.resPlanetTable[brief.index]:setResPlanetData(brief)
        else
            local planet = ggclass.ResPlanet.new(brief)
            self.resPlanetTable[brief.index] = planet
        end
    end
end

function ResPlanetManager:onLookResPlanetData()
    self.curPlanetPlayerId = ResPlanetData.resPlanetData.holdPlayerId
    gg.buildingManager:initOtherBuilding(ResPlanetData.resPlanetData.builds)
    gg.sceneManager:enterPlanetScene()
    self.curPlanet = {}
    self.curPlanet = ResPlanetData.resPlanetData
end

function ResPlanetManager:destoryAllResPlanet()
    for k, v in pairs(self.resPlanetTable) do
        v:onDestroyPlanet()
    end
    self.resPlanetTable = {}
end

function ResPlanetManager:isMyResPlanet()
    if gg.client.loginServer.currentRole.roleid == self.curPlanetPlayerId then
        return true
    else
        return false
    end
end

function ResPlanetManager:resetPlayerId()
    self.curPlanetPlayerId = gg.client.loginServer.currentRole.roleid
end

return ResPlanetManager