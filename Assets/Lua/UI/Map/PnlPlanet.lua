PnlPlanet = class("PnlPlanet", ggclass.UIBase)

PnlPlanet.infomationType = ggclass.UIBase.INFOMATION_NORMAL


function PnlPlanet:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onShowUnionBag", "onShowBuild", "onShowGvgResult", "onPnlGvgResultBtnConFirm", "onAddOtherBuild", "onRemoveOtherBuilding"}
end

function PnlPlanet:onAwake()
    self.view = ggclass.PnlPlanetView.new(self.transform)

    self.soldierItemList = {}
    self.soldierScrollView = UIScrollView.new(self.view.soldierScrollView, "PlanetSoliderItem", self.soldierItemList)
    self.soldierScrollView:setRenderHandler(gg.bind(self.onRenderSoldier, self))
end

PnlPlanet.TYPE_RETURN_MAIN = 1
PnlPlanet.TYPE_RETURN_MAP = 2

PnlPlanet.TYPE_SHOW_BATTLE = 1
PnlPlanet.TYPE_SHOW_VISIT = 2
PnlPlanet.TYPE_SHOW_PLANET = 3

PnlPlanet.TYPE_BATTLE_PVE = 1
PnlPlanet.TYPE_BATTLE_GVG = 2

-- args = {showType = , data = , returnOpenWindow = {name = , args = , type}, battleInfo = {type, func, unionAtkFunc}}
function PnlPlanet:onShow()
    self:bindEvent()
    self.showType = self.args.showType or PnlPlanet.TYPE_SHOW_VISIT

    self:initShow()

    if self.showType == PnlPlanet.TYPE_SHOW_PLANET then
        local isMyPlanet = gg.galaxyManager:isMyResPlanet()
        if isMyPlanet then
            self.view.btnBag:SetActive(true)
            --self.view.btnBuild:SetActive(true)

            if self.args.planetData then
                local belong = self.args.planetData.belong
            end

        else
            if not isMyPlanet then
                -- self.showType = PnlPlanet.TYPE_SHOW_BATTLE
                self:refreshBattle()
            end
        end
    elseif self.showType == PnlPlanet.TYPE_SHOW_BATTLE then
        self:refreshBattle()
    end

    if self.args.planetData then
        gg.event:dispatchEvent("onSetOtherPlayerInfo", true, self.args.planetData, true)
    end

end

function PnlPlanet:onAddOtherBuild(_, build)
    if self.args.planetData then
        table.insert(self.args.planetData.builds, build)
    end

end

function PnlPlanet:onRemoveOtherBuilding(_, buildId)
    if self.args.planetData then

        for i = #self.args.planetData.builds, 1, -1 do
            if self.args.planetData.builds[i].id == buildId then
                table.remove(self.args.planetData.builds, i)
            end
        end

        -- table.insert(self.args.planetData.builds, build)
    end
end



function PnlPlanet:chackStatus()
    local planetData = self.args.planetData
    if planetData then
        if planetData.status == 1 then
            return true
        else
            return false
        end
    else
        return false
    end
end

function PnlPlanet:initShow()
    local view = self.view
    view.btnBag:SetActive(false)
    --view.btnBuild:SetActive(false)

    view.layoutBattle:SetActiveEx(false)

    self:setBooty()
    view.layoutRes:SetActiveEx(false)
end

function PnlPlanet:setBooty()
    if self.args.planetData then
        self.view.layoutRes:SetActiveEx(true)
        self:setResData({
            [constant.RES_CARBOXYL] = {
                count = self.args.planetData.carboxyl
            }
        }, self.args.planetData.carboxyl)
    end
end

-- resData = {[resCfgId] = {count}}
function PnlPlanet:setResData(resMap, integralCount)
    local view = self.view
    for key, value in pairs(view.resMap) do
        local info = resMap[key]
        if info then
            value.item:SetActiveEx(true)
            value.TxtCount.text = Utils.getShowRes(info.count)
        else
            value.item:SetActiveEx(false)
            value.TxtCount.text = 0
        end
    end

    if integralCount ~= nil then
        view.integralItem:SetActiveEx(true)
        view.txtIntegral.text = integralCount
    else
        view.integralItem:SetActiveEx(false)
    end
end

function PnlPlanet:refreshBattle()
    local view = self.view
    -- view.layoutBattle:SetActiveEx(false)
    view.layoutBattle:SetActiveEx(true)

    view.btnAttack:SetActiveEx(false)
    view.btnUnionAttack:SetActiveEx(false)

    if self.args.battleInfo.func then
        view.btnAttack:SetActiveEx(true)
    end

    -- if self.args.battleInfo.unionAtkFunc then
    --     view.btnUnionAttack:SetActiveEx(true)
    -- end

    ---- view.btnAttack:SetActiveEx(true)
    ---- view.imgBtnGray.transform:SetActiveEx(not self.args.data.canAttack)

    -- view.imgBtnGray.transform:SetActiveEx(false)

    -- self.soldierDataList = {}
    -- for key, value in pairs(BuildData.shipExistSoliderData) do
    --     if value.soliderCfgId and value.soliderCfgId > 0 then
    --         table.insert(self.soldierDataList, value)
    --     end
    -- end

    -- table.sort(self.soldierDataList, function(a, b)
    --     local posA = a.pos
    --     local PosB = b.pos
    --     if posA.z ~= PosB.z then
    --         return posA.z > PosB.z
    --     else
    --         return posA.x < PosB.x
    --     end
    -- end)

    -- local dataCount = #self.soldierDataList
    -- if dataCount > 8 then
    --     for i = dataCount, 9, -1 do
    --         table.remove(self.soldierDataList, i)
    --     end
    -- end

    -- local itemCount = #self.soldierDataList
    -- self.soldierScrollView:setItemCount(itemCount)

    -- local resInfo = {}
    -- if self.args.data then
    --     resInfo = self.args.data.resInfo
    -- elseif self.args.planetData then
    --     resInfo = self.args.planetData.currencies
    -- end

    -- local resInfoMap = {}
    -- if resInfo then
    --     for key, value in pairs(resInfo) do
    --         resInfoMap[value.resCfgId] = value
    --     end
    -- end

    -- view.layoutRes:SetActiveEx(true)
    -- self:setResData(resInfoMap)

    -- if HeroData.ChooseingHero and next(HeroData.ChooseingHero) then
    --     local heroData = HeroData.ChooseingHero
    --     view.heroItem:SetActiveEx(true)

    --     local soliderW = 140
    --     local spancing = 5
    --     local soliderLenth = (soliderW + spancing) * itemCount - spancing
    --     self.soldierScrollView.transform:SetRectSizeX(math.min(1221, soliderLenth))
    --     view.heroItem.transform.anchoredPosition = CS.UnityEngine.Vector2(soliderLenth + 15,
    --         view.heroItem.transform.anchoredPosition.y)

    --     local heroCfg = HeroUtil.getHeroCfg(heroData.cfgId, heroData.level, heroData.quality)
    --     local skillCfg = HeroUtil.getSkillMap()[heroData["skill" .. heroData.selectSkill]][heroData["skillLevel" ..
    --                          heroData.selectSkill]]

    --     view.heroCommonItemItem:setQuality(heroCfg.quality)
    --     local iconH = gg.getSpriteAtlasName("Hero_A_Atlas", heroCfg.icon .. "_A")
    --     view.heroCommonItemItem:setIcon(iconH)
    --     view.skillCommonItemItem:setQuality(skillCfg.quality)
    --     local iconS = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")
    --     view.skillCommonItemItem:setIcon(iconS)
    -- else
    --     view.heroItem:SetActiveEx(false)
    -- end
end

function PnlPlanet:onHide()
    self:releaseEvent()
end

function PnlPlanet:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)
    CS.UIEventHandler.Get(view.btnBag):SetOnClick(function()
        self:onBtnBag()
    end)
    -- CS.UIEventHandler.Get(view.btnBuild):SetOnClick(function()
    --     self:onBtnBuild()
    -- end)

    -- CS.UIEventHandler.Get(view.btnPack):SetOnClick(function()
    --     self:onBtnPack()
    -- end)

    self:setOnClick(view.btnAttack, gg.bind(self.onBtnAttack, self))
    self:setOnClick(view.btnUnionAttack, gg.bind(self.onBtnUnionAttack, self))
end

function PnlPlanet:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnReturn)
    CS.UIEventHandler.Clear(view.btnBag)
    --CS.UIEventHandler.Clear(view.btnBuild)

end

function PnlPlanet:onDestroy()
    local view = self.view
    self.soldierScrollView:release()
    view.heroCommonItemItem:release()
    view.skillCommonItemItem:release()
end

function PnlPlanet:onRenderSoldier(obj, index)
    local item = PlanetSoldierItem:getItem(obj, self.soldierItemList)
    item:setData(self.soldierDataList[index])
end

function PnlPlanet:onBtnReturn()
    local callback = function()
        if self.args.returnOpenWindow then
            gg.uiManager:openWindow(self.args.returnOpenWindow.name, self.args.returnOpenWindow.args)
        end
    end
    gg.buildingManager:cancelBuildOrMove()

    gg.event:dispatchEvent("onSetOtherPlayerInfo", false, self.args.data)

    gg.buildingManager:destroyOtherBuilding()
    gg.sceneManager:returnFormPlanet(callback)
    gg.galaxyManager:resetPlayerId()

    self:close()
end

function PnlPlanet:onBtnBag()
    local belong = self.args.planetData.belong
    if belong ~= 1 then
        self:onBtnUnionBag()
        return
    end

    local args = {
        bagBelong = PnlGridNftBag.BAGBELONG_MYPLANET,
        planetData = self.args.planetData,
    }
    gg.uiManager:openWindow("PnlGridNftBag", args)
    gg.buildingManager:cancelBuildOrMove()
end

-- function PnlPlanet:onBtnBuild()
--     UnionData.C2S_Player_QueryUnionBuilds()
--     gg.buildingManager:cancelBuildOrMove()
-- end

function PnlPlanet:onShowBuild()
    local belong = PnlGridItemBag.BAGBELONG_MYBUILD
    if self.args.planetData.belong ~= 1 then
        belong = PnlGridItemBag.BAGBELONG_UNINONBUILD
    end
    local args = {
        bagBelong = belong,
        planetData = self.args.planetData,
    }
    gg.uiManager:openWindow("PnlGridItemBag", args)
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlanet:onBtnUnionBag()
    UnionData.C2S_Player_QueryUnionNfts()
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlanet:onShowUnionBag()
    local belong = self.args.planetData.belong
    if belong ~= 2 then
        return
    end

    local args = {
        bagBelong = PnlGridNftBag.BAGBELONG_UNINON,
        planetData = self.args.planetData,
    }
    gg.uiManager:openWindow("PnlGridNftBag", args)
    gg.buildingManager:cancelBuildOrMove()
end

-- function PnlPlanet:onBtnPack()
--     local name = self.args.planetData.planetName
--     local index = self.args.planetData.index
--     local txt = string.format("Do you need to pack %s stars? Your defense tower willbe transported to the base.", name)
--     local callbackYes = function()
--         ResPlanetData.C2S_Player_ResPlanet2ItemBag(index)
--     end

--     local args = {
--         txt = txt,
--         callbackYes = callbackYes
--     }

--     gg.uiManager:openWindow("PnlAlert", args)
--     gg.buildingManager:cancelBuildOrMove()
-- end
function PnlPlanet:onShowGvgResult(_, data)
    gg.uiManager:openWindow("PnlGvgResult", data)
end

function PnlPlanet:onPnlGvgResultBtnConFirm()
    self:onBtnReturn()
end

function PnlPlanet:onBtnAttack()
    gg.buildingManager:cancelBuildOrMove()

    if self.args.battleInfo then
        self.args.battleInfo.func()
    end
end

function PnlPlanet:onBtnUnionAttack()
    gg.buildingManager:cancelBuildOrMove()

    if self.args.battleInfo then
        self.args.battleInfo.unionAtkFunc()
    end
end

return PnlPlanet
