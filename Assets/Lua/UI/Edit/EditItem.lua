EditBuildItem = EditBuildItem or class("EditBuildItem", ggclass.UIBaseItem)
function EditBuildItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditBuildItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self))
end

function EditBuildItem:setData(data)
    self.data = data

    local name = Utils.getText(data.languageNameID)
    if name == "" then
        name = data.name
    end

    self.txtName.text = name
end

function EditBuildItem:onBtnItem()
    -- if self.data.cfgId == constant.BUILD_LIBERATORSHIP then

    --     BuildUtil.afterBuildingBuild(self.data, function ()
    --         self.initData:close()
    --         gg.buildingManager:loadBuilding(self.data, nil, nil, BuildingManager.OWNER_OWN, nil, isInstance)
    --     end)
    --     return
    -- end
    if self.data.type == constant.BUILD_CLUTTER and self.data.model == "TabletopCloud" then
        local data = 
        {
            pos = {
                [1] = 10,
                [2] = 10,
                [3] = 20,
            },
            model = "TabletopCloud",
            slot = self.data.slot,
        }

        local cloud = Cloud.new()
        cloud:setData({},data)
        self.initData:close()
        return
    end

    gg.buildingManager:loadBuilding(self.data, nil, nil, BuildingManager.OWNER_OWN, nil)
    self.initData:close()
end

-------------------------------------------------------------------------------
EditBuildingItem = EditBuildingItem or class("EditBuildingItem", ggclass.UIBaseItem)
function EditBuildingItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditBuildingItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)

    self.txtLevel = self:Find("TxtName/TxtLevel", UNITYENGINE_UI_TEXT)
    self.txtQuality = self:Find("TxtQuality", UNITYENGINE_UI_TEXT)
    self.txtMaxQuality = self:Find("TxtMaxQuality", UNITYENGINE_UI_TEXT)

    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)

    self.btnDel = self:Find("BtnDel")
    self:setOnClick(self.btnDel, gg.bind(self.onBtnDel, self))

    self.inputField = self:Find("InputField", UNITYENGINE_UI_INPUTFIELD)
    self.btnSet = self:Find("BtnSet")
    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))

    self.btnSetAll = self:Find("BtnSetAll")
    self:setOnClick(self.btnSetAll, gg.bind(self.onBtnSetAll, self))

    self.btnSetAllBuilding = self:Find("BtnSetAllBuilding")
    self:setOnClick(self.btnSetAllBuilding, gg.bind(self.onBtnSetAllBuilding, self))

    self.inputQuality = self:Find("InputQuality", UNITYENGINE_UI_INPUTFIELD)
    self.btnSetQuality = self:Find("BtnSetQuality")
    self:setOnClick(self.btnSetQuality, gg.bind(self.onBtnSetQuality, self))
end

function EditBuildingItem:setData(data)
    self.data = data
    local curCfg = BuildUtil.getCurBuildCfg(data.cfgId, data.level, data.quality)

    local name = Utils.getText(curCfg.languageNameID)
    if name == "" then
        name = curCfg.name
    end
    self.txtName.text = name
    self.txtLevel.text = "lv." .. data.level
    self.inputField.text = data.level
    self.inputQuality.text = data.quality
    self.txtQuality.text = "quality." .. data.quality

    local selectedBuilding = gg.buildingManager.selectedBuilding
    if selectedBuilding then
        self.imgSelect.gameObject:SetActiveEx(selectedBuilding.buildData.id == data.id)
    else
        self.imgSelect.gameObject:SetActiveEx(false)
    end

    local cfgLevelMap = BuildUtil.getBuildCfgMap()[data.cfgId][data.quality]
    local maxLevel = 0
    for key, value in pairs(cfgLevelMap) do
        if key > maxLevel then
            maxLevel = key
        end
    end
    self.maxLevel = maxLevel
    -- self.txtMaxLevel.text = "MaxLevel:" .. maxLevel

    local cfgQualityMap = BuildUtil.getBuildCfgMap()[data.cfgId]
    local maxQuality = 0
    for key, value in pairs(cfgQualityMap) do
        if key > maxQuality then
            maxQuality = key
        end
    end
    self.maxQuality = maxQuality
    self.txtMaxQuality.text = "MaxLevel:" .. maxLevel .. " MaxQuality:" .. maxQuality
end

function EditBuildingItem:onBtnSet()
    local level = math.min(self.maxLevel, math.max(1, tonumber(self.inputField.text) or self.data.level))
    EditData.C2S_Player_ResetGOLevel(1, 1, self.data.id, self.data.cfgId, level)
end

function EditBuildingItem:onBtnSetQuality()
    local quality = math.min(self.maxQuality, math.max(0, tonumber(self.inputQuality.text) or self.data.quality))
    EditData.C2S_Player_ResetGOLevel(1, 4, self.data.id, self.data.cfgId, nil, nil, nil, quality)
end

function EditBuildingItem:onBtnSetAll()
    local level = math.min(self.maxLevel, math.max(1, tonumber(self.inputField.text) or self.data.level))
    for key, value in pairs(BuildData.buildData) do
        if value.cfgId == self.data.cfgId then
            EditData.C2S_Player_ResetGOLevel(1, 1, value.id, value.cfgId, level)
        end
    end
end

function EditBuildingItem:onBtnSetAllBuilding()
    local level = tonumber(self.inputField.text)
    for key, value in pairs(BuildData.buildData) do
        EditData.C2S_Player_ResetGOLevel(1, 1, value.id, value.cfgId, level)
    end
end

function EditBuildingItem:onBtnDel()
    EditData.C2S_Player_ResetGOLevel(1, 2, self.data.id, self.data.cfgId)
end

---------------------------------------------------------------------------------------------

EditHeroItem = EditHeroItem or class("EditHeroItem", ggclass.UIBaseItem)
function EditHeroItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditHeroItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)

    self.txtLevel = self:Find("TxtName/TxtLevel", UNITYENGINE_UI_TEXT)
    self.txtQuality = self:Find("TxtQuality", UNITYENGINE_UI_TEXT)

    self.txtMaxLevel = self:Find("TxtMaxLevel", UNITYENGINE_UI_TEXT)
    self.txtMaxQuality = self:Find("TxtMaxQuality", UNITYENGINE_UI_TEXT)
    
    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)
    self.imgSelect.gameObject:SetActiveEx(false)

    self.btnDel = self:Find("BtnDel")
    self:setOnClick(self.btnDel, gg.bind(self.onBtnDel, self))

    self.inputField = self:Find("InputField", UNITYENGINE_UI_INPUTFIELD)
    self.inputQuality = self:Find("InputQuality", UNITYENGINE_UI_INPUTFIELD)

    self.btnSet = self:Find("BtnSet")
    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))

    self.btnSetAll = self:Find("BtnSetAll")
    self:setOnClick(self.btnSetAll, gg.bind(self.onBtnSetAll, self))

    self.btnSetQuality = self:Find("BtnSetQuality")
    self:setOnClick(self.btnSetQuality, gg.bind(self.onBtnSetQuality, self))

    self.inputFieldSkillIndex = self:Find("InputFieldSkillIndex", UNITYENGINE_UI_INPUTFIELD)
    self.inputFieldSkillLevel = self:Find("InputFieldSkillLevel", UNITYENGINE_UI_INPUTFIELD)
    self.inputFieldSkillId = self:Find("InputFieldSkillId", UNITYENGINE_UI_INPUTFIELD)

    self.btnSetSkillLevel = self:Find("BtnSetSkillLevel")
    self:setOnClick(self.btnSetSkillLevel, gg.bind(self.onBtnSetSkill, self))

    self.BtnSetAllSkillLevel = self:Find("BtnSetAllSkillLevel")
    self:setOnClick(self.BtnSetAllSkillLevel, gg.bind(self.onBtnSetAllSkillLevel, self))
    

    self.btnSetSkillId = self:Find("BtnSetSkillId")
    self:setOnClick(self.btnSetSkillId, gg.bind(self.onBtnSetId, self))

    self.skillItemList = {}
    self.skillScrollView = UIScrollView.new(self:Find("SkillScrollView"), "EditSkillItem", self.skillItemList)
    self.skillScrollView:setRenderHandler(gg.bind(self.onRenderSkillItem, self))
end

function EditHeroItem:setData(data)
    self.data = data
    local curCfg = HeroUtil.getHeroCfg(data.cfgId, data.level, data.quality)
    self.txtName.text = curCfg.name --Utils.getText(curCfg.languageNameID)
    self.txtLevel.text = "lv." .. data.level
    self.inputField.text = data.level
    self.inputQuality.text = data.quality
    self.txtQuality.text = "quality." .. data.quality

    self.skillDataList = {}
    for i = 1, 3, 1 do
        local skillId = data["skill" .. i]
        local skillLevel = data["skillLevel" .. i]
        if skillId > 0 then
            table.insert(self.skillDataList, SkillUtil.getSkillCfgMap()[skillId][skillLevel])
        end
    end
    self.skillScrollView:setItemCount(#self.skillDataList)

    local cfgLevelMap = HeroUtil.getHeroCfgMap()[data.cfgId][data.quality]
    local maxLevel = 0
    for key, value in pairs(cfgLevelMap) do
        if key > maxLevel then
            maxLevel = key
        end
    end
    self.maxLevel = maxLevel
    self.txtMaxLevel.text = "MaxLevel:" .. maxLevel

    local cfgQualityMap = HeroUtil.getHeroCfgMap()[data.cfgId]
    local maxQuality = 0
    for key, value in pairs(cfgQualityMap) do
        if key > maxQuality then
            maxQuality = key
        end
    end
    self.maxQuality = maxQuality
    self.txtMaxQuality.text = "MaxQuality:" .. maxQuality
end

function EditHeroItem:onRenderSkillItem(obj, index)
    local skillCfg = self.skillDataList[index]
    local item = EditSkillItem:getItem(obj, self.skillItemList, self)
    item:setData(skillCfg, index)
end

function EditHeroItem:selectSkill(index, skillCfg)
    self.inputFieldSkillIndex.text = index
    self.inputFieldSkillLevel.text = skillCfg.level
    self.inputFieldSkillId.text = skillCfg.cfgId
end

function EditHeroItem:onBtnSet()
    local level = math.min(self.maxLevel, math.max(1, tonumber(self.inputField.text) or self.data.level)) 
    EditData.C2S_Player_ResetGOLevel(3, 1, self.data.id, self.data.cfgId, level)
end

function EditHeroItem:onBtnSetAll()
    local level = tonumber(self.inputField.text)
    for key, value in pairs(HeroData.heroDataMap) do
        EditData.C2S_Player_ResetGOLevel(3, 1, value.id, value.cfgId, level)
    end
end

function EditHeroItem:onBtnSetQuality()
    local quality = math.min(self.maxQuality, math.max(0, tonumber(self.inputQuality.text) or self.data.quality))
    EditData.C2S_Player_ResetGOLevel(3, 4, self.data.id, self.data.cfgId, nil, nil, nil, quality)
end

function EditHeroItem:onBtnDel()
    EditData.C2S_Player_ResetGOLevel(3, 2, self.data.id, self.data.cfgId)
end

function EditHeroItem:onBtnSetSkill()
    local index = tonumber(self.inputFieldSkillIndex.text)
    local skill = tonumber(self.inputFieldSkillLevel.text)
    EditData.C2S_Player_ResetGOLevel(EditData.TYPE_HERO, 3, self.data.id, self.data.cfgId, nil, index, skill)
end

function EditHeroItem:onBtnSetAllSkillLevel()
    local skillLevel = tonumber(self.inputFieldSkillLevel.text)

    for key, value in pairs(HeroData.heroDataMap) do
        for i = 1, 3, 1 do
            local skillId = value["skill" .. i]
            if skillId and skillId > 0 then
                local maxLevel = 0
                if SkillUtil.getSkillCfgMap()[skillId] then
                    for level, _ in pairs(SkillUtil.getSkillCfgMap()[skillId]) do
                        if level > maxLevel then
                            maxLevel = level
                        end
                    end
                    local setLevel = math.min(maxLevel, skillLevel)
                    EditData.C2S_Player_ResetGOLevel(EditData.TYPE_HERO, 3, value.id, value.cfgId, nil, i, setLevel)
                end
            end
        end
    end
end

function EditHeroItem:onBtnSetId()
    local index = tonumber(self.inputFieldSkillIndex.text)
    local skill = tonumber(self.inputFieldSkillId.text)
    EditData.C2S_Player_GOChangeSkill(EditData.TYPE_HERO, self.data.id, index, skill)
end

function EditHeroItem:onRelease()
    self.skillScrollView:release()
end

--------------------------------------------------------------

EditWarshipItem = EditWarshipItem or class("EditWarshipItem", ggclass.UIBaseItem)
function EditWarshipItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditWarshipItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)

    self.txtLevel = self:Find("TxtName/TxtLevel", UNITYENGINE_UI_TEXT)
    self.txtQuality = self:Find("TxtQuality", UNITYENGINE_UI_TEXT)
    self.imgSelect = self:Find("ImgSelect", UNITYENGINE_UI_IMAGE)
    self.imgSelect.gameObject:SetActiveEx(false)

    self.btnDel = self:Find("BtnDel")
    self:setOnClick(self.btnDel, gg.bind(self.onBtnDel, self))

    self.inputField = self:Find("InputField", UNITYENGINE_UI_INPUTFIELD)
    self.inputQuality = self:Find("InputQuality", UNITYENGINE_UI_INPUTFIELD)

    self.btnSet = self:Find("BtnSet")
    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))

    self.btnSetAll = self:Find("BtnSetAll")
    self:setOnClick(self.btnSetAll, gg.bind(self.onBtnSetAll, self))

    self.btnSetQuality = self:Find("BtnSetQuality")
    self:setOnClick(self.btnSetQuality, gg.bind(self.onBtnSetQuality, self))

    self.inputFieldSkillIndex = self:Find("InputFieldSkillIndex", UNITYENGINE_UI_INPUTFIELD)
    self.inputFieldSkillLevel = self:Find("InputFieldSkillLevel", UNITYENGINE_UI_INPUTFIELD)
    self.inputFieldSkillId = self:Find("InputFieldSkillId", UNITYENGINE_UI_INPUTFIELD)

    self.btnSetSkillLevel = self:Find("BtnSetSkillLevel")
    self:setOnClick(self.btnSetSkillLevel, gg.bind(self.onBtnSetSkill, self))

    self.btnSetSkillId = self:Find("BtnSetSkillId")
    self:setOnClick(self.btnSetSkillId, gg.bind(self.onBtnSetId, self))

    self.skillItemList = {}
    self.skillScrollView = UIScrollView.new(self:Find("SkillScrollView"), "EditSkillItem", self.skillItemList)
    self.skillScrollView:setRenderHandler(gg.bind(self.onRenderSkillItem, self))
end

function EditWarshipItem:setData(data)
    self.data = data
    local curCfg = WarshipUtil.getWarshipCfg(data.cfgId, data.quality, data.level)
    self.txtName.text = curCfg.name --Utils.getText(curCfg.languageNameID)
    self.txtLevel.text = "lv." .. data.level
    self.inputField.text = data.level
    self.inputQuality.text = data.quality

    self.txtQuality.text = "quality." .. data.quality

    self.skillDataList = {}
    for i = 1, 5, 1 do
        local skillId = data["skill" .. i]
        local skillLevel = data["skillLevel" .. i]
        if skillId > 0 then
            table.insert(self.skillDataList, SkillUtil.getSkillCfgMap()[skillId][skillLevel])
        end
    end
    self.skillScrollView:setItemCount(#self.skillDataList)
end

function EditWarshipItem:onRenderSkillItem(obj, index)
    local skillCfg = self.skillDataList[index]
    local item = EditSkillItem:getItem(obj, self.skillItemList, self)
    item:setData(skillCfg, index)
end

function EditWarshipItem:selectSkill(index, skillCfg)
    self.inputFieldSkillIndex.text = index
    self.inputFieldSkillLevel.text = skillCfg.level
    self.inputFieldSkillId.text = skillCfg.cfgId
end

function EditWarshipItem:onBtnSet()
    local level = math.max(0, tonumber(self.inputField.text) or self.data.level)
    EditData.C2S_Player_ResetGOLevel(2, 1, self.data.id, self.data.cfgId, level)
end

function EditWarshipItem:onBtnSetAll()
    local level = tonumber(self.inputField.text)

    for key, value in pairs(WarShipData.warShipData) do
        EditData.C2S_Player_ResetGOLevel(2, 1, value.id, value.cfgId, level)
    end
end

function EditWarshipItem:onBtnSetQuality()
    local quality = math.max(0, tonumber(self.inputQuality.text) or self.data.quality)
    EditData.C2S_Player_ResetGOLevel(2, 4, self.data.id, self.data.cfgId, nil, nil, nil, quality)
end

function EditWarshipItem:onBtnDel()
    EditData.C2S_Player_ResetGOLevel(2, 2, self.data.id, self.data.cfgId)
end

function EditWarshipItem:onBtnSetSkill()
    local index = tonumber(self.inputFieldSkillIndex.text)
    local skill = tonumber(self.inputFieldSkillLevel.text)
    EditData.C2S_Player_ResetGOLevel(2, 3, self.data.id, self.data.cfgId, nil, index, skill)
end

function EditWarshipItem:onBtnSetId()
    local index = tonumber(self.inputFieldSkillIndex.text)
    local skill = tonumber(self.inputFieldSkillId.text)
    EditData.C2S_Player_GOChangeSkill(EditData.TYPE_WARSHIP, self.data.id, index, skill)
end

function EditWarshipItem:onRelease()
    self.skillScrollView:release()
end

-----------------------------------------------------------------------------------
EditSoldierItem = EditSoldierItem or class("EditSoldierItem", ggclass.UIBaseItem)
function EditSoldierItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditSoldierItem:onInit()
    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtLevel = self:Find("TxtName/TxtLevel", UNITYENGINE_UI_TEXT)
    self.btnSet = self:Find("BtnSet")
    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))
    self.inputField = self:Find("InputField", UNITYENGINE_UI_INPUTFIELD)

    self.inputCfgId = self:Find("InputCfgId", UNITYENGINE_UI_INPUTFIELD)
end

function EditSoldierItem:setData(data)
    self.data = data
    self.inputCfgId.text = self.data.cfgId
    local curCfg = SoliderUtil.getSoliderCfgMap()[data.cfgId][data.level]
    self.txtName.text = Utils.getText(curCfg.languageNameID)
    self.txtLevel.text = "lv." .. data.level

    self.inputField.text = data.level
end

function EditSoldierItem:onBtnSet()
    local level = tonumber(self.inputField.text)

    if level and level > 0 then
        EditData.C2S_Player_ResetGOLevel(EditData.TYPE_SOLDIER, 1, self.data.id, self.data.cfgId, level)
    end
end

-----------------------------------------------------------------------------------
EditSkillItem = EditSkillItem or class("EditSkillItem", ggclass.UIBaseItem)
function EditSkillItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditSkillItem:onInit()
    self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))
    self.txtId = self:Find("TxtId", UNITYENGINE_UI_TEXT)
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function EditSkillItem:onRelease()
    self.commonItemItem:release()
end

function EditSkillItem:setData(skillCfg, index)
    self.skillCfg = skillCfg
    self.index = index

    self.commonItemItem:setQuality(skillCfg.quality)
    self.commonItemItem:setIcon(string.format("Skill_A1_Atlas[%s]", skillCfg.icon .. "_A1"))
    self.commonItemItem:setLevel(skillCfg.level)
    self.txtId.text = skillCfg.cfgId
end

function EditSkillItem:onClickItem()
    self.initData:selectSkill(self.index, self.skillCfg)
end

-----------------------------------------------------------------------------------
EditLandShipItem = EditLandShipItem or class("EditLandShipItem", ggclass.UIBaseItem)
function EditLandShipItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditLandShipItem:onInit()
    self.commonItemItem = CommonItemItem.new(self:Find("CommonItemItem"))

    self.txtName = self:Find("TxtName", UNITYENGINE_UI_TEXT)
    self.txtCfgId = self:Find("TxtName/TxtCfgId", UNITYENGINE_UI_TEXT)

    self.txtCount = self:Find("TxtCount", UNITYENGINE_UI_TEXT)
    self.inputCfgId = self:Find("InputCfgId", UNITYENGINE_UI_INPUTFIELD)
    self.inputCount = self:Find("InputCount", UNITYENGINE_UI_INPUTFIELD)
    self.btnSetSoldier = self:Find("BtnSetSoldier")
    self:setOnClick(self.btnSetSoldier, gg.bind(self.onBtnSetSoldier, self))

    self.inputLv = self:Find("InputLv", UNITYENGINE_UI_INPUTFIELD)

    self.btnSetLv = self:Find("BtnSetLv")
    self:setOnClick(self.btnSetLv, gg.bind(self.onBtnSetLv, self))

    -- self.txtId = self:Find("TxtId", UNITYENGINE_UI_TEXT)
    -- self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function EditLandShipItem:onRelease()
    self.commonItemItem:release()
end

function EditLandShipItem:setData(buildData)
    self.buildData = buildData

    self.commonItemItem:setActive(false)
    self.txtName.gameObject:SetActiveEx(false)

    self.txtCount.text = "count:" .. buildData.soliderCount
    self.inputCount.text = 0

    self.soldierData = nil
    if buildData.soliderCfgId and buildData.soliderCfgId > 0 then
        self.soldierData = BuildData.soliderLevelData[buildData.soliderCfgId]
        self.soldierCfg = SoliderUtil.getSoliderCfgMap()[self.soldierData.cfgId][self.soldierData.level]
        self.commonItemItem:setActive(true)
        self.commonItemItem:setIcon(string.format("Soldier_A_Atlas[%s_A]", self.soldierCfg.icon))
        self.commonItemItem:setLevel(self.soldierData.level)

        self.txtName.gameObject:SetActiveEx(true)
        self.txtName.text = Utils.getText(self.soldierCfg.languageNameID)
        self.txtCfgId.text = "cfgId." .. buildData.soliderCfgId

        self.inputCfgId.text = buildData.soliderCfgId
        
        self.inputLv.text = self.soldierData.level
    else
        self.inputLv.text = 0
    end
end

function EditLandShipItem:onBtnSetSoldier()
    local soliderCfgId = tonumber(self.inputCfgId.text)
    local soliderCount = tonumber(self.inputCount.text)
    EditData.C2S_Player_OPLandShipSoldier(self.buildData.id, soliderCfgId, soliderCount)
end

function EditLandShipItem:onBtnSetLv()
    local level = tonumber(self.inputLv.text)
    if level and level > 0 then
        EditData.C2S_Player_ResetGOLevel(EditData.TYPE_SOLDIER, 1, self.soldierData.id, self.soldierData.cfgId, level)
    end
end

-----------------------------------------------------------------------------------
EditArmyItem = EditArmyItem or class("EditArmyItem", ggclass.UIBaseItem)
function EditArmyItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditArmyItem:onInit()
    self.teamItemList = {}
    self.scrollView = UIScrollView.new(self:Find("ScrollView"), "EditTeamItem", self.teamItemList)
    self.scrollView:setRenderHandler(gg.bind(self.onRenderItem, self))
end

function EditArmyItem:setData(data)
    self.data = data
    self.scrollView:setItemCount(5)
end

function EditArmyItem:onRenderItem(obj, index)
    local item = EditTeamItem:getItem(obj, self.teamItemList, self)
    item:setData(self.data.teams[index], index)
end

function EditArmyItem:onRelease()
    self.scrollView:release()
end

-----------------------------------------------------------------------------------
EditTeamItem = EditTeamItem or class("EditTeamItem", ggclass.UIBaseItem)
function EditTeamItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditTeamItem:onInit()
    self.inPutHeroId = self:Find("InPutHeroId", UNITYENGINE_UI_INPUTFIELD)
    self.inPutSoldierCfgId = self:Find("InPutSoldierCfgId", UNITYENGINE_UI_INPUTFIELD)
    self.inPutSoldierCount = self:Find("InPutSoldierCount", UNITYENGINE_UI_INPUTFIELD)

    self.btnSet = self:Find("BtnSet")
    self:setOnClick(self.btnSet, gg.bind(self.onBtnSet, self))
end

function EditTeamItem:onBtnSet()
    local team = {heroId = tonumber(self.inPutHeroId.text), soliderCfgId = tonumber(self.inPutSoldierCfgId.text), soliderCount = tonumber(self.inPutSoldierCount.text) }
    if team.soliderCfgId == 0 or team.soliderCount == 0 then
        team.soliderCfgId = 0
        team.soliderCount = 0
    end
    EditData.C2S_Player_EditedArmyFormation(self.initData.data.armyId, self.initData.data.armyName, self.index, {team})
    -- PlayerData.C2S_Player_ArmyFormationUpdate(self.initData.data.armyId, self.initData.data.armyName, self.index, {team})
end

function EditTeamItem:setData(data, index)
    self.data = data
    self.index = index
    if data then
        self.inPutHeroId.text = data.heroId
        self.inPutSoldierCfgId.text = data.soliderCfgId
        self.inPutSoldierCount.text = data.soliderCount
    else
        self.inPutHeroId.text = 0
        self.inPutSoldierCfgId.text = 0
        self.inPutSoldierCount.text = 0
    end
end
-----------------------------------------------------------------------------------
EditBattleArmyItem = EditBattleArmyItem or class("EditBattleArmyItem", ggclass.UIBaseItem)
function EditBattleArmyItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditBattleArmyItem:onInit()
    self.txtIndex = self:Find("TxtIndex", UNITYENGINE_UI_TEXT)

    self.layoutHero = self:Find("LayoutHero").transform
    self.heroAttrITemList = {}
    self.heroAttrScrollView = UIScrollView.new(self.layoutHero:Find("AttrScrollView"), "EditBattleAttrItem", self.heroAttrITemList)
    self.heroAttrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))

    self.layoutSoldier = self:Find("LayoutSoldier").transform
    self.soldierAttrItemList = {}
    self.soldierAttrScrollView = UIScrollView.new(self.layoutSoldier:Find("AttrScrollView"), "EditBattleAttrItem", self.soldierAttrItemList)
    self.soldierAttrScrollView:setRenderHandler(gg.bind(self.onRenderSoldierAttr, self))

    self.toggleHero = self:Find("ToggleHero", UNITYENGINE_UI_TOGGLE)
    self.toggleHero.onValueChanged:AddListener(gg.bind(self.onToggleHeroChange, self))

    self.toggleSoldier = self:Find("ToggleSoldier", UNITYENGINE_UI_TOGGLE)
    self.toggleSoldier.onValueChanged:AddListener(gg.bind(self.onToggleSoldierChange, self))

    self.btnDelete = self:Find("BtnDelete")
    self:setOnClick(self.btnDelete, gg.bind(self.onBtnDelete, self))
end

function EditBattleArmyItem:onBtnDelete()
    self.initData:deleteArmy(self.index)
end

function EditBattleArmyItem:onToggleHeroChange(isOn)
    self.data.isHero = isOn
end

function EditBattleArmyItem:onToggleSoldierChange(isOn)
    self.data.isSoldier = isOn
end

function EditBattleArmyItem:onRenderHeroAttr(obj, index)
    local item = EditBattleAttrItem:getItem(obj, self.heroAttrITemList, self)
    item:setData(self.heroAttrList[index], self.data.hero)
end

function EditBattleArmyItem:onRenderSoldierAttr(obj, index)
    local item = EditBattleAttrItem:getItem(obj, self.heroAttrITemList, self)
    item:setData(self.soldierAttrList[index], self.data.soldier)
end

function EditBattleArmyItem:setData(index, data)
    self.index = index
    self.data = data
    self.txtIndex.text = index

    self.toggleHero.isOn = data.isHero
    self.toggleSoldier.isOn = data.isSoldier

    self.data.soldier.index = index
    self.data.hero.index = index

    self.heroAttrList = {
        {key = "moveSpeed", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "maxHp", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atk", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atkSpeed", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atkRange", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "radius", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
    }

    self.heroAttrScrollView:setItemCount(#self.heroAttrList)
    self.soldierAttrList = {
        {key = "amount", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "moveSpeed", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "maxHp", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atk", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atkSpeed", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atkRange", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "radius", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
    }
    self.soldierAttrScrollView:setItemCount(#self.soldierAttrList)
end

function EditBattleArmyItem:onRelease()
    self.heroAttrScrollView:release()
    self.toggleHero.onValueChanged:RemoveAllListeners()
    self.toggleSoldier.onValueChanged:RemoveAllListeners()
end

-----------------------------------------------------------------------------------
EditBattleLaunchBuildingItem = EditBattleLaunchBuildingItem or class("EditBattleLaunchBuildingItem", ggclass.UIBaseItem)
function EditBattleLaunchBuildingItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function EditBattleLaunchBuildingItem:onInit()
    self.attrItemList = {}
    self.AttrScrollView = UIScrollView.new(self:Find("AttrScrollView"), "EditBattleAttrItem", self.attrItemList)
    self.AttrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))
    self.btnDelete = self:Find("BtnDelete")
    self:setOnClick(self.btnDelete, gg.bind(self.onBtnDelete, self))

    self.toggleResetPos = self:Find("ToggleResetPos", UNITYENGINE_UI_TOGGLE)
    self.toggleResetPos.onValueChanged:AddListener(gg.bind(self.onToggleResetPos, self))
end

function EditBattleLaunchBuildingItem:onToggleResetPos(isOn)
    self.data.isNotSetPos = not isOn
end

function EditBattleLaunchBuildingItem:onBtnDelete()
    self.initData:deleteBuilding(self.index)
end

function EditBattleLaunchBuildingItem:onRenderAttr(obj, index)
    local item = EditBattleAttrItem.new(obj, self.heroAttrITemList)
    item:setData(self.attrList[index], self.data.build)
end

local lineBuildCount = 14
local lenth = 28

function EditBattleLaunchBuildingItem:setData(index, data)
    self.index = index
    self.data = data

    self.toggleResetPos.isOn = not data.isNotSetPos

    data.build.editCount = data.build.editCount or 1

    self.attrList = {
        {key = "maxHp", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atk", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atkSpeed", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "atkRange", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "radius", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
        {key = "editCount", valueType = EditBattleAttrItem.VALUE_TYPE_NUMBER},
    }
    self.AttrScrollView:setItemCount(#self.attrList)
end

-----------------------------------------------------------------------------------
EditBattleAttrItem = EditBattleAttrItem or class("EditBattleAttrItem", ggclass.UIBaseItem)
function EditBattleAttrItem:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

EditBattleAttrItem.VALUE_TYPE_STRING = 1
EditBattleAttrItem.VALUE_TYPE_NUMBER = 2

function EditBattleAttrItem:onInit()
    self.text = self:Find("Text", UNITYENGINE_UI_TEXT)
    self.inPut = self:Find("InPut", UNITYENGINE_UI_INPUTFIELD)
    self.inPut.onEndEdit:AddListener(gg.bind(self.onInputEnd, self))
    -- self.layoutHero = self:Find("LayoutHero").transform
end

function EditBattleAttrItem:onRelease()
    self.inPut.onEndEdit:RemoveAllListeners()
end

function EditBattleAttrItem:onInputEnd(text)
    if self.attr.valueType == EditBattleAttrItem.VALUE_TYPE_NUMBER then
        text = tonumber(text)
    end

    if self.attr.key == "maxHp" then
        self.data.hp = text
    end

    self.data[self.attr.key] = text
end

function EditBattleAttrItem:setData(attr, data)
    self.attr = attr
    self.data = data
    self.text.text = attr.key
    self.inPut.text = data[attr.key]
end
