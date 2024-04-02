PnlPlayerDetailedView = class("PnlPlayerDetailedView")

PnlPlayerDetailedView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("BtnClose").gameObject

    self.txtName = transform:Find("Root/BgHead/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnShareName = transform:Find("Root/BgHead/BtnShareName").gameObject

    self.btnSetName = transform:Find("Root/BgHead/BtnSetName").gameObject
    self.txtMedal = transform:Find("Root/BgHead/TxtMedal"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtId = transform:Find("Root/TxtId"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnShare = transform:Find("Root/BtnShare").gameObject

    self.txtInvitCode = transform:Find("Root/TxtInvitCode"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnShareCode = transform:Find("Root/BtnShareCode").gameObject

    self.txtInvitUrl = transform:Find("Root/TxtInvitUrl"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnShareInvitUrl = transform:Find("Root/BtnShareInvitUrl").gameObject


    self.btnVip = transform:Find("Root/BgHead/BtnVip")
    self.txtVip = transform:Find("Root/BgHead/BtnVip/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnHead = transform:Find("Root/BgHead/BtnHead").gameObject
    self.imgHead = transform:Find("Root/BgHead/Mask/ImgHead"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgChain = transform:Find("Root/BgHead/ImgChain"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.bgContent = transform:Find("Root/BgContent")
    self.txtContent = self.bgContent:Find("TxtContent"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputContent = self.bgContent:Find("InputContent"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtContentInputCount = self.inputContent.transform:Find("TxtContentInputCount"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutDao = transform:Find("Root/LayoutDao")
    self.imgDao = transform:Find("Root/LayoutDao/ImgDao"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtDaoName = transform:Find("Root/LayoutDao/TxtDaoName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDaoId = transform:Find("Root/LayoutDao/TxtDaoId"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutDaoInvite = transform:Find("Root/LayoutDaoInvite")
    self.toggleDaoInvite = self.layoutDaoInvite:Find("ToggleDaoInvite"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.imgDaoInviteSelect = self.toggleDaoInvite.transform:Find("Background/ImgSelect")

    self.layoutDaoVisit = transform:Find("Root/LayoutDaoVisit")
    self.toggleVisit = self.layoutDaoVisit:Find("ToggleVisit"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.imgDaoVisitSelect = self.toggleVisit.transform:Find("Background/ImgSelect")

    self.PlayerDetailedSelectHeadBox = transform:Find("PlayerDetailedSelectHeadBox")
end

return PnlPlayerDetailedView
