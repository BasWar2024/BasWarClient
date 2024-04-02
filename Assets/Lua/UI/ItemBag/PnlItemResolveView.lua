
PnlItemResolveView = class("PnlItemResolveView")

PnlItemResolveView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtNum = transform:Find("Root/BoxScrollbar/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnReduce = transform:Find("Root/BoxScrollbar/BtnReduce").gameObject
    self.btnIncrease = transform:Find("Root/BoxScrollbar/BtnIncrease").gameObject
    self.btnDetermine = transform:Find("Root/BoxScrollbar/BtnDetermine").gameObject
    self.txtItemNum = transform:Find("Root/TxtItemNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtItemName = transform:Find("Root/TxtItemName"):GetComponent(UNITYENGINE_UI_TEXT)

    self.iconBg = transform:Find("Root/IconBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconItem = transform:Find("Root/IconBg/IconItem"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.Scrollbar = transform:Find("Root/BoxScrollbar/Scrollbar"):GetComponent(UNITYENGINE_UI_SCROLLBAR)

end

return PnlItemResolveView