PnlRename = class("PnlRename", ggclass.UIBase)

PnlRename.VIEW_TYPE = {
    [1] = "Rename",
    [2] = "Remark"
}

function PnlRename:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlRename:onAwake()
    self.view = ggclass.PnlRenameView.new(self.pnlTransform)

end

function PnlRename:onShow()
    self:bindEvent()

    self.view.txtRenameTitel.text = tostring(i18n.format(PnlRename.VIEW_TYPE[self.args.type]))
end

function PnlRename:onHide()
    self:releaseEvent()

end

function PnlRename:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnCancel):SetOnClick(function()
        self:onBtnCancel()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
end

function PnlRename:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnCancel)
    CS.UIEventHandler.Clear(view.btnConfirm)

end

function PnlRename:onDestroy()
    local view = self.view

end

function PnlRename:onBtnCancel()
    self:close()
end

function PnlRename:onBtnConfirm()
    if self.args.type == 1 then
        ResPlanetData.C2S_Player_ModifyResPlanetName(self.args.index, self.view.txtNewName.text)
    elseif self.args.type == 2 then
        ResPlanetData.C2S_Player_ModifyPlanetRemark(self.args.index, self.view.txtNewName.text)
    end
end

return PnlRename
