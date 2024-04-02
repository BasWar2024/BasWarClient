
PnlMailView = class("PnlMailView")

PnlMailView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnDelAll = transform:Find("BtnDelAll").gameObject
    self.btnGetAll = transform:Find("BtnGetAll").gameObject

    self.layoutMail = transform:Find("LayoutMail")
    self.bgContent = transform:Find("LayoutMail/ContentScrollView/Viewport/BgContent")
    self.bgMail = self.bgContent:Find("Mail")

    self.layoutMailTop = self.bgMail:Find("LayoutMailTop")
    self.txtMailTitle = self.layoutMailTop:Find("BgTitle/TxtMailTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMailSender = self.layoutMailTop:Find("TxtMailSender"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMailDate = self.layoutMailTop:Find("TxtMailDate"):GetComponent(UNITYENGINE_UI_TEXT)
    
    self.txtMailContent = self.bgMail:Find("TxtMailContent"):GetComponent(UNITYENGINE_UI_TEXT)
    

    self.layoutMailBottom = self.bgMail:Find("LayoutMailBottom")
    self.txtTips = self.layoutMailBottom:Find("TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.mailRewardScrollView = self.layoutMailBottom:Find("ScrollView")
    self.mailReceiveContent = self.layoutMailBottom:Find("ScrollView/Viewport/Content")
    self.btnReceive = self.layoutMailBottom:Find("BtnReceive").gameObject
    self.txtReceivedTips = self.layoutMailBottom:Find("TxtReceivedTips"):GetComponent(UNITYENGINE_UI_TEXT)


    self.btnDel = transform:Find("LayoutMail/BtnDel").gameObject
    

    self.txtNoContent = self.bgContent:Find("TxtNoContent")

    self.txtNoMail = transform:Find("ScrollView/TxtNoMail")
    self.scrollViewContent = transform:Find("ScrollView/Viewport/Content").gameObject
end

return PnlMailView