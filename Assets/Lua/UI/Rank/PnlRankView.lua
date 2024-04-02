
PnlRankView = class("PnlRankView")

PnlRankView.ctor = function(self, transform)
    self.transform = transform
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.layouPersonalTitle = transform:Find("Root/LayouPersonalTitle")
    self.layotDaoTitle = transform:Find("Root/LayotDaoTitle")

    -- self.tmpDesc = transform:Find("Root/TmpDesc"):GetComponent("TextMeshProUGUI")
    self.loopScrollView = transform:Find("Root/RankScrollView")

    self.btnFetch = transform:Find("Root/LayoutBottom/BtnFetch").gameObject
    self.TextReward = self.btnFetch.transform:Find("TextReward"):GetComponent(UNITYENGINE_UI_TEXT)

    self.rankItem = transform:Find("Root/LayoutBottom/RankItem").gameObject

    self.leftBtnViewBgBtnsBox = LeftBtnViewBgBtnsBox.new(transform:Find("Root/LeftBtnViewBgBtnsBox"))
    self.txtDesc = transform:Find("Root/TextDesc"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlRankView