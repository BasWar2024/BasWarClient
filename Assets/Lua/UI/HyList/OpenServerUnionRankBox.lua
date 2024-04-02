OpenServerUnionRankBox = OpenServerUnionRankBox or class("OpenServerUnionRankBox", ggclass.UIBaseItem)

OpenServerUnionRankBox.events = {"onUnionRankChange"}

function OpenServerUnionRankBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function OpenServerUnionRankBox:onInit()
    self.itemList = {}
    self.scrollView = UILoopScrollView.new(self:Find("ScrollView"), self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.openServerUnionRankItem = OpenServerUnionRankItem.new(self:Find("OpenServerUnionRankItem"))
    self.txtTips = self:Find("TxtTips", UNITYENGINE_UI_TEXT)
end

function OpenServerUnionRankBox:onOpen(...)
    self:onUnionRankChange()
    UnionData.C2S_Player_StarmapMatchRank(UnionData.RANK_CORE)
end

function OpenServerUnionRankBox:onUnionRankChange()
    self.openServerUnionRankItem.transform:SetActiveEx(false)
    self.txtTips.transform:SetActiveEx(true)

    if not UnionData.unionRank then
        self.scrollView.transform:SetActiveEx(false)
        return
    end

    self.scrollView.transform:SetActiveEx(true)
    self.dataList = UnionData.unionRank.rankList
    self.scrollView:setDataCount(#self.dataList)

    if UnionData.unionData then
        for key, value in pairs(self.dataList) do
            if value.unionId == UnionData.unionData.unionId then
                self.openServerUnionRankItem.transform:SetActiveEx(true)
                self.txtTips.transform:SetActiveEx(false)
                self.openServerUnionRankItem:setData(value, true)
                break
            end
        end
    end
end

function OpenServerUnionRankBox:onRenderItem(obj, index)
    local item = OpenServerUnionRankItem:getItem(obj, self.itemList, self)
    item:setData(self.dataList[index])
end

function OpenServerUnionRankBox:onClose()

end

function OpenServerUnionRankBox:onRelease()
    self.scrollView:release()

    self.openServerUnionRankItem:release()
end

-----------------------------------------------------------------------

OpenServerUnionRankItem = OpenServerUnionRankItem or class("OpenServerUnionRankItem", ggclass.UIBaseItem)

function OpenServerUnionRankItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function OpenServerUnionRankItem:onInit()
    self.hyListBaseItem = HyListBaseItem.new(self:Find("HyListBaseItem"))
end

function OpenServerUnionRankItem:onRelease()
    self.hyListBaseItem:release()
end

function OpenServerUnionRankItem:setData(data, isSelf)
    self.hyListBaseItem:setRank(data.index, isSelf)
    self.hyListBaseItem:setFlag(data.unionFlag, data.unionName)

    local rewardCfgList =  ActivityUtil.getActivityRewardMap()[constant.OPEN_UNION_REWARD]

    local rewardCfg = nil
    for key, value in pairs(rewardCfgList) do
        if value.startRank <= data.index and value.endRank >= data.index then
            rewardCfg = value
            break
        end
    end

    local rewardList1, rewardList2 = ActivityUtil.getActivitiesRewardList(rewardCfg)
    self.hyListBaseItem:setRewardList(rewardList1, rewardList2)
end