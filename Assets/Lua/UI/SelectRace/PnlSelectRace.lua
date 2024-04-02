

PnlSelectRace = class("PnlSelectRace", ggclass.UIBase)
PnlSelectRace.closeType = ggclass.UIBase.CLOSE_TYPE_NONE

function PnlSelectRace:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onUpData" }
end

function PnlSelectRace:onAwake()
    self.view = ggclass.PnlSelectRaceView.new(self.pnlTransform)
    self:initCfg()

    self.answerItemList = {}
    self.selectScrollView = UIScrollView.new(self.view.selectScrollView, "RaceAnswerItem", self.answerItemList)
    self.selectScrollView:setRenderHandler(gg.bind(self.onRenderAnswerItem, self))

    -- self.selectIcon = Utils.getDefultHeadIconName()

    self.selectIcon = cfg.PlayerHead[math.random(1, #cfg.PlayerHead)].iconName

    self.playerDetailedSelectHeadBox = PlayerDetailedSelectHeadBox.new(self.view.playerDetailedSelectHeadBox, self)

    self.playerDetailedSelectHeadBox:SetBtnSetCallBack(function (selectIcon)
        self.selectIcon = selectIcon
        self.playerDetailedSelectHeadBox:close()
        self:setCreateStep(PnlSelectRace.STEP_CONFIRM)
    end)
end

function PnlSelectRace:onShow()
    --gg.uiManager:closeWindow("PnlLink")
    self:bindEvent()
    self.scoreMap = {}
    self.playerDetailedSelectHeadBox:close()
    self:setCreateStep(PnlSelectRace.STEP_MOVIE)

    self.view.arrows.transform:DOKill()
    self:startAction(self.view.arrows.transform)
end

function PnlSelectRace:startAction(trans)
    trans:DOKill()
    trans.rotation = CS.UnityEngine.Quaternion.Euler(0, 0, 0)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(trans:DOLocalRotate(Vector3(0, 0, -180), 4):SetEase(CS.DG.Tweening.Ease.Linear))
    sequence:Append(trans:DOLocalRotate(Vector3(0, 0, -360), 4):SetEase(CS.DG.Tweening.Ease.Linear))
    sequence:AppendCallback(function ()
        self:startAction(trans)
    end)
end

PnlSelectRace.STEP_QUESTION = 1

PnlSelectRace.STEP_MOVIE = 2
PnlSelectRace.STEP_SELECT_RACE = 3
PnlSelectRace.STEP_SET_NAME = 4
PnlSelectRace.STEP_SET_HEAD = 5
PnlSelectRace.STEP_CONFIRM = 6

function PnlSelectRace:setCreateStep(step)
    local view = self.view
    self.step = step

    view.layoutVideo:SetActiveEx(false)
    view.videoPlayer:Stop()

    if step == PnlSelectRace.STEP_MOVIE then
        view.layoutVideo:SetActiveEx(true)
        view.videoPlayer:Play()
        -- ResMgr:LoadVideoClipAsync("Cinematic", function(video)
        --     view.videoPlayer.clip = video
        --     view.videoPlayer:Play()
        -- end)

    elseif step == PnlSelectRace.STEP_QUESTION then
        for key, value in pairs(constant.RACE_MESSAGE) do
            self.scoreMap[key] = 0
        end
        view.layoutQuestion:SetActiveEx(true)
        view.layoutConfirm:SetActiveEx(false)
        self:startQuestion(1)

    elseif step == PnlSelectRace.STEP_SELECT_RACE then
        self:onBtnRace(constant.RACE_CENTRA)
        self:onBtnJoin()

    elseif step == PnlSelectRace.STEP_SET_NAME then
        gg.uiManager:openWindow("PnlChangeName", {type = PnlChangeName.TYPE_CREATE, setCallback = function (text)
            self.createName = text
            gg.uiManager:closeWindow("PnlChangeName")
            self:setCreateStep(PnlSelectRace.STEP_SET_HEAD)
        end})

    elseif step == PnlSelectRace.STEP_SET_HEAD then
        -- self.playerDetailedSelectHeadBox:open()
        self:setCreateStep(PnlSelectRace.STEP_CONFIRM)
    elseif step == PnlSelectRace.STEP_CONFIRM then
        view.layoutConfirm:SetActiveEx(true)
        gg.setSpriteAsync(self.view.imgHead, Utils.getHeadIcon(self.selectIcon))
        view.txtFinalName.text = "nickname:" .. self.createName
        -- self:startConfirm()
    end
end

function PnlSelectRace:startConfirm()
    local view = self.view
    local score = nil
    self.selectingRace = nil
    for key, value in pairs(self.scoreMap) do
        if score == nil or value > score then
            score = value
            self.selectingRace = key
        end
    end
    self:refreshSelectingMessage()
end

function PnlSelectRace:refreshSelectingMessage()
    self.view.txtRace.text = constant.RACE_MESSAGE[self.selectingRace].name
end

function PnlSelectRace:onHide()
    --gg.uiManager:openWindow("PnlLink", {isAutoClose = true})
    self:releaseEvent()
    self.view.arrows.transform:DOKill()
end

function PnlSelectRace:startQuestion(index)
    self.showingIndex = index
    local question = self.selectRaceQuestionCfgMap[index]
    self.showingQuestion = question
    self.view.txtQuextion.text = question[1].textQ
    self.selectScrollView:setItemCount(#question)
end

function PnlSelectRace:nextQuestion()
    if self.selectRaceQuestionCfgMap[self.showingIndex + 1] ~= nil then
        self:startQuestion(self.showingIndex + 1)
    else
        self:setCreateStep(PnlSelectRace.STEP_CONFIRM)
    end
end

function PnlSelectRace:onRenderAnswerItem(obj, index)
    local item = RaceAnswerItem:getItem(obj, self.answerItemList, self)
    item:setData(self.showingQuestion[index])
end

function PnlSelectRace:answer(answerCfg)
    for key, value in pairs(constant.RACE_MESSAGE) do
        self.scoreMap[key] = self.scoreMap[key] + answerCfg[value.selectRaceQuestionScoreKey]
    end

    self:nextQuestion()
end

function PnlSelectRace:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    self:setOnClick(self.view.btnConfirm, gg.bind(self.onBtnConfirm, self))
    self:setOnClick(self.view.btnJoin, gg.bind(self.onBtnJoin, self))
    self:setOnClick(self.view.btnCloseConfirm, gg.bind(self.onBtnCloseConfirm, self))
    self:setOnClick(self.view.btnSkip, gg.bind(self.onBtnSkip, self))

    for key, value in pairs(view.btnRaceMap) do
        self:setOnClick(value.btn, gg.bind(self.onBtnRace, self, key))
    end
end

function PnlSelectRace:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlSelectRace:onDestroy()
    local view = self.view
    self.selectScrollView:release()
    self.playerDetailedSelectHeadBox:release()
end

function PnlSelectRace:onBtnClose()
end

function PnlSelectRace:initCfg()
    self.selectRaceQuestionCfgMap = {}
    for key, value in pairs(cfg.SelectRaceQuestion) do
        self.selectRaceQuestionCfgMap[value.questionId] = self.selectRaceQuestionCfgMap[value.questionId] or {}
        self.selectRaceQuestionCfgMap[value.questionId][value.answerId] = value
    end
end

function PnlSelectRace:onBtnConfirm()
    local server = gg.client.loginServer:getServer()
    if server then
        gg.client.loginServer:createRole(server, self.createName, self.selectingRace, self.selectIcon)
    end
end

function PnlSelectRace:onBtnRace(race)
    self.selectingRace = race
    -- self.view.layoutChangeRace:SetActiveEx(false)
    -- self:refreshSelectingMessage()

    for key, value in pairs(self.view.btnRaceMap) do
        if key == race then
            value.imgSelect.gameObject:SetActiveEx(true)
            value.imgGray.gameObject:SetActiveEx(false)
            value.btn.transform:SetAsLastSibling()

            self.view.txtBackground:SetLanguageKey(cfg.textAlert["bgText_" ..  constant.RACE_MESSAGE[race].name .. "1"].textAlert)
            self.view.txtBackground2:SetLanguageKey(cfg.textAlert["bgText_" ..  constant.RACE_MESSAGE[race].name .. "2"].textAlert)
            value.btn.transform.localScale = Vector3(1.1, 1.1, 1.1)
        else
            value.imgSelect.gameObject:SetActiveEx(false)
            value.imgGray.gameObject:SetActiveEx(true)
            value.btn.transform.localScale = Vector3(1, 1, 1)
        end
    end

    for key, value in pairs(self.view.raceSpineMap) do
        value.gameObject:SetActiveEx(key == race)
    end
end

function PnlSelectRace:onBtnSkip()
    self:setCreateStep(PnlSelectRace.STEP_SELECT_RACE)

end

function PnlSelectRace:onBtnCloseConfirm()
    self.view.layoutConfirm:SetActiveEx(false)
end

function PnlSelectRace:onBtnJoin()
    local server = gg.client.loginServer:getServer()
    if server then
        gg.uiManager:openWindow("PnlConnect")
        -- gg.client.loginServer:createRole(server, self.createName, self.selectingRace, self.selectIcon)
        gg.client.loginServer:createRole(server, nil, self.selectingRace, self.selectIcon)
    end

    self:close()
    -- self:setCreateStep(self.STEP_SET_NAME)
end

function PnlSelectRace:onUpData()
    if self.step == PnlSelectRace.STEP_MOVIE then
        if not self.isPlaying and self.view.videoPlayer.isPlaying then
            self.isPlaying = true
        end
        if self.isPlaying and not self.view.videoPlayer.isPlaying then
            self.isPlaying = false
            self:setCreateStep(PnlSelectRace.STEP_SELECT_RACE)
        end
    end
end

return PnlSelectRace
