PnlCollections = class("PnlCollections", ggclass.UIBase)
-- args = {type, name, callback}
function PnlCollections:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onRefreshTxtCollectionNum"}
end

function PnlCollections:onAwake()
    self.view = ggclass.PnlCollectionsView.new(self.pnlTransform)

end

function PnlCollections:onShow()
    self:bindEvent()
    self.collectLimit = 0
    if self.args.type == 1 then
        self.collectLimit = cfg.global.PersonCollectLimit.intValue
    else
        self.collectLimit = cfg.global.GuildCollectLimit.intValue
    end

    self:setTxtCollectionNum("-")
    self.view.inputField.text = self.args.name

    if not GalaxyData.myFavGridsCount or not GalaxyData.unionFavGridCount then
        GalaxyData.C2S_Player_GetMyFavoriteGridList()
    else
        self:onRefreshTxtCollectionNum()
    end
end

function PnlCollections:onRefreshTxtCollectionNum()
    if self.args.type == 1 then
        self:setTxtCollectionNum(GalaxyData.myFavGridsCount)
    else
        self:setTxtCollectionNum(GalaxyData.unionFavGridCount)
    end
end

function PnlCollections:setTxtCollectionNum(num)
    self.view.txtCollectionNum.text = string.format("%s/%s", num, self.collectLimit)
end

function PnlCollections:onHide()
    self:releaseEvent()

end

function PnlCollections:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnCancel):SetOnClick(function()
        self:onBtnCancel()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)

    view.inputField.onValueChanged:AddListener(gg.bind(self.onInputFieldValueChanged, self))
end

function PnlCollections:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnCancel)
    CS.UIEventHandler.Clear(view.btnConfirm)
    view.inputField.onValueChanged:RemoveAllListeners()
end

function PnlCollections:onDestroy()
    local view = self.view

end

function PnlCollections:onBtnCancel()
    self:close()
end

function PnlCollections:onBtnConfirm()
    local num = 0
    if self.args.type == 1 then
        num = GalaxyData.myFavGridsCount
    else
        num = GalaxyData.unionFavGridCount
    end
    if num < self.collectLimit then
        local callback = self.args.callback
        local mark = self.view.inputField.text
        callback(mark)
    end

    self:close()
end

function PnlCollections:onInputFieldValueChanged()
    local text = self.view.inputField.text
    local len = string.len(text)
    if len > 8 then
        local newText = string.sub(text, 1, 8)
        -- len = string.len(newText)
        self.view.inputField.text = newText
    end
end

return PnlCollections
