
PnlStarMapItemBagView = class("PnlStarMapItemBagView")

PnlStarMapItemBagView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgIcon = transform:Find("Root/LayoutInfo/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgNameQuality = transform:Find("Root/LayoutInfo/ImgNameQuality"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("Root/LayoutInfo/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLevel = transform:Find("Root/LayoutInfo/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTitle = transform:Find("Root/LayoutInfo/LayoutSubInfo/Info1/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgLine = transform:Find("Root/LayoutInfo/LayoutSubInfo/Info1/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtInfo = transform:Find("Root/LayoutInfo/LayoutSubInfo/Info1/TxtInfo"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTitle = transform:Find("Root/LayoutInfo/LayoutSubInfo/Info2/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgLine = transform:Find("Root/LayoutInfo/LayoutSubInfo/Info2/ImgLine"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtInfo = transform:Find("Root/LayoutInfo/LayoutSubInfo/Info2/TxtInfo"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLife = transform:Find("Root/LayoutInfo/LayoutSubInfo/SubInfoLife/TxtLife"):GetComponent(UNITYENGINE_UI_TEXT)
    self.sliderLife = transform:Find("Root/LayoutInfo/LayoutSubInfo/SubInfoLife/SliderLife"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.btnDestroy = transform:Find("Root/LayoutInfo/BtnDestroy").gameObject
    self.btnUse = transform:Find("Root/LayoutInfo/BtnUse").gameObject

    self.scrollView = transform:Find("Root/ScrollView").gameObject
end

return PnlStarMapItemBagView