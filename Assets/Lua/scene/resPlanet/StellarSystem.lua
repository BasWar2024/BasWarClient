-- local StellarSystem = class("StellarSystem")

-- function StellarSystem:ctor(cfg, isBig)
--     self.stellarCfg = cfg
--     self.stellar = nil
--     self.isBig = isBig
--     self:loadStellar()
-- end

-- function StellarSystem:loadStellar()
--     local v = self.stellarCfg
--     ResMgr:LoadGameObjectAsync("Stellar", function(obj)
--         local modelName = v.smallModel
--         if self.isBig then
--             modelName = v.bigModel
--         end
--         ResMgr:LoadGameObjectAsync(modelName, function(go)
--             if self.isBig then
--                 obj.transform:SetParent(gg.buildingManager.resPlanet.transform:Find("resPlanet"), false)
--                 obj.transform.localPosition = Vector3(0, 0, 0)
--             else
--                 obj.transform:SetParent(gg.buildingManager.resPlanet.transform:Find("stellar"), false)
--                 obj.transform.localPosition = Vector3(v.pos.x, v.pos.y, v.pos.z)
--             end
--             obj.transform:Find("PlanetUi/BtnEnter").gameObject:SetActive(false)
--             obj.transform:Find("PlanetUi/TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = v.systemName
--             self.stellar = obj

--             go.transform:SetParent(obj.transform, false)
--             go.transform.localPosition = Vector3(0, 0, 0)
--             go.name = v.systemName
--             self.planet = go
--             self:bindEvent()
--             return true
--         end, true)

--         return true
--     end, true)
-- end

-- function StellarSystem:onUnLoadStellar()
--     self:unLoadStellar()
-- end

-- function StellarSystem:onDestroyPlanet()
--     self:unLoadStellar()
-- end

-- function StellarSystem:unLoadStellar()
--     self:releaseEvent()
--     ResMgr:ReleaseAsset(self.planet)
--     ResMgr:ReleaseAsset(self.stellar)
--     self.planet = nil
--     self.stellar = nil
-- end

-- function StellarSystem:bindEvent()
--     CS.UIEventHandler.Get(self.stellar.transform:Find("Collider").gameObject):SetOnClick(function()
--         self:onClickStellar()
--     end)
--     CS.UIEventHandler.Get(self.stellar.transform:Find("PlanetUi/BtnEnter").gameObject):SetOnClick(function()
--         self:onBtnEnter()
--     end)

--     gg.event:addListener("onShowName", self)
--     gg.event:addListener("onShowButton", self)
--     if not self.isBig then
--         gg.event:addListener("onUnLoadStellar", self)
--     end
-- end

-- function StellarSystem:releaseEvent()
--     CS.UIEventHandler.Clear(self.stellar.transform:Find("Collider").gameObject)
--     CS.UIEventHandler.Clear(self.stellar.transform:Find("PlanetUi/BtnEnter").gameObject)

--     gg.event:removeListener("onShowName", self)
--     gg.event:removeListener("onShowButton", self)
--     if not self.isBig then
--         gg.event:removeListener("onUnLoadStellar", self)
--     end

-- end

-- function StellarSystem:onClickStellar()
--     gg.event:dispatchEvent("onClickStellar", self.stellarCfg)
--     gg.event:dispatchEvent("onShowButton", self.stellarCfg.cfgId)

-- end

-- function StellarSystem:onBtnEnter()
--     --gg.resPlanetManager:onEnterStellarScene(self.stellarCfg)
-- end

-- function StellarSystem:onShowButton(args, cfgId)
--     if not self.isBig then
--         if self.stellarCfg.cfgId == cfgId then
--             self.stellar.transform:Find("PlanetUi/BtnEnter").gameObject:SetActive(true)
--         else
--             self.stellar.transform:Find("PlanetUi/BtnEnter").gameObject:SetActive(false)
--         end
--     end
-- end

-- function StellarSystem:onShowName(args, bool)
--     if bool then
--         self.stellar.transform:Find("PlanetUi/TxtName").gameObject:SetActive(true)
--     else
--         self.stellar.transform:Find("PlanetUi/TxtName").gameObject:SetActive(false)
--     end
-- end

-- return StellarSystem
