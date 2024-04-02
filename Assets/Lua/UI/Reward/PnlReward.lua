

PnlReward = class("PnlReward", ggclass.UIBase)

function PnlReward:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

PnlReward.TYPE_RES = constant.ACTIVITY_REWARD_RES
PnlReward.TYPE_ITEM = constant.ACTIVITY_REWARD_ITEM
PnlReward.TYPE_HERO = constant.ACTIVITY_REWARD_HERO

--args = {rewards = {{rewardType = PnlReward.TYPE_RES, resId = , count = ,}} }
-- {rewardType = PnlReward.TYPE_HERO, cfgId = , quality = , }
-- {rewardType = PnlReward.TYPE_ITEM, cfgId = , count = , }

function PnlReward:onAwake()
    self.view = ggclass.PnlRewardView.new(self.pnlTransform)
    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "RewardItems", itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

local perTtemCount = 5

local itemH = 200
local spancing = 50

local topH = 251
local BottomH = 254

function PnlReward:onShow()
    self:bindEvent()

    local view = self.view

    local itemCount = math.ceil(#self.args.rewards / perTtemCount)
    self.scrollView:setItemCount(itemCount)

    local height = itemCount * (itemH + spancing) - spancing
    local maxHeight = view.root.rect.height - topH - BottomH

    view.scrollView:SetRectSizeY(math.min(height, maxHeight))
end

function PnlReward:onRenderItem(obj, index)
    for i = 1, perTtemCount, 1 do
        local idx = (index - 1) * perTtemCount + i
        local trans = obj.transform:GetChild(i - 1)
        local item = RewardItem:getItem(trans, self.itemList)
        item:setData(self.args.rewards[idx], idx)
    end
end

function PnlReward:onHide()
    self:releaseEvent()

end

function PnlReward:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnDetermine):SetOnClick(function()
        self:onBtnDetermine()
    end)

    self:setOnClick(view.btnClose, gg.bind(self.close, self))
end

function PnlReward:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnDetermine)
end

function PnlReward:onDestroy()
    local view = self.view
    self.scrollView:release()
end

function PnlReward:onBtnDetermine()

end

---------------------------------

RewardItem = RewardItem or class("RewardItem", ggclass.UIBaseItem)

function RewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function RewardItem:onInit()
    self.root = self:Find("Root").transform
    self.canvasGroup = self.root:GetComponent(typeof(UnityEngine.CanvasGroup))

    self.txtNum = self:Find("Root/TxtNum", UNITYENGINE_UI_TEXT)
    self.activityRewardItem = ActivityRewardItem.new(self:Find("Root/ActivityRewardItem"))
end

local animTime = 0.3
function RewardItem:setData(data, index)
    -- local resInfo = constant.RES_2_CFG_KEY[data[1]]
    -- gg.setSpriteAsync(self.imgIcon, resInfo.iconBig)
    -- self.txtReward.text = Utils.getShowRes(data[2])
    if not data then
        self:setActive(false)
        return
    end
    self:setActive(true)

    self.activityRewardItem:setData(data)
    local count = data.count or 1
    if data.rewardType == PnlReward.TYPE_RES then
        count = Utils.getShowRes(count)
    end
    self.txtNum.text = count

    -- if data.type == PnlReward.TYPE_RES then
    --     gg.setSpriteAsync(self.imgIcon, constant.RES_2_CFG_KEY[data.cfgId].icon)
    --     self.txtNum.text = Utils.getShowRes(data.count)
    -- elseif data.type == PnlReward.TYPE_HERO then

    -- end

    if self.sequence then
        self.sequence:Kill()
    end
    self.canvasGroup.alpha = 0
    self.root.anchoredPosition = UnityEngine.Vector2(0, -100)

    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:AppendInterval((index - 1) * 0.2)
    self.sequence:Append(self.canvasGroup:DOFade(1, animTime))
    self.sequence:Join(self.root:DOAnchorPosY(0, animTime))
end

function RewardItem:onRelease()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end
    self.activityRewardItem:release()
end

return PnlReward