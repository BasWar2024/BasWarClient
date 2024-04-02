

PnlNewPlayerLoginAct = class("PnlNewPlayerLoginAct", ggclass.UIBase)

function PnlNewPlayerLoginAct:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onLoginActivityInfoChange" }
end

function PnlNewPlayerLoginAct:onAwake()
    self.view = ggclass.PnlNewPlayerLoginActView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "NewPlayerLoginActItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function PnlNewPlayerLoginAct:onShow()
    self:bindEvent()

    PlayerData.C2S_Player_PayChannelInfo()

    self.selectingItem = nil

    self.timer = gg.timer:startLoopTimer(0, 0.5, -1, function()
        local time = ActivityData.loginActivityInfo.endTime - Utils.getServerSec()
        local hms = gg.time.dhms_time({ day = 1, hour = 1, min = 1, sec = 1}, time)

        if time <= 0 then
            self.view.txtTime.text = string.format("%s:%s:%s", 0, 0, 0)
            self:close()
            gg.timer:stopTimer(self.timer)
        else
            if hms.day > 0 then
                self.view.txtTime.text = string.format(Utils.getText("activity_LoginSurp_CountdownDay"), hms.day)
            -- else
            --     self.view.txtTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
            end

            self.view.txtTime.text = self.view.txtTime.text .. string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
        end
    end)

    self:refresh()
end

function PnlNewPlayerLoginAct:refresh()
    self.dataList = cfg.loginActivity
    self.scrollView:setItemCount(#self.dataList)
    self:refreshSelect()
end

function PnlNewPlayerLoginAct:onLoginActivityInfoChange()
    self:refresh()
end

function PnlNewPlayerLoginAct:onHide()
    self:releaseEvent()
    gg.timer:stopTimer(self.timer)
end

function PnlNewPlayerLoginAct:onRenderItem(obj, index)
    local item = NewPlayerLoginActItem:getItem(obj, self.itemList, self)

    item:setData(self.dataList[index])
end

function PnlNewPlayerLoginAct:selectItem(item)
    self.selectingItem = item or self.selectingItem

    for key, value in pairs( self.itemList) do
        value:refreshSelect()
    end

    self:refreshSelect()
end

function PnlNewPlayerLoginAct:refreshSelect()
    if self.selectingItem.loginActivityData.advStatus == -2 then
        self.view.btnUnlock:SetActiveEx(true)
        self.view.imgLock.transform:SetActiveEx(true)
    else
        self.view.btnUnlock:SetActiveEx(false)
        self.view.imgLock.transform:SetActiveEx(false)
    end
end

function PnlNewPlayerLoginAct:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnDesc):SetOnClick(function()
        self:onBtnDesc()
    end)
    CS.UIEventHandler.Get(view.btnUnlock):SetOnClick(function()
        self:onBtnUnlock()
    end)
end

function PnlNewPlayerLoginAct:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnDesc)
    CS.UIEventHandler.Clear(view.btnUnlock)

end

function PnlNewPlayerLoginAct:onDestroy()
    local view = self.view
    self.scrollView:release()
end

function PnlNewPlayerLoginAct:onBtnClose()
    self:close()
end

function PnlNewPlayerLoginAct:onBtnDesc()
    gg.uiManager:openWindow("PnlDesc", {title = Utils.getText("universal_RulesTitle"), desc = Utils.getText("activity_LoginSurp_RulesTxt")})
end

function PnlNewPlayerLoginAct:onBtnUnlock()
    if PlayerData.payChannelInfo and next(PlayerData.payChannelInfo) then
        if self.selectingItem.loginActivityData.advStatus < 0 then
            -- ShopUtil.buyProduct(self.selectingItem.data.costProductId)
            local callbackYes = function ()
                ActivityData.C2S_Player_UnlockLoginAdv(self.selectingItem.data.day)
            end
            local args = {
                bgType = PnlAlert.BG_TYPE_TITLE,
                title = Utils.getText("universal_Ask_Title"),
                txt = string.format("are you sure want to cost %s %s to unlock?", 
                    Utils.getShowRes(self.selectingItem.data.cost), constant.RES_2_CFG_KEY[constant.RES_TESSERACT].name) ,
                callbackYes = callbackYes,
                yesCostList = {{cost = self.selectingItem.data.cost, resId = constant.RES_TESSERACT}}
            }
            gg.uiManager:openWindow("PnlAlert", args)
        end
    end
end

return PnlNewPlayerLoginAct