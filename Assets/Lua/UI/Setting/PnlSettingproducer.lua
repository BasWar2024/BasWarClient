

PnlSettingproducer = class("PnlSettingproducer", ggclass.UIBase)

function PnlSettingproducer:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlSettingproducer:onAwake()
    self.view = ggclass.PnlSettingproducerView.new(self.pnlTransform)
    self.itemList = {}
    self.scrollView = UIScrollView.new(self.view.scrollView, "ProducerItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    -- self.sequence = CS.DG.Tweening.DOTween.Sequence()
end

function PnlSettingproducer:onRenderItem(obj, index)
    local item = ProducerItem:getItem(obj, self.itemList)
    item:setData(self.dataLList[index].dute, self.dataLList[index].name)
end

function PnlSettingproducer:onShow()
    self:bindEvent()

    self.dataLList = {
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
        {dute = "ceo", name = "pei"},
    }
    self.scrollView:setItemCount(#self.dataLList)

    self:startAction()
end

local itemHeight = 80
local spancing = 10
local perTime = 1

function PnlSettingproducer:startAction()
    if self.sequence then
        self.sequence:Kill()
    end

    local view = self.view
    local content = view.scrollView.content
    local scrollHeight = view.scrollView.transform.rect.height
    content.anchoredPosition = CS.UnityEngine.Vector2(content.anchoredPosition.x, -scrollHeight)
    local lenth = #self.dataLList * (itemHeight + spancing) - spancing
    content:DOKill()

    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Append(content:DOAnchorPos(CS.UnityEngine.Vector2(content.anchoredPosition.x, lenth), #self.dataLList * perTime):
        SetEase(CS.DG.Tweening.Ease.Linear))
    self.sequence:AppendCallback(function ()
        self:close()
    end)
end

function PnlSettingproducer:onHide()
    self:releaseEvent()
    self.view.scrollView.content:DOKill()
    self.scrollView:release()
end

function PnlSettingproducer:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
end

function PnlSettingproducer:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlSettingproducer:onDestroy()
    local view = self.view

end

function PnlSettingproducer:onBtnClose()
    self:close()
end

return PnlSettingproducer