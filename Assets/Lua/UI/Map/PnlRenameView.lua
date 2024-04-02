
PnlRenameView = class("PnlRenameView")

PnlRenameView.ctor = function(self, transform)

    self.transform = transform

    self.txtRenameTitel = transform:Find("TxtRenameTitel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.inputField = transform:Find("InputField"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.txtPlaceholder = transform:Find("InputField/TxtPlaceholder"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNewName = transform:Find("InputField/TxtNewName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnCancel = transform:Find("BtnCancel").gameObject
    self.txtCancel = transform:Find("BtnCancel/TxtCancel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnConfirm = transform:Find("BtnConfirm").gameObject
    self.txtCanfirm = transform:Find("BtnConfirm/TxtCanfirm"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlRenameView