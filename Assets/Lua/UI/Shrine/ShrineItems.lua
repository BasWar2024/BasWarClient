-------------------------------------------------------------

local defaultShrineData = {id = 0}

ShrineItem = ShrineItem or class("ShrineItem", ggclass.UIBaseItem)
function ShrineItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.changeCB = nil
    self.initData = initData
end

function ShrineItem:onInit()
    self.commonHeroItem = CommonHeroItem.new(self:Find("CommonHeroItem"))
    self.txtLevel = self:Find("TxtLevel", UNITYENGINE_UI_TEXT)

    self.btnSet = self:Find("BtnSet")
    self.txtSet = self:Find("BtnSet/Text", UNITYENGINE_UI_TEXT)

    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))

    self.layoutLock = self:Find("LayoutLock").transform
    self.txtLock = self.layoutLock:Find("TxtLock"):GetComponent(UNITYENGINE_UI_TEXT)

end

function ShrineItem:setData(index, maxCount, buildData, buildCfg)
    self.index = index
    self.buildData = buildData
    self.buildCfg = buildCfg

    if index > maxCount then
        self.transform:SetActiveEx(false)
        return
    end
    self.transform:SetActiveEx(true)

    if index > buildCfg.heroNum then
        EffectUtil.setGray(self.gameObject, true, true)
        self.layoutLock:SetActiveEx(true)

        local level = 9999999999
        for key, value in pairs(BuildUtil.getBuildCfgMap()[buildData.cfgId][buildData.quality]) do
            if value.heroNum >= index and value.level < level then
                level = value.level
            end
        end

        self.txtLock.text = BuildUtil.getBuildUnlockText(buildCfg, level)
    else
        self.layoutLock:SetActiveEx(false)
        EffectUtil.setGray(self.gameObject, false, true)
    end

    self:refreshHero()
end

function ShrineItem:refreshHero()
    local shrineData = ShrineData.ShrineMap[self.buildData.id]
    local shrineHeroData = shrineData.data[self.index] or defaultShrineData

    if shrineHeroData.id <= 0 then
        self.txtSet.text = Utils.getText("shrine_Addition_AddBtn")
        self.commonHeroItem:setQuality()
        self.commonHeroItem:setIcon(false)
        self.txtLevel.transform:SetActiveEx(false)
    else
        self.txtSet.text = Utils.getText("shrine_Addition_ChangeBtn")
        local heroData = HeroData.heroDataMap[shrineHeroData.id]
        local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
        self.txtLevel.transform:SetActiveEx(true)
        self.txtLevel.text = "LV." .. heroData.level
        self.commonHeroItem:setQuality(heroData.quality)
        self.commonHeroItem:setIcon("Hero_A_Atlas", heroCfg.icon)
    end
end

function ShrineItem:onBtnSet()
    self.initData:showSelect(true, self.index)
end

function ShrineItem:onRelease()
    self.commonHeroItem:release()
end

-------------------------------------------------------------

ShrineSelectItem = ShrineSelectItem or class("ShrineSelectItem", ggclass.UIBaseItem)
function ShrineSelectItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.changeCB = nil
    self.initData = initData
end

function ShrineSelectItem:onInit()
    self.commonHeroItem = CommonHeroItem.new(self:Find("CommonHeroItem"))
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))

    self.txtLevel = self:Find("TxtLevel", UNITYENGINE_UI_TEXT)
end

function ShrineSelectItem:setData(data)
    self.data = data
    if not data then
        self.transform:SetActiveEx(false)
        return
    end

    self.txtLevel.text = "LV." .. data.level

    self.transform:SetActiveEx(true)

    local heroCfg = HeroUtil.getHeroCfg(data.cfgId, data.level, data.quality)

    self.commonHeroItem:setQuality(data.quality)
    self.commonHeroItem:setIcon("Hero_A_Atlas", heroCfg.icon)
end

function ShrineSelectItem:onBtnItem()
    local index = self.initData.selectingIndex
    ShrineData.C2S_Player_UpdateSanctuaryHero(self.initData.buildId, index, self.data.id)
    self.initData:showSelect(false)
end

function ShrineSelectItem:onRelease()
    self.commonHeroItem:release()
end

---------------------------------------------------------------------------------

ShrineBuildingBoundItem = ShrineBuildingBoundItem or class("ShrineBuildingBoundItem", ggclass.UIBaseItem)
function ShrineBuildingBoundItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.changeCB = nil
    self.initData = initData
end

function ShrineBuildingBoundItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtAtkAdd = self:Find("TxtAtkAdd", UNITYENGINE_UI_TEXT)
    self.txtHpAdd = self:Find("TxtHpAdd", UNITYENGINE_UI_TEXT)
end

function ShrineBuildingBoundItem:setData(index)
    local descCfg = cfg.ShrineBuildingBoundsDesc[index]

    local buildCfg = BuildUtil.getCurBuildCfg(descCfg.buildCfgId, 1, 0)

    if descCfg.buildCfgId == constant.BUILD_BASE then
        self.txtName.text = Utils.getText("shrine_Addition_OtherBuild")
    else
        self.txtName.text = Utils.getText(buildCfg.languageNameID)
    end

    self.txtAtkAdd.text = buildCfg.attEnableRatio * 100 .. "%"
    self.txtHpAdd.text = buildCfg.hpEnableRatio * 100 .. "%"
end
