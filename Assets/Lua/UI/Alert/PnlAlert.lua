

PnlAlert = class("PnlAlert", ggclass.UIBase)

--args = {callbackYes = , callbackNo = , txt = }
function PnlAlert:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlAlert:onAwake()
    self.view = ggclass.PnlAlertView.new(self.transform)
end

function PnlAlert:onShow()
    self:bindEvent()
    self:setType()
    self:showTip()
end

function PnlAlert:setType()
    local view = self.view
    local type = self.args.type
    if type then
        view.btnYes.transform:GetComponent("RectTransform"):SetRectPosX(0)
        view.txtBtnYes.text = "OK"
        view.btnNo:SetActive(false)
    else
        view.btnYes.transform:GetComponent("RectTransform"):SetRectPosX(-93)
        view.txtBtnYes.text = "Yes"
        view.btnNo:SetActive(true)
    end
end

function PnlAlert:onHide()
    self:releaseEvent()
end

function PnlAlert:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)
end

function PnlAlert:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnYes)
    CS.UIEventHandler.Clear(view.btnNo)

end

function PnlAlert:onDestroy()
    local view = self.view

end

function PnlAlert:onBtnYes()
    if self.args.callbackYes then
        self.args.callbackYes()
    end
    self:close()
end

function PnlAlert:onBtnNo()
    if self.args.callbackNo then
        self.args.callbackNo()
    end
    self:close()
end

function PnlAlert:showTip(txt)
    self.view.txtTip.text = self.args.txt
end

return PnlAlert