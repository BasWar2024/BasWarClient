

PnlBoard = class("PnlBoard", ggclass.UIBase)

function PnlBoard:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = { }
    self.destroyTime = 5
    self.needBlurBG = true
end

function PnlBoard:onAwake()
    self.view = ggclass.PnlBoardView.new(self.pnlTransform)

    self.newsItemList = {}
    self.newsScrollView = UIScrollView.new(self.view.newsScrollView, "NewsItem", self.newsItemList)
    self.newsScrollView:setRenderHandler(gg.bind(self.onRendernews, self))

    self.newsCountItemList = {}
    self.newsCountScrollView = UIScrollView.new(self.view.newsCountScrollView, "NewsCountItem", self.newsCountItemList)
    self.newsCountScrollView:setRenderHandler(gg.bind(self.onRendernewsCount, self))
end

local newsCountWidth = 21
local newsCountSpancing = 28

function PnlBoard:onShow()
    self:bindEvent()
    self.showingIndex = nil

    if next(MsgData.systemNotice) then
        self.newsDataList = MsgData.systemNotice
    else
        self.newsDataList = cfg.board
    end

    self.itemCount = #self.newsDataList
    self.newsScrollView:setItemCount(self.itemCount)
    self.newsCountScrollView:setItemCount(self.itemCount)
    self:setNewsIndex(1, true)
    self.view.newsCountScrollView:SetRectSizeX(self.itemCount * (newsCountWidth + newsCountSpancing) - newsCountSpancing + 5)
end

function PnlBoard:onHide()
    self:releaseEvent()
end

function PnlBoard:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    self:setOnClick(view.btnOpenView, gg.bind(self.onBtnOpenView, self))
    CS.UIEventHandler.Get(view.newsScrollView.gameObject):SetOnPointerDown(gg.bind(self.onPointerDownNews, self))
    CS.UIEventHandler.Get(view.newsScrollView.gameObject):SetOnPointerUp(gg.bind(self.onPointerUpNews, self))

    self:setOnClick(view.btnLeft, gg.bind(self.onBtnLeft, self, -1))
    self:setOnClick(view.btnRight, gg.bind(self.onBtnLeft, self, 1))
end

function PnlBoard:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.newsScrollView.gameObject)
end

function PnlBoard:onRendernews(obj, index)
    local item = NewsItem:getItem(obj, self.newsItemList, self)
    item:setData(self.newsDataList[index])
end

function PnlBoard:onRendernewsCount(obj, index)
    local item = NewsCountItem:getItem(obj, self.newsCountItemList, self)
    item:setData(index)
    item:setSelect(index == self.showingIndex)
end

function PnlBoard:onPointerDownNews()
    self.pointerDownContentPositon = self.view.newsContent.anchoredPosition
end

function PnlBoard:onPointerUpNews()
    if not self.showingIndex then
        return
    end
    if self.pointerDownContentPositon.x < self.view.newsContent.anchoredPosition.x then
        self:setNewsIndex(self.showingIndex - 1)
    elseif self.pointerDownContentPositon.x > self.view.newsContent.anchoredPosition.x then
        self:setNewsIndex(self.showingIndex + 1)
    end
end

function PnlBoard:onBtnLeft(changeNum)
    if not self.showingIndex then
        return
    end
    self:setNewsIndex(self.showingIndex + changeNum)
end

function PnlBoard:onBtnOpenView()
    local curNews = self.newsDataList[self.showingIndex]
    if curNews then
        CS.UnityEngine.Application.OpenURL(curNews.url)
    end
end

function PnlBoard:onDestroy()
    local view = self.view
    self.newsScrollView:release()
    self.newsCountScrollView:release()
end

function PnlBoard:onBtnClose()
    self:close()
end

local newsWidth = 1304
local spancing = 10

function PnlBoard:setNewsIndex(index, isJump)
    if index < 1 or index > self.itemCount then
        return
    end

    self.showingIndex = index
    for key, value in pairs(self.newsCountItemList) do
        value:setSelect(value.index == index)
    end
    self.view.newsScrollView:GetComponent("ScrollRect"):StopMovement()
    local positionX = math.max(0, (index - 1) * (newsWidth + spancing))
    self.view.newsContent:DOKill()

    if isJump then
        self.view.newsContent.anchoredPosition = CS.UnityEngine.Vector2(-positionX, self.view.newsContent.anchoredPosition.y)
    else
        self.view.newsContent:DOAnchorPos(CS.UnityEngine.Vector2(-positionX, self.view.newsContent.anchoredPosition.y), 0.3)
    end
end

return PnlBoard