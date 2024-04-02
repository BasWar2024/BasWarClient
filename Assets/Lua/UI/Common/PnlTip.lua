PnlTip = class("PnlTip", ggclass.UIBase)

function PnlTip:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    self.events = {}

    self.key = 1
    self.tipTxt = args
    self.endY = 600
    self.moveTime = 4
    self.minDistance = 60

    self.layer = UILayer.tips
end

function PnlTip:onAwake()
    self.view = ggclass.PnlTipView.new(self.transform)

    self.txtTipsTableb = {self.view.txtTips1, self.view.txtTips2, self.view.txtTips3, self.view.txtTips4,
                          self.view.txtTips5, self.view.txtTips6, self.view.txtTips7, self.view.txtTips8,
                          self.view.txtTips9, self.view.txtTips10, self.view.txtTips11, self.view.txtTips12,
                          self.view.txtTips13, self.view.txtTips14, self.view.txtTips15, self.view.txtTips16,
                          self.view.txtTips17, self.view.txtTips18, self.view.txtTips19, self.view.txtTips20}

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
    -- if not self.lastTxt then
    --     self.lastTxt = txt
    -- else
    --     if self.lastTxt == txt then
    --         return
    --     end
    -- end
    self.txtTipsTableb[self.key].gameObject:SetActive(true)
    self.txtTipsTableb[self.key].transform.localPosition = Vector3(0, 0, 0)

    -- local sequence = CS.DG.Tweening.DOTween.Sequence()
    local newPos = Vector3(0, self.endY, 0)
    --sequence:Join(self.txtTipsTableb[self.key].transform:DOLocalMove(newPos, self.moveTime))
    self.txtTipsTableb[self.key].transform:DOLocalMove(newPos, self.moveTime)


    self.txtTipsTableb[self.key].text = txt
    self.lastTxt = txt
    self:preventKeepOut(self.key, self.key)

    self.key = self.key + 1
    if self.key > #self.txtTipsTableb then
        self.key = 1
    end
    self:removeTimer()
    self.closeTimer = gg.timer:addTimer(4, function()
        self.destroyTime = 0.1
        self:close()
    end)
end

function PnlTip:preventKeepOut(startKey, newKey)
    local lastKey = newKey - 1
    if lastKey < 1 then
        lastKey = #self.txtTipsTableb
    end
    if startKey == lastKey then
        return
    end

    local newY = self.txtTipsTableb[newKey].transform.localPosition.y
    local lastY = self.txtTipsTableb[lastKey].transform.localPosition.y
    if lastY >= self.endY then
        return
    end

    if lastY - newY < self.minDistance then
        self.txtTipsTableb[lastKey].transform:DOPause()
        local y = newY + self.minDistance
        self.txtTipsTableb[lastKey].transform.localPosition = Vector3(0, y, 0)
        local speed = self.endY / self.moveTime
        local time = (self.endY - y) / speed
        if time <= 0 then
            return
        end

        -- local sequence = CS.DG.Tweening.DOTween.Sequence()
        local newPos = Vector3(0, self.endY, 0)

        --sequence:Join(self.txtTipsTableb[lastKey].transform:DOLocalMove(newPos, time))
        self.txtTipsTableb[lastKey].transform:DOLocalMove(newPos, time)

    end
    self:preventKeepOut(startKey, lastKey)

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
