

PnlPvpHistory = class("PnlPvpHistory", ggclass.UIBase)

function PnlPvpHistory:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlPvpHistory:onAwake()
    self.view = ggclass.PnlPvpHistoryView.new(self.pnlTransform)

    self.historyItemList = {}
    self.historyScrollView = UIScrollView.new(self.view.historyScrollView, "PvpHistoryItem", self.historyItemList)
    self.historyScrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function PnlPvpHistory:onShow()
    self:bindEvent()
    if not BattleData.pvpMatchRewardRecords then
        return
    end
    self.dataList = BattleData.pvpMatchRewardRecords.records
    self.historyScrollView:setItemCount(#self.dataList)
end

function PnlPvpHistory:onHide()
    self:releaseEvent()

end

function PnlPvpHistory:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    self:setOnClick(view.btnConfirm, gg.bind(self.close, self))
end

function PnlPvpHistory:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlPvpHistory:onDestroy()
    local view = self.view

end

function PnlPvpHistory:onBtnClose()
    self:close()
end

function PnlPvpHistory:onRenderItem(obj, index)
    local item = PvpHistoryItem:getItem(obj, self.historyItemList)
    item:setData(self.dataList[index], index)
    
end

------------------------------------------------------------------------------
PvpHistoryItem = PvpHistoryItem or class("PvpHistoryItem", ggclass.UIBaseItem)
function PvpHistoryItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PvpHistoryItem:onInit()
    self.imgBg = self:Find("ImgBg", "Image")
    self.txtTime = self:Find("TxtTime", "Text")
    self.txtSeason = self:Find("TxtSeason", typeof(CS.TextYouYU))
    self.imgStage = self:Find("ImgStage", "Image")
    self.txtScore = self:Find("TxtScore", "Text")
    self.txtRank = self:Find("TxtRank", "Text")
    self.txtReward1 = self:Find("TxtReward1", "Text")
    self.txtReward2 = self:Find("TxtReward2", "Text")
end

function PvpHistoryItem:setData(data, index)
    self.imgBg.gameObject:SetActiveEx(index % 2 ~= 0)
    -- self.txtTime.text = gg.time.dateYmdh(t)
    self.txtTime.text = gg.time.dateYmdh(data.rankTime)

    self.txtSeason.text = string.format("the %s season", data.season)
    
    local stageCfg = PvpUtil.bladge2StageCfg(data.score)
    gg.setSpriteAsync(self.imgStage, string.format("PvpStage_Atlas[dan_icon_%s]", stageCfg.stage))
    self.txtScore.text = data.score
    self.txtRank.text = data.rank

    self.txtReward1.text = 0
    self.txtReward2.text = 0

    for key, value in pairs(data.reward) do
        if value.resCfgId == constant.RES_CARBOXYL then
            self.txtReward1.text = Utils.getShowRes(value.count)
        elseif value.resCfgId == constant.RES_MIT then
            self.txtReward2.text = Utils.getShowRes(value.count)
        end
    end
end
------------------------------------------------------------------------------
return PnlPvpHistory