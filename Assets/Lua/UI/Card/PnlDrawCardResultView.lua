
PnlDrawCardResultView = class("PnlDrawCardResultView")

PnlDrawCardResultView.ctor = function(self, transform)
    self.transform = transform
    self.layoutCardMore = transform:Find("Root/LayoutCardMore")
    self.layoutRes = transform:Find("Root/LayoutRes")


    self.resMap = {}

    for i = 1, self.layoutRes.childCount, 1 do
        local item = {}
        local itemTrans = self.layoutRes:GetChild(i - 1)
        item.transform = itemTrans
        self.resMap[constant[itemTrans.name]] = item

        item.txtCount = itemTrans:Find("TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)
    end
end

return PnlDrawCardResultView