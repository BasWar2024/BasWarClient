ActivityDailyCheckInBox = ActivityDailyCheckInBox or class("ActivityDailyCheckInBox", ggclass.UIBaseItem)

ActivityDailyCheckInBox.events = {"onDailyChange"}

function ActivityDailyCheckInBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function ActivityDailyCheckInBox:onInit()
    self.itemList = {}
    self.scrollView = UILoopScrollView.new(self:Find("ScrollView"), self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.layoutTitle = self:Find("LayoutTitle")
    self.txtNextCheckTime = self:Find("LayoutTitle/TxtNextCheckTime", UNITYENGINE_UI_TEXT)

    self.btnDesc = self:Find("LayoutTitle/BtnDesc")
    self:setOnClick(self.btnDesc.gameObject, gg.bind(self.onClickDesc, self))

    self.layoutDay7 = self:Find("LayoutDay7").transform
    self.imgBox = self.layoutDay7:Find("ImgBox").transform

    self.txtTitle = self.layoutDay7:Find("BgTitle/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)

    self:setOnClick(self.layoutDay7.gameObject, gg.bind(self.onClickDay7, self))

    

    self.imgBoxAnimator = self.imgBox:GetComponent(typeof(CS.UnityEngine.Animator))
end

local itemCount = 3

function ActivityDailyCheckInBox:onOpen(...)
    -- local weekDay = os.date("!%w", Utils.getServerSec())

    local count = 6
    self.scrollView:setDataCount(math.floor(count / itemCount))
    self:startTimer()
    self:refreshDay7()

    self.txtTitle.text = string.format(Utils.getText("activity_DayWhat"), 7)
end

function ActivityDailyCheckInBox:refreshDay7(...)
    local day7Data = ActivityData.dailyCheckData.data[7]
    day7Data = day7Data or {status = 0, isFirst = 0}

    self.isCanFetchDay7Reward = day7Data.status == 1
    EffectUtil.setGray(self.layoutDay7, day7Data.status == 2, true)

    if self.isCanFetchDay7Reward then
        self.imgBoxAnimator:SetBool("isMove", true)
    else
        self.imgBoxAnimator:SetBool("isMove", false)
    end

    local rewardCfgId = cfg.dailyCheck[1].reward[7]
    self.day7RewardList = ActivityUtil.getRewardList(cfg.giftReward[rewardCfgId])
    
end
 
function ActivityDailyCheckInBox:onClickDay7(...)
    if self.isCanFetchDay7Reward then
        gg.uiManager:openWindow("PnlReward", {rewards = self.day7RewardList})
        ActivityData.C2S_Player_GetDailyReward(7)
    end
    -- ActivityData.S2C_Player_DailyCheck(ActivityData.dailyCheckData)
end

function ActivityDailyCheckInBox:onClickDesc()
    gg.uiManager:openWindow("PnlRule", {title = Utils.getText("activity_RulesTitle"), content = Utils.getText("activity_RulesTxt_CheckIn")})
end

function ActivityDailyCheckInBox:onRenderItem(obj, index)
    for i = 1, itemCount do
        local idx = (index - 1) * itemCount + i
        local item = DailyCheckItem:getItem(obj.transform:GetChild(i - 1), self.itemList)
        item:setData(idx)
    end
end

function ActivityDailyCheckInBox:onDailyChange(obj, index)
    for key, value in pairs(self.itemList) do
        value:refresh()
    end

    self:refreshDay7()
end

function ActivityDailyCheckInBox:startTimer()
    gg.timer:stopTimer(self.timer)

    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        -- local time = math.ceil(24 * 60 * 60 - gg.time.getDaySecPass(Utils.getServerSec(), 8 * 60 * 60))
        local time = ActivityData.dailyCheckData.flushTimeEnd - os.time()
        local hms = gg.time.dhms_time({day=false, hour=1, min=1, sec=1}, time)
        self.txtNextCheckTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    end)
end

function ActivityDailyCheckInBox:onClose()
    gg.timer:stopTimer(self.timer)
end

function ActivityDailyCheckInBox:onRelease()
    self.scrollView:release()
end

---------------------------------------------------------------

DailyCheckItem = DailyCheckItem or class("DailyCheckItem", ggclass.UIBaseItem)

function DailyCheckItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function DailyCheckItem:onInit()


    self.txtTitle = self:Find("TxtTitle", UNITYENGINE_UI_TEXT)
    self.imgRewrad = self:Find("ImgRewrad", UNITYENGINE_UI_IMAGE)
    self.txtReward = self:Find("TxtReward", UNITYENGINE_UI_TEXT)
    self.btnCheckIn = self:Find("BtnCheckIn")

    self:setOnClick(self.btnCheckIn, gg.bind(self.onBtnCheckIn, self))

    self.layoutInfo = self:Find("LayoutInfo")

    self.txtInfo = self:Find("LayoutInfo/TxtInfo", UNITYENGINE_UI_TEXT)
end

function DailyCheckItem:onBtnCheckIn()
    gg.uiManager:openWindow("PnlReward", {rewards = self.rewardList})
    ActivityData.C2S_Player_GetDailyReward(self.index)
end

function DailyCheckItem:setData(index)
    self.index = index

    self.txtTitle.text = string.format(Utils.getText("activity_DayWhat"), index) --"DAY" .. index

    local rewardCfgId = cfg.dailyCheck[1].reward[index]
    self.rewardList = ActivityUtil.getRewardList(cfg.giftReward[rewardCfgId])

    local reward  = nil
    for key, value in pairs(self.rewardList) do
        if value.rewardType == constant.ACTIVITY_REWARD_RES then
            reward = value
        end
    end

    self.txtReward.text = "X" .. Utils.getShowRes(reward.count)
    local resInfo = constant.RES_2_CFG_KEY[reward.resId]
    gg.setSpriteAsync(self.imgRewrad, resInfo.icon)


    self:refresh()
end

function DailyCheckItem:refresh()
    self.dailyData = ActivityData.dailyCheckData.data[self.index] or {
        status = 0,
        isFirst = 0,
    }

    EffectUtil.setGray(self.gameObject, self.dailyData.status == 2, true)

    if self.dailyData.status == 2 then
        self.txtInfo.text = Utils.getText("activity_AlreadyReceived")
    else
        self.txtInfo.text = Utils.getText("activity_WaitCheckIn")
    end
    

    local isCanFetch = self.dailyData.status == 1

    if isCanFetch then
        self.layoutInfo:SetActiveEx(false)
        self.btnCheckIn:SetActiveEx(true)
    else
        self.layoutInfo:SetActiveEx(true)
        self.btnCheckIn:SetActiveEx(false)
    end
end