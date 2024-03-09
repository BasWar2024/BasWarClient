

PnlMain = class("PnlMain", ggclass.UIBase)

function PnlMain:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = { }
    
end

function PnlMain:onAwake()
    self.view = ggclass.PnlMainView.new(self.transform)
    self.shopType = 1
    
    self.resTable = {}
    self:initBuildShop()
    self:refreshBuildShop()

    self.isCanBattle = false

end

function PnlMain:onShow()
    self:bindEvent()
    gg.resPlanetManager:resetPlayerId()
    gg.uiManager:openWindow("PnlPlayerInformation")

end

function PnlMain:onHide()
    self:releaseEvent()
end

function PnlMain:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnActivity):SetOnClick(function()
        self:onBtnActivity()
    end)
    CS.UIEventHandler.Get(view.btnAchievement):SetOnClick(function()
        self:onBtnAchievement()
    end)
    CS.UIEventHandler.Get(view.btnRankingList):SetOnClick(function()
        self:onBtnRankingList()
    end)
    CS.UIEventHandler.Get(view.btnChat):SetOnClick(function()
        self:onBtnChat()
    end)
    CS.UIEventHandler.Get(view.btnSetting):SetOnClick(function()
        self:onBtnSetting()
    end)
    CS.UIEventHandler.Get(view.btnBuild):SetOnClick(function()
        self:onBtnBuild()
    end)
    CS.UIEventHandler.Get(view.btnShop):SetOnClick(function()
        self:onBtnShop()
    end)
    CS.UIEventHandler.Get(view.btnMap):SetOnClick(function()
        self:onBtnMap()
    end)
    CS.UIEventHandler.Get(view.btnMatch):SetOnClick(function()
        self:onBtnMatch()
    end)
    CS.UIEventHandler.Get(view.btnReplenish):SetOnClick(function()
        self:onBtnReplenish()
    end)
    CS.UIEventHandler.Get(view.btnBuildShopClose):SetOnClick(function()
        self:onBtnBuildShopClose()
    end)
    CS.UIEventHandler.Get(view.btnEconomic):SetOnClick(function()
        self:onBtnEconomic()
    end)
    CS.UIEventHandler.Get(view.btnDevelopment):SetOnClick(function()
        self:onBtnDevelopment()
    end)
    CS.UIEventHandler.Get(view.btnDefense):SetOnClick(function()
        self:onBtnDefense()
    end)
    CS.UIEventHandler.Get(view.bubbleBoatRes.gameObject):SetOnClick(function()
        self:onBubbleBoatRes()
    end)

    local max = view.showBar.childCount
    for i=1, max do
        local temp = i
        CS.UIEventHandler.Get(view.showBar:GetChild(i - 1).gameObject):SetOnClick(function()
            self:onBtnLoadBuilding(temp)
        end)
    end

    gg.event:addListener("onShowRes", self)
    gg.event:addListener("onSetCanNotCollect", self)
    gg.event:addListener("onSetCanNotCollectBoat", self)
    gg.event:addListener("onDestroyRes", self)
    gg.event:addListener("onHideRes", self)
    gg.event:addListener("onIsCanBattle", self)
    gg.event:addListener("onShowBuildMsg", self)
    gg.event:addListener("onCollectBoatResSuccessful", self)
    gg.event:addListener("onShowBoatRes", self)
    gg.event:addListener("onRefreshBoatData", self)
end

function PnlMain:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnActivity)
    CS.UIEventHandler.Clear(view.btnAchievement)
    CS.UIEventHandler.Clear(view.btnRankingList)
    CS.UIEventHandler.Clear(view.btnChat)
    CS.UIEventHandler.Clear(view.btnSetting)
    CS.UIEventHandler.Clear(view.btnBuild)
    CS.UIEventHandler.Clear(view.btnShop)
    CS.UIEventHandler.Clear(view.btnMap)
    CS.UIEventHandler.Clear(view.btnMatch)
    CS.UIEventHandler.Clear(view.btnReplenish)
    CS.UIEventHandler.Clear(view.btnBuildShopClose)
    CS.UIEventHandler.Clear(view.btnEconomic)
    CS.UIEventHandler.Clear(view.btnDevelopment)
    CS.UIEventHandler.Clear(view.btnDefense)
    CS.UIEventHandler.Clear(view.bubbleBoatRes.gameObject)
    local max = view.showBar.childCount
    for i=1, max do
        CS.UIEventHandler.Clear(view.showBar:GetChild(i - 1).gameObject)
    end

    gg.event:removeListener("onShowRes", self)
    gg.event:removeListener("onSetCanNotCollect", self)
    gg.event:removeListener("onSetCanNotCollectBoat", self)
    gg.event:removeListener("onDestroyRes", self)
    gg.event:removeListener("onHideRes", self)
    gg.event:removeListener("onIsCanBattle", self)
    gg.event:removeListener("onShowBuildMsg", self)
    gg.event:removeListener("onCollectBoatResSuccessful", self)
    gg.event:removeListener("onShowBoatRes", self)
    gg.event:removeListener("onRefreshBoatData", self)
    if self.msgMoveFollow then
        self:onShowBuildMsg(nil, false)
    end
end

function PnlMain:onDestroy()
    local view = self.view
    gg.uiManager:closeWindow("PnlPlayerInformation")
    local max = view.showBar.childCount
    for i=1, max do
        UnityEngine.GameObject.Destroy(view.showBar:GetChild(0).gameObject)
    end
    self:destroyAllRes()
    self:destroyBoatRes()
end

--
function PnlMain:initBuildShop()
    local max = #gg.buildingManager.buildingTableOfEconomic
    if #gg.buildingManager.buildingTableOfDevelopment > max then
        max = #gg.buildingManager.buildingTableOfDevelopment
    end
    if #gg.buildingManager.buildingTableOfDefense > max then
        max = #gg.buildingManager.buildingTableOfDefense
    end
    local templete = self.view.showBar:GetChild(0)
    local initX = 30
    local space = templete:GetComponent("RectTransform").rect.width + 30
    local initY = -36.5
    for i=1, max-1 do
        local trans =  UnityEngine.GameObject.Instantiate(templete)
        trans:SetParent(self.view.showBar, false)
        local x = space * i +initX
        trans:GetComponent("RectTransform"):SetLocalPosX(x)
        trans:GetComponent("RectTransform"):SetLocalPosY(initY)
    end

end

function PnlMain:refreshBuildShop()
    local buildingTable = {}
    if self.shopType == 1 then
        buildingTable = gg.buildingManager.buildingTableOfEconomic
        self:buildTypeOfCheck(self.view.btnEconomic, true)
        self:buildTypeOfCheck(self.view.btnDevelopment, false)
        self:buildTypeOfCheck(self.view.btnDefense, false)
    end
    if self.shopType == 2 then
        buildingTable = gg.buildingManager.buildingTableOfDevelopment
        self:buildTypeOfCheck(self.view.btnEconomic, false)
        self:buildTypeOfCheck(self.view.btnDevelopment, true)
        self:buildTypeOfCheck(self.view.btnDefense, false)
    end
    if self.shopType == 3 then
        buildingTable = gg.buildingManager.buildingTableOfDefense
        self:buildTypeOfCheck(self.view.btnEconomic, false)
        self:buildTypeOfCheck(self.view.btnDevelopment, false)
        self:buildTypeOfCheck(self.view.btnDefense, true)
    end
    self.view.showBar:GetComponent("RectTransform"):SetLocalPosX(0)
    local max = self.view.showBar.childCount
    local showBarWidth = 0
    for i=1, max do
        if i <= #buildingTable then
            local cardModle = self.view.showBar:GetChild(i - 1)
            cardModle.gameObject:SetActive(true)
            local iconName = buildingTable[i].icon
            -- ResMgr:LoadSpriteAsync(iconName, function(sprite)
            --     cardModle:Find("icon"):GetComponent("Image").sprite = sprite
            -- end)
            cardModle:Find("Name"):GetComponent("Text").text = buildingTable[i].name 
            cardModle:Find("Desc"):GetComponent("Text").text = buildingTable[i].desc      
            cardModle:Find("IconStartCoin/TxtStarCoin"):GetComponent("Text").text = buildingTable[i].levelUpNeedStarCoin
            cardModle:Find("IconIce/TxtIce"):GetComponent("Text").text = buildingTable[i].levelUpNeedIce
            cardModle:Find("IconCarboxyl/TxtCarboxyl"):GetComponent("Text").text = buildingTable[i].levelUpNeedCarboxyl
            cardModle:Find("IconTitanium/TxtTitanium"):GetComponent("Text").text = buildingTable[i].levelUpNeedTitanium
            cardModle:Find("IconGas/TxtGas"):GetComponent("Text").text = buildingTable[i].levelUpNeedGas
            showBarWidth = showBarWidth + cardModle:GetComponent("RectTransform").rect.width + 30
        else
            self.view.showBar:GetChild(i - 1).gameObject:SetActive(false)
        end
    end
    showBarWidth = showBarWidth + 30
    self.view.showBar:GetComponent("RectTransform").sizeDelta =  Vector2.New(showBarWidth, 0)
end

function PnlMain:buildTypeOfCheck(obj, check)
    obj.transform:Find("BgNotCheck").gameObject:SetActive(not check)
    obj.transform:Find("Text"):GetComponent("Outline").enabled = check
    if check then 
        obj.transform:Find("Text"):GetComponent("Text").color = Color.New(217/255, 217/255, 217/255)
    else
        obj.transform:Find("Text"):GetComponent("Text").color = Color.New(173/255, 173/255, 173/255)
    end
end

--
function PnlMain:onBtnCollectRes(temp)
    gg.buildingManager:buildCollectRes(temp)
end

function PnlMain:onBtnActivity()
    --print("onBtnActivity")
    gg.uiManager:showTip("Function not open")
end

function PnlMain:onBtnAchievement()
    --print("onBtnAchievement")
    gg.uiManager:showTip("Function not open")
end

function PnlMain:onBtnRankingList()
    --print("onBtnRankingList")
    -- gg.uiManager:showTip("Function not open")
    gg.uiManager:openWindow("PnlRank")
end

function PnlMain:onBtnChat()
    --print("onBtnChat")
    gg.uiManager:showTip("Function not open")
end

function PnlMain:onBtnSetting()
    gg.uiManager:openWindow("PnlSetting")
end

function PnlMain:onBtnBuild()
    self.view.bulidShop:SetActive(true)
    gg.event:dispatchEvent("onBgHighlighted", true)
    gg.buildingManager:cancelBuildOrMove()
end

function PnlMain:onBtnShop()
    --print("onBtnShop")
    --gg.uiManager:showTip("Function not open")
    gg.uiManager:openWindow("PnlItemBag", "Base")
end

function PnlMain:onBtnMap()
    ResPlanetData.C2S_Player_QueryAllResPlanetBrief()
    self.destroyTime = -1
    self:close()
    gg.sceneManager:enterMapScene()
end

function PnlMain:onBtnBuildShopClose()
    self.view.bulidShop:SetActive(false)
    gg.event:dispatchEvent("onBgHighlighted", false)
end

function PnlMain:onBtnEconomic()
    self.shopType = 1
    self:refreshBuildShop()
end

function PnlMain:onBtnDevelopment()
    self.shopType = 2
    self:refreshBuildShop()
end

function PnlMain:onBtnDefense()
    self.shopType = 3
    self:refreshBuildShop()
end

function PnlMain:onBtnLoadBuilding(index)
    local buildingTable = {}
    if self.shopType == 1 then
        buildingTable = gg.buildingManager.buildingTableOfEconomic
    end
    if self.shopType == 2 then
        buildingTable = gg.buildingManager.buildingTableOfDevelopment
    end
    if self.shopType == 3 then
        buildingTable = gg.buildingManager.buildingTableOfDefense
    end
    local canBuild = true
    if buildingTable[index].cfgId == constant.BUILD_LIBERATORSHIP then
        if not gg.buildingManager:checkResources(buildingTable[index]) then
            canBuild = false
            gg.uiManager:showTip("Insufficient resources")
        end
        if not gg.buildingManager:chenkLiberatorShip() then
            canBuild = false
            gg.uiManager:showTip("The liberator ship is fully built")
        end
    end
    if canBuild then
        gg.buildingManager:loadBuilding(buildingTable[index], nil, nil, BuildingManager.OWNER_OWN)
        self.view.bulidShop:SetActive(false)
    end
    --print(buildingTable[index].cfgId)
end

function PnlMain:onBtnMatch()
    self.destroyTime = 0
     --
     if self.isCanBattle then
        BattleData.C2S_Player_StartBattle(1, 0);
        --gg.sceneManager:enterBattleScene()
     end
end

function PnlMain:onBtnReplenish()
    print("onBtnReplenish")
    gg.uiManager:showTip("Function not open")
end

function PnlMain:onIsCanBattle()
    self.isCanBattle = true
end

--
function PnlMain:onShowBuildMsg(args, bool, buildingObj, name, level)
    local obj = self.view.msgBuilding.gameObject
    obj:SetActive(bool)
    if self.msgMoveFollow then
        self.msgMoveFollow:releaseEvent()
        self.msgMoveFollow = nil
    end
    if bool then
        self.msgMoveFollow = ggclass.MoveFollow.new(obj, buildingObj, nil, true)
        obj.transform:Find("TxtBuildName"):GetComponent("Text").text = name
        obj.transform:Find("TxtBuildLevel"):GetComponent("Text").text = level
    end
end

--
function PnlMain:onShowRes(args, buildingId, buildingObj, type)
    local haveData = false
    if self.resTable[buildingId] then
        haveData = true
    end
    if not haveData then
        ResMgr:LoadGameObjectAsync("BubbleRes", function(obj)
            obj.transform:SetParent(self.view.listRes, false)
            obj.transform:GetComponent("RectTransform").localScale = Vector3(1, 1, 1)
            obj.transform:Find("BgRed").gameObject:SetActive(false)
            obj.transform:Find("Bg").gameObject:SetActive(true)
            local moveFollow = ggclass.MoveFollow.new(obj, buildingObj, nil, false, true)
            local res = {obj = obj, moveFollow = moveFollow}
            self.resTable[buildingId] = res
            CS.UIEventHandler.Get(self.resTable[buildingId].obj):SetOnClick(function()
                self:onBtnCollectRes(buildingId)
            end)
            local max = obj.transform:Find("Res").childCount
            for i=1, max do
                local iconObj = obj.transform:Find("Res"):GetChild(i - 1)
                iconObj.gameObject:SetActive(false)
            end
            obj.transform:Find("Res"):GetChild(type - 1).gameObject:SetActive(true)
            return true
        end, true)
    end
end

function PnlMain:onSetCanNotCollect(args, buildingId, bool)
    --
    if self.resTable[buildingId] then
        self.resTable[buildingId].obj.transform:GetComponent("RectTransform").pivot = Vector2.New(0.5, 0.5)
        self.resTable[buildingId].obj.transform:Find("BgRed").gameObject:SetActive(bool)
        self.resTable[buildingId].obj.transform:Find("Bg").gameObject:SetActive(not bool)
        self.resTable[buildingId].moveFollow.overScreen = true
    end
    self:onSetCanNotCollectBoat()
end

function PnlMain:onDestroyRes(args, buildingId)
    if self.resTable[buildingId] then
        CS.UIEventHandler.Clear(self.resTable[buildingId].obj)
        ResMgr:ReleaseAsset(self.resTable[buildingId].obj)
        self.resTable[buildingId].moveFollow:releaseEvent()
        self.resTable[buildingId] = nil
    end
end

function PnlMain:onHideRes(args, buildingId, bool)
    if not self.resTable[buildingId] then
        return
    end
    self.resTable[buildingId].obj:SetActive(bool)
    if bool then
        self.resTable[buildingId].moveFollow:onMoveFollow()
    end
end

function PnlMain:destroyAllRes()
    for k, v in pairs(self.resTable) do
        CS.UIEventHandler.Clear(v.obj)
        ResMgr:ReleaseAsset(v.obj)
        v.moveFollow:releaseEvent()
    end
    self.resTable = {}
end

--
function PnlMain:onRefreshBoatData()
    self:creatBoat()
    self:setBoatRes(ResPlanetData.resBoatDatas)
end

function PnlMain:creatBoat()
    if not self.resBoat then
        local max = 0
        for k, v in pairs(ResPlanetData.resBoatDatas) do
            max = max + 1
        end
        if max > 0 then
            self.resBoat = nil
            self.resBoat = ggclass.ResBoat.new(ResPlanetData.resBoatDatas)
            self:setBoatRes(ResPlanetData.resBoatDatas)
        end
    else
        self.resBoat:setBoatData(ResPlanetData.resBoatDatas)
        self:setBoatRes(ResPlanetData.resBoatDatas)
    end
end

PnlMain.RES_IOCN_NAME = {[200] = "IconGun", 
                        [102] = "IconStartCoin", 
                        [103] = "IconIce", 
                        [104] = "IconCarboxyl", 
                        [105] = "IconTitanium", 
                        [106] = "IconGas" }

function PnlMain:setBoatRes(datas)
    local view = self.view
    local resCfgIds = {}
    for k, v in pairs(self.resBoat.boatRes) do
        table.insert(resCfgIds, v.key)
    end

    for k,v in pairs(PnlMain.RES_IOCN_NAME) do
        view.bubbleBoatRes:Find(v).gameObject:SetActive(false)
    end

    local max = #resCfgIds
    local interval = 55
    local sizeWidth = max * interval + 14
    local bgWidth = 25 * max
    view.bubbleBoatRes:Find("Bg").gameObject:SetActive(true)
    view.bubbleBoatRes:Find("BgRed").gameObject:SetActive(false)
    view.bubbleBoatRes:GetComponent("RectTransform").sizeDelta = Vector2.New(sizeWidth, 84)
    view.bubbleBoatRes:Find("Bg/Bg1"):GetComponent("RectTransform").sizeDelta = Vector2.New(bgWidth, 84)
    view.bubbleBoatRes:Find("Bg/Bg2"):GetComponent("RectTransform").sizeDelta = Vector2.New(bgWidth, 84)
    view.bubbleBoatRes:Find("BgRed/Bg1"):GetComponent("RectTransform").sizeDelta = Vector2.New(bgWidth, 84)
    view.bubbleBoatRes:Find("BgRed/Bg2"):GetComponent("RectTransform").sizeDelta = Vector2.New(bgWidth, 84)
    local startPsoX = 34.5
    for k = 1, max do
        local posX = startPsoX + interval * (k - 1)
        local name = PnlMain.RES_IOCN_NAME[resCfgIds[k]]
        if not name then
            return
        end
        view.bubbleBoatRes:Find(name).gameObject:SetActive(true)
        view.bubbleBoatRes:Find(name):GetComponent("RectTransform").anchoredPosition = Vector2.New(posX, 48)
    end
end

function PnlMain:onShowBoatRes(args, targetObj)
    self.view.bubbleBoatRes.gameObject:SetActive(true)
    self:releaseBoatRes()
    self.boatResMoveFollow = ggclass.MoveFollow.new(self.view.bubbleBoatRes.gameObject, targetObj, nil, false, true)
end

function PnlMain:onBubbleBoatRes()
    gg.event:dispatchEvent("onCollectRes")
end

function PnlMain:onCollectBoatResSuccessful()
    self:releaseBoatRes()
    self.resBoat = nil
    self.view.bubbleBoatRes.gameObject:SetActive(false)
end

function PnlMain:releaseBoatRes()
    if self.boatResMoveFollow then
        self.boatResMoveFollow:releaseEvent()
        self.boatResMoveFollow = nil
    end
end

function PnlMain:destroyBoatRes()
    gg.event:dispatchEvent("onDestroyResBoat")
    self:releaseBoatRes()
    self.resBoat = nil
end

function PnlMain:onSetCanNotCollectBoat()
    --
    if self.boatResMoveFollow then
        self.boatResMoveFollow.overScreen = true
        self.view.bubbleBoatRes:Find("Bg").gameObject:SetActive(false)
        self.view.bubbleBoatRes:Find("BgRed").gameObject:SetActive(true)
    end
end

return PnlMain