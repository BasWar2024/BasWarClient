
PnlBoardView = class("PnlBoardView")

PnlBoardView.ctor = function(self, transform)
    self.transform = transform
    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.newsScrollView = transform:Find("Root/NewsScrollView")
    self.newsCountScrollView = transform:Find("Root/NewsCountScrollView")
    self.newsContent = transform:Find("Root/NewsScrollView/Viewport/Content")
    self.btnOpenView = transform:Find("Root/BtnOpenView").gameObject

    self.btnLeft = transform:Find("Root/BtnLeft").gameObject
    self.btnRight = transform:Find("Root/BtnRight").gameObject
end

return PnlBoardView