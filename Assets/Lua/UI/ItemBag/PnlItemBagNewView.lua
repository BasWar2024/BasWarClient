
PnlItemBagNewView = class("PnlItemBagNewView")

PnlItemBagNewView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject

    self.LeftBtnViewBgBtnsBox = transform:Find("Root/LeftBtnViewBgBtnsBox")
    self.txtSortType = transform:Find("Root/LayoutSort/TxtSortType"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnSelectSort = transform:Find("Root/LayoutSort/BtnSelectSort").gameObject
    self.imgSort = self.btnSelectSort.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtFilter = transform:Find("Root/LayoutFilter/TxtFilter"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnOpenFilter = transform:Find("Root/LayoutFilter/BtnOpenFilter").gameObject

    self.txtSpace = transform:Find("Root/LayoutSpace/TxtSpace"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgAlertSpace = transform:Find("Root/LayoutSpace/TxtSpace/ImgAlertSpace"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.btnAddSpace = transform:Find("Root/LayoutSpace/BtnAddSpace").gameObject
    self.sliderSpace = transform:Find("Root/LayoutSpace/SliderSpace"):GetComponent(UNITYENGINE_UI_SLIDER)

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.iconBg = transform:Find("Root/LayoutInfo/IconBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgIcon = transform:Find("Root/LayoutInfo/IconBg/Mask/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgNameQuality = transform:Find("Root/LayoutInfo/ImgNameQuality"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("Root/LayoutInfo/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLevel = transform:Find("Root/LayoutInfo/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNum = transform:Find("Root/LayoutInfo/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutSubInfo = transform:Find("Root/LayoutInfo/LayoutSubInfo")
    self.subInfoLife = self.layoutSubInfo:Find("SubInfoLife")
    self.sliderLife = self.subInfoLife:Find("SliderLife"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtLife = self.subInfoLife:Find("TxtLife"):GetComponent(UNITYENGINE_UI_TEXT)

    self.subInfoList = {}
    for i = 1, 2 do
        self.subInfoList[i] = {}
        self.subInfoList[i].transform = self.layoutSubInfo:Find("Info" .. i)
        self.subInfoList[i].txtTitle = self.subInfoList[i].transform:Find("TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
        self.subInfoList[i].txtInfo = self.subInfoList[i].transform:Find("TxtInfo"):GetComponent(UNITYENGINE_UI_TEXT)
    end
    self.txtDesc = transform:Find("Root/LayoutInfo/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnDestroy = transform:Find("Root/LayoutInfo/BtnDestroy").gameObject
    self.btnUse = transform:Find("Root/LayoutInfo/LayoutButton/BtnUse").gameObject
    self.btnResolve = transform:Find("Root/LayoutInfo/LayoutButton/BtnResolve").gameObject

    self.itemScrollView = transform:Find("Root/ItemScrollView").gameObject

    self.BtnItemTypeList = {}
    self.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_NFT_ITEM] = transform:Find("Root/LayoutLeft/BtnItemType1").gameObject
    self.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_DAO_ITEM] = transform:Find("Root/LayoutLeft/BtnItemType2").gameObject
    self.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_PROP] = transform:Find("Root/LayoutLeft/BtnItemType3").gameObject
    self.BtnItemTypeList[PnlItemBagNew.FILTER_TYPE_SKILL_PIECES] = transform:Find("Root/LayoutLeft/BtnItemType4").gameObject

    self.NoItem = transform:Find("Root/NoItem").gameObject
    self.TxtNoItem = transform:Find("Root/NoItem/TxtNoItem"):GetComponent(UNITYENGINE_UI_TEXT)

end

return PnlItemBagNewView