
PnlDailyCheckView = class("PnlDailyCheckView")

PnlDailyCheckView.ctor = function(self, transform)

    self.transform = transform
    self.activityDailyCheckInBox = transform:Find("Root/ActivityDailyCheckInBox").gameObject
end

return PnlDailyCheckView