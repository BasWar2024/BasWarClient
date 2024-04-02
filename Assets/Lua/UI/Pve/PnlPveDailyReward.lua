

PnlPveDailyReward = class("PnlPveDailyReward", ggclass.UIBase)

function PnlPveDailyReward:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlPveDailyReward:onAwake()
    self.view = ggclass.PnlPveDailyRewardView.new(self.pnlTransform)
    self.rewardScrollView = UIScrollView.new(self.view.rewardScrollView, "PveDailyRewardBigItem")
    self.rewardScrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function PnlPveDailyReward:onShow()
    self:bindEvent()
    self.rewardMap = {}
    for key, value in pairs(BattleData.pvePassMap) do
        if not BattleData.pveDailyRewardMap[value.cfgId] then
            PveUtil.addStarReward(PveUtil.getStarReward(value.cfgId, value.star >= 1, value.star >= 2, value.star >= 3), self.rewardMap)
        end
    end

    self.rewardList = {}

    for key, value in pairs(self.rewardMap) do
        table.insert(self.rewardList, value)
    end

    self.rewardScrollView:setItemCount(#self.rewardList)
end

function PnlPveDailyReward:onRenderItem(obj, index)
    local data = self.rewardList[index]
    gg.setSpriteAsync(obj.transform:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE), constant.RES_2_CFG_KEY[data[1]].iconBig)
    obj.transform:Find("TxtCount"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getShowRes(data[2])
end

function PnlPveDailyReward:onHide()
    self:releaseEvent()
end

function PnlPveDailyReward:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
end

function PnlPveDailyReward:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnConfirm)

end

function PnlPveDailyReward:onDestroy()
    local view = self.view
    self.rewardScrollView:release()
end

function PnlPveDailyReward:onBtnClose()
    self:close()
end

function PnlPveDailyReward:onBtnConfirm()
    BattleData.C2S_Player_PVERecvDailyRewards()
    self:close()
end

return PnlPveDailyReward