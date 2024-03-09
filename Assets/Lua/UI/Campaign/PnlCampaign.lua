

PnlCampaign = class("PnlCampaign", ggclass.UIBase)

function PnlCampaign:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlCampaign:onAwake()
    self.view = ggclass.PnlCampaignView.new(self.transform)

end

function PnlCampaign:onShow()
    self:bindEvent()

end

function PnlCampaign:onHide()
    self:releaseEvent()

end

function PnlCampaign:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlCampaign:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlCampaign:onDestroy()
    local view = self.view

end

function PnlCampaign:onBtnClose()
    self:close()
    gg.sceneManager:enterBaseScene(function()
    end)  
end

return PnlCampaign