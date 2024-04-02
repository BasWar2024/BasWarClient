
PnlGridItemBagView = class("PnlGridItemBagView")

PnlGridItemBagView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewItem/BtnClose").gameObject
    self.imgRace = transform:Find("ViewItem/BgInfo/BoxInfo/ImgRace"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgBg = transform:Find("ViewItem/BgInfo/BoxInfo/BgIcon/ImgBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgBuild = transform:Find("ViewItem/BgInfo/BoxInfo/BgIcon/ImgBg/Mask/ImgBuild"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtBuildName = transform:Find("ViewItem/BgInfo/BoxInfo/TxtBuildName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBuildLv = transform:Find("ViewItem/BgInfo/BoxInfo/TitelLv/TxtBuildLv"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAttr1 = transform:Find("ViewItem/BgInfo/BoxInfo/AttrScrollView/Viewport/Content/CommonAttrItem1/TxtAttr"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAttr2 = transform:Find("ViewItem/BgInfo/BoxInfo/AttrScrollView/Viewport/Content/CommonAttrItem2/TxtAttr"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAttr3 = transform:Find("ViewItem/BgInfo/BoxInfo/AttrScrollView/Viewport/Content/CommonAttrItem3/TxtAttr"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnUse = transform:Find("ViewItem/BgInfo/BoxInfo/BtnUse").gameObject
    self.btnQuality = transform:Find("ViewItem/BtnQuality").gameObject

    self.content = transform:Find("ViewItem/ScrollView/Viewport/Content")
    self.boxInfo = transform:Find("ViewItem/BgInfo/BoxInfo").gameObject
    self.bgInfo = transform:Find("ViewItem/BgInfo"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.boxCost = transform:Find("ViewItem/BgInfo/BoxInfo/BoxCost").gameObject


    self.txtNoNft = transform:Find("TxtNoNft"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlGridItemBagView