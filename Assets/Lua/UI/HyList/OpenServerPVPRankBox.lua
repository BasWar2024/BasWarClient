OpenServerPVPRankBox = OpenServerPVPRankBox or class("OpenServerPVPRankBox", ggclass.UIBaseItem)

OpenServerPVPRankBox.events = {"onRankChange"}

function OpenServerPVPRankBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function OpenServerPVPRankBox:onInit()
    self.itemList = {}
    self.scrollView = UILoopScrollView.new(self:Find("ScrollView"), self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.openServerPVPRankItem = OpenServerPVPRankItem.new(self:Find("OpenServerPVPRankItem"))
    self.txtTips = self:Find("TxtTips", UNITYENGINE_UI_TEXT)
end

function OpenServerPVPRankBox:onOpen(...)
    self:onRankChange()
    RankData.C2S_Player_Rank_Info(RankData.RANK_TYPE_PVP)
end

function OpenServerPVPRankBox:onRankChange(_, rankType, version)
    if rankType ~= RankData.RANK_TYPE_PVP then
        return
    end

    local rankData = RankData.rankMap[RankData.RANK_TYPE_PVP]
    if not rankData then
        self.scrollView:setDataCount(0)
        self.openServerPVPRankItem:setActive(false)
        self.txtTips.transform:SetActiveEx(true)
        return
    end

    self.dataList = rankData.dataList
    self.scrollView:setDataCount(#self.dataList)

    local selfRank = rankData.selfRank
    if selfRank and selfRank.index > 0 then
        self.openServerPVPRankItem:setActive(true)
        self.txtTips.transform:SetActiveEx(false)
        self.openServerPVPRankItem:setData(selfRank, true)
    else
        self.openServerPVPRankItem:setActive(false)
        self.txtTips.transform:SetActiveEx(true)
    end
end

function OpenServerPVPRankBox:onRenderItem(obj, index)
    local item = OpenServerPVPRankItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index])
end

function OpenServerPVPRankBox:onClose()

end

function OpenServerPVPRankBox:onRelease()
    self.scrollView:release()

    self.openServerPVPRankItem:release()
end

-----------------------------------------------------------------------

OpenServerPVPRankItem = OpenServerPVPRankItem or class("OpenServerPVPRankItem", ggclass.UIBaseItem)

function OpenServerPVPRankItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function OpenServerPVPRankItem:onInit()
    self.hyListBaseItem = HyListBaseItem.new(self:Find("HyListBaseItem"))
end

function OpenServerPVPRankItem:onRelease()
    self.hyListBaseItem:release()
end

function OpenServerPVPRankItem:setData(rankData, isSelf)

    self.hyListBaseItem:setRank(rankData.index, isSelf)
    self.hyListBaseItem:setHead(rankData.headIcon, rankData.name)

    local rewardCfg = nil
    for key, value in pairs(ActivityUtil.getActivityRewardMap()[constant.OPEN_UNION_REWARD]) do
        if value.startRank <= rankData.index and value.endRank >= rankData.index then
            rewardCfg = value
        end
    end

    local rewardList1, rewardList2 = ActivityUtil.getActivitiesRewardList(rewardCfg)
    self.hyListBaseItem:setRewardList(rewardList1)
end
