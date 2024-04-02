PnlMapEntrance = class("PnlMapEntrance", ggclass.UIBase)

function PnlMapEntrance:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlMapEntrance:onAwake()
    self.view = ggclass.PnlMapEntranceView.new(self.pnlTransform)

end

function PnlMapEntrance:onShow()
    self:bindEvent()
    if self.args then
        if self.args == 1 then
            self:onBtnBsc()
        else
            self:onBtnCon()
        end
    else
        self:onBtnBsc()
    end
end

function PnlMapEntrance:onHide()
    self:releaseEvent()

end

function PnlMapEntrance:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnBsc):SetOnClick(function()
        self:onBtnBsc()
    end)
    CS.UIEventHandler.Get(view.btnCon):SetOnClick(function()
        self:onBtnCon()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
end

function PnlMapEntrance:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnBsc)
    CS.UIEventHandler.Clear(view.btnCon)
    CS.UIEventHandler.Clear(view.btnConfirm)

end

function PnlMapEntrance:onDestroy()
    local view = self.view

end

function PnlMapEntrance:onBtnClose()
    self:close()
end

function PnlMapEntrance:onBtnBsc()
    self.chain = "BSC"
    self.view.btnBsc.transform:Find("IconSel").gameObject:SetActiveEx(true)
    self.view.btnCon.transform:Find("IconSel").gameObject:SetActiveEx(false)

end

function PnlMapEntrance:onBtnCon()
    self.chain = "CFX"
    self.view.btnBsc.transform:Find("IconSel").gameObject:SetActiveEx(false)
    self.view.btnCon.transform:Find("IconSel").gameObject:SetActiveEx(true)

end

function PnlMapEntrance:onBtnConfirm()
    local chainCfg
    for k, v in pairs(cfg.chain) do
        if self.chain == constant.getNameByChain(v.releaseChainId) then
            chainCfg = v
            break
        end
    end
    if chainCfg then
        local curCfgId = gg.galaxyManager:pos2CfgId(chainCfg.centerPos.x, chainCfg.centerPos.y)
        local starCfg = gg.galaxyManager:getGalaxyCfg(curCfgId)
        gg.event:dispatchEvent("onJumpGalaxyGrid", starCfg, false)

        self:close()
    end
end

return PnlMapEntrance
