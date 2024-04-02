-- local ResPlanet = class("ResPlanet")

-- function ResPlanet:ctor(planetData)
--     self.obj = nil

--     self:loadPlanet(planetData)
-- end

-- function ResPlanet:loadPlanet(planetData)
--     ResMgr:LoadGameObjectAsync("ResPlanet", function(obj)
--         local reaPlanetCfg = cfg["resPlanet"]
--         self.planetCfg = reaPlanetCfg[planetData.index]
--         ResMgr:LoadGameObjectAsync(self.planetCfg.model, function(go)
--             obj.transform:SetParent(gg.buildingManager.resPlanet.transform:Find("resPlanet"), false)
--             local pos = self.planetCfg.pos
--             local vec3 = Vector3(pos.x, pos.y, pos.z)
--             obj.transform.localPosition = vec3
--             obj.name = self.planetCfg.planetName
--             self.obj = obj

--             go.transform:SetParent(self.obj.transform, false)
--             go.transform.localPosition = Vector3(0,0,0)
--             go.name = self.planetCfg.planetName
--             self.planetGo = go
--             self:onAwake(planetData)
--             return true
--         end, true)
--         return true
--     end, true)

-- end

-- function ResPlanet:onRefreshPlanetData(args, planet, index)
--     if planet then
--         if self.planetData.index == planet.index then
--             self:refreshData(planet)
--             gg.event:dispatchEvent("onClickPlanet", self.planetMsg)
--         end
--     end
--     if index then
--         if self.planetData.index == index then
--             self.planetMsg.isFavorite = false
--         end
--     end
-- end

-- function ResPlanet:refreshData(data)
--     self.planetData = data
--     local name = data.planetName
--     self.obj.transform:Find("PlanetUi/TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = name

--     self.planetMsg = {}

--     local index = data.index
--     local isFavorite = data.isFavorite
--     local planetName = data.planetName
--     local owenrName = data.holdPlayerName
--     local resCfgId1 = nil
--     local resCound1 = nil
--     local resCfgId2 = nil
--     local resCound2 = nil
--     if data.currencies[1] then
--         resCfgId1 = data.currencies[1].resCfgId
--         resCound1 = data.currencies[1].count
--     end
--     if data.currencies[2] then
--         resCfgId2 = data.currencies[2].resCfgId
--         resCound2 = data.currencies[2].count
--     end
--     local orbitRadius = self.planetCfg.orbitRadius
--     local orbitalPrtiod = self.planetCfg.orbitalPrtiod
--     local rotation = self.planetCfg.rotation
--     local planetRadius = self.planetCfg.planetRadius
--     local planetQuality = self.planetCfg.planetQuality

--     self.planetMsg = {
--         index = index,
--         isFavorite = isFavorite,
--         planetName = planetName,
--         owenrName = owenrName,
--         resCfgId1 = resCfgId1,
--         resCound1 = resCound1,
--         resCfgId2 = resCfgId2,
--         resCound2 = resCound2,
--         orbitRadius = orbitRadius,
--         orbitalPrtiod = orbitalPrtiod,
--         rotation = rotation,
--         planetRadius = planetRadius,
--         planetQuality = planetQuality
--     }
-- end

-- function ResPlanet:onAwake(planetData)
--     self:refreshData(planetData)
--     self:onShow()
-- end

-- function ResPlanet:onShow()
--     self:bindEvent()
-- end

-- function ResPlanet:bindEvent()
--     CS.UIEventHandler.Get(self.obj.transform:Find("Collider").gameObject):SetOnClick(function()
--         self:onBtnClick()
--     end)
--     CS.UIEventHandler.Get(self.obj.transform:Find("PlanetUi/ButtonUi/BtnSount").gameObject):SetOnClick(function()
--         self:onBtnSount()
--     end)
--     CS.UIEventHandler.Get(self.obj.transform:Find("PlanetUi/ButtonUi/BtnFight").gameObject):SetOnClick(function()
--         self:onBtnFight()
--     end)
--     gg.event:addListener("onShowButtonUi", self)
--     gg.event:addListener("onRefreshPlanetData", self)
-- end

-- function ResPlanet:onBtnClick()
--     local index = self.planetData.index
--     gg.event:dispatchEvent("onShowButtonUi", index)
--     gg.event:dispatchEvent("onClickPlanet", self.planetMsg)
-- end

-- function ResPlanet:onBtnSount()
--     self:lookResPlanet()
--     gg.event:dispatchEvent("onShowButtonUi", -1)

-- end

-- function ResPlanet:onBtnFight()
--     local index = self.planetData.index
--     gg.event:dispatchEvent("onShowButtonUi", -1)
--     BattleData.C2S_Player_StartBattle(2, index)
-- end

-- function ResPlanet:unLoadPlanet()
--     ResMgr:ReleaseAsset(self.planetGo)
--     ResMgr:ReleaseAsset(self.obj)
--     self.planetGo = nil
--     self.obj = nil
-- end

-- function ResPlanet:releaseEvent()
--     CS.UIEventHandler.Clear(self.obj.transform:Find("Collider").gameObject)
--     CS.UIEventHandler.Clear(self.obj.transform:Find("PlanetUi/ButtonUi/BtnSount").gameObject)
--     CS.UIEventHandler.Clear(self.obj.transform:Find("PlanetUi/ButtonUi/BtnFight").gameObject)
--     gg.event:removeListener("onShowButtonUi", self)
--     gg.event:removeListener("onRefreshPlanetData", self)

-- end

-- function ResPlanet:onDestroyPlanet()
--     self:releaseEvent()
--     self:unLoadPlanet()
-- end

-- function ResPlanet:lookResPlanet()
--     local index = self.planetData.index
--     ResPlanetData.C2S_Player_LookResPlanet(index)
-- end

-- function ResPlanet:onShowButtonUi(args, index)
--     if self.planetData.index == index then
--         self.obj.transform:Find("PlanetUi/ButtonUi").gameObject:SetActive(true)
--         if self.planetData.holdPlayerId == gg.client.loginServer.currentRole.roleid then
--             self.obj.transform:Find("PlanetUi/ButtonUi"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(28, 110)
--             self.obj.transform:Find("PlanetUi/ButtonUi/BtnFight").gameObject:SetActive(false)
--         else
--             self.obj.transform:Find("PlanetUi/ButtonUi"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(28, 180)
--             self.obj.transform:Find("PlanetUi/ButtonUi/BtnFight").gameObject:SetActive(true)
--         end
--     else
--         self.obj.transform:Find("PlanetUi/ButtonUi").gameObject:SetActive(false)
--     end
-- end

-- return ResPlanet
