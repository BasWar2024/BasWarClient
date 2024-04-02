

PnlTaskReward = class("PnlTaskReward", ggclass.UIBase)

function PnlTaskReward:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlTaskReward:onAwake()
    self.view = ggclass.PnlTaskRewardView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "TaskRewardItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

-- args = {
--     reward = {
-- 			ActivityUtil.getActivitiesRewardList""
-- 		},
--    title = ,
-- }

function PnlTaskReward:onShow()
    self:bindEvent()
    self.dataList = self.args.reward
    self.scrollView:setItemCount(#self.dataList)

    local title = self.args.title or Utils.getText("universal_GetReward_Title")
    self.view.txtTitle.text = title
end

function PnlTaskReward:onRenderItem(obj, index)
   local item = TaskRewardItem:getItem(obj, self.itemList)
   item:setData(self.dataList[index], index)
end

function PnlTaskReward:onHide()
    self:releaseEvent()

end

function PnlTaskReward:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlTaskReward:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlTaskReward:onDestroy()
    local view = self.view
    if view and self.scrollView then
        self.scrollView:release()
    end
end

function PnlTaskReward:onBtnClose()
    self:close()
end

---------------------------------

TaskRewardItem = TaskRewardItem or class("TaskRewardItem", ggclass.UIBaseItem)

function TaskRewardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function TaskRewardItem:onInit()
    self.root = self:Find("Root").transform
    self.canvasGroup = self.root:GetComponent(typeof(UnityEngine.CanvasGroup))

    self.activityRewardItem = ActivityRewardItem.new(self:Find("Root/ActivityRewardItem"))
    self.txtReward = self:Find("Root/bgCost/TxtReward", UNITYENGINE_UI_TEXT)
end

local animTime = 0.3
function TaskRewardItem:setData(data, index)
    local count = data.count or 1
    if data.rewardType == constant.ACTIVITY_REWARD_RES then
        self.txtReward.text = Utils.getShowRes(count)
    else
        self.txtReward.text = count
    end

    self.activityRewardItem:setData(data)

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

function TaskRewardItem:onRelease()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end
    self.activityRewardItem:release()
end

return PnlTaskReward