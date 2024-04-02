
PnlUnionArmySelectView = class("PnlUnionArmySelectView")

PnlUnionArmySelectView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.btnUse = transform:Find("Root/LayoutInfo/BtnUse").gameObject

    self.scrollView = transform:Find("Root/ScrollView")

    self.layoutInfo = transform:Find("Root/LayoutInfo")

    self.commonHeroItem = self.layoutInfo:Find("CommonHeroItem")

    self.txtName = self.layoutInfo:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)

    self.attrScrollView = self.layoutInfo:Find("AttrScrollView")

    self.layoutSkills = self.layoutInfo:Find("LayoutSkills")
    
    self.commonfilterBox = transform:Find("Root/CommonfilterBox")
end

return PnlUnionArmySelectView