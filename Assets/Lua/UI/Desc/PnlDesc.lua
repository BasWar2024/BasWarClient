

PnlDesc = class("PnlDesc", ggclass.UIBase)

function PnlDesc:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlDesc:onAwake()
    self.view = ggclass.PnlDescView.new(self.pnlTransform)

end

-- args = {title = , desc = }
function PnlDesc:onShow()
    self:bindEvent()
    self.view.txtTitle.text = self.args.title
    self.view.txtDesc.text = self.args.desc
end

function PnlDesc:onHide()
    self:releaseEvent()

end

function PnlDesc:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlDesc:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlDesc:onDestroy()
    local view = self.view

end

function PnlDesc:onBtnClose()
    self:close()
end

return PnlDesc