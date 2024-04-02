
PnlCardView = class("PnlCardView")

PnlCardView.ctor = function(self, transform)

    
    self.transform = transform

    self.root = transform:Find("Root")

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnGetCard = transform:Find("Root/BtnGetCard").gameObject
    
    self.layoutCardGroup = transform:Find("Root/LayoutCardGroup")

    self.atkScrollView = self.layoutCardGroup:Find("AtkScrollView")
    self.defScrollView = self.layoutCardGroup:Find("DefScrollView")

    self.cardGroupEditBox = transform:Find("CardGroupEditBox")

    self.drawCardBox = transform:Find("DrawCardBox")
end

return PnlCardView