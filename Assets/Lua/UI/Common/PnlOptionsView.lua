
PnlOptionsView = class("PnlOptionsView")

PnlOptionsView.ctor = function(self, transform)
    self.transform = transform
    self.btnOption = transform:Find("BtnOption").gameObject
    self.options = transform:Find("Options")
    -- self.optionsVerticalLayoutGroup = self.options.transform:GetComponent(CS.UnityEngine.UI.VerticalLayoutGroup)
    self.optionsVerticalLayoutGroup = self.options.transform:GetComponent("VerticalLayoutGroup")
    self.btnClose = transform:Find("BtnClose").gameObject

    self.bgOptions = transform:Find("BgOptions")

    self.bgOptionLeft = self.bgOptions:Find("BgOptionLeft")
    self.bgOptionMid = self.bgOptions:Find("BgOptionMid")
    self.bgOptionRight = self.bgOptions:Find("BgOptionRight")
end

return PnlOptionsView