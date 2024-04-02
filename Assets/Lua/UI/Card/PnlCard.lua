
PnlCard = class("PnlCard", ggclass.UIBase)

function PnlCard:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onCardUpdate"}
    self.needBlurBG = true
end

function PnlCard:onAwake()
    self.view = ggclass.PnlCardView.new(self.pnlTransform)
    local view = self.view

    self.atkItemList ={}
    self.atkScrollView = UIScrollView.new(view.atkScrollView, "CardGroupItem", self.atkItemList)
    self.atkScrollView:setRenderHandler(gg.bind(self.onRenderAtkItem, self))

    self.defItemList ={}
    self.defScrollView = UIScrollView.new(view.defScrollView, "CardGroupItem", self.defItemList)
    self.defScrollView:setRenderHandler(gg.bind(self.onRenderDefItem, self))

    self.cardGroupEditBox = CardGroupEditBox.new(view.cardGroupEditBox, self)
    self.drawCardBox = DrawCardBox.new(view.drawCardBox, self)
end

function PnlCard:onShow()
    self:bindEvent()

    self.atkScrollView:setItemCount(4)
    self.defScrollView:setItemCount(4)

    self.view.root:SetActiveEx(true)
    self.cardGroupEditBox:close()
    self.drawCardBox:close()
end

function PnlCard:onCardUpdate()
    self.atkScrollView:setItemCount(4)
    self.defScrollView:setItemCount(4)
end

function PnlCard:onHide()
    self:releaseEvent()
end

function PnlCard:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)
    CS.UIEventHandler.Get(view.btnGetCard):SetOnClick(function()
        self:onBtnGetCard()
    end)
end

function PnlCard:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnGetCard)
end

function PnlCard:onDestroy()
    local view = self.view

    self.atkScrollView:release()
    self.defScrollView:release()
    self.cardGroupEditBox:release()
    self.drawCardBox:release()
end

function PnlCard:onBtnGetCard()
    self:drawCard(true)
end

function PnlCard:onRenderAtkItem(obj, index)
    local item = CardGroupItem:getItem(obj, self.atkItemList, self)
    item:setData(index, constant.CARD_GROUP_TYPE_ATK)
end

function PnlCard:onRenderDefItem(obj, index)
    local item = CardGroupItem:getItem(obj, self.defItemList, self)
    item:setData(index, constant.CARD_GROUP_TYPE_DEF)
end

function PnlCard:editCardGroup(isEdit, index, groupType)
    local view = self.view

    if isEdit then
        view.root:SetActiveEx(false)
        self.cardGroupEditBox:open(index, groupType)
        self.drawCardBox:close()
    else
        view.root:SetActiveEx(true)
        self.cardGroupEditBox:close()
        self.drawCardBox:close()
    end
end

function PnlCard:drawCard(isDraw)
    local view = self.view

    if isDraw then
        view.root:SetActiveEx(false)
        self.cardGroupEditBox:close()
        self.drawCardBox:open()
    else
        view.root:SetActiveEx(true)
        self.cardGroupEditBox:close()
        self.drawCardBox:close()
    end
end

return PnlCard