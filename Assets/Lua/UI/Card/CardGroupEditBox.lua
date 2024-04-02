CardGroupEditBox = CardGroupEditBox or class("CardGroupEditBox", ggclass.UIBaseItem)
CardGroupEditBox.events = {"onUpData"}

function CardGroupEditBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function CardGroupEditBox:onRelease()
    -- CS.UIEventHandler.Clear(self.cardScrollView.gameObject)
    self.cardScrollView:release()
    self.settingScrollView:release()
    self.dragCardItem:release()

    self.inputName.onValueChanged:RemoveAllListeners()
    self.inputName.onEndEdit:RemoveAllListeners()
end

function CardGroupEditBox:onInit()
    self.btnClose = self:Find("BtnClose")
    self:setOnClick(self.btnClose, gg.bind(self.onBtnClose, self))
    self.settingItemList = {}
    self.settingScrollView = UIScrollView.new(self:Find("LayoutSetting/SettingScrollView"), "SettingCardItem", self.settingItemList)
    self.settingScrollView:setRenderHandler(gg.bind(self.onRenderSettingCard, self))

    self.cardItemList = {}
    self.cardScrollView = UIScrollView.new(self:Find("LayoutCard/CardScrollView"), "ExistCardItem", self.cardItemList)
    self.cardScrollView:setRenderHandler(gg.bind(self.onRenderCard, self))

    self.cardScrollViewContent = self.cardScrollView.component.content
    self.cardScrollViewHorizontalLayoutGroup = self.cardScrollViewContent.transform:GetComponent(typeof(UnityEngine.UI.HorizontalLayoutGroup))

    self.btnFrontPage = self:Find("BtnFrontPage").gameObject
    self:setOnClick(self.btnFrontPage, gg.bind(self.changePage, self, -1))
    self.btnNextPage = self:Find("BtnNextPage").gameObject
    self:setOnClick(self.btnNextPage, gg.bind(self.changePage, self, 1))

    self.btnSave = self:Find("BtnSave")
    self:setOnClick(self.btnSave, gg.bind(self.onBtnSave, self))
    self.btnDelete = self:Find("BtnDelete")
    self:setOnClick(self.btnDelete, gg.bind(self.onBtnDelete, self))

    self.inputName = self:Find("InputName", "InputField")
    self.inputName.onValueChanged:AddListener(gg.bind(self.onInputName, self))
    self.inputName.onEndEdit:AddListener(gg.bind(self.onInputNameEnd, self))

    self.dragCardItem = ExistCardItem.new(self:Find("DragCardItem"))
    --self.camera = uiCamera.transform:GetComponent("Camera")

    self.cardGroupFilterBtnsBox = CardGroupFilterBtnsBox.new(self:Find("CardGroupFilterBtnsBox"))
end

local maxNameLenth = 6
function CardGroupEditBox:onInputName(text)
    local str = string.ltrim(text)
    str = FilterWords.filterWords(str)
    self.inputName.text = string.utf8sub(str, 1, maxNameLenth)
end

function CardGroupEditBox:onInputNameEnd(text)
    self.inputName.text = FilterWords.filterWords(text)
    CardData.C2S_Player_renameCardGroup(self.groupType, self.index, self.inputName.text)
end

CardGroupEditBox.INDEX_2_NAME = {
    [1] = "A",
    [2] = "B",
    [3] = "C",
    [4] = "D",
}

function CardGroupEditBox:onOpen(index, groupType)
    self.index = index
    self.groupType = groupType

    self.data = CardUtil.getCardGroupData(index, groupType)
    self.settingCardDataList = {}
    if self.data then
        self.settingCardDataList = self.data.group.cardIds
        self.inputName.text = self.data.group.name
    else
        self.inputName.text = CardGroupEditBox.INDEX_2_NAME[index]
    end

    self.settingScrollView:setItemCount(8)
    -- self:refreshCard()
    self.dragCardItem:setActive(false)
    self.isDrag = false

    self.cardGroupFilterBtnsBox:setBtnDataList({
        {name = "All", callback = gg.bind(self.refreshCard, self, -1)},
        {name = "1", callback = gg.bind(self.refreshCard, self, 1)},
        {name = "2", callback = gg.bind(self.refreshCard, self, 2)},
    }, 1)
end

function CardGroupEditBox:onBtnSave()
    for i = 1, 8, 1 do
        if self.settingCardDataList[i] == nil then
            gg.uiManager:showTip("not enought cards")
            return
        end
    end
    CardData.C2S_Player_setCardGroup(self.groupType, self.index, self.settingCardDataList, self.inputName.text)
end

function CardGroupEditBox:onBtnDelete()
    CardData.C2S_Player_delCardGroup(self.groupType, self.index)
end

function CardGroupEditBox:refreshCard(quality)
    self.cardDataList = {}
    for key, value in pairs(CardData.cardList) do
        if quality == -1 then
            table.insert(self.cardDataList, value)
        elseif quality == value.quality then
            table.insert(self.cardDataList, value)
        end
    end
    table.sort(self.cardDataList, function (a, b)
        -- local cfgA = cfg.card[a.cfgId]
        -- local cfgB = cfg.card[b.cfgId]
        return a.cfgId < b.cfgId
    end)

    local spancing = self.cardScrollViewHorizontalLayoutGroup.spacing
    self.cardCount = #self.cardDataList --#CardData.cardList

    local cardWidth = self.dragCardItem.transform.rect.width
    local scrollViewWidth = self.cardScrollView.transform.rect.width

    local cardCountPerPage = math.ceil(scrollViewWidth / (cardWidth + spancing))
    local pageWidth = (cardWidth + spancing) * cardCountPerPage - spancing

    if pageWidth > scrollViewWidth then
        cardCountPerPage = cardCountPerPage - 1
        pageWidth = (cardWidth + spancing) * cardCountPerPage - spancing
    end

    local totalWidth = (cardWidth + spancing) * self.cardCount - spancing
    local cardPageCount = math.ceil(self.cardCount / cardCountPerPage)

    local subWidth = cardPageCount * (pageWidth + spancing) - totalWidth
    self.cardScrollViewHorizontalLayoutGroup.padding.right = math.ceil(subWidth)

    self.cardPageCount = cardPageCount
    self.pageWidth = pageWidth

    self:setCardPage(1)
    self.cardScrollView:setItemCount(self.cardCount)
end

function CardGroupEditBox:startScrollPage()
    local content = self.cardScrollView.component.content
    self.pointerDownContentPositon = content.anchoredPosition
end

function CardGroupEditBox:endScrollPage()
    if not self.showingPage or not self.pointerDownContentPositon then
        return
    end

    local content = self.cardScrollView.component.content
    if self.pointerDownContentPositon.x + 20 < content.anchoredPosition.x then
        self:setCardPage(self.showingPage - 1)
    elseif self.pointerDownContentPositon.x - 20 > content.anchoredPosition.x then
        self:setCardPage(self.showingPage + 1)
    else
        self:setCardPage(self.showingPage)
    end
end

function CardGroupEditBox:changePage(change)
    self:setCardPage(self.showingPage + change)
end

function CardGroupEditBox:setCardPage(page, isJump)
    if page < 1 or page > self.cardPageCount then
        return
    end

    self.showingPage = page
    self.cardScrollView.component:StopMovement()

    local spancing = self.cardScrollViewHorizontalLayoutGroup.spacing
    local positionX = math.max(0, (page - 1) * (self.pageWidth + spancing))
    local content = self.cardScrollView.component.content
    content:DOKill()

    if isJump then
        content.anchoredPosition = CS.UnityEngine.Vector2(-positionX, content.anchoredPosition.y)
    else
        content:DOAnchorPos(CS.UnityEngine.Vector2(-positionX, content.anchoredPosition.y), 0.3)
    end
end

function CardGroupEditBox:setData()
end

function CardGroupEditBox:onBtnClose()
    self.initData:editCardGroup(false)
end

function CardGroupEditBox:onRenderSettingCard(obj, index)
    local item = SettingCardItem:getItem(obj, self.settingItemList, self)
    item:setData(self.settingCardDataList[index], index)
end

function CardGroupEditBox:onRenderCard(obj, index)
    local item = ExistCardItem:getItem(obj, self.cardItemList, self)
    item:setData(self.cardDataList[index])
end

function CardGroupEditBox:startDargCard(startObj, data)
    for _, cfgId in pairs(self.settingCardDataList) do
        if cfgId == data.cfgId then
            gg.uiManager:showTip("repeated card")
            return
        end
    end

    self.dragCardItem:setData(data)
    self.dragCardItem:setActive(true)
    self.dragCardItem.transform.position = startObj.transform.position
    self.isDrag = true
    self.cardScrollView.component.horizontal = false
    -- self.cardScrollView.component.vertical = false
end

function CardGroupEditBox:endDargCard()
    self.isDrag = false
    self.cardScrollView.component.horizontal = true
    -- self.cardScrollView.component.vertical = true
    local dragItemPos = self.dragCardItem.transform.localPosition
    self.dragCardItem:setActive(false)

    for key, value in pairs(self.settingItemList) do
        local itemPosition = self.transform:InverseTransformPoint(value.transform.position)
        if math.abs(itemPosition.x - dragItemPos.x) < value.transform.rect.width / 2 and 
            math.abs(itemPosition.y - dragItemPos.y) < value.transform.rect.height / 2 then
                -- for _, cfgId in pairs(self.settingCardDataList) do
                --     if cfgId == self.dragCardItem.data.cfgId then
                --         gg.uiManager:showTip("repeated card")
                --         return
                --     end
                -- end
                value:setData(self.dragCardItem.data.cfgId)
            break
        end
    end
end

function CardGroupEditBox:onUpData()
    if CS.UnityEngine.Input.GetMouseButtonUp(0) then
        self:endScrollPage()
    elseif CS.UnityEngine.Input.GetMouseButtonDown(0) then
        self:startScrollPage()
    end

    if not self.isDrag then
        return
    end
    --local worldPos = self.camera:ScreenToWorldPoint(CS.UnityEngine.Input.mousePosition)
    local localPos = self.transform:InverseTransformPoint(worldPos)
    localPos.z = 0
    self.dragCardItem.transform.localPosition = localPos
    if CS.UnityEngine.Input.GetMouseButtonUp(0) then
        self:endDargCard()
    end
end
-----------------------------------------------------------------
SettingCardItem = SettingCardItem or class("SettingCardItem", ggclass.UIBaseItem)

function SettingCardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function SettingCardItem:onRelease()
    CS.UIEventHandler.Clear(self.gameObject)
end

function SettingCardItem:onInit()
    -- self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    -- CS.UIEventHandler.Get(self.gameObject):SetOnPointerDown(gg.bind(self.onItemDown, self, 1))
    -- CS.UIEventHandler.Get(self.gameObject):SetOnPointerUp(gg.bind(self.onItemUp, self, 1))
    self.layoutExistCard = self:Find("LayoutExistCard").transform
    self.txtName = self.layoutExistCard:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
end

function SettingCardItem:setData(cfgId, index)
    self.cfgId = cfgId
    index = index or self.index
    self.index = index

    if not cfgId then
        self.layoutExistCard:SetActiveEx(false)
        return
    end
    self.layoutExistCard:SetActiveEx(true)
    local curCfg = cfg.card[cfgId]
    self.txtName.text = curCfg.name

    self.initData.settingCardDataList[index] = cfgId
end

function SettingCardItem:onClickItem()
    if not self.cfgId then
        return
    end

    gg.uiManager:openWindow("PnlCardDesc", {cfgId = self.cfgId})
end
-----------------------------------------------------------------
ExistCardItem = ExistCardItem or class("ExistCardItem", ggclass.UIBaseItem)

function ExistCardItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
    -- self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function ExistCardItem:onRelease()
    CS.UIEventHandler.Clear(self.gameObject)
end

function ExistCardItem:onInit()
    -- self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    CS.UIEventHandler.Get(self.gameObject):SetOnPointerDown(gg.bind(self.onItemDown, self, 1))
    CS.UIEventHandler.Get(self.gameObject):SetOnPointerUp(gg.bind(self.onItemUp, self, 1))
    self.layoutExistCard = self:Find("LayoutExistCard").transform
    self.txtName = self.layoutExistCard:Find("TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
end

-- data = CardType {cfgId, level, quality}
function ExistCardItem:setData(data)
    self.data = data

    if not data then
        self.layoutExistCard:SetActiveEx(false)
        return
    end

    self.layoutExistCard:SetActiveEx(true)
    local curCfg = cfg.card[data.cfgId]
    self.txtName.text = curCfg.name
end

function ExistCardItem:onItemDown()
    if not self.data then
        return
    end

    self.isOpenDesc = true
    self.dragTimer = gg.timer:startTimer(0.5, function ()
        self.isOpenDesc = false
        self.initData:startDargCard(self.gameObject, self.data)
    end)
end

function ExistCardItem:onItemUp()
    if not self.data then
        return
    end
    gg.timer:stopTimer(self.dragTimer)
    -- if self.isOpenDesc then
    --     -- print("desc")
    -- end
end
------------------------------------------------------------------------

CardGroupFilterBtnsBox = CardGroupFilterBtnsBox or class("CardGroupFilterBtnsBox", ggclass.CommonBtnsBox)
function CardGroupFilterBtnsBox:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function CardGroupFilterBtnsBox:onGetBtnItem(item)
    item.text = item.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
end

function CardGroupFilterBtnsBox:onSetBtnData(item, data)
    item.text.text = data.name
    -- item.txtSelect.text = data.name

    -- local sprite = ""
    -- if data.icon then
    --     sprite = data.icon
    -- else
    --     if data.name == "Upgrade" then
    --         sprite = "Ascension_icon_A"
    --     end
    -- end
    -- gg.setSpriteAsync(item.icon, sprite)
end

function CardGroupFilterBtnsBox:onSetBtnStageWithoutNotify(item, isSelect)
    -- item.txtBtn.transform:SetActiveEx(not isSelect)
    -- item.imgSelect.transform:SetActiveEx(isSelect)
end