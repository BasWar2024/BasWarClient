GalaxyManager = class("GalaxyManager")

function GalaxyManager:ctor()
    self.curPlanet = nil -- ""
    self.curPlanetPlayerId = nil -- ""id

    self.productionRes = {
        [constant.RES_STARCOIN] = 0,
        [constant.RES_ICE] = 0,
        [constant.RES_CARBOXYL] = 0,
        [constant.RES_TITANIUM] = 0,
        [constant.RES_GAS] = 0
    }

    self.onLookMembers = {}
    self.showCfgId = false
    gg.event:addListener("onJumpGalaxyGrid", self)
    gg.event:addListener("onChatHyperLink2Grid", self)
    gg.event:addListener("onAskToJumpGalaxyGrid", self)
    self:preLoadGalaxyCfg()
end

function GalaxyManager:loadGalaxy()
    if self.galaxyMap then
        self.galaxyMap:onShow(true)
    else
        self.galaxyMap = ggclass.GalaxyMap.new()
    end
end

function GalaxyManager:unLoadGalaxy()
    if self.galaxyMap then
        -- GalaxyData.C2S_Player_LeaveStarmap()
        self.galaxyMap:onHide(function()
            self.galaxyMap = nil
        end)
    end
    self.onLookMembers = nil
end

function GalaxyManager:destroyGalaxy()
    GalaxyData.C2S_Player_LeaveStarmap()
    if self.galaxyMap then
        self.galaxyMap:onHide()
        self.galaxyMap:onDestroy()
        self.galaxyMap = nil
    end
    self.onLookMembers = nil
    self.onLookcfgIds = nil

end

function GalaxyManager:returnGalaxy()
    self.curPlanet = nil
    self:loadGalaxy()
end

-- ""
function GalaxyManager:onLookResPlanetData()
    self.curPlanetPlayerId = GalaxyData.resPlanetData.holdPlayerId
    self.curPlanet = {}
    self.curPlanet = GalaxyData.resPlanetData

    local cfgId = GalaxyData.resPlanetData.cfgId
    local curCfg = self:getGalaxyCfg(cfgId)
    if #GalaxyData.resPlanetData.builds == 0 then
        local presetLayoutId = curCfg.presetLayoutId
        local presetLayoutCfg = cfg.getCfg("presetBuildLayout", presetLayoutId)
        local id = 1
        GalaxyData.resPlanetData.sceneId = presetLayoutCfg.sceneId
        for k, v in pairs(presetLayoutCfg.presetBuilds) do
            local data = {
                cfgId = v.cfgId,
                level = v.level,
                curLife = v.life,
                life = v.life,
                quality = v.quality,
                pos = {
                    x = v.x,
                    y = 0,
                    z = v.z
                },
                id = id,
                curStarCoin = 0,
                curIce = 0,
                curGas = 0,
                curTitanium = 0,
                curCarboxyl = 0,
                soliderCfgId = 0,
                soliderCount = 0,
                lessTick = 0,
                lessTrainTick = 0,
                repairLessTick = 0,
                trainCfgId = 0,
                trainCount = 0,
                refBy = 0,
                chain = 0,
                lessTickEnd = 0
            }

            id = id + 1
            table.insert(GalaxyData.resPlanetData.builds, data)
        end
    end
    gg.buildingManager:initOtherBase(GalaxyData.resPlanetData.builds)

    -- gg.printData()
    local personalAtkFunc = function()
        local signPosId = 3
        gg.uiManager:openWindow("PnlPersonalQuickSelectArmy", {
            fightCB = function(armys)
                local battleArmys = {}
                for key, value in pairs(armys) do
                    local battleArmy = PersonalArmyUtils.personalArmy2BattleArmy(value.armyId)
                    if battleArmy then
                        table.insert(battleArmys, battleArmy)
                    end
                end

                BattleData.StartUnionBattle(BattleData.ARMY_TYPE_SELF, GalaxyData.resPlanetData.cfgId, battleArmys,
                    signPosId, CS.Appconst.BattleVersion, UnionUtil.getUnionBattleOperate(signPosId), nil)
            end,
            selectCount = 5,
            isEnableUnionMode = true,
            isGVG = true
        })
    end

    local battleInfo = {
        func = personalAtkFunc
    }

    if curCfg.belongType == 1 then
        battleInfo.unionAtkFunc = gg.bind(UnionUtil.unionAtk, GalaxyData.resPlanetData.cfgId)
    end

    local viewArgs = {
        planetData = GalaxyData.resPlanetData,
        showType = ggclass.PnlPlanet.TYPE_SHOW_PLANET,
        -- returnOpenWindow = returnOpenWindow
        battleInfo = battleInfo
    }
    gg.sceneManager:enterPlanetScene(viewArgs, GalaxyData.resPlanetData.sceneId)

end

-- ""
function GalaxyManager:onLookOtherBase(data, holdPlayerId, builds, PnlPlanetShowType, returnOpenWindow, battleInfo)
    gg.uiManager:openWindow("PnlLoading", nil, function()
        gg.uiManager:closeWindow("PnlUnion")
        self.curPlanetPlayerId = holdPlayerId
        gg.buildingManager:initOtherBase(builds)

        local viewArgs = {
            data = data,
            showType = PnlPlanetShowType,
            returnOpenWindow = returnOpenWindow,
            battleInfo = battleInfo
        }

        gg.sceneManager:enterPlanetScene(viewArgs, data.sceneId)
        self.curPlanet = nil
    end)
end

function GalaxyManager:isMyResPlanet()
    if not self.curPlanet then
        self.curPlanet = {}
    end
    -- print("aaaa2222      ", self.curPlanetPlayerId, self.curPlanet.belong, self.curPlanet.belong)
    if gg.client.loginServer.currentRole.roleid == self.curPlanetPlayerId or self.curPlanet.belong == 1 or
        self.curPlanet.belong == 2 then
        return true
    else
        return false
    end
end

function GalaxyManager:resetPlayerId()
    self.curPlanetPlayerId = gg.client.loginServer.currentRole.roleid
end

GalaxyManager.INIT_GRID_ID = 11000000

function GalaxyManager:getAreaMembers(point, isFirstEnter)
    local members = {}
    local r = 6
    self.onLookMembers = {}
    self.onLookConten = point
    self.onLookContenCfgId = self:pos2CfgId(point.x, point.y)
    for y = 0, r, 1 do
        local max = r - y
        for x = -r, max, 1 do
            local cfgId = self:pos2CfgId(point.x + x, point.y + y)
            local curCfg = self:getGalaxyCfg(cfgId)
            table.insert(members, cfgId)

            if curCfg then
                table.insert(self.onLookMembers, curCfg)
            else
                curCfg = {}
                for k, v in pairs(self:getGalaxyCfg(GalaxyManager.INIT_GRID_ID)) do
                    curCfg[k] = v
                end
                curCfg.cfgId = cfgId
                curCfg.type = -1
                table.insert(self.onLookMembers, curCfg)
            end
        end
        if y ~= -y then
            local min = y - r
            local newY = -y
            for x = min, r, 1 do
                local cfgId = self:pos2CfgId(point.x + x, point.y + newY)
                local curCfg = self:getGalaxyCfg(cfgId)
                table.insert(members, cfgId)

                if curCfg then
                    table.insert(self.onLookMembers, curCfg)
                else
                    curCfg = {}
                    for k, v in pairs(self:getGalaxyCfg(GalaxyManager.INIT_GRID_ID)) do
                        curCfg[k] = v
                    end
                    curCfg.cfgId = cfgId
                    curCfg.type = -1
                    table.insert(self.onLookMembers, curCfg)
                end
            end
        end
    end
    if isFirstEnter then
        self.onLookcfgIds = members
    else
        self.onLookcfgIds = nil
    end
    return members
end

function GalaxyManager:getOnLookcfgIds()
    return self.onLookcfgIds
end

function GalaxyManager:preLoadGalaxyCfg()
    for i = 0, 3, 1 do
        local cfgName = "starmap"
        if i > 0 then
            cfgName = cfgName .. i
        end
        local curCfg = cfg[cfgName]
    end

end

function GalaxyManager:getGalaxyCfg(cfgId)
    local data = nil
    for i = 0, 3, 1 do
        local cfgName = "starmap"
        if i > 0 then
            cfgName = cfgName .. i
        end
        data = cfg[cfgName][cfgId]
        if data then
            break
        end
    end
    return data
end

function GalaxyManager:getOnLookContenCfg()
    return self:getGalaxyCfg(self.onLookContenCfgId)
end

function GalaxyManager:pos2CfgId(x, y)
    x = x or 0
    y = y or 0
    local baseNum = 11000000
    if x < 0 then
        baseNum = baseNum + 10000000
    end
    if y < 0 then
        baseNum = baseNum + 1000000
    end
    baseNum = baseNum + math.abs(x) * 1000
    baseNum = baseNum + math.abs(y)

    return baseNum
end

function GalaxyManager:onJumpGalaxyGrid(args, endCfg, isShowInfo)
    if self.galaxyMap then
        self.galaxyMap:onJumpGalaxyGrid(endCfg)
    else
        gg.uiManager:openWindow("PnlLoading")
        self.isShowEnterResPlanet = isShowInfo
        self.isShowEnterResPlanetCfgId = endCfg.cfgId
        GalaxyData.C2S_Player_EnterStarmap(self:getAreaMembers(Vector2.New(endCfg.pos.x, endCfg.pos.y)))
    end
end

function GalaxyManager:onChatHyperLink2Grid(agrs, data)
    gg.uiManager:closeWindow("PnlChat")

    local msg = data.text
    local temp1, xStartPos = string.find(msg, "x:")
    xStartPos = xStartPos + 1
    local xEndPos, yStartPos = string.find(msg, " y:")
    xEndPos = xEndPos - 1
    yStartPos = yStartPos + 1
    local yEndPos, temp2 = string.find(msg, ")")
    yEndPos = yEndPos - 1
    local x = string.sub(msg, xStartPos, xEndPos)
    local y = string.sub(msg, yStartPos, yEndPos)
    x = tonumber(x)
    y = tonumber(y)
    if not x or not y then
        gg.uiManager:showTip(Utils.getText("universal_InvalidCoords"))
        return
    end

    local cfgId = self:pos2CfgId(x, y)
    self:askToJumpGalaxyGrid(cfgId)

end

function GalaxyManager:askToJumpGalaxyGrid(cfgId, callback)
    local curCfg = self:getGalaxyCfg(cfgId)
    if not curCfg then
        gg.uiManager:showTip(Utils.getText("universal_InvalidCoords"))
        return
    end

    local callbackYes = function()
        self:onJumpGalaxyGrid(nil, curCfg, true)
        if callback then
            callback()
        end
    end

    local txtTitel = Utils.getText("universal_Ask_Title")
    local txtTips = string.format(Utils.getText("universal_JumpPlot_Ask_Txt"), curCfg.name)

    local txtNo = Utils.getText("universal_Ask_BackButton")
    local txtYes = Utils.getText("universal_ConfirmButton")

    local args = {
        txtTitel = txtTitel,
        txtTips = txtTips,
        txtYes = txtYes,
        callbackYes = callbackYes,
        txtNo = txtNo
    }
    gg.uiManager:openWindow("PnlAlertNew", args)
end

function GalaxyManager:onAskToJumpGalaxyGrid(args, cfgId, callback)
    self:askToJumpGalaxyGrid(cfgId, callback)
end

function GalaxyManager:isSpecialGround(cfgId)
    local chain = 0
    if GalaxyData.specialGround[cfgId] then
        chain = GalaxyData.specialGround[cfgId]
    end
    return chain
end


return GalaxyManager
