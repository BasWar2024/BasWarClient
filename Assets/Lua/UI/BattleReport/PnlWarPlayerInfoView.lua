
PnlWarPlayerInfoView = class("PnlWarPlayerInfoView")

PnlWarPlayerInfoView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgHp = transform:Find("TotalDamageBg/HpBg/ImgHp"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtHp = transform:Find("TotalDamageBg/HpBg/TxtHp"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCon = transform:Find("TotalDamageBg/TxtCon"):GetComponent(UNITYENGINE_UI_TEXT)

    self.scrollViewMy = transform:Find("ScrollViewMy").gameObject

    self.content = transform:Find("ScrollViewMy/Viewport/Content")

    self.totalDamageBg = transform:Find("TotalDamageBg").gameObject
end

return PnlWarPlayerInfoView