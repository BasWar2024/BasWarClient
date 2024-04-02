
PnlCardpoolMessageView = class("PnlCardpoolMessageView")

PnlCardpoolMessageView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("Root/BtnClose").gameObject
    self.btnProbability = transform:Find("Root/BtnProbability").gameObject

    self.boxProbabilitys = transform:Find("Root/BoxProbabilitys").gameObject

    self.ratioScrollView = transform:Find("Root/BoxProbabilitys/RatioScrollView").gameObject


end

return PnlCardpoolMessageView