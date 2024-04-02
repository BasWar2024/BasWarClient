

PnlAlertRemoveBuilding = class("PnlAlertRemoveBuilding", ggclass.UIBase)

function PnlAlertRemoveBuilding:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = { }
    self.needBlurBG = true
    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

function PnlAlertRemoveBuilding:onAwake()
    self.view = ggclass.PnlAlertRemoveBuildingView.new(self.pnlTransform)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "AlertRemoveResItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

local itemW = 153
local spancing = 0
local maxW = 700

--self.args = {buildData = , buildCfg = }
function PnlAlertRemoveBuilding:onShow()
    self:bindEvent()

    local view = self.view
    view.txtTips.text = string.format(Utils.getText("universal_Remove_Ask_Txt"), self.args.buildCfg.name)

    view.txtCost.text = Utils.getShowRes(self.args.buildCfg.removeNeedStarCoin)
    self.removeGetRes = self.args.buildCfg.removeGetRes

    local scrollViewWidth = math.min((itemW + spancing) * #self.removeGetRes, maxW)
    self.view.scrollView.transform:SetRectSizeX(scrollViewWidth)
    self.scrollView:setItemCount(#self.removeGetRes)
end

function PnlAlertRemoveBuilding:onRenderItem(obj, index)
    local item = AlertRemoveResItem:getItem(obj, self.itemList)

    local data = self.removeGetRes[index]
    item:setData(data[1], data[2])
end

function PnlAlertRemoveBuilding:onHide()
    self:releaseEvent()

end

function PnlAlertRemoveBuilding:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)
    CS.UIEventHandler.Get(view.btnYes):SetOnClick(function()
        self:onBtnYes()
    end)

    self:setOnClick(view.btnNo, gg.bind(self.onBtnNo, self))
end

function PnlAlertRemoveBuilding:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnYes)

end

function PnlAlertRemoveBuilding:onDestroy()
    local view = self.view

end

function PnlAlertRemoveBuilding:onBtnClose()

end

function PnlAlertRemoveBuilding:onBtnYes()
    BuildData.C2S_Player_RemoveMess(self.args.buildData.id)
    self:close()
end

function PnlAlertRemoveBuilding:onBtnNo()
    self:close()
end

-----------------------------------------------------------------------------------------
AlertRemoveResItem = AlertRemoveResItem or class("AlertRemoveResItem", ggclass.UIBaseItem)

function AlertRemoveResItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function AlertRemoveResItem:onInit()
    self.imgIcon = self:Find("Root/ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtReward = self:Find("Root/TxtReward", UNITYENGINE_UI_TEXT)
end

function AlertRemoveResItem:setData(resId, count)
    gg.setSpriteAsync(self.imgIcon, constant.RES_2_CFG_KEY[resId].icon)
    self.txtReward.text = Utils.getShowRes(count)
end

return PnlAlertRemoveBuilding