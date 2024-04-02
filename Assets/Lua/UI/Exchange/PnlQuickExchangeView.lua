
PnlQuickExchangeView = class("PnlQuickExchangeView")

PnlQuickExchangeView.ctor = function(self, transform)
    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.root = transform:Find("Root")

    self.txtDesc = transform:Find("Root/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.layoutRes1 = transform:Find("Root/LayoutRes1")
    self.layoutRes2 = transform:Find("Root/LayoutRes2")

    self.resItemList = {}
    for i = 1, self.layoutRes1.childCount do
        local item = self.layoutRes1:GetChild(i - 1)
        table.insert(self.resItemList, self:getResItem(item))
    end

    for i = 1, self.layoutRes2.childCount, 1 do
        local item = self.layoutRes2:GetChild(i - 1)
        table.insert(self.resItemList, self:getResItem(item))
    end

    self.commonUpgradePart = transform:Find("Root/CommonUpgradePart")
end

function PnlQuickExchangeView:getResItem(obj)
    local item = {}
    item.gameObject = obj.gameObject
    item.transform = obj.transform
    item.icon = item.transform:Find("ResIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.text = item.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    return item
end

return PnlQuickExchangeView