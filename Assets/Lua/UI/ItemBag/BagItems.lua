BagItem = BagItem or class("BagItem", ggclass.UIBaseItem)
function BagItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BagItem:onInit()
    -- self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))
    self.CommonBagItem = CommonBagItem.new(self:Find("CommonBagItem"))

    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    self.layoutHero = self:Find("layoutHero")
    self.sliderLife = self:Find("SliderLife", "Slider")
    self.layoutSelect = self:Find("LayoutSelect")

    self.layoutCool = self:Find("LayoutCool")
    self.txtBan = self:Find("LayoutCool/TxtBan", "Text")
    self.txtCoolTime = self:Find("LayoutCool/TxtCoolTime", "Text")
    self.txtNum = self:Find("BgNum/TxtNum", "Text")
end

function BagItem:setData(data)
    self.data = data
    if not data then
        self:setActive(false)
        return
    end
    self:setActive(true)
    self.txtNum.text = data.num
    gg.timer:stopTimer(self.timer)
    local lessLaunchEnd = data.lessLaunchEnd or 0
    if lessLaunchEnd > os.time() then
        self.layoutCool:SetActiveEx(true)
        self.timer = gg.timer:startLoopTimer(0, 1, -1, function()
            local time = self.data.lessLaunchEnd - os.time()
            if time < 0 then
                self.layoutTime:SetActiveEx(false)
                return
            end
            local hms = gg.time.dhms_time({
                day = false,
                hour = 1,
                min = 1,
                sec = 1
            }, time)
            self.txtCoolTime.text = string.format("%s:%s:%s", hms.hour, hms.min, hms.sec)
        end)
    else
        self.layoutCool:SetActiveEx(false)
    end

    self.layoutHero:SetActiveEx(false)
    self.sliderLife.gameObject:SetActiveEx(false)
    self.CommonBagItem:initInfo()
    self:refreshSelect()

    if data.id <= 0 then
        self.CommonBagItem:setQuality(0)
        self.CommonBagItem:setIcon(false)
        return
    end

    -- self.itemCfg = cfg.item[data.cfgId]
    -- self.targetCfg = ItemUtil.getTargetCfgByItemData(data)

    -- constant.ITEM_ITEMTYPE_HERO
    -- if self.itemCfg.itemType == constant.ITEM_ITEMTYPE_HERO then
    --     self.layoutHero:SetActiveEx(true)
    --     self.CommonBagItem:setLevel(data.targetLevel)

    --     self.sliderLife.gameObject:SetActiveEx(true)
    --     self.sliderLife.value = data.entity.curLife / data.entity.life
    -- elseif self.itemCfg.itemType == constant.ITEM_ITEMTYPE_TURRET then
    --     self.sliderLife.gameObject:SetActiveEx(true)
    --     self.sliderLife.value = data.entity.curLife / data.entity.life
    -- elseif self.itemCfg.itemType == constant.ITEM_ITEMTYPE_WARSHIP then
    --     self.sliderLife.gameObject:SetActiveEx(true)
    --     self.sliderLife.value = data.entity.curLife / data.entity.life

    -- else
    -- end
    -- self.CommonBagItem:setQuality(ItemUtil.getItemQualityByItemData(data))
    local isBuild = true
    local curCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
    if not curCfg then
        isBuild = false
        curCfg = cfg.item[data.cfgId]
    end

    self.itemCfg = curCfg
    self.targetCfg = self.itemCfg

    self.CommonBagItem:setQuality(curCfg.quality)

    local icon
    if isBuild then
        icon = gg.getSpriteAtlasName("Build_A_Atlas", curCfg.icon .. "_A")
    else
        if curCfg.itemType == constant.ITEM_ITEMTYPE_DAO_ITEM then
            icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)
        elseif curCfg.itemType == constant.ITEM_ITEMTYPE_PROP then
            icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)
            elseif curCfg.itemType == constant.ITEM_ITEMTYPE_NFT_ITEM then
            icon = gg.getSpriteAtlasName("Item_Atlas", curCfg.icon)
        elseif curCfg.itemType == constant.ITEM_ITEMTYPE_SKILL_PIECES then
            icon = gg.getSpriteAtlasName("Skill_A1_Atlas", curCfg.icon .. "_A1")
        end
    end
    self.CommonBagItem:setIcon(icon)

    self:refreshSelect()
end

function BagItem:refreshSelect()
    if self.data and self.initData.selectItemData and self.data.id == self.initData.selectItemData.id then
        self.layoutSelect:SetActiveEx(true)
    else
        self.layoutSelect:SetActiveEx(false)
    end
end

function BagItem:onClickItem()
    if self.data.id <= 0 then
        return
    end

    self.initData:onSelectItem(self.data)
end

function BagItem:onRelease()
    gg.timer:stopTimer(self.timer)
end

