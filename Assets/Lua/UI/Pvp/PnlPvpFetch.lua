

PnlPvpFetch = class("PnlPvpFetch", ggclass.UIBase)

function PnlPvpFetch:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.popup
    self.events = { }
end

function PnlPvpFetch:onAwake()
    self.view = ggclass.PnlPvpFetchView.new(self.pnlTransform)

end

-- args = {rewards = args.rewards, index = 1}
function PnlPvpFetch:onShow()
    self:bindEvent()

    self.view.resItemMap[constant.RES_CARBOXYL].text.text = 0
    self.view.resItemMap[constant.RES_MIT].text.text = 0

    for key, value in pairs(self.args.rewards[self.args.index].reward) do
        if value.resCfgId == constant.RES_MIT then
            self.view.resItemMap[constant.RES_MIT].text.text = Utils.getShowRes(value.count)
        elseif value.resCfgId == constant.RES_CARBOXYL then
            self.view.resItemMap[constant.RES_CARBOXYL].text.text = Utils.getShowRes(value.count)
        end
    end

    self.view.resItemMap[constant.RES_CARBOXYL].text.transform:SetRectSizeX(self.view.resItemMap[constant.RES_CARBOXYL].text.preferredWidth)
    self.view.resItemMap[constant.RES_MIT].text.transform:SetRectSizeX(self.view.resItemMap[constant.RES_MIT].text.preferredWidth)
end

function PnlPvpFetch:onHide()
    self:releaseEvent()

end

function PnlPvpFetch:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
end

function PnlPvpFetch:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnConfirm)
end

function PnlPvpFetch:onDestroy()
    local view = self.view

end

function PnlPvpFetch:onBtnClose()
    self:close()
end

function PnlPvpFetch:close()
    if #self.args.rewards > self.args.index then
        self.args.index = self.args.index + 1
        ggclass.UIBase.close(self)
        gg.uiManager:openWindow("PnlPvpFetch", self.args)
    else
        ggclass.UIBase.close(self)
    end
end

function PnlPvpFetch:onBtnConfirm()
    self:close()
end

return PnlPvpFetch