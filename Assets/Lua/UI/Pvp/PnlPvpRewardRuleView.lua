
PnlPvpRewardRuleView = class("PnlPvpRewardRuleView")

PnlPvpRewardRuleView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.leftBtnViewBgBtnsBox = transform:Find("Root/LeftBtnViewBgBtnsBox")

    self.layoutHydRule = transform:Find("Root/LayoutHydRule")
    self.danGroup = self.layoutHydRule:Find("DanGroup")

    self.boxRewardList = {}
    for i = 1, 6, 1 do
        local box = self.danGroup:GetChild(i - 1)
        self.boxRewardList[i] = box
    end

    self.layoutMitRule = transform:Find("Root/LayoutMitRule")
    self.ruleScrollView = self.layoutMitRule:Find("RuleScrollView")

    self.layoutDescRule = transform:Find("Root/LayoutDescRule")
end

return PnlPvpRewardRuleView