PnlConnectView = class("PnlConnectView")

PnlConnectView.ctor = function(self, transform)
    self.transform = transform
    self.layoutMain = transform:Find("LayoutMain")
    self.imgMainPoint = transform:Find("LayoutMain/ImgPoint")
    self.imgTipsText = transform:Find("LayoutMain/ImgTips"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("LayoutMain/BtnClose").gameObject

    self.layoutBattle = transform:Find("LayoutBattle")
    self.imgBattlePoint = transform:Find("LayoutBattle/ImgPoint")
    self.imgBattleBg = transform:Find("LayoutBattle/Bg")

end

return PnlConnectView