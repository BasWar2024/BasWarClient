PnlLeagueRankReward = class("PnlLeagueRankReward", ggclass.UIBase)
PnlLeagueRankReward.infomationType = ggclass.UIBase.INFOMATION_RES

function PnlLeagueRankReward:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {}
    self.needBlurBG = true

end

function PnlLeagueRankReward:onAwake()
    self.view = ggclass.PnlLeagueRankRewardView.new(self.pnlTransform)

    self.rewardItemList = {}
    self.rewardScrollView = UILoopScrollView.new(self.view.rewardScrollView, self.rewardItemList)
    self.rewardScrollView:setRenderHandler(gg.bind(self.onRenderRewardItem, self))
end

function PnlLeagueRankReward:onShow()
    self:bindEvent()

    local cfgId = UnionData.unionRank.matchCfgId
    local matchCfg = cfg.match[cfgId]
    local seasonCfg, weedCfg = UnionUtil.getMatchCfg(matchCfg.season)

    self.rewardDataMap = {}
    for key, value in pairs(cfg.matchReward) do
        if value.cfgId == seasonCfg.rewardCfgId then
            self.rewardDataMap[value.startRank] = self.rewardDataMap[value.startRank] or {}
            self.rewardDataMap[value.startRank].seasonCfg = value
        end

        if weedCfg and value.cfgId == weedCfg.rewardCfgId then
            self.rewardDataMap[value.startRank] = self.rewardDataMap[value.startRank] or {}
            self.rewardDataMap[value.startRank].weedCfg = value
        end
    end

    self.rewardDataList = {}

    for key, value in pairs(self.rewardDataMap) do
        table.insert(self.rewardDataList, value)
    end
    table.sort(self.rewardDataList, function(a, b)
        return a.seasonCfg.startRank < b.seasonCfg.startRank
    end)

    self.rewardScrollView:setDataCount(#self.rewardDataList)
end


function PnlLeagueRankReward:onBtnDesc()
    
    -- gg.uiManager:openWindow("PnlDesc", {title = , desc = })
end

function PnlLeagueRankReward:onHide()
    self:releaseEvent()

end

function PnlLeagueRankReward:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnRank):SetOnClick(function()
        self:onBtnRank()
    end)
    self:setOnClick(view.btnDesc, gg.bind(self.onBtnDesc, self))
end

function PnlLeagueRankReward:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnRank)

end

function PnlLeagueRankReward:onDestroy()
    local view = self.view
    self.rewardScrollView:release()
end

function PnlLeagueRankReward:onBtnClose()
    self:close()
end

function PnlLeagueRankReward:onBtnRank()
    gg.uiManager:openWindow("PnlLeagueRank", nil, function()
        self:close()
    end)
end

function PnlLeagueRankReward:onRenderRewardItem(obj, index)
    local item = LeagueRankRewardItem:getItem(obj, self.rewardItemList)
    item:setData(self.rewardDataList[index], index)
end

-------------------------------------------------------------------------------------------------
LeagueRankRewardItem = LeagueRankRewardItem or class("LeagueRankRewardItem", ggclass.UIBaseItem)

function LeagueRankRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData

end

function LeagueRankRewardItem:onInit()
    self.imgBg = self:Find("ImgBg", UNITYENGINE_UI_IMAGE)
    self.txtRank = self:Find("TxtRank", UNITYENGINE_UI_TEXT)
    self.txtReward = self:Find("TxtReward", UNITYENGINE_UI_TEXT)
    self.txtReward2 = self:Find("TxtReward2", UNITYENGINE_UI_TEXT)
end

function LeagueRankRewardItem:setData(data, index)
    self.imgBg.gameObject:SetActiveEx(index % 2 ~= 0)

    local seasonCfg = data.seasonCfg
    local weedCfg = data.weedCfg

    if seasonCfg.startRank == seasonCfg.endRank then
        self.txtRank.text = seasonCfg.startRank
    else
        self.txtRank.text = seasonCfg.startRank .. "-" .. seasonCfg.endRank
    end
    if seasonCfg.endRank <= 3 then
        self.txtRank.color = Color.New(0xff / 0xff, 0xe5 / 0xff, 0x36 / 0xff)
        self.txtReward.color = Color.New(0xff / 0xff, 0xe5 / 0xff, 0x36 / 0xff)
        self.txtReward2.color = Color.New(0xff / 0xff, 0xe5 / 0xff, 0x36 / 0xff)
    else
        self.txtRank.color = Color.New(1, 1, 1, 1)
        self.txtReward.color = Color.New(1, 1, 1, 1)
        self.txtReward2.color = Color.New(1, 1, 1, 1)
    end

    if weedCfg then
        self.txtReward.text = string.format("%.0f", weedCfg.mit / 1000) -- Utils.getShowRes(weedCfg.mit)
    else
        self.txtReward.text = Utils.getShowRes(0)
    end

    self.txtReward2.text = string.format("%.0f", seasonCfg.mit / 1000) -- Utils.getShowRes(seasonCfg.mit)

end

-------------------------------------------------------------------------------------------------

return PnlLeagueRankReward
