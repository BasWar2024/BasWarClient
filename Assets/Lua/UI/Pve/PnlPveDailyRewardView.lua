
PnlPveDailyRewardView = class("PnlPveDailyRewardView")

PnlPveDailyRewardView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject


    self.rewardScrollView = transform:Find("Root/RewardScrollView").gameObject
end

return PnlPveDailyRewardView