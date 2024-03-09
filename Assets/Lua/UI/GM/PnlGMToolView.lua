
PnlGMToolView = class("PnlGMToolView")

PnlGMToolView.ctor = function(self, transform)

    self.transform = transform

    self.inputField = transform:Find("InputField/Text")
    self.btnSend = transform:Find("BtnSend").gameObject
    self.btnClean = transform:Find("BtnClean").gameObject
    self.btnClose = transform:Find("BtnClose").gameObject
    self.btnAddRes = transform:Find("BtnAddRes").gameObject
    self.outPutText = transform:Find("OutPutView/Viewport/OutPutText")
    self.btnAdjust = transform:Find("BtnAdjust").gameObject
end

return PnlGMToolView