PnlUpgradeView = class("PnlUpgradeView")

PnlUpgradeView.ctor = function(self, transform)

    self.transform = transform

    self.btnReturn = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtName = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.commonItemItem = CommonItemItem.new(transform:Find("CommonItemItem"))
    self.attrScrollView = transform:Find("AttrScrollView").gameObject
    self.commonUpgradeNewBox = ggclass.CommonUpgradeNewBox.new(transform:Find("CommonUpgradeNewBox").gameObject)

    self.txtDesc = transform:Find("TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)

    self.boxArrowUpgrade = transform:Find("BoxArrowUpgrade").gameObject
    self.levelMax = transform:Find("BoxArrowUpgrade/LevelMax").gameObject
    self.levelUpgrade = transform:Find("BoxArrowUpgrade/LevelUpgrade").gameObject

    self.txtCurLevle = transform:Find("BoxArrowUpgrade/LevelUpgrade/TxtCurLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNextLevel = transform:Find("BoxArrowUpgrade/LevelUpgrade/TxtNextLevel/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMaxLevel = transform:Find("BoxArrowUpgrade/LevelMax/TxtMaxLevel"):GetComponent(UNITYENGINE_UI_TEXT)

end

return PnlUpgradeView
