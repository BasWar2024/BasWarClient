
PnlAlertView = class("PnlAlertView")

PnlAlertView.ctor = function(self, transform)

    self.transform = transform

    self.root = transform:Find("Root")
    self.btnYes = transform:Find("Root/LayoutBtns/BtnYes").gameObject
    self.btnYesGuideInstead = self.btnYes.transform:Find("btnYesGuideInstead")
    
    self.txtBtnYes = self.btnYes.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutResCost = self.btnYes.transform:Find("LayoutResCost")
    self.yesCostItemList = {}
    for i = 1, self.layoutResCost.childCount do
        local item = {}
        local trans = self.layoutResCost:GetChild(i - 1)
        item.transform = trans
        item.text = trans:GetComponent(UNITYENGINE_UI_TEXT)
        item.image = trans:Find("IconCost"):GetComponent(UNITYENGINE_UI_IMAGE)
        table.insert(self.yesCostItemList, item)
    end

    self.btnNo = transform:Find("Root/LayoutBtns/BtnNo").gameObject
    self.txtBtnNo = self.btnNo.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("Root/BtnClose").gameObject
    self.txtTip = transform:Find("Root/TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)

    self.toggle = transform:Find("Root/Toggle"):GetComponent(UNITYENGINE_UI_TOGGLE)
    self.txtToggle = self.toggle.transform:Find("Label"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTitle = transform:Find("Root/Bg3/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTime = transform:Find("Root/LayoutBtns/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.slider = transform:Find("Root/Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtSlider = self.slider.transform:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)

    self.bgList = {}
    for i = 1, 4 do
        self.bgList[i] = transform:Find("Root/Bg" .. i)
    end

    self.txtAlertLable = transform:Find("Root/Label")
    self.toggleAlertTesCost = transform:Find("Root/Label/ToggleAlertTesCost"):GetComponent(UNITYENGINE_UI_TOGGLE)
end

return PnlAlertView