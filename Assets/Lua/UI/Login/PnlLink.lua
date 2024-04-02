PnlLink = class("PnlLink", ggclass.UIBase)
PnlLink.closeType = ggclass.UIBase.CLOSE_TYPE_NONE

-- args = {isAutoClose = true, closeSec = 1 ,callback = function()}
function PnlLink:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.tips
    self.events = {""}

    self.isCloseWindow = false

    self.destroyTime = -1
end

function PnlLink:onAwake()
    self.view = ggclass.PnlLinkView.new(self.pnlTransform)
end

function PnlLink:onShow()
    self:bindEvent()
    self.view.iconTick:SetActiveEx(false)

    local isAutoClose = self.args.isAutoClose
    local isAlpha = self.args.isAlpha
    -- print("isAutoClose", isAutoClose)
    if isAlpha then
        self.view.bg.color = Color.New(0, 0, 0, 0)
    else
        self.view.bg.color = Color.New(0, 0, 0, 100 / 255)
    end

    if isAutoClose then
        self:startCloseTimer()
    end

    if self.isCloseWindow then
        self:closeWindow()
    end

    self:startDOTween()
end

function PnlLink:startDOTween()
    self:stopDOTween()

    if not self.view.transform.gameObject.activeSelf then
        return
    end
    self.doTweenTimer = gg.timer:startTimer(2, function()
        local icon = self.view.iconConnect
        icon.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 0)
        local sequence = CS.DG.Tweening.DOTween.Sequence()
        sequence:Append(icon:DOLocalRotate(Vector3(0, 0, -180), 1):SetEase(CS.DG.Tweening.Ease.Linear))
        sequence:Append(icon:DOLocalRotate(Vector3(0, 0, -360), 1):SetEase(CS.DG.Tweening.Ease.Linear))
        sequence:AppendCallback(function()
            self:startDOTween()
        end)
    end)
end

function PnlLink:stopDOTween()
    if self.doTweenTimer then
        gg.timer:stopTimer(self.doTweenTimer)
        self.doTweenTimer = nil
    end
    if self.view then
        local icon = self.view.iconConnect
        icon:DOKill()
    end
end

function PnlLink:onHide()
    gg.uiManager:onClosePnlLink(self.args.msg)
    self.view.iconConnect:DOKill()
    self:releaseEvent()
    self:stopCloseTimer()
    self:stopDOTween()
end

function PnlLink:bindEvent()
    local view = self.view

end

function PnlLink:releaseEvent()
    local view = self.view

end

function PnlLink:onDestroy()
    local view = self.view
    self:stopDOTween()
end

function PnlLink:startCloseTimer()
    self:stopCloseTimer()
    if self.args.closeSec then
        self.view.iconTick:SetActiveEx(true)
    else
        self.view.iconTick:SetActiveEx(false)
    end
    local closeSec = self.args.closeSec or 10
    local tick = closeSec
    self.closeTimer = gg.timer:startLoopTimer(0, 1, closeSec, function()
        tick = tick - 1
        self.view.txtTick.text = tick
        if tick <= 0 then
            if self.args.callback then
                self.args.callback()
            else
                gg.uiManager:showTip("Connection failed.Please log in connection again")
            end

            self:close()
            self:stopCloseTimer()
        end
    end)
end

function PnlLink:stopCloseTimer()
    self.view.iconConnect:DOKill()
    if self.closeTimer then
        gg.timer:stopTimer(self.closeTimer)
        self.closeTimer = nil
    end
end

function PnlLink:closeWindow()
    if self.view then
        self:close()
        self.isCloseWindow = false
    else
        self.isCloseWindow = true
    end
end

return PnlLink
