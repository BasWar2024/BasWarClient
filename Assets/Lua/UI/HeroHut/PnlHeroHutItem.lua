
HeroHutSkillItem = HeroHutSkillItem or class("HeroHutSkillItem", ggclass.UIBaseItem)

function HeroHutSkillItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function HeroHutSkillItem:onInit()
    local transform = self.transform
    self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))
    self.imgChooseing = transform:Find("ImgChooseing"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgEmpty = self:Find("ImgEmpty"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.layoutBtns = self:Find("LayoutBtns").gameObject
    self.btnUse = self.layoutBtns.transform:Find("BtnUse").gameObject
    self.btnUpgrade = self.layoutBtns.transform:Find("BtnUpgrade").gameObject

    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
    self:setOnClick(self.btnUse, gg.bind(self.onBtnUse, self))
    self:setOnClick(self.btnUpgrade, gg.bind(self.onBtnUpgrade, self))
    self:setSelect(false)
end

function HeroHutSkillItem:setData(data)
    self.data = data

    if not data then
        self.imgChooseing.gameObject:SetActiveEx(false)
        self.layoutBtns.gameObject:SetActiveEx(false)
        self.commonItemItem:setActive(false)
        self.imgEmpty.gameObject:SetActiveEx(true)
        return
    end

    self.imgEmpty.gameObject:SetActiveEx(false)
    self.commonItemItem:setActive(true)
    self.commonItemItem:initInfo()

    self.skillCfg = data.skillCfg
    local icon = gg.getSpriteAtlasName("Skill_A1_Atlas", self.skillCfg.icon .. "_A1")

    self.commonItemItem:setIcon(icon)
    self.commonItemItem:setLevel(data.level)

    local isEnoughtUpgrade = HeroUtil.checkIsEnoughtSkillUpgrade(data.index)
    self.commonItemItem:setImgArrowActive(isEnoughtUpgrade)
    self.imgChooseing.gameObject:SetActiveEx(self.initData.showingHero.selectSkill == data.index)
end

function HeroHutSkillItem:setSelect(index)
    if self.data and self.data.index == index then
        self.isSelect = true
    else
        self.isSelect = false
    end
    self.layoutBtns:SetActiveEx(self.isSelect)
end

function HeroHutSkillItem:onBtnItem()
    if not self.data then
        return
    end

    if self.isSelect then
        self:setSelect(-1)
    else
        self.initData:selectSkill(self.data.index)
    end
end

function HeroHutSkillItem:onRelease()
end

function HeroHutSkillItem:onBtnUse()
    HeroData.C2S_Player_HeroSelectSkill(self.initData.showingHero.id, self.data.index)
end

function HeroHutSkillItem:onBtnUpgrade()
    local level = self.data.skillCfg.level
    local skillCfgId = self.data.skillCfg.cfgId

    if not HeroUtil.getSkillMap()[skillCfgId][level] or not HeroUtil.getSkillMap()[skillCfgId][level + 1]  then
        gg.uiManager:showTip("Level Max")
        return
    end

    local callbackReturn = function()
        -- gg.uiManager:openWindow("PnlHeroHut")
        -- gg.uiManager:closeWindow("PnlUpgrade")
    end
    local callbackUpgrade = function(isOnExchange)
        if isOnExchange then
            HeroData.C2S_Player_HeroSkillUp(self.initData.showingHero.id, self.data.index, 0)
        elseif not HeroUtil.checkHeroBusy(true, self.data.index) then
            HeroData.C2S_Player_HeroSkillUp(self.initData.showingHero.id, self.data.index, 0)
        end
        callbackReturn()
    end
    local callbackInstant = function()
        HeroData.C2S_Player_HeroSkillUp(self.initData.showingHero.id, self.data.index, 1)
        callbackReturn()
    end

    local args = {
        callbackReturn = callbackReturn,
        callbackInstant = callbackInstant,
        callbackUpgrade = callbackUpgrade,
        exchangeInfoFunc = self.initData.exchangeInfoFunc,
        cfg = HeroUtil.getSkillMap()[skillCfgId][level],
        nextLevelCfg = HeroUtil.getSkillMap()[skillCfgId][level + 1],
        lessTickEnd = self.initData.showingHero.skillUpLessTickEnd, type = "skill"
    }

    -- gg.uiManager:closeWindow("PnlHeroHut")
    gg.uiManager:openWindow("PnlUpgrade", args)
end

HeroHutHeroItem = HeroHutHeroItem or class("HeroHutHeroItem", ggclass.UIBaseItem)

function HeroHutHeroItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function HeroHutHeroItem:onInit()
    local transform = self.transform

    self.bg = transform:GetComponent(UNITYENGINE_UI_IMAGE)

    self.root = self:Find("Root")

    self.imgIcon = self:Find("Root/ImgIcon", "Image")
    self.sliderLife = self:Find("Root/SliderLife", "Slider")
    self.imgSelect = self:Find("Root/ImgSelect", "Image")
    self.imgChoosing = self:Find("Root/ImgChoosing", "Image")

    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function HeroHutSkillItem:onRelease()
end

function HeroHutHeroItem:setData(data)
    self.data = data
    if not data then
        self.root:SetActiveEx(false)
        gg.setSpriteAsync(self.bg, "Item_Bg_Atlas[Item_Bg_0]")
        return
    end
    self.root:SetActiveEx(true)
    self.imgSelect.gameObject:SetActiveEx(HeroData.ChooseingHero and data.id == HeroData.ChooseingHero.id)
    self:refreshChoosing()
    self.heroCfg = HeroUtil.getHeroCfg(data.cfgId, data.level, data.quality)

    local quality = data.quality or 0
    local spriteName = "Item_Bg_" .. quality
    gg.setSpriteAsync(self.bg, string.format("Item_Bg_Atlas[%s]", spriteName))
    self.sliderLife.value = data.curLife / data.life
    gg.setSpriteAsync(self.imgIcon, gg.getSpriteAtlasName("Icon_E_Atlas", self.heroCfg.icon .. "_E"))
end

function HeroHutHeroItem:refreshChoosing()
    if not self.data then
        return
    end

    self.imgChoosing.gameObject:SetActiveEx(self.initData.showingHero and self.data.id == self.initData.showingHero.id)
end

function HeroHutHeroItem:onBtnItem()
    if not self.data then
        return
    end

    self.initData:setShowingHero(self.data)
end