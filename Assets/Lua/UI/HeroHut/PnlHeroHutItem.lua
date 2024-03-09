
HeroHutSkillItem = HeroHutSkillItem or class("HeroHutSkillItem", ggclass.UIBaseItem)

function HeroHutSkillItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function HeroHutSkillItem:onInit()
    local transform = self.transform
    self.imgBg = transform:Find("ImgBg"):GetComponent("Image")
    self.imgSelect = transform:Find("ImgSelect"):GetComponent("Image")
    self.imgLevel = transform:Find("ImgLevel"):GetComponent("Image")
    self.imgUpgrade = transform:Find("ImgUpgrade"):GetComponent("Image")
    self.imgSkill = transform:Find("ImgSkill"):GetComponent("Image")

    self.layoutBtns = self:Find("LayoutBtns").gameObject
    self.btnUse = self.layoutBtns.transform:Find("BtnUse").gameObject
    self.btnUpgrade = self.layoutBtns.transform:Find("BtnUpgrade").gameObject

    CS.UIEventHandler.Get(self.gameObject):SetOnClick(function()
        self:onBtnItem()
    end)

    self:setOnClick(self.btnUse, gg.bind(self.onBtnUse, self))
    self:setOnClick(self.btnUpgrade, gg.bind(self.onBtnUpgrade, self))
    self:setSelect(false)
    self.imgSelect.gameObject:SetActive(false)
end

function HeroHutSkillItem:setSelect(isSelect)
    if self.skillId then
        self.isSelect = isSelect
    else
        self.isSelect = false
    end
    self.layoutBtns:SetActiveEx(self.isSelect)
end

function HeroHutSkillItem:setData(level, index)
    self.index = index
    self.level = level

    if level > 0 and level <= 5 then
        ResMgr:LoadSpriteAsync("Level_icon_" .. level, function(sprite)
            self.imgLevel.sprite = sprite
        end)
    end

    ResMgr:LoadSpriteAsync("icon_Skill_" .. index, function(sprite)
        self.imgSkill.sprite = sprite
    end)

    local heroCfg = HeroUtil:getChooseHeroCfg()
    if heroCfg then
        self.skillId = heroCfg["skill" .. index]
    else
        self.skillId = nil
    end
    self.imgSkill.transform:SetActiveEx(self.skillId ~= nil)

    local isEnoughtUpgrade = HeroUtil:checkIsEnoughtSkillUpgrade(index)
    self.imgLevel.transform:SetActiveEx(not isEnoughtUpgrade and level > 0)
    self.imgUpgrade.transform:SetActiveEx(isEnoughtUpgrade)
    self.imgSelect.transform:SetActiveEx(HeroData.ChooseingHero and HeroData.ChooseingHero.selectSkill == self.index)
end

function HeroHutSkillItem:onBtnItem()
    if self.isSelect then
        self:setSelect(false)
    else
        self.initData:setSelectSkill(self.index)
    end
end

function HeroHutSkillItem:onRelease()
    CS.UIEventHandler.Clear(self.gameObject)
end

function HeroHutSkillItem:onBtnUse()
    HeroData.C2S_Player_HeroSelectSkill(HeroData.ChooseingHero.id, self.index)
end

function HeroHutSkillItem:onBtnUpgrade()
    gg.uiManager:closeWindow("PnlHeroHut")
    local level = 1
    if self.level > 0 then
        level = self.level
    end
    local callbackReturn = function()
        gg.uiManager:openWindow("PnlHeroHut")
        gg.uiManager:closeWindow("PnlUpgrade")
    end
    local callbackUpgrade = function()
        HeroData.C2S_Player_HeroSkillUp(HeroData.ChooseingHero.id, self.index, 0)
    end
    local callbackInstant = function()
        if HeroData.ChooseingHero.skillUpLessTick <= 0 then
            HeroData.C2S_Player_HeroSkillUp(HeroData.ChooseingHero.id, self.index, 1)
        else
            HeroData.C2S_Player_SpeedUp_HeroLevelUp(HeroData.ChooseingHero.id)
        end
    end

    local args = {callbackReturn = callbackReturn, callbackInstant = callbackInstant,
        callbackUpgrade = callbackUpgrade, cfg = HeroUtil:getSkillMap()[self.skillId][level],
        nextLevelCfg = HeroUtil:getSkillMap()[self.skillId][level + 1],
        lessTickEnd = HeroData.ChooseingHero.skillUpLessTickEnd, type = "skill"}

    gg.uiManager:openWindow("PnlUpgrade", args)
end
