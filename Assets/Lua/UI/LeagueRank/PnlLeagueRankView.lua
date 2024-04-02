
PnlLeagueRankView = class("PnlLeagueRankView")

PnlLeagueRankView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDesc = self.txtTitle.transform:Find("BtnDesc").gameObject

    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.txtTime = transform:Find("Root/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtRewardTime = transform:Find("Root/TxtRewardTime"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnRankReward = transform:Find("Root/BtnRankReward").gameObject
    self.btnCoreReward = transform:Find("Root/BtnCoreReward").gameObject

    self.rankScrollView = transform:Find("Root/RankScrollView")
    self.leagueRankItem = transform:Find("Root/LeagueRankItem")

    self.leftButtonView = transform:Find("Root/LeftButtonView")

    self.txtJackpotNum = {}
    for i = 1, 8, 1 do
        local path = "Root/BgJackpot/TxtNum" .. i
        table.insert(self.txtJackpotNum, transform:Find(path):GetComponent(UNITYENGINE_UI_TEXT))
    end

    self.bgJackpot = transform:Find("Root/BgJackpot").gameObject

    -- self.txt1 = transform:Find("Root/BgTop/LayotTitles/Txt1"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.txt2 = transform:Find("Root/BgTop/LayotTitles/Txt2"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.txt3 = transform:Find("Root/BgTop/LayotTitles/Txt3"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.txt4 = transform:Find("Root/BgTop/LayotTitles/Txt4"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.txt5 = transform:Find("Root/BgTop/LayotTitles/Txt5"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlLeagueRankView