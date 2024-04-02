CardGroupItem = CardGroupItem or class("CardGroupItem", ggclass.UIBaseItem)

function CardGroupItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function CardGroupItem:onInit()
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))

    self.layoutExist = self:Find("LayoutExist").transform
    self.txtName = self.layoutExist:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnSet = self:Find("LayoutExist/BtnSet")
    self.txtBtnSet = self.btnSet.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)

    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))
end

function CardGroupItem:setData(index, groupType)
    self.index = index
    self.groupType = groupType

    local data = CardUtil.getCardGroupData(index, groupType)
    if not data then
        self.layoutExist:SetActiveEx(false)
        return
    end

    self.layoutExist:SetActiveEx(true)
    self.txtName.text = data.group.name

    if CardData.useGrpIdx[self.groupType] == self.index then
        self.txtBtnSet.text = "Setting"
    else
        self.txtBtnSet.text = "set"
    end
end

function CardGroupItem:onBtnSet() 
    if CardData.useGrpIdx[self.groupType] == self.index then
        return
    end

    CardData.C2S_Player_setUseCardGroup(self.groupType, self.index)
end

function CardGroupItem:onClickItem()
    self.initData:editCardGroup(true, self.index, self.groupType)
end

------------------------------------------------------------------------------------------------

CardItem = CardItem or class("CardItem", ggclass.UIBaseItem)

function CardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function CardItem:onInit()
    self.txtName = self:Find("TxtName", "Text")
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    self.imgCardBack = self:Find("ImgCardBack"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtRes = self:Find("TxtRes", "Text")
    self:setTxtRes(false)

    self:showCardBack(false)
end

function CardItem:setData(cfgId)
    local curCfg = cfg.card[cfgId]
    self.txtName.text = curCfg.name
end

function CardItem:showCardBack(isShow)
    self.imgCardBack.gameObject:SetActiveEx(isShow)
end

function CardItem:setTxtRes(text)
    if text then
        self.txtRes.gameObject:SetActiveEx(true)
        self.txtRes.text = text
    else
        self.txtRes.gameObject:SetActiveEx(false)
    end
end

function CardItem:onClickItem()
    if self.clickCallback then
        self.clickCallback()
    end
end

---""
function CardItem:setClickCallback(callback)
    self.clickCallback = callback
end