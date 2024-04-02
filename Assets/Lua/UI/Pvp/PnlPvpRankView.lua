
PnlPvpRankView = class("PnlPvpRankView")

PnlPvpRankView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.rankScrollView = transform:Find("Root/RankScrollView")

    self.pvpRankItem = transform:Find("Root/PvpRankItem")

    self.layoutPlayerInfo = transform:Find("Root/LayoutPlayerInfo")

    self.layoutHead = self.layoutPlayerInfo:Find("LayoutHead")

    self.imgHead =  self.layoutHead:Find("MaskHead/ImgHead"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = self.layoutHead:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDao = self.layoutHead:Find("TxtDao"):GetComponent(UNITYENGINE_UI_TEXT)

    self.imgRank = self.layoutPlayerInfo:Find("ImgRank"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtRank = self.layoutPlayerInfo:Find("TxtRank"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtScore = self.layoutPlayerInfo:Find("BgScore/TxtScore"):GetComponent(UNITYENGINE_UI_TEXT)
    
    self.pvpStageBox = self.layoutPlayerInfo:Find("PvpStageBox")

end

return PnlPvpRankView