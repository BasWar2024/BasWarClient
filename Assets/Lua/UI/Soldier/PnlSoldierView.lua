
PnlSoldierView = class("PnlSoldierView")

PnlSoldierView.ctor = function(self, transform)

    self.transform = transform

    self.viewBg = transform:Find("ViewBg")

    self.txtTitle = transform:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("BtnClose").gameObject

    self.txtCurNum = transform:Find("ViewSoldier/BoxChangeSoldier/BgTxtNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)

    self.curCommonItemItemD1 = CommonItemItemD1.new(transform:Find("ViewSoldier/BoxChangeSoldier/CommonItemItemD1"))

    self.txtTip2 = transform:Find("ViewSoldier/BoxChangeSoldier/BgTip/TxtTip2"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnChange = transform:Find("ViewSoldier/BoxChangeSoldier/BtnChange").gameObject

    self.boxTool = transform:Find("ViewSoldier/BoxTool").gameObject
    self.toolCommonItemItemD1 = CommonItemItemD1.new(transform:Find("ViewSoldier/BoxTool/CommonItemItemD1"))
    self.txtToolNum = transform:Find("ViewSoldier/BoxTool/BgTxtNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnTool = transform:Find("ViewSoldier/BoxTool/BtnChange").gameObject

    self.layoutTool = transform:Find("ViewSoldier/LayoutTool")
    self.txtCost = self.layoutTool:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconCost = self.txtCost.transform:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.slider = self.layoutTool:Find("Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtSlider = self.slider.transform:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)

    self.txtTime = self.layoutTool:Find("TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    
    self.viewSoldier = transform:Find("ViewSoldier").gameObject
    self.viewChange = transform:Find("ViewChange").gameObject
    self.viewContent = transform:Find("ViewChange/Viewport/ViewContent")
end

return PnlSoldierView