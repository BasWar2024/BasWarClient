

PnlExchangeAlert = class("PnlExchangeAlert", ggclass.UIBase)

function PnlExchangeAlert:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlExchangeAlert:onAwake()
    self.view = ggclass.PnlExchangeAlertView.new(self.pnlTransform)

end

-- args = {res, val}
function PnlExchangeAlert:onShow()
    self:bindEvent()

    local resInfo = constant.RES_2_CFG_KEY[self.args.res]
    local fromRes = resInfo.exchangeFrom
    local fromResInfo = constant.RES_2_CFG_KEY[fromRes]

    local exchangeInfo = ResData.exchangeData[fromRes]
    local ratio = exchangeInfo[resInfo.exchangeKey]

    gg.setSpriteAsync(self.view.imgFrom, fromResInfo.iconNameHead .. "Many")
    gg.setSpriteAsync(self.view.imgTo, resInfo.iconNameHead .. "Many")

    self.view.txtFrom.text = math.floor(self.args.val / 1000)
    self.view.txtTo.text = math.floor(self.args.val / 1000 * ratio)

    self.view.txtAlert.text = string.format(Utils.getText("exchange_Ask_Text"), self.view.txtFrom.text, Utils.getText(fromResInfo.languageKey), 
    self.view.txtTo.text, Utils.getText(resInfo.languageKey)) 

    self.fromRes = fromRes
end

function PnlExchangeAlert:onHide()
    self:releaseEvent()

end

function PnlExchangeAlert:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnNo):SetOnClick(function()
        self:onBtnNo()
    end)
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)
end

function PnlExchangeAlert:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnNo)
    CS.UIEventHandler.Clear(view.btnYes)

end

function PnlExchangeAlert:onDestroy()
    local view = self.view

end

function PnlExchangeAlert:onBtnClose()

end

function PnlExchangeAlert:onBtnNo()
    self:close()
end

function PnlExchangeAlert:onBtnYes()
    ResData.C2S_Player_Exchange_Res(self.fromRes, self.args.val, self.args.res)
    self:close()
end

return PnlExchangeAlert