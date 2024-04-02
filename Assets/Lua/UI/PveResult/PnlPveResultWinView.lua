
PnlPveResultWinView = class("PnlPveResultWinView")

PnlPveResultWinView.ctor = function(self, transform)

    self.transform = transform
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject
    self.btnReturnBase = transform:Find("Root/BtnReturnBase").gameObject

    self.pveResultStarBox = transform:Find("Root/PveResultStarBox")

    self.layoutContent = transform:Find("Root/LayoutContent")
    self.firstPveSubRewardBox = self.layoutContent:Find("FirstPveSubRewardBox")
    self.dailyPveSubRewardBox = self.layoutContent:Find("DailyPveSubRewardBox")
    self.battleCasualtiesBox = self.layoutContent:Find("BattleCasualtiesBox")

    self.txtNoReward = self.layoutContent:Find("TxtNoReward"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlPveResultWinView