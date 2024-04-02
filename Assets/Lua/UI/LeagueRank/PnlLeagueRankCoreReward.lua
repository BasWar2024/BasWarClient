

PnlLeagueRankCoreReward = class("PnlLeagueRankCoreReward", ggclass.UIBase)

function PnlLeagueRankCoreReward:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlLeagueRankCoreReward:onAwake()
    self.view = ggclass.PnlLeagueRankCoreRewardView.new(self.pnlTransform)

    self.rewardItemList = {}
    self.rewardScrollView = UIScrollView.new(self.view.rewardScrollView, "LeagueRankCoreRewardItem", self.rewardItemList)
    self.rewardScrollView:setRenderHandler(gg.bind(self.onRenderRewardItem, self))
end

function PnlLeagueRankCoreReward:onShow()
    self:bindEvent()
    self.rewardScrollView:setItemCount(10)
end

function PnlLeagueRankCoreReward:onHide()
    self:releaseEvent()

end

function PnlLeagueRankCoreReward:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlLeagueRankCoreReward:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlLeagueRankCoreReward:onDestroy()
    local view = self.view

end

function PnlLeagueRankCoreReward:onBtnClose()
    self:close()
end

function PnlLeagueRankCoreReward:onRenderRewardItem(obj, index)
    local item = LeagueRankCoreRewardItem:getItem(obj, self.rewardItemList)
    item:setData(index)
end

-------------------------------------------------------------------------------------------------
LeagueRankCoreRewardItem = LeagueRankCoreRewardItem or class("LeagueRankCoreRewardItem", ggclass.UIBaseItem)

function LeagueRankCoreRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function LeagueRankCoreRewardItem:onInit()
    self.imgHead = self:Find("ImgHead", UNITYENGINE_UI_IMAGE)
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtPos = self:Find("BgPos/TxtPos", UNITYENGINE_UI_TEXT)
    self.txtDao = self:Find("TxtDao", UNITYENGINE_UI_TEXT)
    self.txtReward = self:Find("BgReward/TxtReward", UNITYENGINE_UI_TEXT)
    self.btnFetch = self:Find("BtnFetch")
    self:setOnClick(self.btnFetch, gg.bind(self.onBtnFetch, self))
end

function LeagueRankCoreRewardItem:setData(data)
end

function LeagueRankCoreRewardItem:onBtnFetch()
    print("fetch")
end


-------------------------------------------------------------------------------------------------

return PnlLeagueRankCoreReward