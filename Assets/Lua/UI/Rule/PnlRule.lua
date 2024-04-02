

PnlRule = class("PnlRule", ggclass.UIBase)

function PnlRule:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlRule:onAwake()
    self.view = ggclass.PnlRuleView.new(self.pnlTransform)

end

-- args = {title = ,content = }
function PnlRule:onShow()
    self:bindEvent()

    local view = self.view

    view.txtTitle.text = self.args.title
    view.txtContent.text = self.args.content
    view.content.transform:SetRectSizeY(math.max(view.scrollView.rect.height + 1, view.txtContent.preferredHeight))
end

function PnlRule:onHide()
    self:releaseEvent()

end

function PnlRule:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlRule:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlRule:onDestroy()
    local view = self.view

end

function PnlRule:onBtnClose()
    self:close()
end

return PnlRule