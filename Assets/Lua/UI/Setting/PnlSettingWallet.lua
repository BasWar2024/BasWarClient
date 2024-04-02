

PnlSettingWallet = class("PnlSettingWallet", ggclass.UIBase)

function PnlSettingWallet:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onWalletChange"}
end

function PnlSettingWallet:onAwake()
    self.view = ggclass.PnlSettingWalletView.new(self.pnlTransform)

end

function PnlSettingWallet:onShow()
    PlayerData.C2S_Player_QueryWallet()
    self:bindEvent()
    self:refresh()
end

function PnlSettingWallet:refresh()
    local view = self.view
    if PlayerData.ownerAddress == nil or PlayerData.ownerAddress == "" then
        view.txtAlert.gameObject:SetActiveEx(false)
        view.txtUnbind.gameObject:SetActiveEx(true)
        view.txtWallet.gameObject:SetActiveEx(false)
        view.btnCopy.gameObject:SetActiveEx(false)
    else
        view.txtAlert.gameObject:SetActiveEx(true)
        view.txtUnbind.gameObject:SetActiveEx(false)
        view.txtWallet.gameObject:SetActiveEx(true)
        view.txtWallet.text = PlayerData.ownerAddress
        view.btnCopy.gameObject:SetActiveEx(true)
    end

    if PlayerData.chainId ~= 0 then
        view.txtChainId.gameObject:SetActiveEx(true)
        view.txtChainId.text = "Chain:" .. PlayerData.chainId .. ChainBridgeData.getChainNameByChainId(PlayerData.chainId)
    else
        view.txtChainId.gameObject:SetActiveEx(false)

    end
end

function PnlSettingWallet:onHide()
    self:releaseEvent()

end

function PnlSettingWallet:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnCopy):SetOnClick(function()
        self:onBtnCopy()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
end

function PnlSettingWallet:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnCopy)
    CS.UIEventHandler.Clear(view.btnConfirm)

end

function PnlSettingWallet:onDestroy()
    local view = self.view

end

function PnlSettingWallet:onBtnClose()
    self:close()
end

function PnlSettingWallet:onBtnCopy()
    CS.UnityEngine.GUIUtility.systemCopyBuffer = PlayerData.ownerAddress
    gg.uiManager:showTip("wallet copy succeed")
end

function PnlSettingWallet:onBtnConfirm()
    self:close()
end

function PnlSettingWallet:onWalletChange()
    self:refresh()
end

return PnlSettingWallet