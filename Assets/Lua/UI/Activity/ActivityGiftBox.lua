ActivityGiftBox = ActivityGiftBox or class("ActivityGiftBox", ggclass.UIBaseItem)

ActivityGiftBox.events = {"onRefreshActivityGiftBox"}

function ActivityGiftBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function ActivityGiftBox:onInit()
    self.itemList = {}
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "ActivityGiftItem", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function ActivityGiftBox:onOpen(...)
    local num = #ActivityData.dailyGift
    self.scrollView:setItemCount(num)

end

function ActivityGiftBox:onRenderItem(obj, index)
    local item = ActivityGiftItem:getItem(obj, self.itemList, self)
    item:setData(index)
end

function ActivityGiftBox:onClose()
end

function ActivityGiftBox:onRelease()
    self.scrollView:release()
end

function ActivityGiftBox:onRefreshActivityGiftBox()
    self:onOpen()
end

---------------------------------------------------------------

ActivityGiftItem = ActivityGiftItem or class("ActivityGiftItem", ggclass.UIBaseItem)

function ActivityGiftItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function ActivityGiftItem:onInit()
    self.txtTime = self:Find("TxtTime", UNITYENGINE_UI_TEXT)
    self.txtTitle = self:Find("TxtTitle", UNITYENGINE_UI_TEXT)
    self.imgIcon = self:Find("ImgIcon", UNITYENGINE_UI_IMAGE)
    self.txtCost = self:Find("BtnBuy/Text", UNITYENGINE_UI_TEXT)

    self.btnBuy = self:Find("BtnBuy")
    self:setOnClick(self.btnBuy, gg.bind(self.onBtnBuy, self))

    self:startTimer()
end

function ActivityGiftItem:startTimer()
    gg.timer:stopTimer(self.timer)

    -- local endTime = Utils.getServerSec() + 3600 * 5
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = math.ceil(24 * 60 * 60 - gg.time.getDaySecPass(Utils.getServerSec(), 8 * 60 * 60))
        local hms = gg.time.dhms_time({
            day = false,
            hour = 1,
            min = 1,
            sec = 1
        }, time)
        self.txtTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
    end)
end

function ActivityGiftItem:onRelease()
    self.scrollView:release()

    gg.timer:stopTimer(self.timer)
    self.curCfg = nil
    self.itemCfg = nil
end

function ActivityGiftItem:onBtnBuy()

    ShopUtil.buyProduct(self.curCfg.productId)
end

function ActivityGiftItem:setData(index)
    self.index = index
    self.curCfg = ShopUtil.getProduct(ActivityData.dailyGift[index].productId)
    self.itemCfg = cfg.getCfg("item", self.curCfg.itemCfgId)

    self.txtTitle.text = Utils.getText(self.curCfg.name)
    local iconName = gg.getSpriteAtlasName("ShopIcon_Atlas", self.curCfg.icon)
    gg.setSpriteAsync(self.imgIcon, iconName)

    self.txtCost.text = string.format("$%s", self.curCfg.price)

    self.itemList = {}
    self.scrollView = UIScrollView.new(self:Find("LayoutReward/ScrollView"), "ActivityGiftCost", self.itemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))

    local num = #self.itemCfg.effect
    self.scrollView:setItemCount(num)

end

function ActivityGiftItem:onRenderItem(obj, index)
    local item = ActivityGiftCost:getItem(obj, self.itemList, self)
    item:setData(self.itemCfg.effect[index])
end

---------------------------------------------------------------
ActivityGiftCost = ActivityGiftCost or class("ActivityGiftCost", ggclass.UIBaseItem)

function ActivityGiftCost:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function ActivityGiftCost:onInit()
    self.txtRes = self:Find("TxtRes", UNITYENGINE_UI_TEXT)
    self.txtNum = self:Find("TxtNum", UNITYENGINE_UI_TEXT)
    self.imgRes = self:Find("ImgRes", UNITYENGINE_UI_IMAGE)
    self.imgBg = self:Find("ImgBg", UNITYENGINE_UI_IMAGE)
    self.icon = self:Find("ImgBg/Mask/Icon", UNITYENGINE_UI_IMAGE)

end

function ActivityGiftCost:setData(cfgId)
    local effCfg = cfg.itemEffect[cfgId]
    if effCfg.effectType == constant.GIFT_EFFECT_RES then
        self.imgBg.gameObject:SetActiveEx(false)
        local resId = effCfg.value[1]
        local num = effCfg.value[2]
        if not resId or not num then
            self:release()
            return
        end
        self.txtNum.text = string.format("X%s", Utils.scientificNotationInt(num / 1000))
        self.txtRes.text = Utils.getText(constant.RES_2_CFG_KEY[resId].languageKey)
        gg.setSpriteAsync(self.imgRes, constant.RES_2_CFG_KEY[resId].icon)
    elseif effCfg.effectType == constant.GIFT_EFFECT_HERO then
        self.imgRes.transform:SetActiveEx(false)
        local cfgId = effCfg.value[1]
        local quailty = effCfg.value[2]
        local lv = effCfg.value[3]
        local curCfg = cfg.getCfg("hero", cfgId, lv, quailty)
        UIUtil.setQualityBg(self.imgBg, quailty)
        local iconName = gg.getSpriteAtlasName("Hero_A_Atlas", curCfg.icon .. "_A")
        gg.setSpriteAsync(self.icon, iconName)
        self.txtNum.text = string.format("X%s", 1)
        self.txtRes.text = Utils.getText(curCfg.languageNameID)

    elseif effCfg.effectType == constant.GIFT_EFFECT_WARSHIP then
        self.imgRes.transform:SetActiveEx(false)
        local cfgId = effCfg.value[1]
        local quailty = effCfg.value[2]
        local lv = effCfg.value[3]
        local curCfg = cfg.getCfg("warShip", cfgId, lv, quailty)
        UIUtil.setQualityBg(self.imgBg, quailty)
        local iconName = gg.getSpriteAtlasName("Warship_A_Atlas", curCfg.icon .. "_A")
        gg.setSpriteAsync(self.icon, iconName)
        self.txtNum.text = string.format("X%s", 1)
        self.txtRes.text = Utils.getText(curCfg.languageNameID)

    elseif effCfg.effectType == constant.GIFT_EFFECT_CARD then
        self.imgRes.transform:SetActiveEx(false)
        local cfgId = effCfg.value[1]
        local num = effCfg.value[2]
        local curCfg = cfg.getCfg("item", cfgId)
        UIUtil.setQualityBg(self.imgBg, curCfg.quailty)
        local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", curCfg.icon .. "_A1")
        gg.setSpriteAsync(self.icon, iconName)
        self.txtNum.text = string.format("X%s", num)
        self.txtRes.text = Utils.getText(curCfg.languageNameID)

    end

end
