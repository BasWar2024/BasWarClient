
require "UI.Edit.EditTools"
PnlEdit = class("PnlEdit", ggclass.UIBase)

local cjson = require "cjson"

function PnlEdit:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onUpdateBuildData", "onRemoveBuilding", "onHeroChange", "onRefreshWarShipData", "onSoliderChange", "onPersonalArmyChange"}
end

PnlEdit.TYPE_INFO = 1
PnlEdit.TYPE_BATTLE = 2
PnlEdit.TYPE_BUILD = 3
PnlEdit.TYPE_BUILDING = 4
PnlEdit.TYPE_HERO = 5
PnlEdit.TYPE_WARSHIP = 6
PnlEdit.TYPE_SOLDIER = 7
PnlEdit.TYPE_ARMY = 8
-- PnlEdit.TYPE_LANDSHIP = 7

PnlEdit.EXPLORE_PATH_KEY = "EDIT_EXPLORE_PATH_KEY"

function PnlEdit:onAwake()
    self.view = ggclass.PnlEditView.new(self.pnlTransform)
    local view = self.view
    self.optionalTopBtnsBox = OptionalTopBtnsBox.new(self.view.optionalTopBtnsBox)

    self.typeInfo = {
        [PnlEdit.TYPE_INFO] = {
            layout = view.layoutInfo,
            func = gg.bind(self.refreshInfo, self),
        },

        [PnlEdit.TYPE_BATTLE] = {
            layout = view.layoutBattle,
            func = gg.bind(self.refreshBattle, self),
        },

        [PnlEdit.TYPE_BUILD] = {
            layout = view.layoutBuild,
            func = gg.bind(self.refreshBuild, self),
        },

        [PnlEdit.TYPE_BUILDING] = {
            layout = view.layoutBuilding,
            func = gg.bind(self.refreshBuilding, self),
        },

        [PnlEdit.TYPE_HERO] = {
            layout = view.layoutHero,
            func = gg.bind(self.refreshHero, self),
        },

        [PnlEdit.TYPE_WARSHIP] = {
            layout = view.layoutWarship,
            func = gg.bind(self.refreshWarship, self),
        },

        [PnlEdit.TYPE_SOLDIER] = {
            layout = view.layoutSoldier,
            func = gg.bind(self.refreshSoldier, self),
        },

        [ PnlEdit.TYPE_ARMY] = {
            layout = view.layoutArmy,
            func = gg.bind(self.refreshArmy, self),
        },

        -- [ PnlEdit.TYPE_LANDSHIP] = {
        --     layout = view.layoutLandship,
        --     func = gg.bind(self.refreshLandship, self),
        -- },
    }

    self.optionalTopBtnsBox:setBtnDataList({
        [PnlEdit.TYPE_INFO] = {
            name = "info",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_INFO)
        },
        [PnlEdit.TYPE_BATTLE] = {
            name = "battle",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_BATTLE)
        },
        [PnlEdit.TYPE_BUILD] = {
            name = "build",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_BUILD)
        },
        [PnlEdit.TYPE_BUILDING] = {
            name = "building info",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_BUILDING)
        },
        [PnlEdit.TYPE_HERO] = {
            name = "hero",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_HERO)
        },

        [PnlEdit.TYPE_WARSHIP] = {
            name = "warship",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_WARSHIP)
        },

        [PnlEdit.TYPE_SOLDIER] = {
            name = "soldier",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_SOLDIER)
        },

        [PnlEdit.TYPE_ARMY] = {
            name = "army",
            callback = gg.bind(self.refresh, self, PnlEdit.TYPE_ARMY)
        },

        -- [7] = {
        --     name = "landship",
        --     callback = gg.bind(self.refresh, self, PnlEdit.TYPE_LANDSHIP)
        -- },
    })

    -- build

    self.buildLeftBtnViewBgBtnsBox = LeftBtnViewBgBtnsBox.new(view.buildLeftBtnViewBgBtnsBox)
    local buildBtnDataList = 
    {
        {name = Utils.getText("build_Economy"), callback = gg.bind(self.onBtnBuildOptions, self, {type = constant.BUILD_ECONIMIC} )},
        {name = Utils.getText("build_Development"), callback = gg.bind(self.onBtnBuildOptions, self, {type = constant.BUILD_DEVELOPMENT})},
        {name = Utils.getText("build_Defense"), callback = gg.bind(self.onBtnBuildOptions, self, {type = constant.BUILD_DEFENSE})},
        {name = "belong=3", callback = gg.bind(self.onBtnBuildOptions, self, {belong = 3, })},
        {name = "belong=4", callback = gg.bind(self.onBtnBuildOptions, self, {belong = 4, })},
        {name = "belong=5", callback = gg.bind(self.onBtnBuildOptions, self, {belong = 5, })},
        {name = """", callback = gg.bind(self.onBtnBuildOptions, self, {type = constant.BUILD_CLUTTER})},
        {name = "TabletopCloud", callback = gg.bind(self.onBtnBuildOptions, self, {type = constant.BUILD_CLUTTER, model = "TabletopCloud"})},

        -- {name = "belong=3", callback = gg.bind(self.onBtnBuildOptions, self, constant.BUILD_CLUTTER)},
        -- {name = "nft1", callback = gg.bind(self.onBtnBuildNFT, self, 1)},
        -- {name = "nft2", callback = gg.bind(self.onBtnBuildNFT, self, 2)},
        -- {name = "nft3", callback = gg.bind(self.onBtnBuildNFT, self, 3)},
        -- {name = "nft4", callback = gg.bind(self.onBtnBuildNFT, self, 4)},
        -- {name = "nft5", callback = gg.bind(self.onBtnBuildNFT, self, 5)},
    }

    
    -- table.insert(buildBtnDataList, {name = "TabletopCloud", callback = gg.bind(self.onBtnBuildOptions, self, {type = constant.BUILD_CLUTTER, model = "TabletopCloud"})})
    for i = 1, 4, 1 do
        local name = "TabletopCom" .. i
        table.insert(buildBtnDataList, {name = name, callback = gg.bind(self.onBtnBuildOptions, self, {type = constant.BUILD_CLUTTER, model = name})})
    end

    self.buildLeftBtnViewBgBtnsBox:setBtnDataList(buildBtnDataList)

    self.buildItemList = {}
    self.buildScrollView = UIScrollView.new(view.buildScrollView, "EditBuildItem", self.buildItemList)
    self.buildScrollView:setRenderHandler(gg.bind(self.onRenderBuildItem, self))

    -- building
    self.buildingItemList = {}
    self.buildingScrollView = UIScrollView.new(view.buildingScrollView, "EditBuildingItem", self.buildingItemList)
    self.buildingScrollView:setRenderHandler(gg.bind(self.onRenderBuildingItem, self))

    -- hero
    self.heroItemList = {}
    self.heroScrollView = UIScrollView.new(view.heroScrollView, "EditHeroItem", self.heroItemList)
    self.heroScrollView:setRenderHandler(gg.bind(self.onRenderHeroItem, self))

    -- warship
    self.warshipItemList = {}
    self.warshipScrollView = UIScrollView.new(view.warshipScrollView, "EditWarshipItem", self.warshipItemList)
    self.warshipScrollView:setRenderHandler(gg.bind(self.onRenderWarship, self))

    -- soldier
    self.soldierItemList = {}
    self.soldierScrollView = UIScrollView.new(view.soldierScrollView, "EditSoldierItem", self.soldierItemList)
    self.soldierScrollView:setRenderHandler(gg.bind(self.onRenderSoldier, self))

    -- army
    self.armyItemList = {}
    self.armyScrollView = UIScrollView.new(view.armyScrollView, "EditArmyItem", self.armyItemList)
    self.armyScrollView:setRenderHandler(gg.bind(self.onRenderArmy, self))

    --landship
    self.landshipItemList = {}
    self.landshipScrollView = UIScrollView.new(view.landshipScrollView, "EditLandShipItem", self.landshipItemList)
    self.landshipScrollView:setRenderHandler(gg.bind(self.onRenderLandship, self))

    -- battle
    self:initBattle()

    -- {"life":50,"x":8,"z":11,"cfgId":3000052,"level":2,"curLife":50,"quality":0}
end

function PnlEdit:onShow()
    self:bindEvent()
    self:bindBattleEvent()
    self.optionalTopBtnsBox:open()

    self.showType = self.showType or PnlEdit.TYPE_INFO
    self.optionalTopBtnsBox:onBtn(self.showType)
    -- local js = " {"life":50,"x":8,"z":11,"cfgId":3000052,"level":2,"curLife":50,"quality":0}
    -- ""
    -- local file = io.open("C:\\Users\\czl\\Desktop\\output.lua", "a")
    -- file:write(gg.table2Str(args))
    -- file:close()

    --local url = "https://galaxyblitzimg.s3.eu-north-1.amazonaws.com/GBGameSprite/test.png"
    -- local name = "background03.jpg"
    -- self.coroutine, self.uwr = CS.DownloadUtils.LoadRemoteSprite(name, function (sprite, error)
    --     if error then
    --         print(error)
    --        -- self:downLoadSprite(url)
    --         return
    --     end
    --     self.view.imgTest.sprite = sprite
    --     --self.coroutine = nil
    --     -- gg.timer:stopTimer(self.progressTimer)
    --     -- self.text.text = "100%"
    -- end)
end

function PnlEdit:refresh(showType)
    self.showType = showType

    for key, value in pairs(self.typeInfo) do
        if key == showType then
            value.layout:SetActiveEx(true)
            value.func()
        else
            value.layout:SetActiveEx(false)
        end
    end

end

-- info
function PnlEdit:refreshInfo()
    self.view.inputFieldExplorePath.text = UnityEngine.PlayerPrefs.GetString(PnlEdit.EXPLORE_PATH_KEY)
    self.view.toggleBattleDetail.isOn = util.getDetail()
end

function PnlEdit:onBtnExplore()
    local dataList = {}
    for key, value in pairs(BuildData.buildData) do
        if value.cfgId ~= constant.BUILD_LIBERATORSHIP then
            table.insert(dataList, {
                ["life"] = value.life,
                ["x"] = value.pos.x,
                ["z"] = value.pos.z,
                ["cfgId"] = value.cfgId,
                ["level"] = value.level,
                ["curLife"] = value.curIce,
                ["quality"] = value.quality,
            })
        end
    end
    local strBuildJson = cjson.encode(dataList)

    local path = self.view.inputFieldExplorePath.text
    UnityEngine.PlayerPrefs.SetString(PnlEdit.EXPLORE_PATH_KEY, path)
    local jsonPath = path .. "\\buildJson.json"
    local file = io.open(jsonPath, "w+")
    file:write(strBuildJson)
    file:close()
end

function PnlEdit:onBtnRemoveAllBuild()
    for key, value in pairs(BuildData.buildData) do
        if value.cfgId ~= constant.BUILD_BASE and value.cfgId ~= constant.BUILD_LIBERATORSHIP then
            EditData.C2S_Player_ResetGOLevel(1, 2, value.id, value.cfgId)
        end
    end
end

function PnlEdit:battleJson(strJson)
    local args = cjson.decode(strJson)

    local battleType = tonumber(self.view.inputBattleType.text)
    if battleType == 0 then
        -- BattleData.S2C_Player_StartBattle(args)
        BattleData.setIsBattleEnd(false)
        gg.sceneManager:enterBattleScene(args.battleId, args.battleInfo, 0)
    elseif battleType == 1 then
        args.bVersion = CS.Appconst.BattleVersion
        BattleData.S2C_Player_LookBattlePlayBack(args)
    elseif battleType == 2 then
        BattleData.setIsBattleEnd(false)
        gg.sceneManager:enterBattleScene(args.battleId, args.battleInfo, 2)
    end
end

function PnlEdit:onBtnBattleJson()
    self:battleJson(self.view.inputFieldBattleJson.text)
end

function PnlEdit:onBtnBattleServerJson()
    local path = self.view.inputFieldBattleJson.text
    local file = io.open(path, "r")
    local json = file:read("a")
    file:close()

    -- 
end

function PnlEdit:onBtnBattleJsonPath()
    local path = self.view.inputFieldBattleJson.text
    local file = io.open(path, "r")
    local json = file:read("a")
    file:close()
    self:battleJson(json)
end

function PnlEdit:onBtnRecord()
    local view = self.view
    BattleData.C2S_Player_LookBattlePlayBack(tonumber(view.inputFieldBattleId.text) , view.inputFieldBattleVersion.text, self)
end

function PnlEdit:onBtnReadBuilding()
    local editorCreateBuilds = {}
    local dataList = cjson.decode(self.view.inputFieldReadBuildingJson.text)
    for key, value in pairs(dataList) do
        if value.cfgId ~= constant.BUILD_LIBERATORSHIP then
            table.insert(editorCreateBuilds, {
                cfgId = value.cfgId,
                pos = Vector3.New(value.x, 0, value.z),
                level = value.level,
            })
        end
    end
    EditData.C2S_Player_GMBuildBatchCreate(editorCreateBuilds)
end

function PnlEdit:onBtnUnionSetBattleCount()
    EditData.unionSelfAutoBattleCount = tonumber(self.view.inputUnionCount.text)
    print(EditData.unionSelfAutoBattleCount)
end

-- build
function PnlEdit:refreshBuild()
    -- self.showType = showType
    self.buildLeftBtnViewBgBtnsBox:onBtn(1)
end

function PnlEdit:onRenderBuildItem(obj, index)
    local item = EditBuildItem:getItem(obj, self.buildItemList, self)
    item:setData(self.buildDataList[index])
end

function PnlEdit:onBtnBuildOptions(filterInfo)
    self.buildDataList = {}

    for _, build in pairs(cfg.build) do
        if build.level == 0 then

            local isFilter = false
            for key, info in pairs(filterInfo) do
                if build[key] ~= info then
                    isFilter = true
                    break
                end
            end

            if not isFilter then
                table.insert(self.buildDataList, build)
            end

            -- value.type == buildType and
            -- if buildType == constant.BUILD_CLUTTER and model then
            --     if model == value.model then
            --         print(model, value.model)
            --         table.insert(self.buildDataList, value)
            --     end
            -- else
            --     table.insert(self.buildDataList, value)
            -- end
        end

        -- if  buildType == constant.BUILD_CLUTTER then
        --     if value.type == buildType then
        --         table.insert(self.buildDataList, value)
        --     end
        -- else
        --     if value.type == buildType and value.level == 0 and value.quality == 0 then
        --         table.insert(self.buildDataList, value)
        --     end
        -- end
    end

    -- if index == 1 then
    --     self.buildDataList = gg.buildingManager.buildingTableOfEconomic
    -- elseif index == 2 then
    --     self.buildDataList = gg.buildingManager.buildingTableOfDevelopment
    -- elseif index == 3 then
    --     self.buildDataList = gg.buildingManager.buildingTableOfDefense
    -- end
    self.buildScrollView:setItemCount(#self.buildDataList)
end

function PnlEdit:onBtnBuildNFT(quality)
    self.buildDataList = {}
    for k, v in pairs(cfg.build) do
        if v.level == 0 and v.quality == quality then
            table.insert(self.buildDataList, v)
        end
    end
    self.buildScrollView:setItemCount(#self.buildDataList)
end

--building

function PnlEdit:refreshBuilding()
    self.buildingDataList = {}

    for key, value in pairs(BuildData.buildData) do
        table.insert(self.buildingDataList, value)
    end

    table.sort(self.buildingDataList, function (a, b)
        if a.cfgId ~= b.cfgId then
            return a.cfgId < b.cfgId
        end
        return a.id < b.id
    end)

    self.buildingScrollView:setItemCount(#self.buildingDataList)
end

function PnlEdit:onRenderBuildingItem(obj, index)
    local item = EditBuildingItem:getItem(obj, self.buildingItemList, self)
    item:setData(self.buildingDataList[index])
end

function PnlEdit:onUpdateBuildData()
    if self.showType == PnlEdit.TYPE_BUILDING then
        self:refreshBuilding()
    elseif self.showType == PnlEdit.TYPE_LANDSHIP then
        self:refreshLandship()
    end
end

function PnlEdit:onRemoveBuilding()
    self:onUpdateBuildData()
end

-- hero

function PnlEdit:refreshHero()
    self.heroDataList = {}
    -- HeroData.heroDataMap
    for key, value in pairs(HeroData.heroDataMap) do
        table.insert(self.heroDataList, value)
    end
    self.heroScrollView:setItemCount(#self.heroDataList)
end

function PnlEdit:onHeroChange()
    if self.showType == PnlEdit.TYPE_HERO then
        self:refreshHero()
    end
end

function PnlEdit:onRenderHeroItem(obj, index)
    local item = EditHeroItem:getItem(obj, self.heroItemList, self)
    item:setData(self.heroDataList[index])
end

-- warship

function PnlEdit:refreshWarship()
    self.warshipDataList = {}
    for key, value in pairs(WarShipData.warShipData) do
        table.insert(self.warshipDataList, value)
    end
    self.warshipScrollView:setItemCount(#self.warshipDataList)
end

function PnlEdit:onRenderWarship(obj, index)
    local item = EditWarshipItem:getItem(obj, self.warshipItemList, self)
    item:setData(self.warshipDataList[index])
end

function PnlEdit:onRefreshWarShipData()
    if self.showType == PnlEdit.TYPE_WARSHIP then
        self:refreshWarship()
    end
end

--soldier
function PnlEdit:refreshSoldier()
    self.soldierDataList = {}
    for key, value in pairs(BuildData.soliderLevelData) do
        table.insert(self.soldierDataList, value)
    end
    self.soldierScrollView:setItemCount(#self.soldierDataList)
end

function PnlEdit:onRenderSoldier(obj, index)
    local item = EditSoldierItem:getItem(obj, self.soldierItemList, self)
    item:setData(self.soldierDataList[index])
end

function PnlEdit:onSoliderChange()
    if self.showType == PnlEdit.TYPE_SOLDIER then
        self:refreshSoldier()
    elseif self.showType == PnlEdit.TYPE_LANDSHIP then
        self:refreshLandship()
    end
end

function PnlEdit:onBtnSetAllSoldier()
    for key, value in pairs(self.soldierDataList) do
        EditData.C2S_Player_ResetGOLevel(EditData.TYPE_SOLDIER, 1, value.id, value.cfgId, tonumber(self.view.inputAllSoldierLevel.text))
    end
end

-- army
function PnlEdit:refreshArmy()
    PlayerData.C2S_Player_ArmyFormationQuery()
end

function PnlEdit:onPersonalArmyChange()
    if self.showType == PnlEdit.TYPE_ARMY then
        self.armyDataList = PlayerData.armyData
        self.armyScrollView:setItemCount(#self.armyDataList)
    end
end

function PnlEdit:onRenderArmy(obj, index)
    local item = EditArmyItem:getItem(obj, self.armyItemList, self)
    item:setData(self.armyDataList[index])
end

-- warshipSoldier

function PnlEdit:refreshLandship()
    self.landshipDataList = {}
    for key, value in pairs(BuildData.buildData) do
        if value.cfgId == constant.BUILD_LIBERATORSHIP then
            table.insert(self.landshipDataList,value )
        end
    end

    self.landshipScrollView:setItemCount(#self.landshipDataList)
end

function PnlEdit:onRenderLandship(obj, index)
    local item = EditLandShipItem:getItem(obj, self.landshipItemList, self)
    item:setData(self.landshipDataList[index])
end

-- battle
function PnlEdit:initBattle()
    local view = self.view

    self.btnBattleAtk = view.layoutBattle:Find("BtnBattleAtk").gameObject

    self.btnBattleClear = view.layoutBattle:Find("BtnBattleClear").gameObject
    self.btnBattleClearArmy = view.layoutBattle:Find("BtnBattleClearArmy").gameObject
    self.btnBattleClearBuild = view.layoutBattle:Find("BtnBattleClearBuild").gameObject

    self.btnBattleExplore = view.layoutBattle:Find("BtnBattleExplore").gameObject
    self.btnExploreBattleInfo = view.layoutBattle:Find("BtnExploreBattleInfo").gameObject
    self.btnBattleRead = view.layoutBattle:Find("BtnBattleRead").gameObject

    self.btnBattleLoadBuild = view.layoutBattle:Find("BtnBattleLoadBuild").gameObject
    self.btnBattleLoadArmy = view.layoutBattle:Find("BtnBattleLoadArmy").gameObject
    self.inputFieldBattleLoadArmyCount = view.layoutBattle:Find("InputFieldBattleLoadArmyCount"):GetComponent(UNITYENGINE_UI_INPUTFIELD)

    
    -- self.veiw.inputFieldExplorePath.text = UnityEngine.PlayerPrefs.GetString(PnlEdit.EXPLORE_PATH_KEY)
    self.inputFieldBattleExplorePath = view.layoutBattle:Find("InputFieldBattleExplorePath"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.inputFieldBattleExplorePath.text = UnityEngine.PlayerPrefs.GetString(PnlEdit.EXPLORE_PATH_KEY, path)

    self.btnBattleSubArmy = view.layoutBattleArmy:Find("BtnBattleSubArmy").gameObject
    self.btnBattleAddArmy = view.layoutBattleArmy:Find("BtnBattleAddArmy").gameObject
    
    self.battleArmyItemList = {}
    self.battleArmyScrollView = UIScrollView.new(view.layoutBattleArmy:Find("ScrollView"), "EditBattleArmyItem", self.battleArmyItemList)
    self.battleArmyScrollView:setRenderHandler(gg.bind(self.onRenderBattleArmy, self))

    self.btnBattleAddBuilding = view.layoutBattleBuilding:Find("BtnBattleAddBuilding").gameObject
    self.btnBattleSubBuilding = view.layoutBattleBuilding:Find("BtnBattleSubBuilding").gameObject
    
    self.battleBuildingItemList = {}
    self.battleBuildingScrollView = UIScrollView.new(view.layoutBattleBuilding:Find("ScrollView"), "EditBattleLaunchBuildingItem", self.battleBuildingItemList)
    self.battleBuildingScrollView:setRenderHandler(gg.bind(self.onRenderBattleBuilding, self))

    self.battleBuildingList = {}
end

function PnlEdit:bindBattleEvent()
    self:setOnClick(self.btnBattleClear, gg.bind(self.onBtnBattleClear, self))
    self:setOnClick(self.btnBattleClearArmy, gg.bind(self.onBtnBattleClearArmy, self))
    self:setOnClick(self.btnBattleClearBuild, gg.bind(self.onBtnBattleClearBuild, self))

    self:setOnClick(self.btnBattleAtk, gg.bind(self.onBtnBattleAtk, self))
    self:setOnClick(self.btnBattleSubArmy, gg.bind(self.onBtnBattleSubArmy, self))
    self:setOnClick(self.btnBattleAddArmy, gg.bind(self.onBtnBattleAddArmy, self))
    self:setOnClick(self.btnBattleAddBuilding, gg.bind(self.onBtnBattleAddBuilding, self))
    self:setOnClick(self.btnBattleSubBuilding, gg.bind(self.onBtnBattleSubBuilding, self))
    self:setOnClick(self.btnBattleExplore, gg.bind(self.onBtnBattleExplore, self))
    self:setOnClick(self.btnExploreBattleInfo, gg.bind(self.onBtnExploreBattleInfo, self))
    self:setOnClick(self.btnBattleRead, gg.bind(self.onBtnBattleRead, self))
    self:setOnClick(self.btnBattleLoadBuild, gg.bind(self.onBtnBattleLoadBuild, self))
    self:setOnClick(self.btnBattleLoadArmy, gg.bind(self.onBtnBattleLoadArmy, self))
end

function PnlEdit:onRenderBattleArmy(obj, index)
    local item = EditBattleArmyItem:getItem(obj, self.battleArmyItemList, self)
    item:setData(index, self.battleArmyDataList[index])
end

function PnlEdit:onRenderBattleBuilding(obj, index)
    local item = EditBattleLaunchBuildingItem:getItem(obj, self.battleArmyItemList, self)
    item:setData(index, self.battleBuildingDataList[index])
end

function PnlEdit:onBtnBattleAddBuilding()
    table.insert(self.battleBuildingDataList, {build = GetDefaultBuilding()})
    self:refreshBattleBuilding()
end

function PnlEdit:onBtnBattleSubBuilding()
    -- table.remove(self.battleBuildingDataList, #self.battleBuildingDataList)
    -- self:refreshBattleBuilding()
end

function PnlEdit:deleteBuilding(index)
    table.remove(self.battleBuildingDataList, index)
    self:refreshBattleBuilding()
end

function PnlEdit:onBtnBattleAddArmy()
    table.insert(self.battleArmyDataList, {soldier = GetDefaultSoldier(), isSoldier = true, hero = GetDefaultHero(), isHero = true})
    self:refreshBattleArmy()
end

function PnlEdit:onBtnBattleSubArmy()
    -- table.remove(self.battleArmyDataList, #self.battleArmyDataList)
    -- self:refreshBattleArmy()
end

function PnlEdit:deleteArmy(index)
    table.remove(self.battleArmyDataList, index)
    self:refreshBattleArmy()
end

function PnlEdit:refreshBattleArmy()
    self.battleArmyScrollView:setItemCount(#self.battleArmyDataList)
end

function PnlEdit:refreshBattleBuilding()
    self.battleBuildingScrollView:setItemCount(#self.battleBuildingDataList)
end

function PnlEdit:refreshBattle()
    self.battleArmyDataList = self.battleArmyDataList or {}
    self:refreshBattleArmy()

    self.battleBuildingDataList = self.battleBuildingDataList or {}
    self:refreshBattleBuilding()
end

function PnlEdit:onBtnBattleClear()
    self.battleArmyDataList = {}
    self:refreshBattleArmy()

    self.battleBuildingDataList = {}
    self:refreshBattleBuilding()
end

function PnlEdit:onBtnBattleClearArmy()
    self.battleArmyDataList = {}
    self:refreshBattleArmy()
end

function PnlEdit:onBtnBattleClearBuild()
    self.battleBuildingDataList = {}
    self:refreshBattleBuilding()
end

function PnlEdit:onBtnBattleRead()
    local path = self.inputFieldBattleExplorePath.text .. "\\battleArmyJson.json"
    local file = io.open(path, "r")
    local json = file:read("a")
    file:close()

    local data = cjson.decode(json)
    -- gg.printData(data)

    self.battleBuildingDataList = data.builds
    self.battleArmyDataList = data.armys

    self:refreshBattleArmy()
    self:refreshBattleBuilding()
end

function PnlEdit:onBtnBattleLoadBuild()
    for _, build in pairs(BuildData.buildData) do
        local buildCfg = BuildUtil.getCurBuildCfg(build.cfgId, build.level, build.quality)

        if (build.pos.x ~= 0 or build.pos.z ~= 0) and buildCfg.type ~= constant.BUILD_CLUTTER then
            local buildData = GetDefaultBuilding()

            for key, value in pairs(buildData) do
                if buildCfg[key] then
                    buildData[key] = buildCfg[key]
                end
            end

            buildData.hp = buildData.maxHp
            buildData.x = build.pos.x
            buildData.z = build.pos.z

            table.insert(self.battleBuildingDataList, {build = buildData, isNotSetPos = true})
        end
    end

    self:refreshBattle()
end

function PnlEdit:onBtnBattleLoadArmy()
    gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", {
        fightCB = function (armys)
            local loadCount = tonumber(self.inputFieldBattleLoadArmyCount.text) or 1
            for _, army in pairs(armys) do
                for _, team in pairs(army.teams) do
                    local armyData = {soldier = GetDefaultSoldier(), isSoldier = false, hero = GetDefaultHero(), isHero = false}
                    table.insert(self.battleArmyDataList, armyData)

                    if team.heroId and team.heroId > 0 then
                        armyData.isHero = true
                        local hero = HeroData.heroDataMap[team.heroId]
                        local heroCfg = HeroUtil.getHeroCfg(hero.cfgId, hero.level, hero.quality)

                        for key, value in pairs(armyData.hero) do
                            if heroCfg[key] then
                                armyData.hero[key] = heroCfg[key]
                            end
                        end
                        armyData.hero.hp = heroCfg.maxHp

                        armyData.hero.skillCfgId1 = hero.skill1
                        armyData.hero.skillCfgId2 = hero.skill2
                        armyData.hero.skillCfgId3 = hero.skill3
                        
                        armyData.hero.skillLevel1 = hero.skillLevel1
                        armyData.hero.skillLevel2 = hero.skillLevel2
                        armyData.hero.skillLevel3 = hero.skillLevel3
                    end

                    if team.soliderCfgId and team.soliderCfgId > 0 then
                        armyData.isSoldier = true
                        local soldier = BuildData.soliderLevelData[team.soliderCfgId]

                        local soldierCfg = SoliderUtil.getSoliderCfgMap()[team.soliderCfgId][soldier.level]

                        for key, value in pairs(armyData.soldier) do
                            if soldierCfg[key] then
                                armyData.soldier[key] = soldierCfg[key]
                            end
                        end

                        armyData.soldier.hp = soldierCfg.maxHp

                        armyData.soldier.amount = team.soliderCount
                    end
                    
                    if loadCount > 1 then
                        for i = 1, loadCount - 1, 1 do
                            local copyArmyData = gg.deepcopy(armyData)
                            copyArmyData.soldier.id = GetId()
                            copyArmyData.hero.id = GetId()
                            table.insert(self.battleArmyDataList, copyArmyData)

                            --print("55555555555555555555555555")
                            --gg.printData(armyData)
                            --gg.printData(copyArmyData)
                        end
                    end
                end
            end

            self:refreshBattle()
        end,
        selectCount = 100,
    })
end

-- self:setOnClick(self.btnBattleLoadBuild, gg.bind(self.onBtnBattleLoadBuild, self))
-- self:setOnClick(self.btnBattleLoadArmy, gg.bind(self.onBtnBattleLoadArmy, self))

function PnlEdit:onBtnBattleExplore()
    local strJson = cjson.encode({armys = self.battleArmyDataList, builds = self.battleBuildingDataList})

    local path = self.inputFieldBattleExplorePath.text
    UnityEngine.PlayerPrefs.SetString(PnlEdit.EXPLORE_PATH_KEY, path)
    local jsonPath = path .. "\\battleArmyJson.json"

    local file = io.open(jsonPath, "w+")
    file:write(strJson)
    file:close()
end

function PnlEdit:onBtnBattleAtk()
    self:send2BattleServer(nil,"http://127.0.0.1:8888/calcBattleResult", self:getBattleInfoJson())
end

function PnlEdit:onBtnExploreBattleInfo()
    local jsonModel = self:getBattleInfoJson()

    local path = self.view.inputFieldExplorePath.text
    UnityEngine.PlayerPrefs.SetString(PnlEdit.EXPLORE_PATH_KEY, path)
    local jsonPath = path .. "\\battleInfoJson.json"

    local file = io.open(jsonPath, "w+")
    file:write(jsonModel)
    file:close()
end

function PnlEdit:getBattleInfoJson()
    local soldiers = {}
    local heros = {}
    local builds = {}

    for key, value in pairs(self.battleArmyDataList) do
        if value.isHero then
            table.insert(heros, value.hero)
        end

        if value.isSoldier then
            table.insert(soldiers, value.soldier)
        end
    end

    for key, value in pairs(self.battleBuildingDataList) do
        local build = value.build

        for i = 1, build.editCount, 1 do
            local data = gg.deepcopy(build)
            table.insert(builds, data)
            data.id = GetId()

            if not value.isNotSetPos then
                self:setBuildPosByIndex(#builds, data)
            end
        end
    end

    local jsonModel = GetBattleModel(builds, soldiers, heros)
    print(jsonModel)
    return jsonModel
end

local lineBuildCount = 14
local lenth = 28
function PnlEdit:setBuildPosByIndex(index, data)
    local row = math.ceil(index / lineBuildCount) - 1
    local idx = (index - 1) - row * lineBuildCount

    local interval = lenth / lineBuildCount

    data.x = idx * interval + 6 + 6
    data.z = row * interval + 6 + 6

    --print(data.x .. "  " .. data.y)
end

function PnlEdit:send2BattleServer(callback,url,data)
    local http = global:GetComponent("HttpComponent")
    local request = http:newHttpRequest(url,"post")
    request:SetRequestHeader("Content-Type","application/json")
    http:sendHttpRequest(request,data,nil)
end

-------------------------

function PnlEdit:onHide()
    self:releaseEvent()
    self.optionalTopBtnsBox:close()
end

function PnlEdit:bindEvent()
    local view = self.view
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    self:setOnClick(view.btnBattle, gg.bind(self.onBtnBattle, self))
    self:setOnClick(view.btnExplore, gg.bind(self.onBtnExplore, self))
    self:setOnClick(view.btnReadBuilding, gg.bind(self.onBtnReadBuilding, self))
    self:setOnClick(view.btnRemoveAllBuild, gg.bind(self.onBtnRemoveAllBuild, self))
    self:setOnClick(view.btnBattleJson, gg.bind(self.onBtnBattleJson, self))
    self:setOnClick(view.btnBattleJsonPath, gg.bind(self.onBtnBattleJsonPath, self))
    self:setOnClick(view.btnRecord, gg.bind(self.onBtnRecord, self))
    self:setOnClick(view.btnSetAllSoldier, gg.bind(self.onBtnSetAllSoldier, self))
    self:setOnClick(view.btnUnionSetBattleCount, gg.bind(self.onBtnUnionSetBattleCount, self))
    self:setOnClick(view.btnBattleServerJson, gg.bind(self.onBtnBattleServerJson, self))
    
    
    view.toggleBattleDetail.onValueChanged:AddListener(gg.bind(self.onBattleDetailToggleValChange, self))
end

function PnlEdit:onBattleDetailToggleValChange(isOn)
    if isOn then
        util.setDetail(1)
    else
        util.setDetail(0)
    end
end

function PnlEdit:onBtnBattle()
    -- gg.uiManager:openWindow("PnlPersonalArmy", {fightCB = function (armyId)
    --     BattleData.startPvp(BattleData.BATTLE_TYPE_SELF, gg.playerMgr.localPlayer:getPid(), armyId, self)
    -- end})

    gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", {fightCB = function (armys)
        BattleData.startPvp(BattleData.BATTLE_TYPE_SELF, gg.playerMgr.localPlayer:getPid(), armys[1].armyId, self)
    end})
end

function PnlEdit:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    view.toggleBattleDetail.onValueChanged:RemoveAllListeners()
end

function PnlEdit:onDestroy()
    local view = self.view
    self.optionalTopBtnsBox:release()
    self.buildingScrollView:release()
    self.buildScrollView:release()
    self.heroScrollView:release()
    self.landshipScrollView:release()
    self.armyScrollView:release()
    self.battleArmyScrollView:release()
end

function PnlEdit:onBtnClose()
    self:close()
end

return PnlEdit