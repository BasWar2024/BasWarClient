
PnlNewPlayerLoginActView = class("PnlNewPlayerLoginActView")

PnlNewPlayerLoginActView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject
    self.txtEndTime = transform:Find("Root/TxtEndTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTime = transform:Find("Root/TxtEndTime/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDesc = transform:Find("Root/TxtEndTime/TxtTime/BtnDesc").gameObject
    self.btnUnlock = transform:Find("Root/BtnUnlock").gameObject
    self.imgLock = transform:Find("Root/ImgLock"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.scrollView = transform:Find("Root/ScrollView")
end

return PnlNewPlayerLoginActView