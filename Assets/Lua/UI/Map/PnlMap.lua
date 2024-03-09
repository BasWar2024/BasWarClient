

PnlMap = class("PnlMap", ggclass.UIBase)

function PnlMap:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlMap:onAwake()
    self.view = ggclass.PnlMapView.new(self.transform)

end

function PnlMap:onShow()
    self:bindEvent()

end

function PnlMap:onHide()
    self:releaseEvent()

end

function PnlMap:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnBattleReport):SetOnClick(function()
        self:onBtnBattleReport()
    end)
    CS.UIEventHandler.Get(view.btnResInfor):SetOnClick(function()
        self:onBtnResInfor()
    end)
    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)
    CS.UIEventHandler.Get(view.btnReplenish):SetOnClick(function()
        self:onBtnReplenish()
    end)
    CS.UIEventHandler.Get(view.btnSoldier1):SetOnClick(function()
        self:onBtnSoldier1()
    end)
    CS.UIEventHandler.Get(view.btnSoldier2):SetOnClick(function()
        self:onBtnSoldier2()
    end)
    CS.UIEventHandler.Get(view.btnSoldier3):SetOnClick(function()
        self:onBtnSoldier3()
    end)
    CS.UIEventHandler.Get(view.btnSoldier4):SetOnClick(function()
        self:onBtnSoldier4()
    end)
    CS.UIEventHandler.Get(view.btnSoldier5):SetOnClick(function()
        self:onBtnSoldier5()
    end)
    CS.UIEventHandler.Get(view.btnSoldier6):SetOnClick(function()
        self:onBtnSoldier6()
    end)
    CS.UIEventHandler.Get(view.btnSoldier7):SetOnClick(function()
        self:onBtnSoldier7()
    end)
    CS.UIEventHandler.Get(view.btnSoldier8):SetOnClick(function()
        self:onBtnSoldier8()
    end)
end

function PnlMap:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnBattleReport)
    CS.UIEventHandler.Clear(view.btnResInfor)
    CS.UIEventHandler.Clear(view.btnReturn)
    CS.UIEventHandler.Clear(view.btnReplenish)
    CS.UIEventHandler.Clear(view.btnSoldier1)
    CS.UIEventHandler.Clear(view.btnSoldier2)
    CS.UIEventHandler.Clear(view.btnSoldier3)
    CS.UIEventHandler.Clear(view.btnSoldier4)
    CS.UIEventHandler.Clear(view.btnSoldier5)
    CS.UIEventHandler.Clear(view.btnSoldier6)
    CS.UIEventHandler.Clear(view.btnSoldier7)
    CS.UIEventHandler.Clear(view.btnSoldier8)

end

function PnlMap:onDestroy()
    local view = self.view

end

function PnlMap:onBtnBattleReport()

end

function PnlMap:onBtnResInfor()

end

function PnlMap:onBtnReturn()
    gg.sceneManager:returnBaseScene()
    self:close()
end

function PnlMap:onBtnReplenish()

end

function PnlMap:onBtnSoldier1()

end

function PnlMap:onBtnSoldier2()

end

function PnlMap:onBtnSoldier3()

end

function PnlMap:onBtnSoldier4()

end

function PnlMap:onBtnSoldier5()

end

function PnlMap:onBtnSoldier6()

end

function PnlMap:onBtnSoldier7()

end

function PnlMap:onBtnSoldier8()

end

return PnlMap