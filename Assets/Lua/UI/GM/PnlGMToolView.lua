
PnlGMToolView = class("PnlGMToolView")

PnlGMToolView.ctor = function(self, transform)

    self.transform = transform

    self.txtInput = transform:Find("InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD)

    self.inputField = transform:Find("InputField/Text")
    self.btnSend = transform:Find("BtnSend").gameObject
    self.btnClean = transform:Find("BtnClean").gameObject
    self.btnClose = transform:Find("BtnClose").gameObject
    self.btnAddRes = transform:Find("BtnAddRes").gameObject
    self.outPutText = transform:Find("OutPutView/Viewport/OutPutText")
    self.btnAdjust = transform:Find("BtnAdjust").gameObject

    self.btnEnterEdit = transform:Find("BtnEnterEdit").gameObject

    self.btnOpenList = transform:Find("BtnOpenList").gameObject
    self.buttonList = transform:Find("ButtonList").gameObject
    self.btnGenerateNft = transform:Find("ButtonList/BtnGenerateNft").gameObject
    self.btnFullItem = transform:Find("ButtonList/BtnFullItem").gameObject
    self.btnUnionSolider = transform:Find("ButtonList/BtnUnionSolider").gameObject
    self.btnCostRes = transform:Find("ButtonList/BtnCostRes").gameObject
    self.btnTemp = transform:Find("ButtonList/BtnTemp").gameObject

end

return PnlGMToolView