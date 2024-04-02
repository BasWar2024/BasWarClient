DrawCardResultBox = DrawCardResultBox or class("DrawCardResultBox", ggclass.UIBaseItem)

DrawCardResultBox.events = {"onMoonCardChange"}

function DrawCardResultBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function DrawCardResultBox:onInit()
    self.layoutResult = self:Find("LayoutResult").transform

    self.cardItemList = {}
    self.scrollView = UIScrollView.new(self.layoutResult:Find("ScrollView"), "BoxCards", self.cardItemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderCard, self))

    self.btnAgain = self.layoutResult:Find("BtnAgain").gameObject
    self:setOnClick(self.btnAgain, gg.bind(self.onBtnAgain, self))

    self.iconRes = self.btnAgain.transform:Find("BgBlack/IconRes"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtRes = self.btnAgain.transform:Find("BgBlack/TxtRes"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutOneCardAnim = self:Find("LayoutOneCardAnim").transform

    self.spineTheCardUi = self.layoutOneCardAnim:Find("SpineTheCardUi"):GetComponent("SkeletonGraphic")

    self.boxCard = BoxCard.new(self.layoutOneCardAnim:Find("BoxCard"))
end

function DrawCardResultBox:onRelease()
    self.scrollView:release()
end

function DrawCardResultBox:onBtnAgain()
    DrawCardData.C2S_Player_Draw_Card(self.cardPoolId, self.drawNum)
end

function DrawCardResultBox:setData(cardData, cardPoolId, drawNum)
    self.cardData = cardData
    self.cardCfgIds = self.cardData.cfgIds
    self.newCfgIds = self.cardData.newCfgIds

    self.cardPoolId = cardPoolId
    self.drawNum = drawNum

    self.showOneCardAnimQuene = {}

    for key, value in pairs(cardData.cfgIds) do
        local itemCfg = cfg.item[value]
        if itemCfg.quality >= 3 then
            table.insert(self.showOneCardAnimQuene, value)
        end
    end

    self.layoutResult:SetActiveEx(false)
    self.layoutOneCardAnim:SetActiveEx(true)
    self:showOneCardAnim()
    -- self:showResult()
end

function DrawCardResultBox:showOneCardAnim()
    if not next(self.showOneCardAnimQuene) then
        self:showResult()
        return
    end

    local cfgId = table.remove(self.showOneCardAnimQuene, 1)
    self.boxCard:setData(cfgId, self.newCfgIds, 0, false)

    self.spineTheCardUi.transform:SetActiveEx(true)
    local anim = self.spineTheCardUi
    anim.Skeleton:SetToSetupPose()
    anim.AnimationState:ClearTracks()
    anim.AnimationState:SetAnimation(0, "animation", false)

    -- anim.AnimationState:AddAnimation(0, "idle", true, 0)

    self.boxCard.transform:SetActiveEx(false)
    self.boxCard.transform.localScale = UnityEngine.Vector3(0, 0, 0)

    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:AppendInterval(0.6)
    sequence:AppendCallback(function()
        self.boxCard.transform:SetActiveEx(true)
        self.spineTheCardUi.transform:SetActiveEx(false)
    end)
    sequence:Append(self.boxCard.transform:DOScale(UnityEngine.Vector3(1, 1, 1), 0.5))
    sequence:AppendInterval(0.6)
    sequence:AppendCallback(function()
        self:showOneCardAnim()
    end)
end

local animTime = 0.3
local animInterval = 0.2

function DrawCardResultBox:showResult()
    self.layoutResult:SetActiveEx(true)
    self.layoutOneCardAnim:SetActiveEx(false)

    local dataCount = math.ceil(#self.cardCfgIds / 5)
    self.scrollView:setItemCount(dataCount)

    local curPoorCfg = cfg.getCfg("cardPool", self.cardPoolId)
    if curPoorCfg.costItem[1] then
        local curCfg = cfg.getCfg("item", curPoorCfg.costItem[1])
        gg.setSpriteAsync(self.iconRes, gg.getSpriteAtlasName("ResIcon_200_Atlas", curCfg.icon))
        if self.drawNum == 1 then
            self.txtRes.text = curPoorCfg.costItem[2] * self.drawNum
        else
            self.txtRes.text = curPoorCfg.costItemInMuilt[2]
        end

    elseif curPoorCfg.costRes[1] then
        gg.setSpriteAsync(self.iconRes, constant.RES_2_CFG_KEY[curPoorCfg.costRes[1]].icon)

        local discount = 1
        if curPoorCfg.costRes[1] == constant.RES_TESSERACT then
            discount = DrawCardData.discount
        end

        local cost = 0

        if self.drawNum == 1 then
            cost = curPoorCfg.costRes[2] / 1000 * discount
        else
            cost = curPoorCfg.costResInMuilt[2] / 1000 * discount * self.drawNum
        end

        self.txtRes.text = Utils.scientificNotation(cost)
    end

    if dataCount > 1 then
        self.scrollView.transform:SetRectSizeY(692)
    else
        self.scrollView.transform:SetRectSizeY(352)
    end

    self.btnAgain:SetActiveEx(false)
    local delay = #self.cardCfgIds * animInterval + animTime
    gg.timer:startTimer(delay, function()
        self.btnAgain:SetActiveEx(true)
    end)
end

function DrawCardResultBox:onRenderCard(obj, index)
    for i = 1, 5, 1 do
        local idx = (index - 1) * 5 + i
        local item = BoxCard:getItem(obj.transform:GetChild(i - 1), self.cardItemList, self)
        item:setData(self.cardCfgIds[idx], self.newCfgIds, idx, true)
    end
end

function DrawCardResultBox:onOpen(...)

end

function DrawCardResultBox:onClose()

end

---------------------------------------------------

BoxCard = BoxCard or class("BoxCard", ggclass.UIBaseItem)

BoxCard.events = {"onMoonCardChange"}

function BoxCard:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BoxCard:onInit()
    self.root = self:Find("Root").transform
    self.canvasGroup = self.root:GetComponent(typeof(UnityEngine.CanvasGroup))

    self.iconBg = self.root:Find("IconBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.icon = self.root:Find("IconBg/Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.imgNew = self.root:Find("ImgNew"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.bgLight = self.root:Find("BgLight")

    self.bgQuality = self.root:Find("BgQuality").transform
    self.imgQuality = self.root:Find("BgQuality/ImgQuality"):GetComponent(UNITYENGINE_UI_IMAGE)

end

function BoxCard:onRelease()
end

-- self.newCfgIds

function BoxCard:setData(itemCfgId, newCfgIds, index, isShowAnim)

    if not itemCfgId then
        self.transform:SetActiveEx(false)
        return
    end

    self.imgNew.transform:SetActiveEx(false)

    for key, value in pairs(newCfgIds) do
        if value == itemCfgId then
            self.imgNew.transform:SetActiveEx(true)
            break
        end
    end

    self.transform:SetActiveEx(true)

    local itemCfg = cfg.item[itemCfgId]
    local itemType = itemCfg.itemType


    local spriteName = ItemUtil.getItemIcon(itemCfgId)

    self.bgQuality:SetActiveEx(false)
    if itemType == constant.ITEM_ITEMTYPE_HERO then
        self.bgQuality:SetActiveEx(true)

        gg.setSpriteAsync(self.imgQuality, string.format("PersonalArmyIcon_Atlas[quality_icon_%sB]", itemCfg.quality))
    end

    gg.setSpriteAsync(self.icon, spriteName)
    gg.setSpriteAsync(self.iconBg,
        gg.getSpriteAtlasName("Item_Bg_Atlas", string.format("longframe_icon_%s", itemCfg.quality)))

    self.bgLight:SetActiveEx(itemCfg.quality >= 3)

    if isShowAnim then
        self.canvasGroup.alpha = 0
        self.root.anchoredPosition = UnityEngine.Vector2(0, -100)

        local sequence = CS.DG.Tweening.DOTween.Sequence()
        sequence:AppendInterval(index * animInterval)
        sequence:Append(self.canvasGroup:DOFade(1, animTime))
        sequence:Join(self.root:DOAnchorPosY(0, animTime))
    end

end
