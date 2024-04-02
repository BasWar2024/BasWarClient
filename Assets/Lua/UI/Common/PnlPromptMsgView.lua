
PnlPromptMsgView = class("PnlPromptMsgView")

PnlPromptMsgView.ctor = function(self, transform)

    self.transform = transform

    self.txtTips = transform:Find("Image/TxtTips"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlPromptMsgView