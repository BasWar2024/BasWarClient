

PnlTip = class("PnlTip", ggclass.UIBase)

function PnlTip:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }

    self.key = 1
    self.tipTxt = args
    
end

function PnlTip:onAwake()
    self.view = ggclass.PnlTipView.new(self.transform)

    self.txtTipsTableb = {self.view.txtTips1 ,self.view.txtTips2 ,
                            self.view.txtTips3 ,self.view.txtTips4 ,
                            self.view.txtTips5 , self.view.txtTips6 ,
                            self.view.txtTips7 ,self.view.txtTips8 ,
                            self.view.txtTips9 ,self.view.txtTips10 ,
                            self.view.txtTips11 ,self.view.txtTips12 ,
                            self.view.txtTips13 ,self.view.txtTips14 ,
                            self.view.txtTips15 , self.view.txtTips16 ,
                            self.view.txtTips17 ,self.view.txtTips18 ,
                            self.view.txtTips19 ,self.view.txtTips20 }

    self:setTipText(self.tipTxt)
end

function PnlTip:onShow()
    self:bindEvent()

    
end

function PnlTip:onHide()
    self:releaseEvent()

end

function PnlTip:setTipText(txt)
    if not self.txtTipsTableb then
        return
    end

    self.txtTipsTableb[self.key].gameObject:SetActive(true)
    self.txtTipsTableb[self.key].text = txt
    self.key = self.key + 1
    if self.key > #self.txtTipsTableb then
        self.key = 1
    end
    self:removeTimer()
    self.closeTimer = gg.timer:addTimer(2, function ()
        self.destroyTime = 0.1
        self:close()
    end)
end

function PnlTip:removeTimer()
    if (self.closeTimer) then
        gg.timer:stopTimer(self.closeTimer)
        self.closeTimer = nil
    end
end

function PnlTip:bindEvent()
    local view = self.view

end

function PnlTip:releaseEvent()
    local view = self.view

end

function PnlTip:onDestroy()
    local view = self.view
    self:removeTimer()
end

return PnlTip