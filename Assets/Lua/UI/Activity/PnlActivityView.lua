
PnlActivityView = class("PnlActivityView")

PnlActivityView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject

    self.fullViewOptionBtnBox = transform:Find("Root/FullViewOptionBtnBox")

    self.layoutDailyCheckIn = transform:Find("Root/LayoutDailyCheckIn")
    self.activityDailyCheckInBox = self.layoutDailyCheckIn:Find("ActivityDailyCheckInBox")

    self.layoutAccruingTes = transform:Find("Root/LayoutAccruingTes")
    self.accruingTesBox = self.layoutAccruingTes:Find("AccruingTesBox")

    self.layoutGift = transform:Find("Root/LayoutGift")
    self.activityGiftBox = self.layoutGift:Find("ActivityGiftBox")

    self.layoutFirstCharge = transform:Find("Root/LayoutFirstCharge")
    self.firstChargeBox = self.layoutFirstCharge:Find("FirstChargeBox")

    self.layoutOpenAccruingCharge = transform:Find("Root/LayoutOpenAccruingCharge")
    self.openAccruingChargeBox = self.layoutOpenAccruingCharge:Find("OpenAccruingChargeBox")

    self.layoutLimitTimeGoods = transform:Find("Root/LayoutLimitTimeGoods")
    self.limitTimeGoodsBox = self.layoutLimitTimeGoods:Find("LimitTimeGoodsBox")
end

return PnlActivityView