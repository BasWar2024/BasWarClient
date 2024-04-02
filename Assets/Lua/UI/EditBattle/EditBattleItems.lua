local EditBattleTypes = {
    soldier = 1,
    hero = 2,
    building = 3,
    skill = 4,
}

local attrList = {
    {
        key = "maxHp",
    },
    {
        key = "atk",
    },
    {
        key = "atkSpeed",
    },
    {
        key = "moveSpeed",
    },
    {
        key = "atkRange",
    },
    {
        key = "inAtkRange",
    },

}

local buildAttrList = {
    {
        key = "maxHp",
    },
    {
        key = "atk",
    },
    {
        key = "atkSpeed",
    },
    {
        key = "atkRange",
    },
    {
        key = "inAtkRange",
    },
}

local skillAttrList = {
    {
        key = "moveSpeed",
    },
    {
        key = "lifeTime",
    },
    {
        key = "frequency",
    },
}

----------------
EditBattleSetAttrItem = EditBattleSetAttrItem or class("EditBattleSetAttrItem", ggclass.UIBaseItem)
function EditBattleSetAttrItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditBattleSetAttrItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtAttr = self:Find("TxtAttr", UNITYENGINE_UI_TEXT)

    self.inputAttr = self:Find("InputAttr", UNITYENGINE_UI_INPUTFIELD)
    self.btnSet = self:Find("BtnSet")

    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))
end

function EditBattleSetAttrItem:setData(data, model, modelType, refreshData)
    self.data = data
    self.model = model
    self.refreshData = refreshData

    self.modelType = modelType

    self.txtName.text = data.key
    self.txtAttr.text = model[data.key]
    self.inputAttr.text = model[data.key]
end

function EditBattleSetAttrItem:onBtnSet()
    self.model[self.data.key] = self.inputAttr.text
    CS.EditModel.EditBattleTools.RefreshAllEnityAttr()

    if self.refreshData then
        self.initData:setData(self.refreshData)
    else
        self.initData:setData(self.model)
    end
end
------------------------------------------------------
EditBattleAtkSkillItem = EditBattleAtkSkillItem or class("EditBattleAtkSkillItem", ggclass.UIBaseItem)
function EditBattleAtkSkillItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditBattleAtkSkillItem:onInit()
    self.txtId = self:Find("TxtId", UNITYENGINE_UI_TEXT)
    self.txtCfgId = self:Find("TxtCfgId", UNITYENGINE_UI_TEXT)

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self:Find("AttrScrollView"), "EditBattleSetAttrItem", self.soldierItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))
end

function EditBattleAtkSkillItem:setData(skillModelId)
    self.skillModelId = skillModelId
    self.skillModel = CS.NewGameData._SkillModelDict[skillModelId]
    self.txtId.text = self.skillModel.id
    self.txtCfgId.text = self.skillModel.cfgId
    self.attrScrollView:setItemCount(#skillAttrList)
end

function EditBattleAtkSkillItem:onRenderAttr(obj, index)
    local item = EditBattleSetAttrItem:getItem(obj, self.attrItemList, self)
    item:setData(skillAttrList[index], self.skillModel, EditBattleTypes.skill, self.skillModelId)
end

------------------------------------------------------

EditBattleModelItemBase = EditBattleModelItemBase or class("EditBattleModelItemBase", ggclass.UIBaseItem)
function EditBattleModelItemBase:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditBattleModelItemBase:onInit()
    self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))

    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtLevel = self:Find("TxtName/TxtLevel", UNITYENGINE_UI_TEXT)

    self.txtResName = self:Find("TxtResName", UNITYENGINE_UI_TEXT)

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self:Find("AttrScrollView"), "EditBattleSetAttrItem", self.soldierItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

    self.EditBattleAtkSkillItem = EditBattleAtkSkillItem.new(self:Find("EditBattleAtkSkillItem"))
end

function EditBattleModelItemBase:setData(model)
    self.model = model
    self.modelType = EditBattleTypes.soldier
    self.attrList = attrList
end

function EditBattleModelItemBase:onRenderAttr(obj, index)
    local item = EditBattleSetAttrItem:getItem(obj, self.attrItemList, self)
    item:setData(self.attrList[index], self.model, self.modelType)
end

function EditBattleModelItemBase:onRelease()
    self.attrScrollView:release()
    self.EditBattleAtkSkillItem:release()
end

------------------------------------------------------
EditBattleSoldierItem = EditBattleSoldierItem or class("EditBattleSoldierItem", EditBattleModelItemBase)
function EditBattleSoldierItem:ctor(obj, initData)
    EditBattleModelItemBase.ctor(self, obj)
    self.initData = initData
end

function EditBattleSoldierItem:onInit()
    EditBattleModelItemBase.onInit(self)
end

function EditBattleSoldierItem:setData(soldierModel)
   self.model = soldierModel
   self.modelType = EditBattleTypes.soldier

    if not SoliderUtil.getSoliderCfgMap()[soldierModel.cfgId] then
        self:setActive(false)
        return
    end
    self:setActive(true)

    self.EditBattleAtkSkillItem:setData(soldierModel.atkSkillId)

    local soldierCfg = SoliderUtil.getSoliderCfgMap()[soldierModel.cfgId][0]
    self.commonItemItem:setIcon(gg.getSpriteAtlasName("Soldier_A_Atlas", soldierCfg.icon .. "_A"))
    self.txtName.text = Utils.getText(soldierCfg.languageNameID)
    self.txtResName.text = soldierCfg.resName

    self.attrList = attrList
    self.attrScrollView:setItemCount(#attrList)
end

function EditBattleSoldierItem:onRelease()
    EditBattleModelItemBase.onRelease(self)
end

------------------------------------------------------
EditBattleHeroItem = EditBattleHeroItem or class("EditBattleHeroItem", EditBattleModelItemBase)
function EditBattleHeroItem:ctor(obj, initData)
    EditBattleModelItemBase.ctor(self, obj)
    self.initData = initData
end

function EditBattleHeroItem:onInit()
    EditBattleModelItemBase.onInit(self)
end

function EditBattleHeroItem:setData(heroModel)
    self.model = heroModel
    self.modelType = EditBattleTypes.hero

    if not HeroUtil.getHeroCfgMap()[heroModel.cfgId] then
        self:setActive(false)
        return
    end
    self:setActive(true)

    self.EditBattleAtkSkillItem:setData(heroModel.atkSkillId)

    local heroCfg
    for key, value in pairs(HeroUtil.getHeroCfgMap()[heroModel.cfgId]) do
        heroCfg = value[0]
    end

    self.commonItemItem:setIcon(gg.getSpriteAtlasName("Hero_A_Atlas", heroCfg.icon .. "_A"))
    self.txtName.text = Utils.getText(heroCfg.languageNameID)
    self.txtResName.text = heroCfg.resName

    self.attrList = attrList
    self.attrScrollView:setItemCount(#attrList)
end

function EditBattleHeroItem:onRelease()
    EditBattleModelItemBase.onRelease(self)
end

------------------------------------------------------
EditBattleBuildingItem = EditBattleBuildingItem or class("EditBattleBuildingItem", EditBattleModelItemBase)
function EditBattleBuildingItem:ctor(obj, initData)
    EditBattleModelItemBase.ctor(self, obj)
    self.initData = initData
end

function EditBattleBuildingItem:onInit()
    EditBattleModelItemBase.onInit(self)
end

function EditBattleBuildingItem:setData(BuildingModel)
    self.model = BuildingModel
    self.modelType = EditBattleTypes.building

    -- if BuildingModel.type ~= 3 or not BuildUtil.getBuildCfgMap()[BuildingModel.cfgId] then
    if not BuildUtil.getBuildCfgMap()[BuildingModel.cfgId] then
        self:setActive(false)
        return
    end
    self:setActive(true)

    if BuildingModel.type == 3 then
        self.transform:SetActiveEx(true)

        self.EditBattleAtkSkillItem:setActive(true)
        self.EditBattleAtkSkillItem:setData(BuildingModel.atkSkillId)
    else
        self.EditBattleAtkSkillItem:setActive(false)

        self.transform:SetActiveEx(false)
    end

    local buildCfg
    for key, value in pairs(BuildUtil.getBuildCfgMap()[BuildingModel.cfgId]) do
        buildCfg = value[0]
    end

    self.commonItemItem:setIcon(gg.getSpriteAtlasName("Build_B_Atlas", buildCfg.icon .. "_B"))
    self.txtName.text = Utils.getText(buildCfg.languageNameID)
    self.txtResName.text = buildCfg.resName

    self.attrList = buildAttrList
    self.attrScrollView:setItemCount(#buildAttrList)
end

function EditBattleBuildingItem:onRelease()
    EditBattleModelItemBase.onRelease(self)
end