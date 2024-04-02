
PnlRank = class("PnlRank", ggclass.UIBase)

function PnlRank:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = {"onRankChange" }
    self.needBlurBG = true
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN
end

function PnlRank:onAwake()
    self.view = ggclass.PnlRankView.new(self.pnlTransform)

    self.rankItemList = {}
    self.loopScrollView = UILoopScrollView.new(self.view.loopScrollView, self.rankItemList)
    self.loopScrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.view.leftBtnViewBgBtnsBox:setBtnDataList({
        {
            name = "MEDAL LIST", 
            callback = gg.bind(self.showType, self, constant.RANK_TYPE_BADGE), 
            icon = "Rank_Atlas[Medal list_icon_A]",
            iconSelect = "Rank_Atlas[Medal list_icon_B]",
        },
        {
            name = "TRADING LIST", 
            callback = gg.bind(self.showType, self, constant.RANK_TYPE_COST_MIT), 
            icon = "Rank_Atlas[List of trading_icon_A]",
            iconSelect = "Rank_Atlas[List of trading_icon_B]",
        },
        {
            name = "GUILD LIST", 
            callback = gg.bind(self.showType, self, constant.RANK_TYPE_PLANET), 
            icon = "Rank_Atlas[The association list_icon_A]",
            iconSelect = "Rank_Atlas[The association list_icon_B]",
        },
    })
    self.rankItem = RankItem.new(self.view.rankItem)
end

function PnlRank:onShow()
    self:bindEvent()
    --self:showType(1)

    self.view.leftBtnViewBgBtnsBox:onBtn(1)
end

function PnlRank:onHide()
    self:releaseEvent()
end

function PnlRank:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    self:setOnClick(view.btnFetch, gg.bind(self.onBtnFetch, self))
end

function PnlRank:onRenderItem(obj, index)
    local item = RankItem:getItem(obj, self.rankItemList, self)
    item:setData(self.dataList[index], self.selectType)
end

-- function PnlRank:onRenderItemSize(dataIndex)
--     return CS.UnityEngine.Vector2(880, dataIndex * 10)-- 500 --dataIndex * 10
-- end

function PnlRank:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlRank:onDestroy()
    local view = self.view
    self.loopScrollView:release()
    self.view.leftBtnViewBgBtnsBox:release()
    self.rankItem:release()
end

function PnlRank:onBtnClose()
    self:close()
end

function PnlRank:showType(rankType)
    if self.selectType == rankType then
        return
    end
    self.selectType = rankType
    local view = self.view
    self:onRankChange(nil, rankType)
    RankData.C2S_Player_Rank_Info(rankType)

    view.layouPersonalTitle:SetActiveEx(false)
    view.layotDaoTitle:SetActiveEx(false)
    if rankType == constant.RANK_TYPE_BADGE or rankType == constant.RANK_TYPE_COST_MIT then
        view.layouPersonalTitle:SetActiveEx(true)
    else
        view.layotDaoTitle:SetActiveEx(true)
    end
end

function PnlRank:onRankChange(event, rankType, version)
    local view = self.view
    if rankType == self.selectType then
        if RankData.rankMap[self.selectType] then
            self.dataList = RankData.rankMap[self.selectType].dataList
            self.loopScrollView:setDataCount(#self.dataList)
            --self.loopScrollView:
            self.loopScrollView.component:Jump2DataIndex(1)
        else
            self.dataList = {}
            self.loopScrollView:setDataCount(0)
        end
    end
end

function PnlRank:onBtnFetch()
    -- self.view.loopScrollView.component:Scroll2DataIndex(self.view.loopScrollView.component.dataCount, 100)
    --self.view.loopScrollView.component:Jump2DataIndex(self.view.loopScrollView.component.dataCount, 1)
end

return PnlRank