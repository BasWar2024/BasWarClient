PnlPlanet = class("PnlPlanet", ggclass.UIBase)

function PnlPlanet:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlPlanet:onAwake()
    self.view = ggclass.PnlPlanetView.new(self.transform)

end

function PnlPlanet:onShow()
    self:bindEvent()

end

function PnlPlanet:onHide()
    self:releaseEvent()

end

function PnlPlanet:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)
    CS.UIEventHandler.Get(view.btnBag):SetOnClick(function()
        self:onBtnBag()
    end)
end

function PnlPlanet:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnReturn)

end

function PnlPlanet:onDestroy()
    local view = self.view

end

function PnlPlanet:onBtnReturn()
    gg.buildingManager:destroyOtherBuilding()
    gg.sceneManager:enterMapScene()
    gg.resPlanetManager:resetPlayerId()
    self:close()
end

function PnlPlanet:onBtnBag()
    gg.uiManager:openWindow("PnlItemBag")
end

return PnlPlanet
