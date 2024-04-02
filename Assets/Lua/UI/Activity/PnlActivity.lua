

PnlActivity = class("PnlActivity", ggclass.UIBase)

function PnlActivity:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onGiftActivitiesChange" }
end

PnlActivity.TYPE_DAILY_CHECK_IN = 1                                         -- ""
PnlActivity.TYPE_ACCRUING_TES = 2                                          -- ""
PnlActivity.TYPE_GIFT = 3                                                   -- ""
PnlActivity.TYPE_FIRST_CHARGE = 4                                           -- ""
PnlActivity.TYPE_OPEN_ACCRUING_CHARGE = 5                                   -- ""
PnlActivity.TYPE_LIMIT_TIME_GOODS = 6                                      -- ""

function PnlActivity:onAwake()
    self.view = ggclass.PnlActivityView.new(self.pnlTransform)
    self.funcDataMap = {
        [PnlActivity.TYPE_DAILY_CHECK_IN] = {
            activityType = constant.DAILY_CHECK,
            openFunc = gg.bind(self.openDailyCheckIn, self),
            closeFunc = gg.bind(self.closeDailyCheckIn, self),
            layout = self.view.layoutDailyCheckIn,
            btnData = {
                sortWeight = PnlActivity.TYPE_DAILY_CHECK_IN,
                nemeKey = "activity_Left_DailyCheckIn",
                callback = gg.bind(self.refresh, self, PnlActivity.TYPE_DAILY_CHECK_IN),
                redPointName = RedPointDailyCheckIn.__name,
            },
        },

        [PnlActivity.TYPE_ACCRUING_TES] = {
            activityType = constant.CUMULATIVE_FUNDS,
            openFunc = gg.bind(self.openAccruingTes, self),
            closeFunc = gg.bind(self.closeAccruingTes, self),
            layout = self.view.layoutAccruingTes,
            btnData = {
                sortWeight = PnlActivity.TYPE_ACCRUING_TES,
                nemeKey = "activity_Left_RechargeFund",
                callback = gg.bind(self.refresh, self, PnlActivity.TYPE_ACCRUING_TES),
                redPointName = RedPointAccruingTes.__name,
            },
        },

        [PnlActivity.TYPE_GIFT] = {
            activityType = constant.DAILY_GIFT,
            openFunc = gg.bind(self.openGift, self),
            closeFunc = gg.bind(self.closeGift, self),
            layout = self.view.layoutGift,
            btnData = {
                sortWeight = PnlActivity.TYPE_GIFT,
                nemeKey = "activity_Left_SupplyPack",
                callback = gg.bind(self.refresh, self, PnlActivity.TYPE_GIFT)
            },
        },

        [PnlActivity.TYPE_FIRST_CHARGE] = {
            activityType = constant.FIRST_CHARGE,
            openFunc = gg.bind(self.openFirstCharge, self),
            closeFunc = gg.bind(self.closeFirstCharge, self),
            layout = self.view.layoutFirstCharge,
            btnData = {
                sortWeight = PnlActivity.TYPE_FIRST_CHARGE,
                nemeKey = "activity_Left_RechargePack",
                callback = gg.bind(self.refresh, self, PnlActivity.TYPE_FIRST_CHARGE),
                redPointName = RedPointActFirstCharge.__name,
            },
        },

        [PnlActivity.TYPE_OPEN_ACCRUING_CHARGE] = {
            activityType = constant.RECHARGE,
            openFunc = gg.bind(self.openOpenAccruingCharge, self),
            closeFunc = gg.bind(self.closeOpenAccruingCharge, self),
            layout = self.view.layoutOpenAccruingCharge,
            btnData = {
                sortWeight = PnlActivity.TYPE_OPEN_ACCRUING_CHARGE,
                nemeKey = "activity_Left_AccumulatedRecharge",
                callback = gg.bind(self.refresh, self, PnlActivity.TYPE_OPEN_ACCRUING_CHARGE),
                redPointName = RedPointActRecharge.__name,
            },
        },

        [PnlActivity.TYPE_LIMIT_TIME_GOODS] = {
            activityType = constant.LIMIT_TIME_SHOP,
            openFunc = gg.bind(self.openLimitTimeGoods, self),
            closeFunc = gg.bind(self.closeLimitTimeGoods, self),
            layout = self.view.layoutLimitTimeGoods,
            btnData = {
                sortWeight = PnlActivity.TYPE_LIMIT_TIME_GOODS,
                nemeKey = "activity_Left_LimitedTimeShop",
                callback = gg.bind(self.refresh, self, PnlActivity.TYPE_LIMIT_TIME_GOODS)
            },
        },
    }

    self.viewOptionBtnBox = ViewOptionBtnBox.new(self.view.fullViewOptionBtnBox)
    self.activityDailyCheckInBox = ActivityDailyCheckInBox.new(self.view.activityDailyCheckInBox, self)
    self.accruingTesBox = AccruingTesBox.new(self.view.accruingTesBox, self)
    self.activityGiftBox = ActivityGiftBox.new(self.view.activityGiftBox, self)
    self.firstChargeBox = FirstChargeBox.new(self.view.firstChargeBox, self)
    self.openAccruingChargeBox = OpenAccruingChargeBox.new(self.view.openAccruingChargeBox, self)
    self.limitTimeGoodsBox = LimitTimeGoodsBox.new(self.view.limitTimeGoodsBox, self)
end

function PnlActivity:onShow()
    PlayerData.C2S_Player_PayChannelInfo()

    self:bindEvent()
    self.activityOpenMap = nil
    self:refreshActivityOpen(1)
end

function PnlActivity:onGiftActivitiesChange()
    self:refreshActivityOpen()
end

function PnlActivity:refreshActivityOpen(clickIndex)
    self.activityOpenMap = self.activityOpenMap or {}

    local isChange = false
    for key, value in pairs(self.funcDataMap) do
        local isOpen = ActivityUtil.checkGiftActivitiesOpen(value.activityType)
        if self.activityOpenMap[key] ~= isOpen then
            self.activityOpenMap[key] = isOpen
            isChange = true
        end
    end

    if isChange then
        local btnDataList = {}
        for key, value in pairs(self.activityOpenMap) do
            if value then
                table.insert(btnDataList, self.funcDataMap[key].btnData)
            end
        end

        table.sort(btnDataList, function (a, b)
            return a.sortWeight < b.sortWeight
        end)

        self.viewOptionBtnBox:setBtnDataList(btnDataList, clickIndex)
        self.viewOptionBtnBox:open()
    end
end

function PnlActivity:refresh(showType)
    self.showType = showType
    for key, value in pairs(self.funcDataMap) do
        if key == showType then
            value.layout:SetActiveEx(true)
            value.openFunc()
        else
            value.layout:SetActiveEx(false)
            value.closeFunc()
        end
    end
end

---- TYPE_DAILY_CHECK_IN
function PnlActivity:openDailyCheckIn()
    self.activityDailyCheckInBox:open()
end

function PnlActivity:closeDailyCheckIn()
    self.activityDailyCheckInBox:close()
end

------TYPE_ACCRUING_TES

function PnlActivity:openAccruingTes()
    self.accruingTesBox:open()
end

function PnlActivity:closeAccruingTes()
    self.accruingTesBox:close()
end

------TYPE_GIFT

function PnlActivity:openGift()
    self.activityGiftBox:open()
end

function PnlActivity:closeGift()
    self.activityGiftBox:close()
end

------TYPE_FIRST_CHARGE 

function PnlActivity:openFirstCharge()
    self.firstChargeBox:open()
end

function PnlActivity:closeFirstCharge()
    self.firstChargeBox:close()
end

-------TYPE_OPEN_ACCRUING_CHARGE
function PnlActivity:openOpenAccruingCharge()
    self.openAccruingChargeBox:open()
end

function PnlActivity:closeOpenAccruingCharge()
    self.openAccruingChargeBox:close()
end

------TYPE_LIMIT_TIME_GOODS

function PnlActivity:openLimitTimeGoods()
    self.limitTimeGoodsBox:open()
end

function PnlActivity:closeLimitTimeGoods()
    self.limitTimeGoodsBox:close()
end

--------------------------------


function PnlActivity:onHide()
    self:releaseEvent()
    self.viewOptionBtnBox:close()
end

function PnlActivity:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlActivity:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlActivity:onDestroy()
    local view = self.view

    self.viewOptionBtnBox:release()
    self.activityDailyCheckInBox:release()
    self.accruingTesBox:release()
    self.activityGiftBox:release()
    self.firstChargeBox:release()
    self.openAccruingChargeBox:release()
    self.limitTimeGoodsBox:release()
end

function PnlActivity:onBtnClose()
    self:close()
end

return PnlActivity