
PnlMaterialRewardView = class("PnlMaterialRewardView")

PnlMaterialRewardView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnReceive = transform:Find("BgInfo/BtnReceive").gameObject
    
    self.btnCloseViewDetailed = transform:Find("ViewDetailed/ViewBg/Bg/BtnClose").gameObject
    self.txtTitleviewDetailed = transform:Find("ViewDetailed/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPos = transform:Find("ViewDetailed/TxtTitle/TxtPos"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBasic = transform:Find("ViewDetailed/BgOutput/TxtBasic"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTotal = transform:Find("ViewDetailed/BoxInfo/TxtTotal"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMy = transform:Find("ViewDetailed/BoxInfo/TxtMy"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtProfit = transform:Find("ViewDetailed/BoxInfo/TxtProfit"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMyTotal = transform:Find("ViewDetailed/BgMyTotal/TxtMyTotal"):GetComponent(UNITYENGINE_UI_TEXT)

    self.content = transform:Find("ScrollView/Viewport/Content")
    self.viewDetailed = transform:Find("ViewDetailed").gameObject

end

return PnlMaterialRewardView