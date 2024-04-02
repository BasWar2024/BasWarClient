
PnlLeagueRankRewardView = class("PnlLeagueRankRewardView")

PnlLeagueRankRewardView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDesc = self.txtTitle.transform:Find("BtnDesc").gameObject

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txt1 = transform:Find("Root/BgTop/LayotTitles/Txt1"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txt2 = transform:Find("Root/BgTop/LayotTitles/Txt2"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txt3 = transform:Find("Root/BgTop/LayotTitles/Txt3"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnRank = transform:Find("Root/BtnRank").gameObject

    self.rewardScrollView = transform:Find("Root/RewardScrollView")
end

return PnlLeagueRankRewardView