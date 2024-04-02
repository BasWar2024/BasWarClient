HyListBaseItem = HyListBaseItem or class("HyListBaseItem", ggclass.UIBaseItem)

HyListBaseItem.BGRANKNAME = {
    [1] = "HyList_Atlas[first baseboard_icon]",
    [2] = "HyList_Atlas[second baseboard_icon]",
    [3] = "HyList_Atlas[third baseboard_icon]"
}

HyListBaseItem.ICONRANKNAME = {
    [1] = "HyList_Atlas[first_icon_A]",
    [2] = "HyList_Atlas[first_icon_B]",
    [3] = "HyList_Atlas[first_icon_C]"
}

function HyListBaseItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function HyListBaseItem:onInit()
    self.layoutRank = self:Find("LayoutRank").transform

    self.bgTopRank = self.layoutRank:Find("BgTopRank"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.iconTopRank = self.layoutRank:Find("BgTopRank/IconTopRank"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtRank = self.layoutRank:Find("TxtRank"):GetComponent(UNITYENGINE_UI_TEXT)


    self.layoutSelfRank = self:Find("LayoutSelfRank").transform
    self.txtSelfRank = self.layoutSelfRank:Find("TxtSelfRank"):GetComponent(UNITYENGINE_UI_TEXT)

    self.iconHead = self:Find("BgHead/Mask/IconHead", UNITYENGINE_UI_IMAGE)
    self.txtName = self:Find("BgHead/TxtName", UNITYENGINE_UI_TEXT)

    self.rewardItemList = {}
    self.rewardScrollView = UIScrollView.new(self:Find("RewardScrollView"), "HyListRewardItem", self.rewardItemList) 
    self.rewardScrollView:setRenderHandler(gg.bind(self.onRenderReward, self))

    self.rewardItemList2 = {}
    self.rewardScrollView2 = UIScrollView.new(self:Find("RewardScrollView2"), "HyListRewardItem", self.rewardItemList2) 
    self.rewardScrollView2:setRenderHandler(gg.bind(self.onRenderReward2, self))
end

function HyListBaseItem:onRelease()
    self.rewardScrollView:release()
    self.rewardScrollView2:release()
end

function HyListBaseItem:setRank(rank, isSelf)
    if isSelf then
        self.layoutRank:SetActiveEx(false)
        self.layoutSelfRank:SetActiveEx(true)
        self.txtSelfRank.text = rank

    else
        self.layoutRank:SetActiveEx(true)
        self.layoutSelfRank:SetActiveEx(false)

        if rank <= 3 then
            self.bgTopRank.transform:SetActiveEx(true)
            self.txtRank.transform:SetActiveEx(false)
            gg.setSpriteAsync(self.bgTopRank, HyListBaseItem.BGRANKNAME[rank])
            gg.setSpriteAsync(self.iconTopRank, HyListBaseItem.ICONRANKNAME[rank])

        else
            self.bgTopRank.transform:SetActiveEx(false)
            self.txtRank.transform:SetActiveEx(true)
            self.txtRank.text = rank
        end
    end
end

function HyListBaseItem:onRenderReward(obj, index)
    local item = HyListRewardItem:getItem(obj, self.rewardItemList)
    item:setData(self.rewardList1[index])
end

function HyListBaseItem:onRenderReward2(obj, index)
    local item = HyListRewardItem:getItem(obj, self.rewardItemList2)
    item:setData(self.rewardList2[index])
end

local itemW = 105
local spancing = 0
local maxW = 224

function HyListBaseItem:refreshRewardLenth(scrollView, count)
    local width = math.min(maxW, (itemW + spancing) * count - spancing)
    scrollView.transform:SetRectSizeX(width)
end

------------------------""

function HyListBaseItem:setHead(head, name)
    gg.setSpriteAsync(self.iconHead, gg.getSpriteAtlasName("Head_Atlas", head))
    self.txtName.text = name
end

function HyListBaseItem:setFlag(flag, name)
    gg.setSpriteAsync(self.iconHead, gg.getSpriteAtlasName("ContryFlag_Atlas", cfg.flag[flag].icon))
    self.txtName.text = name
end

function HyListBaseItem:setRewardList(rewardList1, rewardList2)
    if rewardList1 then
        self.rewardScrollView.transform:SetActiveEx(true)
        self.rewardList1 = rewardList1
        local count = #rewardList1
        self.rewardScrollView:setItemCount(count)
        self:refreshRewardLenth(self.rewardScrollView, count)
    else
        self.rewardScrollView.transform:SetActiveEx(false)
    end

    if rewardList2 then
        self.rewardScrollView2.transform:SetActiveEx(true)
        self.rewardList2 = rewardList2
        local count = #rewardList2
        self.rewardScrollView2:setItemCount(count)
        self:refreshRewardLenth(self.rewardScrollView2, count)
    else
        self.rewardScrollView2.transform:SetActiveEx(false)
    end
end

------------------------------------------------


HyListRewardItem = HyListRewardItem or class("HyListRewardItem", ggclass.UIBaseItem)

function HyListRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function HyListRewardItem:onInit()
    self.activityRewardItem = ActivityRewardItem.new(self:Find("ActivityRewardItem"))
    self.txtReward = self:Find("bgCost/TxtReward", UNITYENGINE_UI_TEXT)
end

function HyListRewardItem:setData(reward)
    self.activityRewardItem:setData(reward)

    local count = reward.count or 1

    if reward.rewardType == constant.ACTIVITY_REWARD_RES then
        count = Utils.getShowRes(count)
    end

    self.txtReward.text = count
end

function HyListRewardItem:onRelease()
    self.activityRewardItem:release()
end