
PnlMapView = class("PnlMapView")

PnlMapView.ctor = function(self, transform)

    self.transform = transform

    self.btnBattleReport = transform:Find("BtnBattleReport").gameObject
    self.btnResInfor = transform:Find("BtnResInfor").gameObject
    self.btnReturn = transform:Find("BtnReturn").gameObject
    self.btnReplenish = transform:Find("BtnReplenish").gameObject
    self.btnSoldier1 = transform:Find("BgSoldier/BtnSoldier1").gameObject
    self.btnSoldier2 = transform:Find("BgSoldier/BtnSoldier2").gameObject
    self.btnSoldier3 = transform:Find("BgSoldier/BtnSoldier3").gameObject
    self.btnSoldier4 = transform:Find("BgSoldier/BtnSoldier4").gameObject
    self.btnSoldier5 = transform:Find("BgSoldier/BtnSoldier5").gameObject
    self.btnSoldier6 = transform:Find("BgSoldier/BtnSoldier6").gameObject
    self.btnSoldier7 = transform:Find("BgSoldier/BtnSoldier7").gameObject
    self.btnSoldier8 = transform:Find("BgSoldier/BtnSoldier8").gameObject
    self.txtTitle = transform:Find("BgSoldier/BgTitle/TxtTitle"):GetComponent("Text")
end

return PnlMapView