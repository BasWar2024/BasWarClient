

PnlEditBattle = class("PnlEditBattle", ggclass.UIBase)

function PnlEditBattle:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = { }
end

PnlEditBattle.TYPE_INFO = 1
PnlEditBattle.TYPE_SOLDIER = 2
PnlEditBattle.TYPE_HERO = 3
PnlEditBattle.TYPE_BUILDING = 4
PnlEditBattle.TYPE_SOMMON_SOLDIER = 5

function PnlEditBattle:onAwake()
    self.view = ggclass.PnlEditBattleView.new(self.pnlTransform)
    self.optionalTopBtnsBox = OptionalTopBtnsBox.new(self.view.optionalTopBtnsBox)

    local view = self.view

    self.typeInfo = {
        [PnlEditBattle.TYPE_INFO] = {
            layout = view.layoutInfo,
            func = gg.bind(self.refreshInfo, self),
        },
        [PnlEditBattle.TYPE_SOLDIER] = {
            layout = view.layoutSoldier,
            func = gg.bind(self.refreshSoldier, self),
        },
        [PnlEditBattle.TYPE_HERO] = {
            layout = view.layoutHero,
            func = gg.bind(self.refreshHero, self),
        },
        [PnlEditBattle.TYPE_BUILDING] = {
            layout = view.layoutBuilding,
            func = gg.bind(self.refreshBuilding, self),
        },

        [PnlEditBattle.TYPE_SOMMON_SOLDIER] = {
            layout = view.layoutSommonSoldier,
            func = gg.bind(self.refreshSommonSoldier, self),
        },
    }


    self.optionalTopBtnsBox:setBtnDataList({
        [1] = {
            name = "info",
            callback = gg.bind(self.refresh, self, PnlEditBattle.TYPE_INFO)
        },
        [2] = {
            name = "soldier",
            callback = gg.bind(self.refresh, self, PnlEditBattle.TYPE_SOLDIER)
        },
        [3] = {
            name = "hero",
            callback = gg.bind(self.refresh, self, PnlEditBattle.TYPE_HERO)
        },
        [4] = {
            name = "building",
            callback = gg.bind(self.refresh, self, PnlEditBattle.TYPE_BUILDING)
        },
        [5] = {
            name = "sommon Soldier",
            callback = gg.bind(self.refresh, self, PnlEditBattle.TYPE_SOMMON_SOLDIER)
        },
    })

    -- soldier
    self.soldierItemList = {}
    self.soldierScrollView = UIScrollView.new(view.soldierScrollView, "EditBattleSoldierItem", self.soldierItemList)
    self.soldierScrollView:setRenderHandler(gg.bind(self.onRenderSoldier, self))

    -- hero
    self.heroItemList = {}
    self.heroScrollView = UIScrollView.new(view.heroScrollView, "EditBattleHeroItem", self.heroItemList)
    self.heroScrollView:setRenderHandler(gg.bind(self.onRenderHero, self))

    -- building
    self.buildingItemList = {}
    self.buildingScrollView = UIScrollView.new(view.buildingScrollView, "EditBattleHeroItem", self.buildingItemList)
    self.buildingScrollView:setRenderHandler(gg.bind(self.onRenderBuilding, self))

    -- sommon soldier
    self.sommonSoldierItemList = {}
    self.sommomSoldierScrollView = UIScrollView.new(view.sommomSoldierScrollView, "EditBattleSoldierItem", self.sommonSoldierItemList)
    self.sommomSoldierScrollView:setRenderHandler(gg.bind(self.onRenderSommonSoldier, self))
end

function PnlEditBattle:onShow()
    self:bindEvent()

    self.optionalTopBtnsBox:open()
    self.showType = self.showType or PnlEditBattle.TYPE_INFO
    self.optionalTopBtnsBox:onBtn(self.showType)

    self.view.toggleShowSkillRange.isOn = CS.EditModel.EditBattleTools.IsShowSkillRange
    self.view.toggleTowerAtkRange.isOn = CS.EditModel.EditBattleTools.IsTowerAtkRange
    self.view.toggleShowHp.isOn = CS.EditModel.EditBattleTools.IsShowHp
    self.view.toggleShowHpChange.isOn = CS.EditModel.EditBattleTools.IsShowHpChange
end

function PnlEditBattle:refresh(showType)
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

function PnlEditBattle:refreshInfo()
    self.view.inputFieldExplorePath.text = UnityEngine.PlayerPrefs.GetString(PnlEdit.EXPLORE_PATH_KEY)

    self.view.toggleShowSkillRange.isOn = CS.EditModel.EditBattleTools.IsShowSkillRange
    self.view.toggleTowerAtkRange.isOn = CS.EditModel.EditBattleTools.IsTowerAtkRange
end

function PnlEditBattle:onBtnExplore()
    local strJson = CS.EditModel.EditBattleTools.GetInitBattleModelJson()

    local path = self.view.inputFieldExplorePath.text
    UnityEngine.PlayerPrefs.SetString(PnlEdit.EXPLORE_PATH_KEY, path)
    local jsonPath = path .. "\\BattleModelJson.json"
    local file = io.open(jsonPath, "w+")
    file:write(strJson)
    file:close()
end

function PnlEditBattle:onToggleShowSkillRange(isOn)
    CS.EditModel.EditBattleTools.IsShowSkillRange = isOn
end

function PnlEditBattle:onToggleTowerAtkRange(isOn)
    CS.EditModel.EditBattleTools.IsTowerAtkRange = isOn
end

function PnlEditBattle:onToggleShowHp(isOn)
    CS.EditModel.EditBattleTools.IsShowHp = isOn
end

function PnlEditBattle:onToggleShowHpChange(isOn)
    CS.EditModel.EditBattleTools.IsShowHpChange = isOn
end

-- soldier
function PnlEditBattle:refreshSoldier()
    self.soldierDataList = CS.NewGameData._InitBattleModel.soliders
    if self.soldierDataList then
        self.soldierScrollView:setItemCount(self.soldierDataList.Count)
    else
        self.soldierScrollView:setItemCount(0)
    end
end

function PnlEditBattle:onRenderSoldier(obj, index)
    local item = EditBattleSoldierItem:getItem(obj, self.soldierItemList, self)
    item:setData(self.soldierDataList[index - 1])
end

-- hero
function PnlEditBattle:refreshHero()
    self.heroDataList = CS.NewGameData._InitBattleModel.heros
    if self.heroDataList then
        self.heroScrollView:setItemCount(self.heroDataList.Count)
    else
        self.heroScrollView:setItemCount(0)
    end
end

function PnlEditBattle:onRenderHero(obj, index)
    local item = EditBattleHeroItem:getItem(obj, self.heroItemList, self)
    item:setData(self.heroDataList[index - 1])
end

-- building
function PnlEditBattle:refreshBuilding()
    self.buildDataList = CS.NewGameData._InitBattleModel.builds
    self.buildingScrollView:setItemCount(self.buildDataList.Count)
end

function PnlEditBattle:onRenderBuilding(obj, index)
    local item = EditBattleBuildingItem:getItem(obj, self.buildingItemList, self)
    item:setData(self.buildDataList[index - 1])
end

-- SommonSoldier
function PnlEditBattle:refreshSommonSoldier()
    self.sommonSoldierDataList = CS.NewGameData._InitBattleModel.summonSoliders
    if  self.sommonSoldierDataList then
        self.sommomSoldierScrollView:setItemCount(self.sommonSoldierDataList.Count)
    else
        self.sommomSoldierScrollView:setItemCount(0)
    end
end

function PnlEditBattle:onRenderSommonSoldier(obj, index)
    local item = EditBattleSoldierItem:getItem(obj, self.sommonSoldierItemList, self)
    item:setData(self.sommonSoldierDataList[index - 1])
end

--------------------------------------

function PnlEditBattle:onHide()
    self:releaseEvent()
    self.optionalTopBtnsBox:close()

end

function PnlEditBattle:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    self:setOnClick(view.btnExplore, gg.bind(self.onBtnExplore, self))

    view.toggleShowSkillRange.onValueChanged:AddListener(gg.bind(self.onToggleShowSkillRange, self))
    view.toggleTowerAtkRange.onValueChanged:AddListener(gg.bind(self.onToggleTowerAtkRange, self))
    view.toggleShowHp.onValueChanged:AddListener(gg.bind(self.onToggleShowHp, self))
    view.toggleShowHpChange.onValueChanged:AddListener(gg.bind(self.onToggleShowHpChange, self))
    
end

function PnlEditBattle:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    view.toggleShowSkillRange.onValueChanged:RemoveAllListeners()
    view.toggleTowerAtkRange.onValueChanged:RemoveAllListeners()
    view.toggleShowHp.onValueChanged:RemoveAllListeners()
    view.toggleShowHpChange.onValueChanged:RemoveAllListeners()
end

function PnlEditBattle:onDestroy()
    local view = self.view
    self.optionalTopBtnsBox:release()
    self.soldierScrollView:release()
end

function PnlEditBattle:onBtnClose()
    self:close()
end

function PnlEditBattle:onBtn()

end

return PnlEditBattle