
PnlRank = class("PnlRank", ggclass.UIBase)

function PnlRank:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    self.layer = UILayer.normal
    self.events = { }
    self.test = "test"
    self.rankItemList = {}
end

function PnlRank:onAwake()
    self.view = ggclass.PnlRankView.new(self.transform)
end

function PnlRank:onShow()
    self:bindEvent()
    self:onBtnTop(1)

    --self.view.transform:DOScale(Vector3(5, 5, 0), 2);
    -- self:onBtnServer(1)
    -- self.listView = UIList.new(self.view.listView, "UIListItem", true)
    -- self.listView:ResetItemDatas()
    -- self.listView:RefreshData({{},{},{},{},{},{},{},{},{},{},{}})
end

function PnlRank:onHide()
    self:releaseEvent()
    for key, value in pairs(self.rankItemList) do
        value:release()
    end
    --self.view.scrollView:release()
end

function PnlRank:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    for i = 1, #view.topBtnList do
        self:setOnClick(view.topBtnList[i].gameObject, gg.bind(self.onBtnTop, self, i))
    end

    --view.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    self.view.loopScrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function PnlRank:onRenderItem(obj, index)
    local item = RankItem:getItem(obj, self.view.rankItemList, self)
    item:setData(index)
end

function PnlRank:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlRank:onDestroy()
    local view = self.view
    self.view.loopScrollView:release()
end

function PnlRank:onBtnClose()
    self:close()
end

function PnlRank:onBtnTop(index)
    --print(index)
    if self.selectType == index then
        return
    end
    self.selectType = index
    local view = self.view
    for i = 1, #view.topBtnList do
        if index == i then
            ResMgr:LoadSpriteAsync("tap_button_A", function(sprite)
                view.topBtnList[i].image.sprite = sprite
            end)
            ResMgr:LoadSpriteAsync(string.format("RankTopIcon%d_2", i), function(sprite)
                view.topBtnList[i].imgIcon.sprite = sprite
                view.topBtnList[i].imgIcon.transform.sizeDelta = CS.UnityEngine.Vector2(45, 45)
            end)
        else
            ResMgr:LoadSpriteAsync("tap_button_B", function(sprite)
                view.topBtnList[i].image.sprite = sprite
            end)
            ResMgr:LoadSpriteAsync(string.format("RankTopIcon%d_1", i), function(sprite)
                view.topBtnList[i].imgIcon.sprite = sprite
                view.topBtnList[i].imgIcon.transform.sizeDelta = CS.UnityEngine.Vector2(30, 30)
            end)
        end
    end

    --self.view.scrollView:setItemCount(index)

    self.view.loopScrollView:setDataCount(50)
end

return PnlRank