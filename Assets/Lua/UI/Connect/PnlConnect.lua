

PnlConnect = class("PnlConnect", ggclass.UIBase)

function PnlConnect:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.tipsNode
    self.events = {"onClientBattleEnd" }

    self.destroyTime = -1
end

function PnlConnect:onAwake()
    self.view = ggclass.PnlConnectView.new(self.transform)
end

function PnlConnect:onShow()
    self:bindEvent()
    local view = self.view
    view.imgTipsText.text = ""
    view.imgMainPoint.transform:DOKill()
    view.imgBattlePoint.transform:DOKill()
    if gg.battleManager.isInBattle then
        view.layoutMain:SetActiveEx(false)
        view.layoutBattle:SetActiveEx(true)
        self:startAction(view.imgBattlePoint.transform)
        view.imgBattleBg.transform:SetActiveEx(BattleData.isBattleEnd)
    else
    
        view.layoutMain:SetActiveEx(true)
        view.layoutBattle:SetActiveEx(false)
        self:startAction(view.imgMainPoint.transform)
    end
end

function PnlConnect:onClientBattleEnd()
    if gg.battleManager.isInBattle then
        self:startTickTimer()
        self.view.imgBattleBg.transform:SetActiveEx(BattleData.isBattleEnd)
    end
end

function PnlConnect:onHide()
    local view = self.view
    self:stopTickTimer()
    self:releaseEvent()
    view.imgMainPoint.transform:DOKill()
    view.imgBattlePoint.transform:DOKill()
end

function PnlConnect:bindEvent()
    local view = self.view

    gg.event:addListener("onConnectChange", self)

    CS.UIEventHandler.Get(view.btnClose.gameObject):SetOnClick(function()
        gg.uiManager:closeWindow("PnlConnect")
    end)
end

function PnlConnect:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose.gameObject)
    gg.event:removeListener("onConnectChange", self)
end

function PnlConnect:onDestroy()
    local view = self.view
end

function PnlConnect:onConnectChange(event, msg, showButton)
    local view = self.view
    view.imgTipsText.text = msg

    if showButton then
        view.btnClose:SetActiveEx(true)
    else
        view.btnClose:SetActiveEx(false)
    end
end


function PnlConnect:startAction(trans)
    trans:DOKill()
    if self.status == UIState.hide or self.status == UIState.destroy then
        return
    end
    trans.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 0)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(trans:DOLocalRotate(Vector3(0, 0, -180), 2):SetEase(CS.DG.Tweening.Ease.Linear))
    sequence:Append(trans:DOLocalRotate(Vector3(0, 0, -360), 2):SetEase(CS.DG.Tweening.Ease.Linear))
    sequence:AppendCallback(function ()
        self:startAction(trans)
    end)
end

function PnlConnect:startTickTimer()
    self:stopTickTimer()
    self.tickTimer = gg.timer:startTimer(60, function()
        self:playerEcsapeMsg()
    end)
end

function PnlConnect:stopTickTimer()
    if self.tickTimer then
        gg.timer:stopTimer(self.tickTimer)
        self.tickTimer = nil
    end
end

function PnlConnect:playerEcsapeMsg()
    local txt = "You have been dropped "
    local callbackYes = function()
        gg.uiManager:destroyAllWindows()
        returnLogin()
    end
    local args = {
        txt = txt,
        callbackYes = callbackYes,
        btnType = ggclass.PnlAlert.BTN_TYPE_SINGLE,
        txtYes = "To log in"
    }
    gg.uiManager:openWindow("PnlAlert", args)
end


return PnlConnect