
PnlSoldierView = class("PnlSoldierView")

PnlSoldierView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent("Text")
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.iconSoldier = transform:Find("ViewSoldier/BoxChangeSoldier/IconBg/IconSoldier"):GetComponent("Image")
    self.txtCurNum = transform:Find("ViewSoldier/BoxChangeSoldier/IconBg/TxtNum"):GetComponent("Text")
    self.txtTip1 = transform:Find("ViewSoldier/BoxChangeSoldier/BgTip/TxtTip1"):GetComponent("Text")
    self.txtTip2 = transform:Find("ViewSoldier/BoxChangeSoldier/BgTip/TxtTip2"):GetComponent("Text")
    self.btnChange = transform:Find("ViewSoldier/BoxChangeSoldier/BtnChange").gameObject

    self.boxTool = transform:Find("ViewSoldier/BoxTool").gameObject
    self.iconToolSoldier = transform:Find("ViewSoldier/BoxTool/IconBg/IconToolSoldier"):GetComponent("Image")
    self.txtToolNum = transform:Find("ViewSoldier/BoxTool/IconBg/TxtToolNum"):GetComponent("Text")
    self.txtToolTip = transform:Find("ViewSoldier/BoxTool/BgTip/TxtToolTip"):GetComponent("Text")
    self.txtTime = transform:Find("ViewSoldier/BoxTool/BgTip/TxtTime"):GetComponent("Text")
    self.btnTool = transform:Find("ViewSoldier/BoxTool/BtnTool").gameObject
    self.txtCost = transform:Find("ViewSoldier/BoxTool/BtnTool/TxtCost"):GetComponent("Text")
    self.iconCost = transform:Find("ViewSoldier/BoxTool/BtnTool/TxtCost/IconCost"):GetComponent("Image")

    self.viewSoldier = transform:Find("ViewSoldier").gameObject
    self.viewChange = transform:Find("ViewChange").gameObject
    self.viewContent = transform:Find("ViewChange/Viewport/ViewContent")
end

return PnlSoldierView