

PnlPveResultWin = class("PnlPveResultWin", ggclass.UIBase)

function PnlPveResultWin:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onPnlLoadingOpen" }
end

function PnlPveResultWin:onAwake()
    self.view = ggclass.PnlPveResultWinView.new(self.pnlTransform)
    self.pveResultStarBox = PveResultStarBox.new(self.view.pveResultStarBox, self)

    

    self.firstPveSubRewardBox = BattleResultRewardBox.new(self.view.firstPveSubRewardBox)
    self.dailyPveSubRewardBox = BattleResultRewardBox.new(self.view.dailyPveSubRewardBox)
    self.battleCasualtiesBox = BattleCasualtiesBox.new(self.view.battleCasualtiesBox)

    Utils.fixUiResolutionW(self.view.layoutContent)
end

local itemW = 140
local spancing = -19
local DailyBeginX = 1044

-- args = C2S_Player_EndBattle
function PnlPveResultWin:onShow()
    self:bindEvent()
    self.pveResultStarBox:setData(self.args)

    self.battleCasualtiesBox:setData(self.args.soliders)
    self.battleCasualtiesBox:setIsWin(true)

    self.cfgId = self.args.endInfo.cfgId
    local pveCfg = cfg.pve[self.cfgId]

    self.view.txtNoReward.transform:SetActiveEx(true)

    local firstBoxW = 0
    if self.args.endInfo.firstPass then
        self.firstPveSubRewardBox:setActive(true)

        firstBoxW = (itemW + spancing) * #pveCfg.passReward - spancing + 70
        self.firstPveSubRewardBox.transform:SetRectSizeX(firstBoxW)

        self.firstPveSubRewardBox:setData(pveCfg.passReward, BattleResultRewardBox.TYPE_REWARD_FIRST)

        self.view.txtNoReward.transform:SetActiveEx(false)
    else
        self.firstPveSubRewardBox:setActive(false)
    end

    local pos = self.dailyPveSubRewardBox.transform.anchoredPosition
    pos.x = DailyBeginX + firstBoxW
    self.dailyPveSubRewardBox.transform.anchoredPosition = pos

    local dayPass = BattleData.pveDayPassMap[self.cfgId]

    if dayPass and self.args.endInfo.isNewStar then
        self.dailyPveSubRewardBox:setActive(true)

        local starList = {
            [1] = false,
            [2] = false,
            [3] = false,
        }

        local passCount = #dayPass.stars
        if passCount == 1 then
            for i = 1, dayPass.stars[1] do
                starList[i] = true
            end
        else
            for i = dayPass.stars[passCount - 1] + 1, dayPass.stars[passCount] do
                starList[i] = true
            end
        end
        self.dailyPveSubRewardBox:setData(PveUtil.getStarReward(self.cfgId, starList[1], starList[2], starList[3]), BattleResultRewardBox.TYPE_REWARD_DAILY)

        self.view.txtNoReward.transform:SetActiveEx(false)
    else
        self.dailyPveSubRewardBox:setActive(false)
    end
    
    AudioFmodMgr:PauseBgm(true)
    local audioInfo = constant.AUDIO_BATTLE_WIN
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

function PnlPveResultWin:onHide()
    self:releaseEvent()
end

function PnlPveResultWin:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)

    self:setOnClick(view.btnReturnBase.gameObject, gg.bind(self.onBtnConfirm, self, true))
end

function PnlPveResultWin:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnConfirm)

    if self.audioInstence then
        self.audioInstence:stop()
        self.audioInstence:release()
        self.audioInstence = nil
    end
end

function PnlPveResultWin:onDestroy()
    local view = self.view
    self.pveResultStarBox:release()

    self.firstPveSubRewardBox:release()
    self.dailyPveSubRewardBox:release()
    self.battleCasualtiesBox:release()
end

function PnlPveResultWin:onBtnConfirm(isReturnBase)
    if isReturnBase then
        gg.sceneManager:clearEnterSceneOpenWindows(constant.SCENE_BASE)
    else
        gg.sceneManager:addEnterSceneOpenWindows(constant.SCENE_BASE, "PnlPveNew")
    end

    BattleUtil.returnFromResult()

    AudioFmodMgr:PauseBgm(false)
    if self.audioInstence then
        self.audioInstence:stop()
        self.audioInstence:release()
        self.audioInstence = nil
    end

    -- self:close()
end

function PnlPveResultWin:onPnlLoadingOpen()
    self:close()
end

return PnlPveResultWin