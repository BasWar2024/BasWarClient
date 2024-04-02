

PnlForgeResult = class("PnlForgeResult", ggclass.UIBase)

function PnlForgeResult:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlForgeResult:onAwake()
    self.view = ggclass.PnlForgeResultView.new(self.pnlTransform)
end

--args = {result = }
function PnlForgeResult:onShow()
    self:bindEvent()

    local view = self.view
    if self.args.result then
        view.txtResult.text = "succeed"
    else
        view.txtResult.text = "fail"
    end

    self:startAnimate("......")
end

PnlForgeResult.Time_Per_Word = 0.5
function PnlForgeResult:startAnimate(str)
    self:stopAnimate()
    local view = self.view
    view.txtResult.transform:SetActiveEx(false)
    view.txtContent.transform:SetActiveEx(true)

    local time = string.utf8len(str) * PnlForgeResult.Time_Per_Word
    
    view.txtContent.text = ""
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Append(view.txtContent:DOText(str, time):SetEase(CS.DG.Tweening.Ease.Linear))
    self.sequence:AppendCallback(function ()
        -- self:onAnimationEnd()
        self:onBtnBg()
    end)
end

function PnlForgeResult:onAnimationEnd()
    local view = self.view
    view.txtResult.transform:SetActiveEx(true)
    view.txtContent.transform:SetActiveEx(false)
    self.closeTimer = gg.timer:startTimer(3, function ()
        self:close()
    end)
end

function PnlForgeResult:stopAnimate()
    if self.sequence then
        self.sequence:Kill()
    end
    if self.closeTimer then
        gg.timer:stopTimer(self.closeTimer)
        self.closeTimer = nil
    end
end

function PnlForgeResult:onHide()
    self:releaseEvent()
    self:stopAnimate()
    gg.event:dispatchEvent("onForgeResultAnimateFinish", self.args.result)
end

function PnlForgeResult:bindEvent()
    local view = self.view
    self:setOnClick(view.bg, gg.bind(self.onBtnBg, self))
end

function PnlForgeResult:onBtnBg()
    if self.sequence then--and not self.sequence:IsComplete() then
        -- self.sequence:Complete()
        self.sequence:Kill()
        self.sequence = nil
        self:onAnimationEnd()
    else
        self:close()
    end
end

function PnlForgeResult:releaseEvent()
    local view = self.view
end

function PnlForgeResult:onDestroy()
    local view = self.view
end

return PnlForgeResult