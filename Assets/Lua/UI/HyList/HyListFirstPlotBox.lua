HyListFirstPlotBox = HyListFirstPlotBox or class("HyListFirstPlotBox", ggclass.UIBaseItem)

HyListFirstPlotBox.events = {"onFirstGetGridRankChange"}

function HyListFirstPlotBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function HyListFirstPlotBox:onInit()
    self.itemList = {}
    self.scrollView = UILoopScrollView.new(self:Find("ScrollView"), self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.hyListFirstPlotItem = HyListFirstPlotItem.new(self:Find("HyListFirstPlotItem"))
    self.txtTips = self:Find("TxtTips", UNITYENGINE_UI_TEXT)
end

function HyListFirstPlotBox:onOpen(...)
    self:onFirstGetGridRankChange()
    RankData.C2S_Player_FirstGetGridRank()
end

function HyListFirstPlotBox:onFirstGetGridRankChange()
    if not RankData.FirstGetGridRankData then
        self.scrollView:setDataCount(0)
        self.hyListFirstPlotItem:setActive(false)
        self.txtTips.transform:SetActiveEx(true)
        return
    end

    self.dataList = RankData.FirstGetGridRankData.list
    self.scrollView:setDataCount(#self.dataList)

    local selfRank = RankData.FirstGetGridRankData.selfRank

    if selfRank and selfRank.index > 0 then
        self.hyListFirstPlotItem:setActive(true)
        self.txtTips.transform:SetActiveEx(false)
        self.hyListFirstPlotItem:setData(selfRank, true)
    else
        self.hyListFirstPlotItem:setActive(false)
        self.txtTips.transform:SetActiveEx(true)
    end
end

function HyListFirstPlotBox:onRenderItem(obj, index)
    local item = HyListFirstPlotItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index])
end

function HyListFirstPlotBox:onClose()

end

function HyListFirstPlotBox:onRelease()
    self.scrollView:release()

    self.hyListFirstPlotItem:release()
end

-----------------------------------------------------------------------

HyListFirstPlotItem = HyListFirstPlotItem or class("HyListFirstPlotItem", ggclass.UIBaseItem)

function HyListFirstPlotItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function HyListFirstPlotItem:onInit()
    self.hyListBaseItem = HyListBaseItem.new(self:Find("HyListBaseItem"))
end

function HyListFirstPlotItem:onRelease()
    self.hyListBaseItem:release()
end

function HyListFirstPlotItem:setData(rankData, isSelf)
    self.hyListBaseItem:setRank(rankData.index, isSelf)
    self.hyListBaseItem:setHead(rankData.headIcon, rankData.name)

    local rewardCfg = nil
    for key, value in pairs(ActivityUtil.getActivityRewardMap()[constant.FIRST_GET_GRID_REWARD]) do
        if value.startRank <= rankData.index and value.endRank >= rankData.index then
            rewardCfg = value
        end
    end

    local rewardList1, rewardList2 = ActivityUtil.getActivitiesRewardList(rewardCfg)
    self.hyListBaseItem:setRewardList(rewardList1)
end
