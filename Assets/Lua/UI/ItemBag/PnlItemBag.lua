PnlItemBag = class("PnlItemBag", ggclass.UIBase)

function PnlItemBag:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
    self.itemTable = {}
    self.itemData = cfg.get("etc.cfg.item")
end

function PnlItemBag:onAwake()
    self.view = ggclass.PnlItemBagView.new(self.transform)

end

function PnlItemBag:onShow()
    self:bindEvent()
    self:onRefreshItemBag()
    self.view.viewContent:GetComponent("RectTransform"):SetRectPosY(0)
    gg.event:dispatchEvent("onBgHighlighted", true)
end

function PnlItemBag:onHide()
    self:releaseEvent()
    self:releaseItem()
    self.view.uiItem:SetParent(self.view.transform, false)
    self.view.uiItem.gameObject:SetActive(false)
    gg.event:dispatchEvent("onBgHighlighted", false)
end

function PnlItemBag:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnType):SetOnClick(function()
        self:onBtnType()
    end)
    CS.UIEventHandler.Get(view.btnRare):SetOnClick(function()
        self:onBtnRare()
    end)
    CS.UIEventHandler.Get(view.btnQuantity):SetOnClick(function()
        self:onBtnQuantity()
    end)
    CS.UIEventHandler.Get(view.btnFull):SetOnClick(function()
        self:onBtnFull()
    end)
    CS.UIEventHandler.Get(view.btnFastFull):SetOnClick(function()
        self:onBtnFastFull()
    end)
    CS.UIEventHandler.Get(view.btnDel):SetOnClick(function()
        self:onBtnDel()
    end)
    CS.UIEventHandler.Get(view.btnUse):SetOnClick(function()
        self:onBtnPlace()
    end)

    gg.event:addListener("onItemSort", self)
    gg.event:addListener("onRefreshItemBag", self)
end

function PnlItemBag:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnType)
    CS.UIEventHandler.Clear(view.btnRare)
    CS.UIEventHandler.Clear(view.btnQuantity)
    CS.UIEventHandler.Clear(view.btnFull)
    CS.UIEventHandler.Clear(view.btnFastFull)
    CS.UIEventHandler.Clear(view.btnDel)
    CS.UIEventHandler.Clear(view.btnUse)

end

function PnlItemBag:onDestroy()
    local view = self.view
    gg.event:removeListener("onItemSort", self)
    gg.event:removeListener("onRefreshItemBag", self)

end

function PnlItemBag:onRefreshItemBag()
    self.view.uiItem:SetParent(self.view.transform, false)
    self.view.uiItem.gameObject:SetActive(false)
    self:releaseItem()
    local startPosX = 28
    local startPosY = -8
    local nextPosX = 180
    local nextPosY = -180
    local max = ItemData.maxSpace + ItemData.expandSpace
    local rowMax = max / 5
    rowMax = math.modf(rowMax)
    local viewHigh = startPosY + nextPosY * rowMax
    for k = 1, max do
        ResMgr:LoadGameObjectAsync("Item", function(obj)
            local args = k - 1
            local lineI = args % 5
            local rowI = args / 5
            rowI = math.modf(rowI)
            local psoX = startPosX + nextPosX * lineI
            local posY = startPosY + nextPosY * rowI

            obj.transform:SetParent(self.view.viewContent, false)
            obj.transform:GetComponent("RectTransform").localScale = Vector3(1, 1, 1)
            obj.transform:GetComponent("RectTransform"):SetRectPosX(psoX)
            obj.transform:GetComponent("RectTransform"):SetRectPosY(posY)
            table.insert(self.itemTable, obj)
            CS.UIEventHandler.Get(obj):SetOnClick(function()
                self:onItemClick(k)
            end)
            if k == max then
                self.sortType = 1
                self:onItemSort()
            end
            return true
        end, true)
    end
    self.view.viewContent:GetComponent("RectTransform").sizeDelta = Vector2.New(0, -viewHigh)
end

function PnlItemBag:releaseItem()
    if self.itemTable then
        for k, v in pairs(self.itemTable) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.sortTable = {}
        self.itemTable = {}
    end

end

function PnlItemBag:onBtnClose()
    self:close()
end

function PnlItemBag:onBtnType()
    if not self.coldTimer then
        self.sortType = 1
        self:onItemSort()
    end
end

function PnlItemBag:onBtnRare()
    if not self.coldTimer then
        self.sortType = 2
        self:onItemSort()
    end
end

function PnlItemBag:onBtnQuantity()
    if not self.coldTimer then
        self.sortType = 3
        self:onItemSort()
    end
end

function PnlItemBag:onBtnFull()

end

function PnlItemBag:onBtnFastFull()

end

function PnlItemBag:onBtnDel()
    local txt = "Are you sure you want to deleta Item?"
    local callbackYes = function()
        self:destoryItem()
    end

    local args = {
        txt = txt,
        callbackYes = callbackYes
    }

    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlItemBag:destoryItem()
    local index = self.itemIndex
    local id = self.sortTable[index].id
    ItemData.C2S_Player_DestoryItem(id)
end

function PnlItemBag:onBtnPlace()
    local index = self.itemIndex
    local id = self.sortTable[index].id
    local cfgId = ItemData.itemBagData[id].cfgId
    local targetCfgId = ItemData.itemBagData[id].targetCfgId
    local itemType = self.itemData[cfgId].itemType
    local level = ItemData.itemBagData[id].targetLevel
    if itemType == constant.ITEM_ITEMTYPE_WARSHIP then
        ItemData.C2S_Player_MoveOutItemBag(id, Vector3.zero)
    elseif itemType == constant.ITEM_ITEMTYPE_HERO then
        ItemData.C2S_Player_MoveOutItemBag(id, Vector3.zero)
    elseif itemType == constant.ITEM_ITEMTYPE_TURRET then
        local buildCfg = gg.buildingManager:getCfg(targetCfgId, level)
        local baseOwner = gg.buildingManager.baseOwner
        gg.buildingManager:loadBuilding(buildCfg, nil, id, baseOwner)
    end
    self:close()
end

function PnlItemBag:onItemClick(temp)
    if temp > #self.sortTable then
        return
    end
    self.itemIndex = temp
    local id = self.sortTable[temp].id
    local cfgId = ItemData.itemBagData[id].cfgId

    if self:whetherCompose(id, cfgId) then
        self:close()
        local args = {
            index = 3,
            openWindow = {
                name = "PnlDrawSet",
                args = {
                    item = ItemData.itemBagData[id]
                }
            }
        }
        gg.uiManager:openWindow("PnlInstitute", args)
    else
        self.view.uiItem.gameObject:SetActive(true)
        self.view.uiItem:SetParent(self.itemTable[temp].transform, false)
        self.view.uiItem:GetComponent("RectTransform"):SetRectPosX(0)
        self.view.uiItem:GetComponent("RectTransform"):SetRectPosY(0)
    end
end

function PnlItemBag:onItemSort()
    self.view.uiItem:SetParent(self.view.transform, false)
    self.view.uiItem.gameObject:SetActive(false)
    self.sortTable = {}
    if self.sortType == 1 then
        self.view.btnType.transform:Find("IconSelected").gameObject:SetActive(true)
        self.view.btnRare.transform:Find("IconSelected").gameObject:SetActive(false)
        self.view.btnQuantity.transform:Find("IconSelected").gameObject:SetActive(false)
    end
    if self.sortType == 2 then
        self.view.btnType.transform:Find("IconSelected").gameObject:SetActive(false)
        self.view.btnRare.transform:Find("IconSelected").gameObject:SetActive(true)
        self.view.btnQuantity.transform:Find("IconSelected").gameObject:SetActive(false)
    end
    if self.sortType == 3 then
        self.view.btnType.transform:Find("IconSelected").gameObject:SetActive(false)
        self.view.btnRare.transform:Find("IconSelected").gameObject:SetActive(false)
        self.view.btnQuantity.transform:Find("IconSelected").gameObject:SetActive(true)
    end
    for k, data in pairs(ItemData.itemBagData) do
        local sort = 0
        local id = 0
        local type = self.itemData[data.cfgId].itemType
        local quality = data.targetQuality
        if self.args == "Base" or type == constant.ITEM_ITEMTYPE_TURRET or type == constant.ITEM_ITEMTYPE_RESPLANETBUILD then
            local num = data.num
            local name = string.byte(self.itemData[data.cfgId].name)
            if self.sortType == 1 then
                --   
                sort = type * 1000000 + quality * 10000 + num * 100 + name
                id = data.id
            end
            if self.sortType == 2 then
                --   
                sort = quality * 1000000 + type * 10000 + num * 100 + name
                id = data.id
            end
            if self.sortType == 3 then
                --   
                sort = num * 1000000 + type * 10000 + quality * 100 + name
                id = data.id
            end
            local temp = {
                sort = sort,
                id = id
            }
            table.insert(self.sortTable, temp)
        end
    end

    QuickSort:quickSort(self.sortTable, 1, #self.sortTable)
    local max = #self.itemTable
    for k = 1, max do
        if k <= #self.sortTable then
            local id = self.sortTable[k].id
            local cfgId = ItemData.itemBagData[id].cfgId
            local num = ItemData.itemBagData[id].num
            local icon = self.itemData[cfgId].icon
            local name = self.itemData[cfgId].name
            if num == 1 then
                num = ""
            end
            self.itemTable[k].transform:Find("TxtName"):GetComponent("Text").text = name
            self.itemTable[k].transform:Find("TxtNum"):GetComponent("Text").text = num
            self.itemTable[k].transform:Find("IconItem").gameObject:SetActive(true)
            ResMgr:LoadSpriteAsync(icon, function(sprite)
                self.itemTable[k].transform:Find("IconItem"):GetComponent("Image").sprite = sprite
            end)
            if self:whetherCompose(id, cfgId) then
                self.itemTable[k].transform:Find("BtnComposable").gameObject:SetActive(true)
            else
                self.itemTable[k].transform:Find("BtnComposable").gameObject:SetActive(false)
            end
        else
            self.itemTable[k].transform:Find("TxtName"):GetComponent("Text").text = " "
            self.itemTable[k].transform:Find("TxtNum"):GetComponent("Text").text = " "
            self.itemTable[k].transform:Find("IconItem").gameObject:SetActive(false)
            self.itemTable[k].transform:Find("BtnComposable").gameObject:SetActive(false)
        end
    end

    self.coldTimer = gg.timer:addTimer(0.1, function()
        self.coldTimer = nil
    end)
end

function PnlItemBag:whetherCompose(id, cfgId)
    local num = ItemData.itemBagData[id].num
    local need = self.itemData[cfgId].composeNeed
    if need == 0 then
        return false
    end
    if num >= need then
        return true
    else
        return false
    end
end

return PnlItemBag
