DrawCardBox = DrawCardBox or class("DrawCardBox", ggclass.UIBaseItem)

function DrawCardBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function DrawCardBox:onRelease()
    
end

function DrawCardBox:onInit()

    self.btnClose = self:Find("BtnClose")
    self:setOnClick(self.btnClose, gg.bind(self.onBtnClose, self))
    self.layoutDraw = self:Find("LayoutDraw").transform
    self.btnDrawOne = self.layoutDraw:Find("BtnDrawOne").gameObject
    self.btnDrawMore = self.layoutDraw:Find("BtnDrawMore").gameObject

    self:setOnClick(self.btnDrawOne, gg.bind(self.onBtnDrawCard, self, 1))
    self:setOnClick(self.btnDrawMore, gg.bind(self.onBtnDrawCard, self, 10))

    -- self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    -- self.txtName = self:Find("TxtName", "Text")
    -- self.txtName.text = "??"
end

-- function DrawCardBox:setData(index)
--     self.index = index
-- end
-- function DrawCardBox:onClickItem()
--     self.initData:editCardGroup(true, self.index)
-- end

function DrawCardBox:onBtnDrawCard(count)
    CardData.C2S_Player_drawCard(count)
end

function DrawCardBox:onBtnClose()
    self.initData:drawCard(false)
end
