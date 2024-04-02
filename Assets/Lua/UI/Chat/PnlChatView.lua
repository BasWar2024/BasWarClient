
PnlChatView = class("PnlChatView")

PnlChatView.ctor = function(self, transform)

    self.transform = transform

    self.btnSend = transform:Find("Root/LayoutBottom/BtnSend").gameObject
    self.btnPlus = transform:Find("Root/LayoutBottom/BtnPlus").gameObject
    self.inputChat = transform:Find("Root/LayoutBottom/InputChat"):GetComponent(UNITYENGINE_UI_INPUTFIELD)

    self.channelScrollView = transform:Find("Root/ChannelScrollView")

    self.layoutScrollView = transform:Find("Root/LayoutScrollView")
    self.scrollView = self.layoutScrollView:Find("ScrollView")

    self.btnClose = transform:Find("Root/BtnClose").gameObject

    self.chatItem = ChatItem.new(transform:Find("Root/ChatItem"))
end

return PnlChatView