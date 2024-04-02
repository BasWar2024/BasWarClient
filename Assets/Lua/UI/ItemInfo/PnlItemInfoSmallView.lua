
PnlItemInfoSmallView = class("PnlItemInfoSmallView")

PnlItemInfoSmallView.ctor = function(self, transform)

    self.transform = transform

    -- self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    -- self.imgBg = transform:Find("Root/ActivityRewardItem/CommonNormalItem/ImgBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    -- self.imgIcon = transform:Find("Root/ActivityRewardItem/CommonNormalItem/Mask/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtTitle = transform:Find("Root/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCount = transform:Find("Root/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDesc = transform:Find("Root/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)

    self.commonNormalItem = transform:Find("Root/CommonNormalItem")
end

return PnlItemInfoSmallView