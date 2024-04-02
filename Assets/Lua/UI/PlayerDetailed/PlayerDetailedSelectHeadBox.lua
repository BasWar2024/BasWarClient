PlayerDetailedSelectHeadBox = PlayerDetailedSelectHeadBox or class("PlayerDetailedSelectHeadBox", ggclass.UIBaseItem)
function PlayerDetailedSelectHeadBox:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PlayerDetailedSelectHeadBox:onInit()
    self.btnClose = self:Find("LayoutSelectHead/BtnClose")
    self:setOnClick(self.btnClose, gg.bind(self.close, self))

    self.headItemList = {}
    self.scrollHead = UIScrollView.new(self:Find("LayoutSelectHead/ScrollHead"), "PlayerDetailedHeadItem", self.headItemList)
    self.scrollHead:setRenderHandler(gg.bind(self.onRenderHead, self))

    self.imgHead = self:Find("LayoutSelectHead/BgRight/Mask/ImgHead", "Image")
    self.btnSet = self:Find("LayoutSelectHead/BgRight/BtnSet")
    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))
end

function PlayerDetailedSelectHeadBox:onRelease()
    self.scrollHead:release()
    self.setCallback = nil
end

function PlayerDetailedSelectHeadBox:onBtnSet()
    if self.setCallback then
        self.setCallback(self.selectIcon)
    end
end

function PlayerDetailedSelectHeadBox:SetBtnSetCallBack(callback)
    self.setCallback = callback
end

function PlayerDetailedSelectHeadBox:onOpen()
    -- self.dataList = cfg.PlayerHead
    self.dataList = {}
    for key, value in pairs(cfg.PlayerHead) do
        if value.available == 1 then
            table.insert(self.dataList, value)
        end
    end

    self.selectIcon = self.initData.selectIcon or Utils.getDefultHeadIconName()
    self.scrollHead:setItemCount(#self.dataList)
    gg.setSpriteAsync(self.imgHead, Utils.getHeadIcon(self.selectIcon))
end

function PlayerDetailedSelectHeadBox:selectHeadIcon(icon)
    if not self.scrollHead.isRenderFinish then
        return
    end

    for key, value in pairs(self.headItemList) do
        value:setSelect(icon)
    end

    self.selectIcon = icon
    gg.setSpriteAsync(self.imgHead, Utils.getHeadIcon(icon))
    --self.initData:selectHeadIcon(icon)
end

function PlayerDetailedSelectHeadBox:onRenderHead(obj, index)
    local item = PlayerDetailedHeadItem:getItem(obj, self.headItemList, self)
    item:setData(self.dataList[index])
end
------------------------------------------------------------
PlayerDetailedHeadItem = PlayerDetailedHeadItem or class("PlayerDetailedHeadItem", ggclass.UIBaseItem)
function PlayerDetailedHeadItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
    self.imgHead = self:Find("Mask/ImgHead", "Image")
    self.imgSelect = self:Find("ImgSelect", "Image")
end

function PlayerDetailedHeadItem:onInit()
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function PlayerDetailedHeadItem:setData(data)
    self.data = data
    gg.setSpriteAsync(self.imgHead, Utils.getHeadIcon(data.iconName))
    self:setSelect(self.initData.selectIcon)
end

function PlayerDetailedHeadItem:setSelect(icon)
    self.imgSelect.transform:SetActiveEx(self.data and icon == self.data.iconName)
end

function PlayerDetailedHeadItem:onClickItem()
    self.initData:selectHeadIcon(self.data.iconName)
end
