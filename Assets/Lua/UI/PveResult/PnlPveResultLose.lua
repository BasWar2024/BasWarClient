

PnlPveResultLose = class("PnlPveResultLose", ggclass.UIBase)

function PnlPveResultLose:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onPnlLoadingOpen" }
end

function PnlPveResultLose:onAwake()
    self.view = ggclass.PnlPveResultLoseView.new(self.pnlTransform)
    self.pveResultStarBox = PveResultStarBox.new(self.view.pveResultStarBox, self)

    self.battleCasualtiesBox = BattleCasualtiesBox.new(self.view.battleCasualtiesBox)
    self.battleResultStrengthBox = BattleResultStrengthBox.new(self.view.battleResultStrengthBox)

    Utils.fixUiResolutionW(self.battleCasualtiesBox.transform)
    Utils.fixUiResolutionW(self.battleResultStrengthBox.transform)
end

-- args = C2S_Player_EndBattle
function PnlPveResultLose:onShow()
    self:bindEvent()
    self.pveResultStarBox:setData(self.args)

    self.battleCasualtiesBox:setData(self.args.soliders)
    self.battleCasualtiesBox:setIsWin(false)

    AudioFmodMgr:PauseBgm(true)
    local audioInfo = constant.AUDIO_BATTLE_LOSE
    AudioFmodMgr:LoadAudioInstance(audioInfo.event, audioInfo.bank, function (instance)
        self.audioInstence = instance
        if not self:isShow() then
            self.audioInstence:release()
            self.audioInstence = nil
        else
            self.audioInstence:start()
        end
    end)
end

function PnlPveResultLose:onHide()
    self:releaseEvent()
end

function PnlPveResultLose:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)

    self:setOnClick(view.btnReturnBase.gameObject, gg.bind(self.onBtnConfirm, self, true))
end

function PnlPveResultLose:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnConfirm)
end

function PnlPveResultLose:onDestroy()
    local view = self.view
    self.pveResultStarBox:release()
    self.battleResultStrengthBox:release()
    self.battleCasualtiesBox:release()
end

function PnlPveResultLose:onBtnConfirm(isReturnBase)
    if isReturnBase then
        gg.sceneManager:clearEnterSceneOpenWindows(constant.SCENE_BASE)
    else
        gg.sceneManager:addEnterSceneOpenWindows(constant.SCENE_BASE, "PnlPveNew")
    end

    BattleUtil.returnFromResult()
    -- self:close()
    AudioFmodMgr:PauseBgm(false)
    if self.audioInstence then
        self.audioInstence:stop()
        self.audioInstence:release()
        self.audioInstence = nil
    end
end

function PnlPveResultLose:onPnlLoadingOpen()
    self:close()
end

return PnlPveResultLose