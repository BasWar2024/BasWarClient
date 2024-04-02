PnlBattle = class("PnlBattle", ggclass.UIBase)
local cjson = require "cjson"

function PnlBattle:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onSetBattleAtkCard", "onHideSkillDesc", "onSetGuideOperate"}
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlBattle:onAwake()
    self.view = ggclass.PnlBattleView.new(self.transform)
end

-- args = {battleInfo = , guideNode = }
function PnlBattle:onShow()
    -- BattleData.ResultDelay = 3.5

    self.battleHeroItemList = {}
    for index, value in ipairs(self.view.heroBtnList) do
        self.battleHeroItemList[index] = BattleHeroItem.new(value, self)
        self.battleHeroItemList[index]:addClickCallback(gg.bind(self.onClickOperOrder, self, index))
    end

    self.battleHeroSkillItemList = {}
    for index, value in ipairs(self.view.heroSkillBtnList) do
        self.battleHeroSkillItemList[index] = BattleHeroSkillItem.new(value, self)
        self.battleHeroSkillItemList[index]:addClickCallback(gg.bind(self.onClickOperOrder, self, index + 5))
    end

    -- self.battleSoldierItemList = {}
    -- for index, value in ipairs(self.view.soliderBtnList) do
    --     self.battleSoldierItemList[index] = BattleSoldierItem.new(value, self)
    --     self.battleSoldierItemList[index]:addClickCallback(gg.bind(self.onClickOperOrder, self, index))
    -- end

    self.battleSkillItemList = {}
    for index, value in ipairs(self.view.skillBtnList) do
        self.battleSkillItemList[index] = BattleSkillItem.new(value, self)
        self.battleSkillItemList[index]:addClickCallback(gg.bind(self.onClickOperOrder, self, index + 10))
    end

    self.isShowBattleDetail = util.getDetail()
    self.view.layoutBattleDetail:SetActiveEx(self.isShowBattleDetail)

    -- self.view.btnReturn2Main:SetActiveEx(not self.args.guideNode)

    self:bindEvent()

    self.terrain = gg.sceneManager.terrain
    self.mainCamera = UnityEngine.Camera.main
    self.battleMono = gg.battleManager.battleMono
    self.newBattleData = gg.battleManager.newBattleData
    self.closeColor = UnityEngine.Color(0.5, 0.5, 0.5)
    self.openColor = UnityEngine.Color(1, 1, 1)

    self.view.boxSkillTips:SetActive(false)
    self.battleSpeed = 1
    self.heroSkill_Oper_MaxCdDict = {}

    self.view.btnReturn2Main:SetActiveEx(false)
    self.view.btnEndBattle:SetActiveEx(false)
    self.view.btnEndReport:SetActiveEx(false)

    local isReplay = string.match(tostring(self.newBattleData._BattleType ), "0") == nil
    if isReplay then
        self.view.btnEndReport:SetActiveEx(true)
    else
        self.view.btnEndBattle:SetActiveEx(not self.args.guideNode)
    end

    if self.args.battleInfo.enemy ~= nil then
        if isReplay then
            self.view.txtReplayName.text = self.args.battleInfo.enemy.playerName
        else
            self.view.txtName.text = self.args.battleInfo.enemy.playerName
            if self.args.battleInfo.enemy.playerScore and self.args.battleInfo.enemy.playerScore ~= "" then
                self.view.txtBadge.transform:SetActiveEx(true)
                self.view.txtBadge.text = self.args.battleInfo.enemy.playerScore
            else
                self.view.txtBadge.transform:SetActiveEx(false)
            end
        end
    end

    local updateSkillUIMaxTime = cfg.global.UpdateSkillUIMaxTime
    if updateSkillUIMaxTime ~= nil and updateSkillUIMaxTime ~= 0 then
        self.battleMono.UpdateSkillUIMaxTime = updateSkillUIMaxTime
    end

    self.battleMono.ShowOperUI = function()
        self:showOperUI()
    end

    self.battleMono.CloseOperUI = function(oper)
        self:closeOperUI(oper)
    end

    self.battleMono.BattleLogic.OpenOperUI = function(oper, amount)
        self:openOperUI(oper, amount)
    end

    self.battleMono.UpdateSkillCost = function()
        self:updateSkillCost()
    end

    self.battleMono.BattleLogic.UpdateTime = function(time)
        self:updateTime(time)
    end

    self.battleMono.ActionShowTips = gg.bind(self.showTips, self)
    self.battleMono.BattleLogic.ActionShowTips = gg.bind(self.showTips, self)

    self.battleMono.BattleLogic.BattleStageChange = function(stage)
        self.stage = stage
        if stage == 1 then
            gg.audioManager:playBgAudio(constant.AUDIO_BGM_BATTLE_READY)
            self.view.txtTimeTitle:SetLanguageKey("battle_BeginTips")
            
            -- gg.uiManager:openWindow("PnlBattleDrawCard", {defCardList = self.args.battleInfo.defenseCards})
        elseif stage == 2 then
            gg.audioManager:playBgAudio(constant.AUDIO_BGM_BATTLE, false)
            self.view.txtTimeTitle:SetLanguageKey("battle_EndTips")
        elseif stage == 3 then
            self.view.txtTimeTitle:SetLanguageKey("battle_EndTips")
            gg.audioManager:playBgAudio(constant.AUDIO_BGM_BATTLE, false)
            if string.match(tostring(CS.NewGameData._IsRePlay), "0") == nil then
                gg.warCameraCtrl:move2LandPoint(self.newBattleData._SigninPosId)
            end
        elseif stage == 4 then
            if self.args.guideNode then
                self.args.guideNode:triggerGuide()

                gg.timer:startTimer(1, function()
                    -- self:onReturn2Main()
                    self:close()
                    BattleUtil.returnFromResult()
                end)
            end
        end
    end

    self.battleOperItemList = {}
    for i = 1, 14, 1 do
        if i <= 5 then
            local value, heroModel = self.newBattleData._ArmyIndex_HeroModel:TryGetValue(i)
            --local value1, soliderModel = self.newBattleData._ArmyIndex_SoliderModel:TryGetValue(i)

            if value then
                self.battleOperItemList[i] = self.battleHeroItemList[i]
            -- elseif value1 then
            --     self.battleOperItemList[i] = self.battleSoldierItemList[i]
            end
        elseif i <= 10 then
            self.battleOperItemList[i] = self.battleHeroSkillItemList[i - 5]
        else
            self.battleOperItemList[i] = self.battleSkillItemList[i - 10]
        end
    end

    self.battleMono.BattleLogic.ShowResult = function(value)
        self:showResult(value)
    end

    self.battleMono.BattleLogic.EndBattle = function(endBattle)
        self:endBattle(endBattle)
    end

    self.battleMono.CurrOrderChange = function(order)
        if order == 0 then
            return
        end

        for index, value in pairs(self.battleOperItemList) do
            value:setSelect(false)
        end

        self.battleOperItemList[order]:setSelect(true)

        if order <= 5 then
            self.battleOperItemList[order + 5]:setSelect(true)
        end
    end

    CS.NewGameData._FightManager.UpdateSkillPoint = function()
        self:updateSkillPoint()
    end

    CS.NewGameData._FightManager.OnHeroKilled = function(index)
        self:OnHeroKilled(index)
    end

    self.battleMono.BattleLogic.HeroSkillCdChange = function(oper, cd)
        self:heroSkillCdChange(oper, cd)
    end

    self.battleMono.BattleLogic.HeroSkillReleaseDistance = function(oper, value)
        self:heroSkillReleaseDistance(oper, value)
    end

    self.battleMono.ShowSkillMissTip = function(skillNumber)
        self:ShowSkillMissTip(skillNumber)
    end

    --self:UnlockArea()

    self:hideOperUI(not self.args.guideNode)

    self.selectSignalSkill = false
    self.battleMono.OperSignalSkill = self.selectSignalSkill
end

function PnlBattle:UnlockArea()
    if BattleData.battleType == 3 then
        CS.NewGameData._AreaLevel = 7
        gg.areaManager:setUnlockArea(7)
        CS.NewGameData._AStar:SetWall()
        return
    end

    if CS.NewGameData._MineralBuildingList ~= nil then
        local list =  CS.NewGameData._MineralBuildingList
        if list.Count > 0 then
            local level = list[0].Level
            CS.NewGameData._AreaLevel = level
            gg.areaManager:setUnlockArea(level)
            CS.NewGameData._AStar:SetWall()
        end
    end
end

function PnlBattle:updateSkillCost()
    local view = self.view
    self:updateSkillPoint()
    for k, v in pairs(self.newBattleData._SkillCostPointsDict) do
        local operStrList = string.split(tostring(k), ":")
        local costStrList = string.split(tostring(v), ":")
        local operNum = tonumber(operStrList[2])
        local costNum = tonumber(costStrList[1])

        -- if operNum <= 8 then
        --     local item = self.battleSoldierItemList[operNum]
        --     item:setCost(costNum)

        -- elseif operNum == 10 then
        --     self.battleHeroSkillItem:setCost(costNum)

        if operNum > 10 then
            local battleSkillItem = self.battleSkillItemList[operNum - 10]
            battleSkillItem:setCost(costNum)
        end
    end
end

PnlBattle.OPER_TYPE_SOLDIER = 1
PnlBattle.OPER_TYPE_HERO = 2
PnlBattle.OPER_TYPE_HERO_SKILL = 3
PnlBattle.OPER_TYPE_SKILL = 4

function PnlBattle:getOperItemByOper(oper)
    if oper < 9 then
        return PnlBattle.OPER_TYPE_SOLDIER
    elseif oper == 9 then
        return PnlBattle.OPER_TYPE_HERO
    elseif oper == 10 then
        return PnlBattle.OPER_TYPE_HERO_SKILL
    elseif oper > 10 then
        return PnlBattle.OPER_TYPE_SKILL
    end
end

PnlBattle.SKILL_STAGE_HERO_NOT_USE = 1
PnlBattle.SKILL_STAGE_HERO_USED = 2
function PnlBattle:closeOperUI(oper)
    if oper == 0 then
        return
    end
    if oper <= 5 then
        local value, heroModel = self.newBattleData._ArmyIndex_HeroModel:TryGetValue(oper)
        --local value1, soliderModel = self.newBattleData._ArmyIndex_SoliderModel:TryGetValue(oper)
        if value == true then      
            self.battleHeroItemList[oper]:setCardStage(PnlBattle.SKILL_STAGE_HERO_USED)
            local skillItem = self.battleHeroSkillItemList[oper]
            skillItem:setCardStage(PnlBattle.SKILL_STAGE_HERO_NOT_USE)
        -- elseif value1 == true then
        --     local soldierItem = self.battleSoldierItemList[oper]
        --     soldierItem:setItemGray(true)
        end
    end
end

function PnlBattle:openOperUI(oper, amount)
    -- if oper == 0 then
    --     return
    -- end

    -- if amount == nil or amount == 0 then
    --     local soldierItem = self.battleSoldierItemList[oper]
    --     soldierItem.txtCount.text = tonumber(soldierItem.txtCount.text) - 1
    -- elseif oper < 9 then
    --     local soldierItem = self.battleSoldierItemList[oper]
    --     self.battleSoldierItemList[oper]:setItemGray(false)
    --     soldierItem:setCount(amount)
    -- end
end

function PnlBattle:showOperUI()
    gg.warCameraCtrl:move2LandPoint(self.newBattleData._SigninPosId)
    local view = self.view
    -- view.herosBG.gameObject:SetActive(true)
    view.skillBG.gameObject:SetActive(true)
    view.skillPoint.gameObject:SetActive(true)
    self:updateSkillPoint()

    for i = 1, 5 do
        local value, heroModel = self.newBattleData._ArmyIndex_HeroModel:TryGetValue(i)
        --local value1, soliderModel = self.newBattleData._ArmyIndex_SoliderModel:TryGetValue(i)

        if value == true then
            local heroItem = self.battleHeroItemList[i]
            -- heroItem.battleCardItem:setIcon(icon, iconTop)
            heroItem:setActive(true)

            heroItem:setHeroModel(heroModel)
            local isExistSoldier, soldierModel = self.newBattleData._ArmyIndex_SoliderModel:TryGetValue(i)
            if isExistSoldier then
                heroItem:setSoldierModel(soldierModel)
            else
                heroItem:setSoldierModel(nil)
            end

        -- elseif value1 == true then 
        --     local soldierItem = self.battleSoldierItemList[i]
        --     local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", soliderModel.icon .. "_A")
        --     print(icon)
        --     soldierItem:setActive(true)
        end
    end

    for i = 6, 14 do
        local value, id = self.newBattleData._OperOrder_ModelIdDict:TryGetValue(i)
        if value == true then 
            local value1, skillModel = self.newBattleData._SkillModelDict:TryGetValue(id)
            if value1 == true then
                local skillItem = nil
                if i <= 10 then
                    skillItem = self.battleHeroSkillItemList[i - 5]
                    if skillModel.skillCd ~= 0 then
                        self.heroSkill_Oper_MaxCdDict[i] = skillModel.skillCd / 1000
                    end
                    local value2, heroModel = self.newBattleData._ArmyIndex_HeroModel:TryGetValue(i - 5)
                    if value2 == true then
                        local heroData = cfg.getCfg("hero", heroModel.cfgId)
                        local skillData = cfg.getCfg("skill", self.newBattleData._SkillModelDict[heroModel.skill1].cfgId)
                        skillItem:setQuality(skillData.quality, heroData)
                    end
                    self:heroSkillReleaseDistance(i, false)
                    skillItem:setActive(false)
                else
                    skillItem = self.battleSkillItemList[i - 10]
                    local skillData = cfg.getCfg("skill", skillModel.cfgId)
                    skillItem:setQuality(skillData.quality)
                    skillItem:setActive(true)
                end

                local icon = gg.getSpriteAtlasName("Skill_A2_Atlas", skillModel.icon .. "_A2")
                skillItem:setIcon(icon)
                --skillItem.battleCardItem:setIcon(icon)
            end
        end
    end
end

-- ""
function PnlBattle:onClickOperOrder(order)
    if order <= 5 or (order > 10 and order <= 14) then
        self.battleMono:OnOperOrder(order)
    elseif order <= 10 then
        self.battleMono:OnClickHeroSkill(order)
    end

    -- if order > 5 and order <= 10 then
    --     self:ShowSkillMissTip(order - 5)
    -- end
end

function PnlBattle:onReturn2Main()
    -- BattleData.ResultDelay = 0
    self.battleMono:EndGame()
end

function PnlBattle:onBtnEndBattle()
    self.view.btnReturn2Main:SetActiveEx(true)
    self.view.btnEndBattle:SetActiveEx(false)
end

function PnlBattle:onBtnEndReport()
    self.battleMono:EndGame()
end

function PnlBattle:updateSkillPoint()
    local view = self.view
    local skillStrList = string.split(tostring(self.newBattleData._SkillPoints), ":")
    local skillNum = tonumber(skillStrList[1])
    view.txtSkillPoint.text = skillNum
end

function PnlBattle:heroSkillCdChange(oper, cd)
    local maxCd = self.heroSkill_Oper_MaxCdDict[oper]
    if maxCd == nil or maxCd == 0 then
        return 
    end

    local cdItem = self.view.heroSkillCdTextList[oper - 5]
    cdItem.text = cd

    if cd <= 0 then
        self:showHeroSkillItem(oper, true, cdItem)
    else
        if cdItem.gameObject.activeSelf == false then
            self:showHeroSkillItem(oper, false, cdItem)
        end
    end
end

function PnlBattle:heroSkillReleaseDistance(oper, value)
    local cdItem = self.view.heroSkillCdTextList[oper - 5]
    self:showHeroSkillItem(oper, value, cdItem)
    cdItem.gameObject:SetActive(false)
end

function PnlBattle:showHeroSkillItem(oper, value, cdItem)
    if value then
        cdItem.gameObject:SetActive(false)
        self.view.heroSkillMaskList[oper - 5]:SetActive(false)
    else
        cdItem.gameObject:SetActive(true)
        self.view.heroSkillMaskList[oper - 5]:SetActive(true)
    end
end

function PnlBattle:updateTime(time)
    if (string.match(tostring(self.newBattleData._BattleType ), "0") == nil) then
        self.view.txtRePlayTime.text = os.date("%M:%S", time)
    else
        self.view.txtTime.text = os.date("%M:%S", time)
    end
end

function PnlBattle:showTips(tips)
    gg.uiManager:showTip(Utils.getText(tips))
end

function PnlBattle:showResult(value)
    BattleData.setIsBattleEnd(true)
end

function PnlBattle:endBattle(json)
    gg.battleManager.isInBattle = false
    -- json""endgame""，""
    if json == nil then
        BattleUtil.returnFromResult()
        self:close()
        return
    end

    local endBattle = cjson.decode(json)
    local operates = {}
    local soliders = {}

    for k, v in pairs(endBattle.operates) do
        operates[k] = {}
        operates[k].GameFrame = v.GameFrame
        operates[k].Order = v.Order
        operates[k].X = v.X
        operates[k].Y = v.Y
        operates[k].Z = v.Z
    end

    for k, v in pairs(endBattle.soliders) do
        soliders[k] = {}
        soliders[k].id = v.id
        soliders[k].dieCount = v.dieCount
        soliders[k].cfgId = v.cfgId
        soliders[k].index = v.index
    end

    BattleData.C2S_Player_EndBattle(endBattle.battleId, endBattle.bVersion, endBattle.ret, endBattle.signinPosId,
        operates, soliders, endBattle.endStep, endBattle.destoryDefendCount, endBattle.destoryDevelopCount,
        endBattle.destoryEconomyCount)
end

-- ""
function PnlBattle:hideOperUI(isGuide)
    local view = self.view
    view.skillPoint.gameObject:SetActive(false)

    -- for key, value in pairs(self.battleSoldierItemList) do
    --     value:setActive(false)
    -- end

    for key, value in pairs(self.battleHeroItemList) do
        value:setActive(false)
    end

    for key, value in pairs(self.battleHeroSkillItemList) do
        value:setActive(false)
    end

    for key, value in pairs(self.battleSkillItemList) do
        value:setActive(false)
    end

    -- if self.args.guideNode ~= nil then
    --     self.view.rePlayTimeRoot:SetActive(false)
    -- else
    --     self.view.rePlayTimeRoot:SetActive(true)
    -- end

    if string.match(tostring(self.newBattleData._BattleType ), "0") == nil then
        view.rePlayBtnRoot:SetActive(true and not self.args.guideNode)
        view.rePlayTimeRoot:SetActive(true)
        view.imgPause:SetActive(true)
        view.imgPlay:SetActive(false)
        view.txtSpeed.text = "1"
        view.time:SetActive(false)
        view.bgTop:SetActive(false)
        view.bgBottom:SetActive(false)
        view.playerName:SetActive(false)

        if not isGuide then
            view.rePlayTimeRoot:SetActive(false)
        else
            view.rePlayTimeRoot:SetActive(true)
        end
    else
        view.rePlayBtnRoot:SetActive(false)
        view.rePlayTimeRoot:SetActive(false)
        view.time:SetActive(true)
        view.bgTop:SetActive(true)
        view.bgBottom:SetActive(true)
        view.playerName:SetActive(true)
    end
end

function PnlBattle:onHide()
    local view = self.view

    self:releaseEvent()

    -- for k, v in pairs(self.battleSoldierItemList) do
    --     v:setItemGray(false)
    -- end

    for key, value in pairs(self.battleHeroItemList) do
        value:release()
    end

    
    for key, value in pairs(self.battleHeroSkillItemList) do
        value:release()
    end

    for key, value in pairs(self.battleSkillItemList) do
        value:release()
    end

    self.isShowBattleDetail = nil

    self.battleMono.ShowOperUI = nil
    self.battleMono.CloseOperUI = nil
    self.battleMono.BattleLogic.OpenOperUI = nil
    self.battleMono.BattleLogic.UpdateTime = nil
    self.battleMono.UpdateSkillCost = nil
    self.battleMono.BattleLogic.BattleStageChange = nil
    self.battleMono.BattleLogic.ShowResult = nil
    self.battleMono.BattleLogic.EndBattle = nil
    self.battleMono.CurrOrderChange = nil
    CS.NewGameData._FightManager.UpdateSkillPoint = nil
    CS.NewGameData._FightManager.OnHeroKilled = nil
    self.battleMono.BattleLogic.HeroSkillCdChange = nil
    self.battleMono.BattleLogic.HeroSkillReleaseDistance = nil
    self.battleMono.ActionShowTips = nil
    self.battleMono.BattleLogic.ActionShowTips = nil
    self.battleMono.ShowSkillMissTip = nil
    gg.battleManager.isInBattle = false
    gg.battleManager.isInBattleServer = false

    self.operUITable = nil
    self.terrain = nil
    self.mainCamera = nil
    self.battleMono = nil
    self.newBattleData = nil
    self.closeColor = nil
    self.openColor = nil

    self.battleHeroItemList = nil
    self.battleHeroSkillItemList = nil
    self.battleSkillItemList = nil
    self.battleOperItemList = nil

    self.heroSkill_Oper_MaxCdDict = nil
    CS.NewGameData._FightManager.OnHeroKilled = nil
end

function PnlBattle:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnReturn2Main):SetOnClick(function()
        self:onReturn2Main()
    end, "event:/UI_button_click", "se_UI", false)

    CS.UIEventHandler.Get(view.btnPause):SetOnClick(function()
        self:onPauseBattle()
    end, "event:/UI_button_click", "se_UI", false)

    CS.UIEventHandler.Get(view.btnAddSpeed):SetOnClick(function()
        self:onAddBattleSpeed()
    end, "event:/UI_button_click", "se_UI", false)

    --gg.event:addListener("onPsEnd", self)

    self:setOnClick(view.btnBattleMessage, gg.bind(self.onBtnBattleMessage, self))
    self:setOnClick(view.btnRefreshBattleMessage, gg.bind(self.onBtnRefreshBattleMessage, self))
    self:setOnClick(view.btnAddMaxHp, gg.bind(self.onBtnAddMaxHp, self))
    self:setOnClick(view.btnSkillPoint, gg.bind(self.onBtnAddSkillPoint, self))
    self:setOnClick(view.btnEditBattle, gg.bind(self.onBtnEditBattle, self))
    self:setOnClick(view.btnEditSignalSkill, gg.bind(self.onBtnEditSignalSkill, self))

    self:setOnClick(view.btnEndBattle, gg.bind(self.onBtnEndBattle, self))
    self:setOnClick(view.btnEndReport, gg.bind(self.onBtnEndReport, self))
end

function PnlBattle:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnReturn2Main)
    CS.UIEventHandler.Clear(view.btnPause)
    CS.UIEventHandler.Clear(view.btnAddSpeed)

    --gg.event:removeListener("onPsEnd", self)
    self:stopPsTimer()
end

function PnlBattle:onDestroy()
    local view = self.view
    -- for key, value in pairs(self.battleSoldierItemList) do
    --     value:release()
    -- end
    -- self.battleHeroItem:release()
    -- self.battleHeroSkillItem:release()

    -- self.atkCardItem:release()
    -- self.defCardItem:release()
end

-- function PnlBattle:onPsStart()
--     self.view.psStart:SetActive(true)
--     self.view.psEnd:SetActive(false)
-- end

-- function PnlBattle:onPsEnd()
--     self.view.psStart:SetActive(false)
--     self.view.psEnd:SetActive(true)
--     self:stopPsTimer()
--     self.psTimer = gg.timer:startTimer(6, function()
--         self.view.psStart:SetActive(false)
--         self.view.psEnd:SetActive(false)
--         self:stopPsTimer()
--     end)
-- end

function PnlBattle:stopPsTimer()
    if self.psTimer then
        gg.timer:stopTimer(self.psTimer)
        self.psTimer = nil
    end
end

function PnlBattle:onSetBattleAtkCard()
    self.atkCard = gg.battleManager.atkCardId
    self.defCard = self.args.battleInfo.defenseCards[1]

    if self.atkCard then
        self.atkCardItem:setActive(true)
        self.atkCardItem:setData(self.atkCard)
    end

    if self.defCard then
        self.defCardItem:setActive(true)
        self.defCardItem:setData(self.defCard)
    end
end

function PnlBattle:onBtnBattleMessage()
    gg.battleManager:openBattleMessage()
end

function PnlBattle:onBtnAddMaxHp()
    self.battleMono:AddMaxHp()
end

function PnlBattle:onBtnAddSkillPoint()
    self.battleMono:AddSkillPoint()
end

function PnlBattle:onBtnEditBattle()
    gg.uiManager:openWindow("PnlEditBattle")
end

function PnlBattle:onBtnEditSignalSkill()
    self.selectSignalSkill = not self.selectSignalSkill
    self.battleMono.OperSignalSkill = self.selectSignalSkill
    self.view.imgSelectSignalSkill:SetActiveEx(self.selectSignalSkill)
end

function PnlBattle:onBtnRefreshBattleMessage()
    self.battleMono:RefreshBattleDetail()
end

-- guide
-- override
function PnlBattle:getGuideRectTransform(guideCfg)
    if  guideCfg.otherArgs then
        if self.stage ~= guideCfg.otherArgs[1] then
            return
        end
    
        -- if guideCfg.otherArgs[2] == "Solider" then
        --     return self.view.soliderBtnList[tonumber(guideCfg.viewFuncName)]
    
        if guideCfg.otherArgs[2] == "BattleHeroItem" then
            -- return self.view.battleHeroItem
    
            return self.battleHeroItemList[guideCfg.otherArgs[3]].transform
    
        elseif guideCfg.otherArgs[2] == "BattleHeroSkillItem" then
            return self.view.btnHeroSkill
    
        elseif guideCfg.otherArgs[2] == "Skill" then
            return self.battleSkillItemList[guideCfg.otherArgs[3]]
    
        elseif guideCfg.otherArgs[2] == "heroSkill" then
            return self.battleHeroSkillItemList[guideCfg.otherArgs[3]].transform
    
        end

    end

    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

-- override
function PnlBattle:triggerGuideClick(guideCfg)
    if  guideCfg.otherArgs then
        if guideCfg.otherArgs[2] == "Solider" then
            self:onClickOperOrder(tonumber(guideCfg.viewFuncName))
            return

        elseif guideCfg.otherArgs[2] == "BattleHeroItem" then
            -- self:onClickOperOrder(9)
            self.battleHeroItemList[guideCfg.otherArgs[3]]:onBtnItem()
            return

        elseif guideCfg.otherArgs[2] == "BattleHeroSkillItem" then
            self:onClickOperOrder(10)
            return

        elseif guideCfg.otherArgs[2] == "Skill" then
            -- self:onClickOperOrder(tonumber(guideCfg.viewFuncName) + 10)
            self.battleSkillItemList[guideCfg.otherArgs[3]]:onBtnItem()
            return

        elseif guideCfg.otherArgs[2] == "heroSkill" then
            self.battleHeroSkillItemList[guideCfg.otherArgs[3]]:onBtnItem()
            return
        end
    end

    return ggclass.UIBase.triggerGuideClick(self, guideCfg)

end

PnlBattle.GUIDE_ONLY_SHOW_HERO = "GUIDE_ONLY_SHOW_HERO"
PnlBattle.GUIDE_SHOW_HERO_SKILL = "GUIDE_SHOW_HERO_SKILL"
PnlBattle.GUIDE_SHOW_WARSHIP_SKILL = "GUIDE_SHOW_WARSHIP_SKILL"


-- PnlBattle.GUIDE_HIDE_ALL = "GUIDE_HIDE_ALL"
-- PnlBattle.GUIDE_SHOW_HERO = "GUIDE_SHOW_HERO"

function PnlBattle:onSetGuideOperate(_, setType)
    -- print("tttttttttttttttttttttt", setType)

    if setType == PnlBattle.GUIDE_ONLY_SHOW_HERO then
        self.view.layoutHeros:SetActiveEx(true)
        self.view.layoutHeroSkills:SetActiveEx(false)
        self.view.layoutSkill:SetActiveEx(false)
    elseif setType == PnlBattle.GUIDE_SHOW_HERO_SKILL then
        self.view.layoutHeroSkills:SetActiveEx(true)
    elseif setType == PnlBattle.GUIDE_SHOW_WARSHIP_SKILL then
        self.view.layoutSkill:SetActiveEx(true)
    end
end

----------------------------

function PnlBattle:onPauseBattle()
    local view = self.view
    if self.battleSpeed == 0 then
        self.battleSpeed = 1
        view.imgPause:SetActive(true)
        view.imgPlay:SetActive(false)
        view.txtSpeed.text = "1"
    else
        self.battleSpeed = 0
        view.imgPause:SetActive(false)
        view.imgPlay:SetActive(true)
    end

    self.battleMono.BattleLogic:ChangeBattleSpeed(self.battleSpeed)
end

function PnlBattle:onAddBattleSpeed()
    local view = self.view
    if self.battleSpeed == 1 then
        self.battleSpeed = 2
        view.txtSpeed.text = "2"
    else
        self.battleSpeed = 1
        view.txtSpeed.text = "1"
    end

    view.imgPause:SetActive(true)
    view.imgPlay:SetActive(false)

    self.battleMono.BattleLogic:ChangeBattleSpeed(self.battleSpeed)
end

function PnlBattle:onLongPressSkill(skillData, tarn)
    self.view.boxSkillTips:SetActive(true)
    local pos = self.pnlTransform:InverseTransformPoint(tarn.position)
    if tarn.name == "Skill5" then
        self.view.boxSkillTips.transform:Find("Bg"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosX(-138)
    else
        self.view.boxSkillTips.transform:Find("Bg"):GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosX(0)
    end
    self.view.boxSkillTips.transform.anchoredPosition = Vector2.New(pos.x, pos.y + 137)
    self.view.boxSkillTips.transform:Find("Bg"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(skillData.desc)
    self.view.txtSkillDec.text = Utils.getText(skillData.desc)
    self.view.txtSkillName.text = Utils.getText(skillData.languageNameID)
end

function PnlBattle:onHideSkillDesc()
    self.view.boxSkillTips:SetActive(false)
end

function PnlBattle:OnHeroKilled(index)
    self.view.heroSkillMaskList[index].gameObject:SetActive(false)
    self.view.heroSkillCdTextList[index].gameObject:SetActive(false)
    self.battleHeroSkillItemList[index]:setItemGray(true)
end

function PnlBattle:ShowSkillMissTip(skillNum)
    -- self:showTips(skillNum)

    gg.uiManager:showTipsNode("miss", "skill" .. skillNum, self.view.heroSkillBtnList[skillNum].transform.position)

    -- showTipsNode

    -- self.view.heroSkillBtnList
end

return PnlBattle
