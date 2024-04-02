
PnlAcquisitionView = class("PnlAcquisitionView")

PnlAcquisitionView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDetermine = transform:Find("VIew/BtnDetermine").gameObject

    self.content = transform:Find("VIew/ScrollView/Viewport/Content")
end

return PnlAcquisitionView