
PnlPlayerInformationView = class("PnlPlayerInformationView")

PnlPlayerInformationView.ctor = function(self, transform)

    self.transform = transform

    self.btnMit = transform:Find("ResourceUI/Mit/BtnMit").gameObject
    self.txtMit = transform:Find("ResourceUI/Mit/TxtMit"):GetComponent("Text")
    self.txtStarCoin = transform:Find("ResourceUI/StarCoin/TxtStarCoin"):GetComponent("Text")
    self.btnStartCoin = transform:Find("ResourceUI/StarCoin/BtnStartCoin").gameObject
    self.txtGas = transform:Find("ResourceUI/Gas/TxtGas"):GetComponent("Text")
    self.btnGas = transform:Find("ResourceUI/Gas/BtnGas").gameObject
    self.txtTitanium = transform:Find("ResourceUI/Titanium/TxtTitanium"):GetComponent("Text")
    self.btnTitanium = transform:Find("ResourceUI/Titanium/BtnTitanium").gameObject
    self.txtIce = transform:Find("ResourceUI/Ice/TxtIce"):GetComponent("Text")
    self.btnIce = transform:Find("ResourceUI/Ice/BtnIce").gameObject
    self.txtCarboxyl = transform:Find("ResourceUI/Carboxyl/TxtCarboxyl"):GetComponent("Text")
    self.btnCarboxyl = transform:Find("ResourceUI/Carboxyl/BtnCarboxyl").gameObject
    self.btnLevel = transform:Find("PlayerInformation/BtnLevel").gameObject
    self.btnPlayerName = transform:Find("PlayerInformation/BtnPlayerName").gameObject
    self.txtPlayerName = transform:Find("PlayerInformation/BtnPlayerName/TxtPlayerName"):GetComponent("Text")
    self.btnPvpScore = transform:Find("PlayerInformation/BtnPvpScore").gameObject
    self.txtPvpScore = transform:Find("PlayerInformation/BtnPvpScore/TxtPvpScore"):GetComponent("Text")

    self.bgLevel = transform:Find("PlayerInformation/BgLevel").gameObject
    self.bgLevelHighlighted = transform:Find("PlayerInformation/BgLevelHighlighted").gameObject

    self.bgMit = transform:Find("ResourceUI/Mit/BgMit").gameObject
    self.bgMitHighlighted = transform:Find("ResourceUI/Mit/BgMitHighlighted").gameObject

    self.bgStarCoin = transform:Find("ResourceUI/StarCoin/BgStarCoin").gameObject
    self.bgStarCoinHighlighted = transform:Find("ResourceUI/StarCoin/BgStarCoinHighlighted").gameObject

    self.bgGas = transform:Find("ResourceUI/Gas/BgGas").gameObject
    self.bgGasHighlighted = transform:Find("ResourceUI/Gas/BgGasHighlighted").gameObject

    self.bgTitanium = transform:Find("ResourceUI/Titanium/BgTitanium").gameObject
    self.bgTitaniumHighlighted = transform:Find("ResourceUI/Titanium/BgTitaniumHighlighted").gameObject

    self.bgIce = transform:Find("ResourceUI/Ice/BgIce").gameObject
    self.bgIceHighlighted = transform:Find("ResourceUI/Ice/BgIceHighlighted").gameObject

    self.bgCarboxyl = transform:Find("ResourceUI/Carboxyl/BgCarboxyl").gameObject
    self.bgCarboxylHighlighted = transform:Find("ResourceUI/Carboxyl/BgCarboxylHighlighted").gameObject
end

return PnlPlayerInformationView