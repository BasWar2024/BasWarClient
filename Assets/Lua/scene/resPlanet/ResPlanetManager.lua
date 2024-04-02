-- ResPlanetManager = class("ResPlanetManager")

-- function ResPlanetManager:ctor()
--     self.resPlanetTable = {}
--     self:bindEvent()

--     self.resPlanetCfg = cfg["resPlanet"]

--     self.productionRes = {
--         [constant.RES_STARCOIN] = 0,
--         [constant.RES_ICE] = 0,
--         [constant.RES_CARBOXYL] = 0,
--         [constant.RES_TITANIUM] = 0,
--         [constant.RES_GAS] = 0
--     }
-- end

-- function ResPlanetManager:bindEvent()
--     gg.event:addListener("onRefreshResPlanetData", self)
--     gg.event:addListener("onLookResPlanetData", self)
--     -- gg.event:addListener("onLookOtherBase", self)
-- end

-- function ResPlanetManager:releaseEvent()
--     gg.event:removeListener("onRefreshResPlanetData", self)
--     gg.event:removeListener("onLookResPlanetData", self)
--     -- gg.event:removeListener("onLookOtherBase", self)
-- end

-- -- ""
-- function ResPlanetManager:loadStellarSystem()
--     local myCfg = cfg["stellarSystem"]
--     for k, v in pairs(myCfg) do
--         local stellar = ggclass.StellarSystem.new(v)
--     end
-- end

-- -- ""
-- function ResPlanetManager:onEnterStellarScene(temp)
--     if temp then
--         ResPlanetData.C2S_Player_QueryResPlanetByStellar(temp.cfgId)
--         self.nowStellar = temp
--     elseif self.nowStellar then
--         ResPlanetData.C2S_Player_QueryResPlanetByStellar(self.nowStellar.cfgId)
--     end
-- end

-- -- ""，""
-- function ResPlanetManager:onRefreshResPlanetData()
--     self:unLoadResPlanet()
--     for k, brief in pairs(ResPlanetData.resPlanetBrief) do
--         if gg.buildingManager.resPlanet then
--             local planet = ggclass.ResPlanet.new(brief)
--             self.resPlanetTable[brief.index] = planet
--         end
--     end
--     local planet = ggclass.StellarSystem.new(self.nowStellar, true)
--     self.resPlanetTable[self.nowStellar.cfgId] = planet
--     gg.sceneManager:enterStellarScene()
-- end

-- -- ""
-- function ResPlanetManager:unLoadResPlanet()
--     for k, v in pairs(self.resPlanetTable) do
--         v:onDestroyPlanet()
--     end
--     self.resPlanetTable = {}
-- end

-- -- ""
-- function ResPlanetManager:onLookResPlanetData(args, planetData)
--     self.curPlanetPlayerId = ResPlanetData.resPlanetData.holdPlayerId
--     gg.buildingManager:initOtherBase(ResPlanetData.resPlanetData.builds)
--     local viewArgs = {
--         returnType = PnlPlanet.TYPE_RETURN_MAP,
--         planetData = planetData,
--         showType = ggclass.PnlPlanet.TYPE_SHOW_PLANET,
--     }
--     gg.sceneManager:enterPlanetScene(viewArgs)
--     self.curPlanet = {}
--     self.curPlanet = ResPlanetData.resPlanetData
-- end

-- -- ""
-- function ResPlanetManager:onLookOtherBase(data, holdPlayerId, builds, PnlPlanetShowType, returnOpenWindow)
--     self.curPlanetPlayerId = holdPlayerId
--     gg.buildingManager:initOtherBase(builds)

--     local viewArgs = {
--         returnType = ggclass.PnlPlanet.TYPE_RETURN_MAIN,
--         data = data,
--         showType = PnlPlanetShowType,
--         returnOpenWindow = returnOpenWindow,
--     }

--     gg.sceneManager:enterPlanetScene(viewArgs)
--     self.curPlanet = nil
-- end

-- -- ""
-- function ResPlanetManager:destoryAllStar()
--     gg.event:dispatchEvent("onUnLoadStellar")
--     self:unLoadResPlanet()
-- end

-- function ResPlanetManager:isMyResPlanet()
--     if gg.client.loginServer.currentRole.roleid == self.curPlanetPlayerId then
--         return true
--     else
--         return false
--     end
-- end

-- function ResPlanetManager:resetPlayerId()
--     self.curPlanetPlayerId = gg.client.loginServer.currentRole.roleid
-- end

-- function ResPlanetManager:onMove2ResPlanet(planetCfg)
--     local myCfg = cfg["stellarSystem"]

--     self.nowStellar = myCfg[planetCfg.stellarCfgId]
--     gg.sceneManager:onMove2ResPlanet()
--     gg.uiManager:closeWindow("PnlMyPlanet")
--     gg.uiManager:closeWindow("PnlCollect")
-- end

-- return ResPlanetManager
