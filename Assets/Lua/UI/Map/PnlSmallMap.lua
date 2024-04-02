PnlSmallMap = class("PnlSmallMap", ggclass.UIBase)

PnlSmallMap.TYPE_LV1 = 1
PnlSmallMap.TYPE_LV2 = 2
PnlSmallMap.TYPE_LV3 = 3
PnlSmallMap.TYPE_LV4 = 4
PnlSmallMap.TYPE_LV5 = 5
PnlSmallMap.TYPE_LV6 = 6
PnlSmallMap.TYPE_LV7 = 7

PnlSmallMap.TYPE_DAO = 8
PnlSmallMap.TYPE_MY = 9

function PnlSmallMap:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onLoadMaskBoxGrids"}
end

function PnlSmallMap:onAwake()
    self.view = ggclass.PnlSmallMapView.new(self.pnlTransform)
    self.galaxyRadius = 50
    self.chainContenCfgId = {}
    local chainCfg = cfg.chain
    for k, v in pairs(cfg.chain) do
        if v.isOpen == 1 then
            self.chainContenCfgId[v.id] = gg.galaxyManager:pos2CfgId(v.centerPos.x, v.centerPos.y)
        end
    end

    local cfgIds = {}

    for i, v in pairs(self.chainContenCfgId) do
        cfgIds[i] = self:calcCfgId(v)

        -- table.insert(cfgIds, self:calcCfgId(v))
    end

    self.allMapPos = {}
    for i, v in pairs(cfgIds) do
        local worldPos = {}
        for k, id in ipairs(v) do
            table.insert(worldPos, gg.galaxyManager:getGalaxyCfg(id).worldPos)
        end
        self.allMapPos[i] = worldPos
        -- table.insert(self.allMapPos, worldPos)
    end
end

function PnlSmallMap:calcCfgId(contenCfgId)
    local r = self.galaxyRadius
    local cfgIds = {}
    cfgIds[1] = contenCfgId
    local contenCfg = gg.galaxyManager:getGalaxyCfg(contenCfgId)
    cfgIds[2] = gg.galaxyManager:pos2CfgId(contenCfg.pos.x - r, contenCfg.pos.y)
    cfgIds[3] = gg.galaxyManager:pos2CfgId(contenCfg.pos.x + r, contenCfg.pos.y)
    cfgIds[4] = gg.galaxyManager:pos2CfgId(contenCfg.pos.x - r / 2, contenCfg.pos.y + r)
    cfgIds[5] = gg.galaxyManager:pos2CfgId(contenCfg.pos.x + r / 2, contenCfg.pos.y - r)

    return cfgIds
end

function PnlSmallMap:onShow()
    self.chainID = gg.galaxyManager:getOnLookContenCfg().chainID
    self.mapPos = self.allMapPos[self.chainID]
    self.starList = {}
    self.lvBoxGrids = {}
    self.selGridCfgId = self.chainContenCfgId[self.chainID]
    self.contenPos = gg.galaxyManager:getGalaxyCfg(self.chainContenCfgId[self.chainID]).pos
    self:bindEvent()
    self:loadStarBoxGrids()
    self:resetView()
    if UnionData.beginGridId ~= 0 then
        local x, y = self:calaStarDis(UnionData.beginGridId)
        self.view.initGrid.transform.localPosition = Vector3(x, y, 0)
        self.view.initGrid:SetActiveEx(true)
    else
        self.view.initGrid:SetActiveEx(false)
    end
end

function PnlSmallMap:resetView()
    self.view.boxGridData:SetActiveEx(false)
    -- self.view.gridPosMsg:SetActiveEx(false)
    self.view.btnGo:SetActiveEx(true)
    self.view.selGrid:SetActiveEx(false)
    self.view.txtPosX.text = self.contenPos.x
    self.view.txtPosY.text = self.contenPos.y
end

function PnlSmallMap:onHide()
    self:releaseEvent()
    self:releaseBoxGrids()
    self.starContentWidth = nil
    self.markContentWidth = nil
    GalaxyData.StarmapMinimap = nil
    self.unionFavList = nil
    self.myFavList = nil

end

function PnlSmallMap:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnStar):SetOnClick(function()
        self:onBtnStar()
    end)
    CS.UIEventHandler.Get(view.btnMark):SetOnClick(function()
        self:onBtnMark()
    end)
    CS.UIEventHandler.Get(view.btnGo):SetOnClick(function()
        self:onBtnGo()
    end)

    view.txtPosX.onValueChanged:AddListener(gg.bind(self.onValueChanged, self))
    view.txtPosY.onValueChanged:AddListener(gg.bind(self.onValueChanged, self))

end

function PnlSmallMap:onValueChanged()
    local view = self.view
    view.txtX.text = view.txtPosX.text
    view.txtY.text = view.txtPosY.text
    local x = tonumber(view.txtPosX.text)
    local y = tonumber(view.txtPosY.text)
    if not x or not y then
        self:posError()
        return
    end

    x = x or 0
    y = y or 0
    if x > 999 or y > 999 or x < -999 or y < -999 then
        self:posError()
        return
    end
    local cfgId = gg.galaxyManager:pos2CfgId(x, y)
    self:setSelGrid(cfgId)
end

function PnlSmallMap:posError()
    gg.uiManager:showTip(Utils.getText("universal_InvalidCoords"))
    self.view.btnGo:SetActiveEx(false)
end

function PnlSmallMap:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnStar)
    CS.UIEventHandler.Clear(view.btnMark)
    CS.UIEventHandler.Clear(view.btnGo)

end

function PnlSmallMap:onDestroy()
    local view = self.view
    self.mapPos = nil
end

function PnlSmallMap:onBtnClose()
    self:close()
end

function PnlSmallMap:onBtnStar()
    self:resetView()
    if self.starContentWidth and #self.lvBoxGrids > 0 then
        self.view.content.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(
            self.starContentWidth, 0)
        for i, v in ipairs(self.lvBoxGrids) do
            v:SetActiveEx(true)
        end
        for k, v in pairs(self.lvToggleGrids) do
            v.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
        end

        if self.daoBoxGrids then
            self.daoBoxGrids:SetActiveEx(false)
        end
        if self.myBoxGrids then
            self.myBoxGrids:SetActiveEx(false)
        end
    end
end

function PnlSmallMap:onBtnMark()
    self:resetView()
    if self.markContentWidth then
        self.view.content.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(
            self.markContentWidth, 0)
        if self.daoBoxGrids then
            self.daoBoxGrids:SetActiveEx(true)
        end
        if self.myBoxGrids then
            self.myBoxGrids:SetActiveEx(true)
        end

        for k, v in pairs(self.daoMarkToggleGrids) do
            v.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
        end
        for k, v in pairs(self.myMarkToggleGrids) do
            v.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
        end

        if self.lvBoxGrids then
            for i, v in ipairs(self.lvBoxGrids) do
                v:SetActiveEx(false)
            end
        end
    else
        GalaxyData.C2S_Player_GetMyFavoriteGridList()
    end
end

function PnlSmallMap:onBtnGo()
    local starCfg = gg.galaxyManager:getGalaxyCfg(self.selGridCfgId)
    gg.event:dispatchEvent("onJumpGalaxyGrid", starCfg, true)
    self:close()
end

function PnlSmallMap:onToggleGrid(cfgId, type)
    local list = {}
    local datas = {}
    if type <= PnlSmallMap.TYPE_LV7 then
        list = self.lvToggleGrids
        datas = GalaxyData.StarmapMinimap
    elseif type == PnlSmallMap.TYPE_DAO then
        list = self.daoMarkToggleGrids
        datas = self.unionFavList
        for k, v in pairs(self.myMarkToggleGrids) do
            v.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
        end
    elseif type == PnlSmallMap.TYPE_MY then
        list = self.myMarkToggleGrids
        datas = self.myFavList
        for k, v in pairs(self.daoMarkToggleGrids) do
            v.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
        end
    end

    for k, v in pairs(list) do
        v.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
    end
    if list[cfgId] then
        list[cfgId].transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = true
    end

    local starCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
    local view = self.view
    local resIconName = nil
    if starCfg.type == 3 then
        resIconName = gg.getSpriteAtlasName("ResIcon_E_Atlas", "myplot_icon")
    else
        local resId = 0
        if starCfg.perMakeRes[1] then
            resId = starCfg.perMakeRes[1][1]
            resIconName = gg.getSpriteAtlasName("ResIcon_E_Atlas", constant.RES_2_CFG_KEY[resId].iconNameHead .. "E1")
        end
    end

    if resIconName then
        gg.setSpriteAsync(view.iconRes, resIconName, nil, nil, true)
    end
    local unionName = ""
    local status = 0
    if datas[cfgId] then
        status = datas[cfgId].status
        unionName = datas[cfgId].unionName
    end

    view.txtName.text = starCfg.name
    view.txtPos.text = string.format("X:%s Y:%s", starCfg.pos.x, starCfg.pos.y)
    view.txtGuild.text = unionName
    if status == 1 then
        view.bgRed:SetActiveEx(true)
        view.bgblue:SetActiveEx(false)
        view.red:SetActiveEx(true)
        view.blue:SetActiveEx(false)
        view.state:SetActiveEx(true)
        view.boxGridData.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(425, 299)
    elseif status == 2 then
        view.bgRed:SetActiveEx(false)
        view.bgblue:SetActiveEx(true)
        view.red:SetActiveEx(false)
        view.blue:SetActiveEx(true)
        view.state:SetActiveEx(true)
        view.boxGridData.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(425, 299)
    else
        view.state:SetActiveEx(false)
        view.boxGridData.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(425, 173)
    end
    view.txtPosX.text = starCfg.pos.x
    view.txtPosY.text = starCfg.pos.y

    view.boxGridData:SetActiveEx(true)
    -- view.gridPosMsg:SetActiveEx(true)
    view.btnGo:SetActiveEx(true)
end

function PnlSmallMap:setSelGrid(cfgId)
    local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
    if not curCfg or curCfg.isBan ~= 1 then
        self:posError()
        return
    end
    self.view.btnGo:SetActiveEx(true)
    self.selGridCfgId = cfgId
    local x, y = self:calaStarDis(cfgId)
    self.view.selGrid.transform.localPosition = Vector3(x, y, 0)
    self.view.selGrid:SetActiveEx(true)

end

function PnlSmallMap:loadStarBoxGrids()
    local lvData = self:clearUpGridData()
    local lvWidth = {}
    for i, data in pairs(lvData) do
        if #data > 0 then
            table.insert(lvWidth, self:calcBoxGridsWidth(#data))
        end
    end

    local starPosX = 150

    local posX = {}
    for i = 1, #lvWidth, 1 do
        local lastW = lvWidth[i - 1] or 0
        local lastP = posX[i - 1] or 0
        local x = starPosX + lastW + lastP
        table.insert(posX, x)
    end

    self.starContentWidth = posX[#posX] + lvWidth[#lvWidth] + 150
    self.view.content.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(
        self.starContentWidth, 0)

    self.lvToggleGrids = {}
    self.lvBoxGrids = {}
    local index = 0
    for i, data in pairs(lvData) do
        if #data > 0 then
            local key = index + 1
            index = key
            ResMgr:LoadGameObjectAsync("BoxGrids", function(box)
                box.transform:SetParent(self.view.content, false)
                box.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(lvWidth[key], 179)
                box.transform.localPosition = Vector3(posX[key], -20.5, 0)
                box.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format(Utils.getText(
                    "league_Lv7Star"), data[1].level)

                for n, v in ipairs(data) do
                    self:loadToggleGrid(v, n, box, self.lvToggleGrids, v.level)
                end
                table.insert(self.lvBoxGrids, box)
                return true
            end, true)
        end
    end
end

function PnlSmallMap:onLoadMaskBoxGrids(args, unionFavList, myFavList)
    self.unionFavList = {}
    self.myFavList = {}

    local _unionFavList = {}
    local _myFavList = {}

    for k, v in pairs(unionFavList) do
        local curCfg = gg.galaxyManager:getGalaxyCfg(v.cfgId)
        if curCfg then
            if curCfg.chainID == self.chainID then
                self.unionFavList[v.cfgId] = v
                table.insert(_unionFavList, v)
            end
        else
            GalaxyData.C2S_Player_DelUnionFavoriteGrid(v.cfgId)
        end

    end
    for k, v in pairs(myFavList) do
        local curCfg = gg.galaxyManager:getGalaxyCfg(v.cfgId)
        if curCfg then
            if curCfg.chainID == self.chainID then
                self.myFavList[v.cfgId] = v
                table.insert(_myFavList, v)
            end
        else
            GalaxyData.C2S_Player_DelMyFavoriteGrid(v.cfgId)
        end
    end

    if #_unionFavList > 0 then
        QuickSort.quickSort(_unionFavList, "cfgId", 1, #_unionFavList, "up")
    end
    if #_myFavList > 0 then
        QuickSort.quickSort(_myFavList, "cfgId", 1, #_myFavList, "up")
    end

    self:loadMaskBoxGrids(_unionFavList, _myFavList)
end

function PnlSmallMap:loadMaskBoxGrids(unionFavList, myFavList)
    if self.lvBoxGrids then
        for i, v in ipairs(self.lvBoxGrids) do
            v:SetActiveEx(false)
        end
    end

    local unionWidth = self:calcBoxGridsWidth(#unionFavList)
    local myWidth = self:calcBoxGridsWidth(#myFavList)

    local unionPosX = 150
    local myPosX = 150
    if #unionFavList > 0 and #myFavList > 0 then
        myPosX = unionPosX * 2 + unionWidth

    end
    self.markContentWidth = myWidth + myPosX + 150
    self.view.content.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(
        self.markContentWidth, 0)

    self.daoMarkToggleGrids = {}
    self.myMarkToggleGrids = {}

    if #unionFavList > 0 then
        ResMgr:LoadGameObjectAsync("BoxGrids", function(box)
            box.transform:SetParent(self.view.content, false)
            box.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(unionWidth, 179)
            box.transform.localPosition = Vector3(unionPosX, -20.5, 0)
            box.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                "league_MiniMap_DaoFavorites")
            -- box.transform:Find("Text").localPosition = Vector3(-20, -60, 0)
            -- box.transform:Find("Text1").gameObject:SetActiveEx(false)

            for i, v in ipairs(unionFavList) do
                self:loadToggleGrid(v, i, box, self.daoMarkToggleGrids, PnlSmallMap.TYPE_DAO)
            end
            self.daoBoxGrids = box
            return true
        end, true)
    end

    if #myFavList > 0 then
        ResMgr:LoadGameObjectAsync("BoxGrids", function(box)
            box.transform:SetParent(self.view.content, false)
            box.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(myWidth, 179)
            box.transform.localPosition = Vector3(myPosX, -20.5, 0)
            box.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                "league_MiniMap_MyFavorites")
            -- box.transform:Find("Text").localPosition = Vector3(-20, -60, 0)
            -- box.transform:Find("Text1").gameObject:SetActiveEx(false)

            for i, v in ipairs(myFavList) do
                self:loadToggleGrid(v, i, box, self.myMarkToggleGrids, PnlSmallMap.TYPE_MY)
            end
            self.myBoxGrids = box
            return true
        end, true)
    end

end

function PnlSmallMap:loadToggleGrid(data, index, parent, table, type)

    local labelColor = {
        [0] = {
            ["r"] = 0x26 / 0xff,
            ["g"] = 0xd6 / 0xff,
            ["b"] = 1
        },
        [1] = {
            ["r"] = 1,
            ["g"] = 0xae / 0xff,
            ["b"] = 0x00 / 0xff
        },
        [2] = {
            ["r"] = 1,
            ["g"] = 0xae / 0xff,
            ["b"] = 0x00 / 0xff
        },
        [3] = {
            ["r"] = 1,
            ["g"] = 0x62 / 0xff,
            ["b"] = 0x62 / 0xff
        }
    }
    ResMgr:LoadGameObjectAsync("ToggleGrid", function(go)
        local cfgId = data.cfgId
        local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
        go.transform:SetParent(parent.transform, false)
        local re = index % 2
        local x = (math.floor(index / 2) - 1 + re) * 240 + 30
        local y = re * 76 - 106
        -- print("aaaa", x, y)
        go.transform.localPosition = Vector3(x, y, 0)
        local name = curCfg.name
        if data.tag and data.tag ~= "" then
            name = data.tag
        end
        go.transform:Find("Label"):GetComponent(UNITYENGINE_UI_TEXT).text = name
        go.transform:GetComponent(UNITYENGINE_UI_TOGGLE).isOn = false
        local color = labelColor[0]
        if type == PnlSmallMap.TYPE_LV7 or type == PnlSmallMap.TYPE_LV6 then
            if GalaxyData.StarmapMinimap[cfgId] then
                local belong = GalaxyData.StarmapMinimap[cfgId].belong
                color = labelColor[belong]
            end
        elseif type == PnlSmallMap.TYPE_DAO then
            if self.unionFavList[cfgId] then
                local belong = self.unionFavList[cfgId].belong
                color = labelColor[belong]
            end
        elseif type == PnlSmallMap.TYPE_MY then
            if self.myFavList[cfgId] then
                local belong = self.myFavList[cfgId].belong
                color = labelColor[belong]
            end
        end

        go.transform:Find("Label"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(color.r, color.g, color.b)
        CS.UIEventHandler.Get(go):SetOnClick(function()
            self:onToggleGrid(cfgId, type)
        end)
        table[cfgId] = go
        return true
    end, true)
    if type <= PnlSmallMap.TYPE_LV7 then
        self:loadSmallMapStar(data.cfgId, type)
    end
end

function PnlSmallMap:releaseBoxGrids()
    if self.lvToggleGrids then
        for k, v in pairs(self.lvToggleGrids) do
            CS.UIEventHandler.Clear(v)

            ResMgr:ReleaseAsset(v)
        end
        self.lvToggleGrids = nil
    end
    if self.daoMarkToggleGrids then
        for k, v in pairs(self.daoMarkToggleGrids) do
            CS.UIEventHandler.Clear(v)

            ResMgr:ReleaseAsset(v)
        end
        self.daoMarkToggleGrids = nil
    end
    if self.myMarkToggleGrids then
        for k, v in pairs(self.myMarkToggleGrids) do
            CS.UIEventHandler.Clear(v)

            ResMgr:ReleaseAsset(v)
        end
        self.myMarkToggleGrids = nil
    end

    for k, v in pairs(self.starList) do
        ResMgr:ReleaseAsset(v)
    end

    if self.lvBoxGrids then
        for i, v in ipairs(self.lvBoxGrids) do
            ResMgr:ReleaseAsset(v)
        end
    end

    if self.daoBoxGrids then
        ResMgr:ReleaseAsset(self.daoBoxGrids)
    end
    if self.myBoxGrids then
        ResMgr:ReleaseAsset(self.myBoxGrids)
    end

    self.lvBoxGrids = nil
    self.daoBoxGrids = nil
    self.myBoxGrids = nil
    self.starList = nil
end

function PnlSmallMap:clearUpGridData()
    local starMapMaskcfg = cfg["StarMapMark"]
    local keys = {
        [1] = 7,
        [2] = 6,
        [3] = 5,
        [4] = 4,
        [5] = 3,
        [6] = 2,
        [7] = 1
    }

    local lvData = {}
    for k, v in pairs(starMapMaskcfg) do
        if not lvData[keys[v.level]] then
            lvData[keys[v.level]] = {}
        end
        if v.chain == self.chainID then
            table.insert(lvData[keys[v.level]], v)
        end
    end
    for k, data in pairs(lvData) do
        QuickSort.quickSort(data, "cfgId", 1, #data, "up")
    end
    return lvData
end

function PnlSmallMap:calcBoxGridsWidth(count)
    local re = count % 2
    local num = count / 2
    num = math.floor(num) - 1 + re
    return num * 240 + 270
end

function PnlSmallMap:loadSmallMapStar(cfgId, type)
    local x, y = self:calaStarDis(cfgId)
    ResMgr:LoadGameObjectAsync("SmallMapStar", function(go)
        go.transform:SetParent(self.view.starList.transform, false)
        table.insert(self.starList, go)
        for i = 1, 7, 1 do
            local path = "Star" .. i
            go.transform:Find(path).gameObject:SetActiveEx(false)

        end

        local path = "Star" .. type
        go.transform:Find(path).gameObject:SetActiveEx(true)

        go.transform.localPosition = Vector3(x, y, 0)
        return true
    end, true)
end

function PnlSmallMap:calaStarDis(cfgId)
    local curCfg = gg.galaxyManager:getGalaxyCfg(cfgId)
    if not curCfg then
        return
    end
    -- "" "" "" "" ""
    local smallMapPos = {
        [1] = Vector2.New(50, 70),
        [2] = Vector2.New(-464, 70),
        [3] = Vector2.New(564, 70),
        [4] = Vector2.New(50, 375),
        [5] = Vector2.New(50, -300)
    }
    local worldPos = {
        x = curCfg.worldPos.x - self.mapPos[1].x,
        z = curCfg.worldPos.z - self.mapPos[1].z
    }
    local xNum
    local zNum
    if curCfg.pos.x < self.contenPos.x and curCfg.pos.y >= self.contenPos.y then
        xNum = 2
        zNum = 4
    elseif curCfg.pos.x >= self.contenPos.x and curCfg.pos.y >= self.contenPos.y then
        xNum = 3
        zNum = 4
    elseif curCfg.pos.x >= self.contenPos.x and curCfg.pos.y < self.contenPos.y then
        xNum = 3
        zNum = 5
    elseif curCfg.pos.x < self.contenPos.x and curCfg.pos.y < self.contenPos.y then
        xNum = 2
        zNum = 5
    end

    local x1 = self.mapPos[xNum].x - self.mapPos[1].x
    local z1 = self.mapPos[zNum].z - self.mapPos[1].z
    local x2 = smallMapPos[xNum].x - smallMapPos[1].x
    local y2 = smallMapPos[zNum].y - smallMapPos[1].y
    local x = worldPos.x / x1 * x2 + smallMapPos[1].x
    local y = worldPos.z / z1 * y2 + smallMapPos[1].y

    return x, y
end

return PnlSmallMap
