

PnlCardpoolMessage = class("PnlCardpoolMessage", ggclass.UIBase)

function PnlCardpoolMessage:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

function PnlCardpoolMessage:onAwake()
    self.view = ggclass.PnlCardpoolMessageView.new(self.pnlTransform)

    local view = self.view

    self.cardpoolMessageLeftBtns = CardpoolMessageLeftBtns.new(view.transform:Find("Root/CardpoolMessageLeftBtns"))
    self.cardpoolMessageTopBtns = CardpoolMessageTopBtns.new(view.transform:Find("Root/CardpoolMessageTopBtns"))

    self.cardMessageItemList = {}
    self.cardMessageScrollView = UILoopScrollView.new(view.transform:Find("Root/CardMessageScrollView"), self.cardMessageItemList)
    self.cardMessageScrollView:setRenderHandler(gg.bind(self.onRenderCardMessageItem, self))


    self.ratioItemList = {}
    self.ratioScrollView = UIScrollView.new(self.view.ratioScrollView, "CardPoolRatioItem", self.ratioItemList)
    self.ratioScrollView:setRenderHandler(gg.bind(self.onRenderRatioItem, self))
end

function PnlCardpoolMessage:onShow()
    self:bindEvent()

    local cardPoolBtnsData = {}

    for key, value in pairs(cfg.cardPool) do
        if value.available == 1 then
            table.insert(cardPoolBtnsData, {
                nameKey = value.name,
                callback = gg.bind(self.onBtnLeftBtn, self, value),
            })
        end
    end

    self.view.boxProbabilitys:SetActiveEx(false)
    self.cardpoolMessageLeftBtns:setBtnDataList(cardPoolBtnsData, 1)
end

function PnlCardpoolMessage:onHide()
    self:releaseEvent()

end

-- PnlCardpoolMessage.SHOW_TYPE_HERO = 1

PnlCardpoolMessage.CARD_TYPE_INFO = {
    [1] = {
        key = "heroShow",
        name = "Hero",
    },
    [2] = {
        key = "heroSkillShow",
        name = "HeroSkill",
    },
    [3] = {
        key = "warshipSkillShow",
        name = "warshipSkill"
    },
}

function PnlCardpoolMessage:onBtnLeftBtn(cardPoolCfg)
    self.cardPoolCfg = cardPoolCfg

    local cardPoolTopBtnsData = {}

    for index, value in ipairs(PnlCardpoolMessage.CARD_TYPE_INFO) do
        local showCardsCfg = cardPoolCfg[value.key]


        if showCardsCfg and next(showCardsCfg) then
            table.insert(cardPoolTopBtnsData, {
                nameKey = value.name,
                callback = gg.bind(self.onBtnTopBtn, self, showCardsCfg),
            })
        end
    end
    self.cardpoolMessageTopBtns:setBtnDataList(cardPoolTopBtnsData, 1)


    self.ratioDataList = cardPoolCfg.probabilityShow
    self.ratioScrollView:setItemCount(#self.ratioDataList)
end

function PnlCardpoolMessage:onRenderRatioItem(obj, index)
    local item = CardPoolRatioItem:getItem(obj, self.ratioItemList)
    item:setData(self.ratioDataList[index])
end

function PnlCardpoolMessage:onBtnTopBtn(showCardsCfg)
    self.cardDataList = showCardsCfg

    table.sort(self.cardDataList, function (a, b)
        local cfgA = cfg.item[a]
        local cfgB = cfg.item[b]

        if cfgA.quality ~= cfgB.quality then
            return cfgA.quality > cfgB.quality
        end

        return cfgA.cfgId < cfgB.cfgId
    end)

    local itemCount = math.ceil(#self.cardDataList / 7) 
    self.cardMessageScrollView:setDataCount(itemCount, true)
end

function PnlCardpoolMessage:onRenderCardMessageItem(obj, index )
    for i = 1, 7, 1 do
        local idx = (index - 1) * 7 + i

        local item = CardMessageItem:getItem(obj.transform:GetChild(i - 1), self.cardMessageItemList)

        item:setData(self.cardDataList[idx])
        
    end

end

function PnlCardpoolMessage:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnProbability):SetOnClick(function()
        self:onBtnProbability()
    end)
end

function PnlCardpoolMessage:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnProbability)
end

function PnlCardpoolMessage:onDestroy()
    local view = self.view
    self.cardpoolMessageLeftBtns:release()
    self.cardpoolMessageTopBtns:release()
    self.cardMessageScrollView:release()
    self.ratioScrollView:release()
end

function PnlCardpoolMessage:onBtnClose()
    self:close()
end

function PnlCardpoolMessage:onBtnProbability()
    self.view.boxProbabilitys:SetActiveEx(not self.view.boxProbabilitys.activeSelf)
end

-------------------------------------------
CardpoolMessageLeftBtns = CardpoolMessageLeftBtns or class("CardpoolMessageLeftBtns", ggclass.CommonBtnsBox)
function CardpoolMessageLeftBtns:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function CardpoolMessageLeftBtns:onGetBtnItem(item)
    item.image = item.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.text = item.transform:Find("Text"):GetComponent(typeof(CS.TextYouYU))
end

-- data = {nameKey = , callback = }
function CardpoolMessageLeftBtns:onSetBtnData(item, data)
    item.text:SetLanguageKey(data.nameKey)
end

function CardpoolMessageLeftBtns:onSetBtnStageWithoutNotify(item, isSelect)
    if isSelect then
        item.image.transform:SetActiveEx(true)
        -- gg.setSpriteAsync(item.image, "BuildShop_Atlas[Btn_Option_Select]")
        item.text.color = UnityEngine.Color(0xff / 0xff, 0xff / 0xff, 0xff / 0xff, 1)
    else
        item.image.transform:SetActiveEx(false)
        -- gg.setSpriteAsync(item.image, "BuildShop_Atlas[Btn_Option_Unselect]")
        item.text.color = UnityEngine.Color(0x3d / 0x97, 0x9f / 0xff, 0xe2 / 0xff, 1)
    end
end

--------------------------------------------
CardpoolMessageTopBtns = CardpoolMessageTopBtns or class("CardpoolMessageTopBtns", ggclass.CommonBtnsBox)
function CardpoolMessageTopBtns:ctor(obj, initData)
    ggclass.CommonBtnsBox.ctor(self, obj, initData)
end

function CardpoolMessageTopBtns:onGetBtnItem(item)
    item.image = item.transform:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.text = item.transform:Find("Text"):GetComponent(typeof(CS.TextYouYU))
end

-- data = {nameKey = , callback = }
function CardpoolMessageTopBtns:onSetBtnData(item, data)
    -- item.text:SetLanguageKey(data.nameKey)
    item.text.text = data.nameKey
end

function CardpoolMessageTopBtns:onSetBtnStageWithoutNotify(item, isSelect)
    if isSelect then
        item.image.transform:SetActiveEx(true)
        -- gg.setSpriteAsync(item.image, "BuildShop_Atlas[Btn_Option_Select]")
        item.text.color = UnityEngine.Color(0x31 / 0xd1, 0xff / 0xff, 0xff / 0xff, 1)
    else
        item.image.transform:SetActiveEx(false)
        -- gg.setSpriteAsync(item.image, "BuildShop_Atlas[Btn_Option_Unselect]")
        item.text.color = UnityEngine.Color(0x9f / 0xff, 0x9f / 0xff, 0x9f / 0xff, 1)
    end
end

---------------------------------------------
CardMessageItem = CardMessageItem or class("CardMessageItem", ggclass.UIBaseItem)

function CardMessageItem:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CardMessageItem:onInit()
    self.commonLongItem = CommonLongItem.new(self:Find("CommonLongItem")) 
    self.imgQuality = self:Find("BgQuality/ImgQuality", UNITYENGINE_UI_IMAGE)
end

function CardMessageItem:setData(itemCfgId)
    if not itemCfgId then
        self.transform:SetActiveEx(false)
        return
    end

    self.transform:SetActiveEx(true)
    local itemCfg = cfg.item[itemCfgId]

    if itemCfg then
        self.commonLongItem:setQuality(itemCfg.quality)
        local icon = ItemUtil.getItemIcon(itemCfgId)
        self.commonLongItem:setIcon(icon)
    end

    gg.setSpriteAsync(self.imgQuality, 
        gg.getSpriteAtlasName("PersonalArmyIcon_Atlas", PnlDrawCardInfo.QUALITY_ICON[itemCfg.quality]))

    -- self:setQuality(0)
end

function CardMessageItem:onRelease()
    self.commonLongItem:release()
end

----------------------------------------



CardPoolRatioItem = CardPoolRatioItem or class("CardPoolRatioItem", ggclass.UIBaseItem)

function CardPoolRatioItem:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CardPoolRatioItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtRatio = self:Find("TxtRatio", UNITYENGINE_UI_TEXT)
end

function CardPoolRatioItem:setData(data)
    self.txtName.text = Utils.getText(data[1])
    self.txtRatio.text = data[2] .. "%"
end

-- function CardPoolRatioItem:onRelease()
--     self.commonLongItem:release()
-- end


return PnlCardpoolMessage