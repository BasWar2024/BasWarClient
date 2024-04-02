
PnlPvpFetchView = class("PnlPvpFetchView")

PnlPvpFetchView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.btnConfirm = transform:Find("Root/BtnConfirm").gameObject

    self.layoutRes = transform:Find("Root/LayoutRes")

    self.resItemMap = {}
    for i = 1, self.layoutRes.childCount do
        local item = self.layoutRes:GetChild(i - 1)
        self.resItemMap[constant[item.name]] = {}
        self.resItemMap[constant[item.name]].text = item:GetComponent(UNITYENGINE_UI_TEXT)
        self.resItemMap[constant[item.name]].icon = item:Find("ResIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
    end
end

return PnlPvpFetchView