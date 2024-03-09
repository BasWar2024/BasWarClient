local ResPlanet = class("ResPlanet")

ResPlanet.PLANET_POS = {Vector3(10, 0, 30), Vector3(30, 0, 30), Vector3(30, 0, 10), Vector3(10, 0, 10)}

function ResPlanet:ctor(planetData)
    self.obj = nil
    self:loadPlanet(planetData)
end

function ResPlanet:loadPlanet(planetData)
    ResMgr:LoadGameObjectAsync("ResPlanet", function(go)
        go.transform:SetParent(gg.buildingManager.resPlanet.transform, false)
        go.transform.localPosition = ResPlanet.PLANET_POS[planetData.index]
        self.obj = go
        self:onAwake(planetData)
        return true
    end, true)

end

function ResPlanet:onAwake(planetData)
    self:setResPlanetData(planetData)
    self:onShow()
end

function ResPlanet:setResPlanetData(planetData)
    self.planetData = planetData
    local name = string.format("%s's planet", planetData.holdPlayerName)
    self.obj.transform:Find("PlanetUi/TxtName"):GetComponent("Text").text = name
end

function ResPlanet:onShow()
    self:bindEvent()
end

function ResPlanet:bindEvent()
    CS.UIEventHandler.Get(self.obj.transform:Find("Planet").gameObject):SetOnClick(function()
        self:onBtnClick()
    end)
end

function ResPlanet:onBtnClick()
    self:lookResPlanet()
end

function ResPlanet:unLoadPlanet()
    ResMgr:ReleaseAsset(self.obj)
    self.obj = nil
end

function ResPlanet:releaseEvent()
    CS.UIEventHandler.Clear(self.obj)
end

function ResPlanet:onDestroyPlanet()
    self:releaseEvent()
    self:unLoadPlanet()
end

function ResPlanet:lookResPlanet()
    local index = self.planetData.index
    ResPlanetData.C2S_Player_LookResPlanet(index)
end

return ResPlanet