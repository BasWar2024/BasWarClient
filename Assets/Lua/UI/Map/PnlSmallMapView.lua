PnlSmallMapView = class("PnlSmallMapView")

PnlSmallMapView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject
    self.boxGridData = transform:Find("ViewMsg/BoxGridData").gameObject
    self.iconRes = transform:Find("ViewMsg/BoxGridData/Res/IconRes"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("ViewMsg/BoxGridData/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPos = transform:Find("ViewMsg/BoxGridData/TxtPos"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtGuild = transform:Find("ViewMsg/BoxGridData/Guild/TxtGuild"):GetComponent(UNITYENGINE_UI_TEXT)
    self.state = transform:Find("ViewMsg/BoxGridData/State").gameObject
    self.bgRed = transform:Find("ViewMsg/BoxGridData/State/BgRed").gameObject
    self.bgblue = transform:Find("ViewMsg/BoxGridData/State/Bgblue").gameObject
    self.red = transform:Find("ViewMsg/BoxGridData/State/TitelState/Rad").gameObject
    self.blue = transform:Find("ViewMsg/BoxGridData/State/TitelState/Blue").gameObject

    self.btnStar = transform:Find("ViewMsg/BtnStar").gameObject
    self.btnMark = transform:Find("ViewMsg/BtnMark").gameObject
    self.gridPosMsg = transform:Find("ViewMsg/GridPosMsg").gameObject
    self.txtPosX = transform:Find("ViewMsg/GridPosMsg/PosX/TxtPosX"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtX = transform:Find("ViewMsg/GridPosMsg/PosX/TxtPosX/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtPosY = transform:Find("ViewMsg/GridPosMsg/PosY/TxtPosY"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtY = transform:Find("ViewMsg/GridPosMsg/PosY/TxtPosY/Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnGo = transform:Find("ViewMsg/BtnGo").gameObject
    self.content = transform:Find("ViewMsg/BoxGridsScrollView/Viewport/Content")

    self.starList = transform:Find("ViewMap/StarList").gameObject

    self.initGrid = transform:Find("ViewMap/InitGrid").gameObject
    self.selGrid = transform:Find("ViewMap/SelGrid").gameObject

end

return PnlSmallMapView
