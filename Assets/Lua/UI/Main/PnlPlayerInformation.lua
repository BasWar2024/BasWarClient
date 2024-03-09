

PnlPlayerInformation = class("PnlPlayerInformation", ggclass.UIBase)

function PnlPlayerInformation:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.information
    self.events = { }
end

function PnlPlayerInformation:onAwake()
    self.view = ggclass.PnlPlayerInformationView.new(self.transform)

end

function PnlPlayerInformation:onShow()
    self:bindEvent()

    self:setTxtPlayerName(gg.playerMgr.localPlayer:getName())  
    self:setTxtMit(ResData.getMit())
    self:setTxtStarCoin(ResData.getStarCoin())
    self:setTxtIce(ResData.getIce())
    self:setTxtCarboxyl(ResData.getCarboxyl())
    self:setTxtGas(ResData.getGas())
    self:setTxtTitanium(ResData.getTitanium())
    self:setTxtPvpScore(ResData.getBadge())

    gg.event:addListener("onBgHighlighted", self)
end

function PnlPlayerInformation:onHide()
    self:releaseEvent()

    gg.event:removeListener("onBgHighlighted", self)
end

function PnlPlayerInformation:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnMit):SetOnClick(function()
        self:onBtnMit()
    end)
    CS.UIEventHandler.Get(view.btnStartCoin):SetOnClick(function()
        self:onBtnStartCoin()
    end)
    CS.UIEventHandler.Get(view.btnGas):SetOnClick(function()
        self:onBtnGas()
    end)
    CS.UIEventHandler.Get(view.btnTitanium):SetOnClick(function()
        self:onBtnTitanium()
    end)
    CS.UIEventHandler.Get(view.btnIce):SetOnClick(function()
        self:onBtnIce()
    end)
    CS.UIEventHandler.Get(view.btnCarboxyl):SetOnClick(function()
        self:onBtnCarboxyl()
    end)
    CS.UIEventHandler.Get(view.btnLevel):SetOnClick(function()
        self:onBtnLevel()
    end)
    CS.UIEventHandler.Get(view.btnPlayerName):SetOnClick(function()
        self:onBtnPlayerName()
    end)
    CS.UIEventHandler.Get(view.btnPvpScore):SetOnClick(function()
        self:onBtnPvpScore()
    end)

    gg.event:addListener("onRefreshResTxt", self)
end

function PnlPlayerInformation:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnMit)
    CS.UIEventHandler.Clear(view.btnStartCoin)
    CS.UIEventHandler.Clear(view.btnGas)
    CS.UIEventHandler.Clear(view.btnTitanium)
    CS.UIEventHandler.Clear(view.btnIce)
    CS.UIEventHandler.Clear(view.btnCarboxyl)
    CS.UIEventHandler.Clear(view.btnLevel)
    CS.UIEventHandler.Clear(view.btnPlayerName)
    CS.UIEventHandler.Clear(view.btnPvpScore)

    gg.event:removeListener("onRefreshResTxt", self)
end

function PnlPlayerInformation:onDestroy()
    local view = self.view

end

function PnlPlayerInformation:onBtnMit()
    --print("onBtnMit")
    ResData.C2S_Player_Exchange_Rate()
end

function PnlPlayerInformation:onBtnStartCoin()
    --print("onBtnStartCoin")
    gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:onBtnGas()
    --print("onBtnGas")
    gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:onBtnTitanium()
    --print("onBtnTitanium")
    gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:onBtnIce()
    --print("onBtnIce")
    gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:onBtnCarboxyl()
    --print("onBtnCarboxyl")
    gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:onBtnLevel()
    --print("onBtnLevel")
    gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:onBtnPlayerName()
    print("ffffff2:", gg.playerMgr.localPlayer:getPid())
    --gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:onBtnPvpScore()
    --print("onBtnPvpScore")
    gg.uiManager:showTip("Function not open")
end

function PnlPlayerInformation:setTxtPlayerName(txt)
    self.view.txtPlayerName.text = txt
end

function PnlPlayerInformation:setTxtPvpScore(txt)
    self.view.txtPvpScore.text = txt
end

function PnlPlayerInformation:setTxtMit(txt)
    self.view.txtMit.text = txt
end

function PnlPlayerInformation:setTxtStarCoin(txt)
    self.view.txtStarCoin.text = txt
end

function PnlPlayerInformation:setTxtGas(txt)
    self.view.txtGas.text = txt
end

function PnlPlayerInformation:setTxtTitanium(txt)
    self.view.txtTitanium.text = txt
end

function PnlPlayerInformation:setTxtIce(txt)
    self.view.txtIce.text = txt
end

function PnlPlayerInformation:setTxtCarboxyl(txt)
    self.view.txtCarboxyl.text = txt
end

function PnlPlayerInformation:onRefreshResTxt(args, resCfgId, count)
    if resCfgId == constant.RES_MIT then
        self:setTxtMit(count)
    end
    if resCfgId == constant.RES_STARCOIN then
        self:setTxtStarCoin(count)
    end
    if resCfgId == constant.RES_ICE then
        self:setTxtIce(count)
    end    
    if resCfgId == constant.RES_CARBOXYL then
        self:setTxtCarboxyl(count)
    end   
    if resCfgId == constant.RES_TITANIUM then
        self:setTxtTitanium(count)
    end 
    if resCfgId == constant.RES_GAS then
        self:setTxtGas(count)
    end

    if resCfgId == constant.RES_BADGE then
        self:setTxtPvpScore(count)
    end
end

function PnlPlayerInformation:onBgHighlighted(args, bool)
    local view = self.view
    local notBool = not bool
    view.bgLevel:SetActive(notBool)
    view.bgLevelHighlighted:SetActive(bool)
    view.bgMit:SetActive(notBool)
    view.bgMitHighlighted:SetActive(bool)
    view.bgStarCoin:SetActive(notBool)
    view.bgStarCoinHighlighted:SetActive(bool)
    view.bgGas:SetActive(notBool)
    view.bgGasHighlighted:SetActive(bool)
    view.bgTitanium:SetActive(notBool)
    view.bgTitaniumHighlighted:SetActive(bool)
    view.bgIce:SetActive(notBool)
    view.bgIceHighlighted:SetActive(bool)
    view.bgCarboxyl:SetActive(notBool)
    view.bgCarboxylHighlighted:SetActive(bool)
end

return PnlPlayerInformation