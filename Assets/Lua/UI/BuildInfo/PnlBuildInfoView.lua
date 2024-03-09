
PnlBuildInfoView = class("PnlBuildInfoView")

PnlBuildInfoView.ctor = function(self, transform)
    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent("Text")
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtLevel = transform:Find("Root/LayoutTitle/TxtLevel"):GetComponent("Text")
    self.txtName = transform:Find("Root/LayoutTitle/TxtName"):GetComponent("Text")
    self.imgEnoughtUpgrade = transform:Find("Root/LayoutTitle/ImgEnoughtUpgrade"):GetComponent("Image")

    self.txtAlert = transform:Find("Root/TxtAlert"):GetComponent("Text")

    self.imgBuild = transform:Find("Root/bgBuild/ImgBuild"):GetComponent("Image")
    self.scRectAttr = transform:Find("Root/scRectAttr"):GetComponent("ScrollRect")
    
    self.LayoutInfo = transform:Find("Root/LayoutInfo").gameObject
    self.txtDesc = transform:Find("Root/LayoutInfo/TxtDesc"):GetComponent("Text")
    self.txtAlertUnlock = transform:Find("Root/LayoutInfo/TxtAlertUnlock"):GetComponent("Text")

    self.layoutUpgrade = transform:Find("Root/LayoutUpgrade").gameObject
    self.layoutPledge = self.layoutUpgrade.transform:Find("LayoutPledge").gameObject
    self.btnPledge = self.layoutPledge.transform:Find("BtnPledge").gameObject
    self.btnTakeOut = self.layoutPledge.transform:Find("BtnTakeOut").gameObject

    self.LayoutUnlockTechnology = self.layoutUpgrade.transform:Find("LayoutUnlockTechnology")
    self.LayoutTechnologys = self.LayoutUnlockTechnology:Find("LayoutTechnologys")
    self.buildInfoTechnoItemList = {}
    for i = 1, 4 do
        table.insert(self.buildInfoTechnoItemList, BuildInfoTechnoItem.new(self.LayoutTechnologys:GetChild(i - 1)))
    end
    
    self.commonUpgradeBox = ggclass.CommonUpgradeBox.new(transform:Find("Root/LayoutUpgrade/CommonUpgradeBox").gameObject)
end

return PnlBuildInfoView