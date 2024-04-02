PnlAlertNew = class("PnlAlertNew", ggclass.UIBase)

-- args = {
-- txtTitel = ,
-- txtTips = ,
-- txtYes = , 
-- callbackYes = , 
-- txtNo = , 
-- callbackNo = , 
-- yesCost = {{resId = , count = }},
--closeType = ,
-- }

PnlAlertNew.CLOSE_TYPE_BG = 1

function PnlAlertNew:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlAlertNew:onAwake()
    self.view = ggclass.PnlAlertNewView.new(self.pnlTransform)

    self.commonUpgradePartYes = CommonUpgradePart.new(self.view.commonUpgradePartYes)
    self.commonUpgradePartYes:setInstanceCostActive(false)
    self.commonUpgradePartYes:setSliderData(false)
    self.commonUpgradePartYes:setClickCallback(gg.bind(self.onBtnYes, self))

end

function PnlAlertNew:onShow()
    self:bindEvent()

    if self.args.bigSize then
        self.view.root.sizeDelta = Vector2.New(1160, 636)
    else
        self.view.root.sizeDelta = Vector2.New(845, 465)
    end

    self.view.txtTitle.text = self.args.txtTitel
    self.view.txtTips.text = self.args.txtTips
    if self.args.txtNo then
        self.view.btnNo:SetActiveEx(true)
        self.view.txtBtnNo.text = self.args.txtNo
    else
        self.view.btnNo:SetActiveEx(false)
    end

    self.commonUpgradePartYes:setBtnText(self.args.txtYes)

    local yesBtnData = {}
    if self.args.yesCost then
        for key, value in pairs(self.args.yesCost) do
            local resInfo = constant.RES_2_CFG_KEY[value.resId]
            local color = nil
            if ResData.getRes(value.resId) < value.count then
                color = constant.COLOR_RED
            end
            table.insert(yesBtnData, {icon = resInfo.icon, cost = value.count, resId = value.resId, color = color})
        end
    end
    self.commonUpgradePartYes:setBtnData(yesBtnData)
end

function PnlAlertNew:onHide()
    self:releaseEvent()

end

function PnlAlertNew:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)

    self:setOnClick(self.view.bg.gameObject, gg.bind(self.onBtnBg, self))
end

function PnlAlertNew:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnNo)

end

function PnlAlertNew:onBtnBg()
    if self.args.closeType == PnlAlertNew.CLOSE_TYPE_BG then
        self:close()
    end
end

function PnlAlertNew:onDestroy()
    local view = self.view
    self.commonUpgradePartYes:release()
end

function PnlAlertNew:onBtnNo()
    self:close()
    if self.args.callbackNo then
        self.args.callbackNo()
    end
end

function PnlAlertNew:onBtnYes()
    if self.args.callbackYes then
        self.args.callbackYes()
    end
    self:close()
end

return PnlAlertNew
