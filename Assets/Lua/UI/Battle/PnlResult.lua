

PnlResult = class("PnlResult", ggclass.UIBase)

function PnlResult:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlResult:onAwake()
    self.view = ggclass.PnlResultView.new(self.transform)
    self.battleResultBox = BattleResultBox.new(self.view.battleResultBox, self)
end

--self.args : S2C_Player_EndBattle
function PnlResult:onShow()
    self:bindEvent()
    self.battleResultBox:open()
    self.battleResultBox:setResult(self.args)
end

function PnlResult:onHide()
    self:releaseEvent()
    self.battleResultBox:close()
end

function PnlResult:bindEvent()
    local view = self.view

    -- CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
    --     self:onBtnReturn()
    -- end)
end

function PnlResult:releaseEvent()
    local view = self.view
end

function PnlResult:onDestroy()
    local view = self.view
    self.battleResultBox:release()
end

--override
function PnlResult:getGuideRectTransform(guideCfg)
    if guideCfg.gameObjectName == "btnReturn" then
        return self.battleResultBox.btnReturnBase
    end

    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

--override
function PnlResult:triggerGuideClick(guideCfg)
    if guideCfg.gameObjectName == "btnReturn" then
        self.battleResultBox:onBtnReturn()
    end
end

return PnlResult