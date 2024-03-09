
PnlPromptMsgView = class("PnlPromptMsgView")

PnlPromptMsgView.ctor = function(self, transform)

    self.transform = transform

    self.txtTips = transform:Find("Image/TxtTips"):GetComponent("Text")
end

return PnlPromptMsgView