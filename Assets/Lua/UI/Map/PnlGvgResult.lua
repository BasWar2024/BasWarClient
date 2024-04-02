

PnlGvgResult = class("PnlGvgResult", ggclass.UIBase)

function PnlGvgResult:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlGvgResult:onAwake()
    self.view = ggclass.PnlGvgResultView.new(self.pnlTransform)

end

function PnlGvgResult:onShow()
    self:bindEvent()

    self:showResult()

    gg.uiManager:closeWindow("PnlUnionArmy")
end

PnlGvgResult.ICON_RESULT = {
    [0] = "Result_Defect_icon",
    [1] = "Result_Victory_icon",
}

function PnlGvgResult:showResult()
    self.view.txtDefeat.text = string.format(Utils.getText("battle_down_Dao_LostSoldiers"), self.args.battleTotal, self.args.reserveTotal)

    gg.setSpriteAsync(self.view.iconResult, PnlGvgResult.ICON_RESULT[self.args.battleResult])
end

function PnlGvgResult:onHide()
    self:releaseEvent()

end

function PnlGvgResult:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnConFirm):SetOnClick(function()
        self:onBtnConFirm()
    end)
    CS.UIEventHandler.Get(view.btnReview):SetOnClick(function()
        self:onBtnReview()
    end)
end

function PnlGvgResult:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnConFirm)
    CS.UIEventHandler.Clear(view.btnReview)

end

function PnlGvgResult:onDestroy()
    local view = self.view

end

function PnlGvgResult:onBtnConFirm()
    gg.event:dispatchEvent("onPnlGvgResultBtnConFirm")
    self:close()
end

function PnlGvgResult:onBtnReview()
    local cfgId = self.args.gridCfgId
    local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
    local type = BattleData.BATTLE_TYPE_SELF
    if curCfg.belongType == 1 then
        type = BattleData.BATTLE_TYPE_RES_PLANNET
    end
    gg.uiManager:openWindow("PnlUnionWarReport", type)

    -- UnionData.C2S_Player_QueryUnionStarmapCampaignReports(1, 5)
    self:close()
end

return PnlGvgResult