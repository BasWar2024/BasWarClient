

PnlPvpRewardRule = class("PnlPvpRewardRule", ggclass.UIBase)

function PnlPvpRewardRule:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onRankChange" }
end

PnlPvpRewardRule.TYPE_HYD = 1
PnlPvpRewardRule.TYPE_MIT = 2
PnlPvpRewardRule.TYPE_DESC = 3

function PnlPvpRewardRule:onAwake()
    self.view = ggclass.PnlPvpRewardRuleView.new(self.pnlTransform)

    self.leftBtnViewBgBtnsBox = LeftBtnViewBgBtnsBox.new(self.view.leftBtnViewBgBtnsBox)

    self.typeMessage = {
        [PnlPvpRewardRule.TYPE_HYD] = {
            layout = self.view.layoutHydRule,
            func = gg.bind(self.refreshHyd, self),
        },
        [PnlPvpRewardRule.TYPE_MIT] = {
            layout = self.view.layoutMitRule,
            func = gg.bind(self.refreshMit, self),
        },
        [PnlPvpRewardRule.TYPE_DESC] = {
            layout = self.view.layoutDescRule,
            func = gg.bind(self.refreshDesc, self),
        },
    }

    self.ruleItemList = {}
    self.ruleScrollView = UIScrollView.new(self.view.ruleScrollView, "PvpRewardRuleItem", self.ruleItemList)
    self.ruleScrollView:setRenderHandler(gg.bind(self.onRenderRuleItem, self))
end

function PnlPvpRewardRule:onShow()
    self:bindEvent()
    RankData.C2S_Player_Rank_Info(RankData.RANK_TYPE_PVP)

    self.leftBtnViewBgBtnsBox:setBtnDataList({
        {nemeKey = "pvp_JackpotReward_HyReward", callback = gg.bind(self.refresh, self, PnlPvpRewardRule.TYPE_HYD)},
        {nemeKey = "pvp_JackpotReward_MitReward", callback = gg.bind(self.refresh, self, PnlPvpRewardRule.TYPE_MIT)},
        {nemeKey = "pvp_JackpotReward_Rules", callback = gg.bind(self.refresh, self, PnlPvpRewardRule.TYPE_DESC)},
     }, 1)

    self.leftBtnViewBgBtnsBox:open()
end

function PnlPvpRewardRule:onRankChange(event, rankType, version)
    if rankType == RankData.RANK_TYPE_PVP then
        if self.showType == PnlPvpRewardRule.TYPE_MIT then
            self:refresh(PnlPvpRewardRule.TYPE_MIT)
        elseif self.showType == PnlPvpRewardRule.TYPE_HYD then
            self:refresh(PnlPvpRewardRule.TYPE_HYD)
        end
    end
end

function PnlPvpRewardRule:refresh(type)
    self.showType = type

    for key, value in pairs(self.typeMessage) do
        if key == type then
            value.layout:SetActiveEx(true)
            value.func()
        else
            value.layout:SetActiveEx(false)
        end
    end
end

--hyd
function PnlPvpRewardRule:refreshHyd()
    local boxRewardList = self.view.boxRewardList

    for i = 1, 6, 1 do
        local stageData = BattleData.pvpBackGroundCfg.stage[6 - (i - 1)]
        local stage = stageData.stage

        local BoxReward = boxRewardList[i]

        local txtDanName = BoxReward:Find("TxtDanName"):GetComponent(UNITYENGINE_UI_TEXT)
        txtDanName.text = Utils.getText("pvpStageName_" .. stage)

        local gradientDanName = txtDanName.transform:GetComponent(typeof(CS.TextGradient))
        gradientDanName:SetColor(constant.COLOR_PVP_STAGE[stage][1], constant.COLOR_PVP_STAGE[stage][2])

        local iconDan = BoxReward:Find("IconDan"):GetComponent(UNITYENGINE_UI_IMAGE)
        gg.setSpriteAsync(iconDan, string.format("PvpStage_Atlas[dan_icon_%s]", stage))

        local bgIcon = BoxReward:Find("BgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
        gg.setSpriteAsync(bgIcon, string.format("PvpStage_Atlas[dan round_icon_%s]", stage))

        BoxReward:Find("TxtIntegral"):GetComponent(UNITYENGINE_UI_TEXT).text = stageData.score[1]
        BoxReward:Find("TxtShare"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("%.0f%%", stageData.ratio * 100)

        local imgHightLight = BoxReward:Find("ImgHightLight")

        if RankData.rankMap[RankData.RANK_TYPE_PVP] then
            local selfRank = RankData.rankMap[RankData.RANK_TYPE_PVP].selfRank
            local stageCfg = PvpUtil.bladge2StageCfg(selfRank.value)
            imgHightLight:SetActiveEx(stageCfg.stage == stage)
        else
            imgHightLight:SetActiveEx(false)
        end
    end
end

--mit
function PnlPvpRewardRule:refreshMit()
    self.mitDataList = BattleData.pvpBackGroundCfg.reward
    self.ruleScrollView:setItemCount(#self.mitDataList)
end

function PnlPvpRewardRule:onRenderRuleItem(obj, index)
    local item = PvpRewardRuleItem:getItem(obj)
    item:setData(self.mitDataList[index])
end

--desc
function PnlPvpRewardRule:refreshDesc()

end

function PnlPvpRewardRule:onHide()
    self:releaseEvent()
    self.leftBtnViewBgBtnsBox:close()
end

function PnlPvpRewardRule:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlPvpRewardRule:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlPvpRewardRule:onDestroy()
    local view = self.view
    self.ruleScrollView:release()
    self.leftBtnViewBgBtnsBox:release()
end

function PnlPvpRewardRule:onBtnClose()
    self:close()
end

---------------------------------------------------------------------------------------------------------
PvpRewardRuleItem = PvpRewardRuleItem or class("PvpRewardRuleItem", ggclass.UIBaseItem)
function PvpRewardRuleItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PvpRewardRuleItem:onInit()
    self.txtRank = self:Find("TxtRank", "Text")
    self.txtReward = self:Find("TxtReward", "Text")

    self.imgHightLight = self:Find("ImgHightLight")
end

function PvpRewardRuleItem:setData(data)
    self.data = data
    if data.max_rank == data.min_rank then
        self.txtRank.text = data.max_rank

        self.txtRank.color = UnityEngine.Color(0xff/0xff, 0xbc/0xff, 0x1a/0xff, 1)
        self.txtReward.color = UnityEngine.Color(0xff/0xff, 0xbc/0xff, 0x1a/0xff, 1)
    else
        self.txtRank.text = data.min_rank .. "-" .. data.max_rank

        self.txtRank.color = UnityEngine.Color(0xff/0xff, 0xff/0xff, 0xff/0xff, 1)
        self.txtReward.color = UnityEngine.Color(0xff/0xff, 0xff/0xff, 0xff/0xff, 1)
    end
    self.txtReward.text = math.floor(data.mit / 1000)

    self:refreshRank()
end

function PvpRewardRuleItem:refreshRank()
    local rankData = RankData.rankMap[RankData.RANK_TYPE_PVP]
    self.imgHightLight:SetActiveEx(false)
    if rankData and rankData.selfRank then
        local selfRank = rankData.selfRank
        if selfRank.index >= self.data.min_rank and selfRank.index <= self.data.max_rank then
            self.imgHightLight:SetActiveEx(true)
        end
    end
end
---------------------------------------------------------------------------------------------------------
return PnlPvpRewardRule