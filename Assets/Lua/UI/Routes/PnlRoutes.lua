PnlRoutes = class("PnlRoutes", ggclass.UIBase)

PnlRoutes.infomationType = ggclass.UIBase.INFOMATION_RES

function PnlRoutes:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)

    self.layer = UILayer.normal
    self.events = {"onSetViewRecord"}
    self.needBlurBG = true

    self.warshipData = {} -- ""
    self.buildData = {} -- ""
    self.heroData = {} -- ""
    self.allData = {} -- ""

    self.timerList = {} -- ""

    self.nftBtnList = {} -- NFT""

    self.chooseData = nil -- ""nft""id

    self.chooseWarshipData = nil

    self.chooseNftData = {}
    self.chooseNftObj = {}

    self.boxRecordList = {}

    self.filterType = PnlRoutes.FILTER_TYPE_ALL
end

PnlRoutes.FILTER_TYPE_ALL = -1
PnlRoutes.FILTER_TYPE_WARSHIP = 1
PnlRoutes.FILTER_TYPE_HERO = 2
PnlRoutes.FILTER_TYPE_TOWER = 3
PnlRoutes.FILTER_TYPE_DAO_ITEM = constant.ITEM_ITEMTYPE_DAO_ITEM
PnlRoutes.FILTER_TYPE_NFT_ITEM = constant.ITEM_ITEMTYPE_NFT_ITEM

PnlRoutes.FILTER_NAME = {
    [PnlRoutes.FILTER_TYPE_ALL] = "bag_All",
    [PnlRoutes.FILTER_TYPE_WARSHIP] = "bag_Warship",
    [PnlRoutes.FILTER_TYPE_HERO] = "bag_Hero",
    [PnlRoutes.FILTER_TYPE_TOWER] = "bag_Tower",
    [PnlRoutes.FILTER_TYPE_DAO_ITEM] = "bag_DaoArtifact",
    [PnlRoutes.FILTER_TYPE_NFT_ITEM] = "bag_NftItem"
}

function PnlRoutes:onAwake()
    self.view = ggclass.PnlRoutesView.new(self.pnlTransform)

    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderAttr, self))

    self.leftBtnViewBgBtnsBox = ItemBagOptionBtns.new(self.view.leftBtnViewBgBtnsBox)

    self.leftBtnDataList = {{
        name = Utils.getText(PnlRoutes.FILTER_NAME[PnlRoutes.FILTER_TYPE_ALL]),
        callback = gg.bind(self.onBtnFilter, self, PnlRoutes.FILTER_TYPE_ALL)
    }, {
        name = Utils.getText(PnlRoutes.FILTER_NAME[PnlRoutes.FILTER_TYPE_WARSHIP]),
        callback = gg.bind(self.onBtnFilter, self, PnlRoutes.FILTER_TYPE_WARSHIP)
    }, {
        name = Utils.getText(PnlRoutes.FILTER_NAME[PnlRoutes.FILTER_TYPE_HERO]),
        callback = gg.bind(self.onBtnFilter, self, PnlRoutes.FILTER_TYPE_HERO)
    }, {
        name = Utils.getText(PnlRoutes.FILTER_NAME[PnlRoutes.FILTER_TYPE_TOWER]),
        callback = gg.bind(self.onBtnFilter, self, PnlRoutes.FILTER_TYPE_TOWER)
    }, {
        name = Utils.getText(PnlRoutes.FILTER_NAME[PnlRoutes.FILTER_TYPE_DAO_ITEM]),
        callback = gg.bind(self.onBtnFilter, self, PnlRoutes.FILTER_TYPE_DAO_ITEM)
    }, {
        name = Utils.getText(PnlRoutes.FILTER_NAME[PnlRoutes.FILTER_TYPE_NFT_ITEM]),
        callback = gg.bind(self.onBtnFilter, self, PnlRoutes.FILTER_TYPE_NFT_ITEM)
    }}

    self.leftBtnViewBgBtnsBox:setBtnDataList(self.leftBtnDataList)

    self:initBtnSkillTable()
    local vipLv = VipData.vipData.vipLevel
    self.withdrawCD = cfg.global.WithdrawCD.intValue - cfg.vip[vipLv].withdrawReduce - self.args.buildCfg.withdrawReduce
    if self.withdrawCD < 0 then
        self.withdrawCD = 0
    end
end

function PnlRoutes:initBtnSkillTable()
    local view = self.view
    self.btnSkillTable = {}

    for i = 1, 5 do
        local btn = view["btnSkill" .. i]
        local t = {
            obj = btn,
            skillCfg = nil
        }
        t.commonItemItem = CommonItemItem.new(btn.transform:Find("CommonItemItem"))
        t.layoutSlider = btn.transform:Find("LayoutSlider")
        t.txtSlider = t.layoutSlider:Find("TxtSlider"):GetComponent(UNITYENGINE_UI_TEXT)
        t.slider = t.layoutSlider:Find("Slider"):GetComponent(UNITYENGINE_UI_SLIDER)
        table.insert(self.btnSkillTable, t)
    end
end

function PnlRoutes:onShow()
    self:bindEvent()

    self:onBtnTransportHy()
    -- self:onBtnTransport()
    self.view.viewRoute:SetActive(true)

    self.view.viewChoose:SetActive(false)
    self.view.bgTips:SetActive(false)
    self.warshipData = nil
    self.chooseNftData = {}

    self.view.inputFieldMit.text = ""
    self.view.inputFieldHydroxyl.text = ""

    self.leftBtnViewBgBtnsBox:setBtnStageWithoutNotify(1)

    self:setViewRoute()

    local inputCount = self.view.inputFieldHydroxyl.text or 0
    if inputCount == "" then
        inputCount = 0
    end
    inputCount = tonumber(inputCount)
    local hyMax = self:getMaxHydroxyl()
    if inputCount > hyMax then
        self.view.inputFieldHydroxyl.text = hyMax
        self:setTxtFreight(hyMax)
    else
        self:setTxtFreight(inputCount)
    end

    self.filterType = PnlRoutes.FILTER_TYPE_ALL
    self.view.txtFilter.text = Utils.getText(PnlRoutes.FILTER_NAME[self.filterType])
    local date = gg.time.dhms_time({
        day = true,
        hour = true,
        min = false,
        sec = false
    }, self.withdrawCD)
    -- self.view.TxtWithdrowTime.text = string.format(Utils.getText("route_WithdrawTime"), date.day, date.hour)

    if ChainBridgeData.chainBridgeData.needShip then
        self.view.tipsNeedWarship:SetActiveEx(true)
        self.view.tipsNeedWarship2:SetActiveEx(true)
    else
        self.view.tipsNeedWarship:SetActiveEx(false)
        self.view.tipsNeedWarship2:SetActiveEx(false)
    end
    self:startTickTimer()
    gg.event:dispatchEvent("onOnlyHyMit", true)
end

function PnlRoutes:getTick()
    -- ChainBridgeData.chainBridgeData.lastTick = 0
    return self.withdrawCD - (Utils.getServerSec() - ChainBridgeData.chainBridgeData.lastTick)
end

function PnlRoutes:startTickTimer()
    self:stopTickTimer()
    self.view.txtTick.gameObject:SetActiveEx(true)
    self.view.btnSetOutHY.transform:GetComponent(UNITYENGINE_UI_IMAGE).color =
        Color.New(0x87 / 0xff, 0x87 / 0xff, 0x87 / 0xff, 1)

    local func = function()
        local tick = self:getTick()
        if tick <= 0 then
            -- self.view.txtTick.gameObject:SetActiveEx(false)
            self.view.txtTick.text = Utils.getText("route_WithdrawIsReady")
            self.view.btnSetOut.transform:GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)

            self:stopTickTimer()
        else
            if tick > 86400 then
                local date = gg.time.dhms_time({
                    day = true,
                    hour = true,
                    min = false,
                    sec = false
                }, tick)
                self.view.txtTick.text = string.format("%s day %s h", date.day, date.hour)
            else
                self.view.txtTick.text = gg.time:getTick(tick)
            end
        end
    end
    self.tickTimer = gg.timer:startLoopTimer(0, 1, -1, function()
        func()
    end)
end

function PnlRoutes:stopTickTimer()
    if self.tickTimer then
        gg.timer:stopTimer(self.tickTimer)
        self.tickTimer = nil
    end
end

function PnlRoutes:onHide()
    self:releaseEvent()
    self:stopTickTimer()
    self:stopAllTimer()
    self:destoryBtnNft()
    self:destoryBtnNftInRoutes()
    self:destoryBoxRecord()

    self.warshipData = {}
    self.buildData = {}
    self.heroData = {}
    self.allData = {}

    self.timerList = {}

    self.nftBtnList = {}

    self.chooseData = nil

    self.chooseWarshipData = nil

    self.chooseNftData = {}
    self.chooseNftObj = {}
    gg.event:dispatchEvent("onOnlyHyMit", false)
end

function PnlRoutes:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnHelp):SetOnClick(function()
        self:onBtnHelp()
    end)
    CS.UIEventHandler.Get(view.btnTransport):SetOnClick(function()
        self:onBtnTransport()
    end)
    CS.UIEventHandler.Get(view.btnRecord):SetOnClick(function()
        self:onBtnRecord()
    end)
    CS.UIEventHandler.Get(view.btnWarship):SetOnClick(function()
        self:onBtnWarship()
    end)
    CS.UIEventHandler.Get(view.btnReSet):SetOnClick(function()
        self:onBtnReSet()
    end)
    CS.UIEventHandler.Get(view.btnMaxMit):SetOnClick(function()
        self:onBtnMaxMit()
    end)
    CS.UIEventHandler.Get(view.btnMaxHydroxyl):SetOnClick(function()
        self:onBtnMaxHydroxyl()
    end)
    CS.UIEventHandler.Get(view.btnAddNft):SetOnClick(function()
        self:onBtnAddNft()
    end)
    CS.UIEventHandler.Get(view.btnSetOut):SetOnClick(function()
        self:onBtnSetOut()
    end)
    CS.UIEventHandler.Get(view.btnCloseTip):SetOnClick(function()
        self:onBtnCloseTip()
    end)
    CS.UIEventHandler.Get(view.btnConfirm):SetOnClick(function()
        self:onBtnConfirm()
    end)
    CS.UIEventHandler.Get(view.btnReturn):SetOnClick(function()
        self:onBtnReturn()
    end)

    CS.UIEventHandler.Get(view.btnConfirmWarship):SetOnClick(function()
        self:onBtnConfirmWarship()
    end)
    CS.UIEventHandler.Get(view.btnConfirmNft):SetOnClick(function()
        self:onBtnConfirmNft()
    end)
    CS.UIEventHandler.Get(view.btnSelelcted):SetOnClick(function()
        self:onBtnSelelcted()
    end)
    CS.UIEventHandler.Get(view.btnDesSelelct):SetOnClick(function()
        self:onBtnDesSelelct()
    end)
    CS.UIEventHandler.Get(view.btnOpenFilter):SetOnClick(function()
        self:onBtnOpenFilter()
    end)
    self:setOnClick(view.btnTransportHy, gg.bind(self.onBtnTransportHy, self))
    self:setOnClick(view.btnSetOutHY, gg.bind(self.onBtnSetOut, self))

    view.inputFieldMit.onValueChanged:AddListener(gg.bind(self.onMitValueChanged, self))
    view.inputFieldHydroxyl.onValueChanged:AddListener(gg.bind(self.onHydroxylValueChanged, self))
end

function PnlRoutes:stopAllTimer()
    for k, v in pairs(self.timerList) do
        self:stopTimer(k)
    end
end

function PnlRoutes:destoryBtnNft()
    if self.chooseNftObj then
        for k, v in pairs(self.chooseNftObj) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.chooseNftObj = {}
    end
end

function PnlRoutes:destoryBtnNftInRoutes()
    if self.nftBtnList then
        for k, v in pairs(self.nftBtnList) do
            CS.UIEventHandler.Clear(v)
            ResMgr:ReleaseAsset(v)
        end
        self.nftBtnList = {}
    end
end

function PnlRoutes:destoryBoxRecord()
    if self.boxRecordList then
        for k, v in pairs(self.boxRecordList) do
            ResMgr:ReleaseAsset(v)
        end
        self.boxRecordList = {}
    end
end

function PnlRoutes:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnHelp)
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnTransport)
    CS.UIEventHandler.Clear(view.btnRecord)
    CS.UIEventHandler.Clear(view.btnWarship)
    CS.UIEventHandler.Clear(view.btnReSet)
    CS.UIEventHandler.Clear(view.btnMaxMit)
    CS.UIEventHandler.Clear(view.btnMaxHydroxyl)
    CS.UIEventHandler.Clear(view.btnAddNft)
    CS.UIEventHandler.Clear(view.btnSetOut)
    CS.UIEventHandler.Clear(view.btnCloseTip)
    CS.UIEventHandler.Clear(view.btnConfirmNft)
    CS.UIEventHandler.Clear(view.btnReturn)
    CS.UIEventHandler.Clear(view.btnSkill1)
    CS.UIEventHandler.Clear(view.btnSkill2)
    CS.UIEventHandler.Clear(view.btnSkill3)
    CS.UIEventHandler.Clear(view.btnSkill4)
    CS.UIEventHandler.Clear(view.btnSkill5)
    CS.UIEventHandler.Clear(view.btnConfirmWarship)
    CS.UIEventHandler.Clear(view.btnConfirmNft)
    CS.UIEventHandler.Clear(view.btnSelelcted)
    CS.UIEventHandler.Clear(view.btnDesSelelct)
    CS.UIEventHandler.Clear(view.btnOpenFilter)
    view.inputFieldMit.onValueChanged:RemoveAllListeners()
    view.inputFieldHydroxyl.onValueChanged:RemoveAllListeners()

end

function PnlRoutes:onDestroy()
    local view = self.view
    self.leftBtnViewBgBtnsBox:release()

end

function PnlRoutes:onBtnClose()
    self:close()
end

function PnlRoutes:onBtnHelp()
    local launchBridgeFeesMax1 = ChainBridgeData.launchBridgeFees[1].max / 1000
    local launchBridgeFeesMin2 = ChainBridgeData.launchBridgeFees[2].min / 1000
    local launchBridgeFeesMax2 = ChainBridgeData.launchBridgeFees[2].max / 1000
    local launchBridgeFeesMin3 = ChainBridgeData.launchBridgeFees[3].min / 1000
    local launchBridgeFeesMax3 = ChainBridgeData.launchBridgeFees[3].max / 1000
    local launchBridgeFeesMin4 = ChainBridgeData.launchBridgeFees[4].min / 1000

    local launchBridgeFees1 = ChainBridgeData.launchBridgeFees[1].fee / 100
    local launchBridgeFees2 = ChainBridgeData.launchBridgeFees[2].fee / 100
    local launchBridgeFees3 = ChainBridgeData.launchBridgeFees[3].fee / 100
    local launchBridgeFees4 = ChainBridgeData.launchBridgeFees[4].fee / 100

    -- "When you transport hoydroxyl,you have charges.\nHY<%.1f, the freght %.1f\n%.1f<=HY<%.1f,the freight %.1f\nHY>%.1f,the freight %.1f"
    -- local text = string.format(Utils.getText("route_Illstrate"), launchBridgeFeesMax1, launchBridgeFees1,
    --     launchBridgeFeesMin2, launchBridgeFeesMax2, launchBridgeFees2, launchBridgeFeesMin3, launchBridgeFeesMax3,
    --     launchBridgeFees3, launchBridgeFeesMin4, launchBridgeFees4)
    local text = Utils.getText("route_Illstrate")

    gg.uiManager:openWindow("PnlRule", {
        title = Utils.getText("universal_RulesTitle"),
        content = text
    })
end

PnlRoutes.TRANSPORT_TYPE_HY = 1
PnlRoutes.TRANSPORT_TYPE_NFT = 2

function PnlRoutes:onBtnTransportHy()
    self.transportType = PnlRoutes.TRANSPORT_TYPE_HY

    self.view.viewTransportHy:SetActive(true)
    self.view.viewTransport:SetActive(false)
    self.view.viewRecord:SetActive(false)
    self.view.btnTransport.transform:Find("Selected").gameObject:SetActive(false)
    self.view.btnTransport.transform:Find("UnSelected").gameObject:SetActive(true)

    self.view.btnRecord.transform:Find("Selected").gameObject:SetActive(false)
    self.view.btnRecord.transform:Find("UnSelected").gameObject:SetActive(true)

    self.view.btnTransportHy.transform:Find("Selected").gameObject:SetActive(true)
    self.view.btnTransportHy.transform:Find("UnSelected").gameObject:SetActive(false)
end

function PnlRoutes:onBtnTransport()
    self.transportType = PnlRoutes.TRANSPORT_TYPE_NFT

    self.view.viewTransport:SetActive(true)
    self.view.viewRecord:SetActive(false)
    self.view.viewTransportHy:SetActive(false)
    self.view.btnTransport.transform:Find("Selected").gameObject:SetActive(true)
    self.view.btnTransport.transform:Find("UnSelected").gameObject:SetActive(false)
    self.view.btnRecord.transform:Find("Selected").gameObject:SetActive(false)
    self.view.btnRecord.transform:Find("UnSelected").gameObject:SetActive(true)
    self.view.btnTransportHy.transform:Find("Selected").gameObject:SetActive(false)
    self.view.btnTransportHy.transform:Find("UnSelected").gameObject:SetActive(true)

end

function PnlRoutes:onBtnRecord()
    self.view.viewTransport:SetActive(false)
    self.view.viewRecord:SetActive(true)
    self.view.viewTransportHy:SetActive(false)
    self.view.btnTransport.transform:Find("Selected").gameObject:SetActive(false)
    self.view.btnTransport.transform:Find("UnSelected").gameObject:SetActive(true)
    self.view.btnRecord.transform:Find("Selected").gameObject:SetActive(true)
    self.view.btnRecord.transform:Find("UnSelected").gameObject:SetActive(false)
    self.view.btnTransportHy.transform:Find("Selected").gameObject:SetActive(false)
    self.view.btnTransportHy.transform:Find("UnSelected").gameObject:SetActive(true)
    -- self:setViewRecord()
    ChainBridgeData.C2S_Player_GetLaunchBridgeRecrods()
end

function PnlRoutes:onSetViewRecord()
    self:setViewRecord()
end

function PnlRoutes:onBtnWarship()
    self:setViewChoose(1)
end

function PnlRoutes:onBtnReSet()
    self:setViewChoose(1)
end

function PnlRoutes:onBtnMaxMit()
    self.view.inputFieldMit.text = self:getMaxMit()
end

function PnlRoutes:onMitValueChanged()
    local inputCount = self.view.inputFieldMit.text or 0
    if inputCount == "" then
        inputCount = 0
    end
    inputCount = tonumber(inputCount)
    local mitMax = self:getMaxMit()
    if inputCount > mitMax then
        self.view.inputFieldMit.text = mitMax
    end
end

function PnlRoutes:onBtnMaxHydroxyl()
    local hyMax = self:getMaxHydroxyl()
    self.view.inputFieldHydroxyl.text = hyMax
    self:setTxtFreight(hyMax)
end

function PnlRoutes:onHydroxylValueChanged()
    local inputCount = self.view.inputFieldHydroxyl.text or 0
    if inputCount == "" then
        inputCount = 0
    end
    inputCount = tonumber(inputCount)
    inputCount = math.floor(inputCount * 1000) / 1000
    local hyMax = self:getMaxHydroxyl()
    if inputCount > hyMax then
        self.view.inputFieldHydroxyl.text = hyMax
        inputCount = hyMax
    end
    self:setTxtFreight(inputCount)

end

function PnlRoutes:getMaxMit()
    local mitMax = string.format("%.3f", ResData.getMit() / 1000)
    mitMax = tonumber(mitMax)
    return mitMax
end

function PnlRoutes:getMaxHydroxyl()
    local hyMax = string.format("%.3f", ResData.getCarboxyl() / 1000)
    hyMax = tonumber(hyMax)
    return hyMax
end

function PnlRoutes:setTxtFreight(hy)
    local hy = hy
    local freight = 0
    if hy > ChainBridgeData.launchBridgeFees[4].min / 1000 then
        freight = ChainBridgeData.launchBridgeFees[4].fee / 10000
    elseif hy > ChainBridgeData.launchBridgeFees[3].min / 1000 and hy <= ChainBridgeData.launchBridgeFees[3].max / 1000 then
        freight = ChainBridgeData.launchBridgeFees[3].fee / 10000
    elseif hy > ChainBridgeData.launchBridgeFees[2].min / 1000 and hy <= ChainBridgeData.launchBridgeFees[2].max / 1000 then
        freight = ChainBridgeData.launchBridgeFees[2].fee / 10000
    elseif hy <= ChainBridgeData.launchBridgeFees[1].max / 1000 then
        freight = ChainBridgeData.launchBridgeFees[1].fee / 10000
    end
    local fre = freight * hy
    if fre < 1000 then
        fre = 1000
    end
    self.view.txtFreight.text = fre
end

function PnlRoutes:onBtnAddNft()
    self:setViewChoose(2)
end

function PnlRoutes:onBtnSetOut()
    if self.transportType == PnlRoutes.TRANSPORT_TYPE_HY then
        local tick = self:getTick()
        if tick > 0 then
            gg.uiManager:showTip(Utils.getText("route_InCd_CannotWithdraw"))
            return
        end

        -- local hyt = (tonumber(self.view.inputFieldHydroxyl.text) or 0) * 1000
        -- if hyt > 0 and hyt < cfg.global.WithdrawMinHYT.intValue then
        --     gg.uiManager:showTip(string.format("the number of HYT must be greater than %s", Utils.getShowRes(cfg.global.WithdrawMinHYT.intValue)))
        --     return
        -- end

        -- local mit = (tonumber(self.view.inputFieldMit.text) or 0) * 1000
        -- if mit > 0 and mit < cfg.global.WithdrawMinMIT.intValue then
        --     gg.uiManager:showTip(string.format("the number of MIT must be greater than %s", Utils.getShowRes(cfg.global.WithdrawMinMIT.intValue)))
        --     return
        -- end
    end

    if self:chackWarship() then
        self.view.bgTips:SetActive(true)
        self:setBgTips()
    else
        gg.uiManager:showTip(Utils.getText("market_NotWarship"))
    end
end

function PnlRoutes:onBtnCloseTip()
    self.view.bgTips:SetActive(false)
end

function PnlRoutes:onBtnConfirm()
    if self:chackWarship() then
        local chainId = 0
        local warShipId = 0 -- self.chooseWarshipData.id or 0

        local mit = 0
        local hyt = 0
        local tokenIds = {}
        local tokenKinds = {}


        if self.transportType == PnlRoutes.TRANSPORT_TYPE_HY then
            hyt = (tonumber(self.view.inputFieldHydroxyl.text) or 0) * 1000
            mit = (tonumber(self.view.inputFieldMit.text) or 0) * 1000

        elseif self.transportType == PnlRoutes.TRANSPORT_TYPE_NFT then
            for k, v in pairs(self.chooseNftData) do
                table.insert(tokenIds, v.id)
                table.insert(tokenKinds, v.itemType)
            end
        end

        if mit > 0 or hyt > 0 or #tokenIds > 0 then
            ChainBridgeData.C2S_Player_LaunchToBridge(chainId, warShipId, mit, hyt, tokenIds, tokenKinds)
            self:close()
        else
            gg.uiManager:showTip(Utils.getText("market_NotGoods"))
        end
    else
        gg.uiManager:showTip(Utils.getText("market_NotWarship"))
    end
end

function PnlRoutes:chackWarship()
    if ChainBridgeData.chainBridgeData.needShip then
        local bool = false
        for k, v in pairs(WarShipData.warShipData) do
            if v.chain ~= 0 then
                bool = true
                break
            end
        end
        return bool
    else
        return true
    end
    return false
end

function PnlRoutes:onBtnReturn()
    self:setViewRoute()
end

function PnlRoutes:onBtnConfirmWarship()
    self.chooseWarshipData = self.chooseData
    self:setViewRoute()
end

function PnlRoutes:onBtnConfirmNft()
    self:setViewRoute()
end

function PnlRoutes:onBtnSelelcted()
    if self.chooseData.ref == 0 then
        self.chooseNftData[self.chooseData.id] = self.chooseData
        self.nftBtnList[self.chooseData.id].transform:Find("IconYes").gameObject:SetActive(true)
        self:refreshAttr(self.chooseData, 2)
    end
end

function PnlRoutes:onBtnDesSelelct()
    self.chooseNftData[self.chooseData.id] = nil
    self.nftBtnList[self.chooseData.id].transform:Find("IconYes").gameObject:SetActive(false)
    self:refreshAttr(self.chooseData, 2)
end

function PnlRoutes:onBtnOpenFilter()
    self.leftBtnViewBgBtnsBox.gameObject:SetActiveEx(not self.leftBtnViewBgBtnsBox.gameObject.activeSelf)
end

function PnlRoutes:onBtnChooseNft(data, obj, type)
    if data.ref == 0 then
        for k, v in pairs(self.nftBtnList) do
            v.transform:Find("Choose").gameObject:SetActive(false)
        end
        obj.transform:Find("Choose").gameObject:SetActive(true)

        self:refreshAttr(data, type)
    end
end

function PnlRoutes:onBtnCancel(id)
    self.chooseNftData[id] = nil
    self:makeBtnNft()
end

function PnlRoutes:onBtnFilter(filterType, isForce)
    if not isForce and self.filterType == filterType then
        return
    end

    self.filterType = filterType
    self.view.txtFilter.text = Utils.getText(PnlRoutes.FILTER_NAME[filterType])
    self.leftBtnViewBgBtnsBox.gameObject:SetActiveEx(false)

    self:setViewChoose(2)
end

function PnlRoutes:setViewRoute()
    self.view.viewRoute:SetActive(true)
    self.view.viewChoose:SetActive(false)

    if self.chooseWarshipData then
        self.view.maskWarship:SetActive(true)
        self.view.btnReSet:SetActive(true)
        local myCfg = cfg.getCfg("warShip", self.chooseWarshipData.cfgId, self.chooseWarshipData.level,
            self.chooseWarshipData.quality)
        local icon = myCfg.icon .. "_C"

        gg.setSpriteAsync(self.view.iconWarship, icon)
    else
        self.view.maskWarship:SetActive(false)
        self.view.btnReSet:SetActive(false)

    end

    self:makeBtnNft()
end

function PnlRoutes:makeBtnNft()
    self:destoryBtnNft()
    local startX = 2
    local startY = -26
    local nextX = 110
    local index = 1
    local content = self.view.transform:Find("ViewRoute/ViewTransport/BoxNft/Scroll View/Viewport/Content")

    for k, v in pairs(self.chooseNftData) do
        local temp = index
        local data = v
        ResMgr:LoadGameObjectAsync("BtnNft", function(obj)
            local posX = startX + temp * nextX

            obj.transform:SetParent(content, false)
            -- obj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(posX, startY)
            local myCfg = {}
            local icon
            if data.itemType == PnlRoutes.FILTER_TYPE_WARSHIP then
                myCfg = cfg.getCfg("warShip", data.cfgId, data.level, data.quality)
                icon = gg.getSpriteAtlasName("Warship_A_Atlas", myCfg.icon .. "_A")
                obj.transform:Find("IconTop").gameObject:SetActiveEx(false)
            elseif data.itemType == PnlRoutes.FILTER_TYPE_HERO then
                myCfg = cfg.getCfg("hero", data.cfgId, data.level, data.quality)
                icon = gg.getSpriteAtlasName("Hero_A_Atlas", myCfg.icon .. "_A")
            elseif data.itemType == PnlRoutes.FILTER_TYPE_TOWER then
                myCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
                icon = gg.getSpriteAtlasName("Build_A_Atlas", myCfg.icon .. "_A")
                obj.transform:Find("IconTop").gameObject:SetActiveEx(false)
            elseif data.itemType == PnlRoutes.FILTER_TYPE_DAO_ITEM or data.itemType == PnlRoutes.FILTER_TYPE_NFT_ITEM then
                myCfg = cfg.getCfg("item", data.cfgId)
                icon = gg.getSpriteAtlasName("Item_Atlas", myCfg.icon)
                obj.transform:Find("IconTop").gameObject:SetActiveEx(false)
            end
            UIUtil.setQualityBg(obj.transform:GetComponent(UNITYENGINE_UI_IMAGE), data.quality)
            gg.setSpriteAsync(obj.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

            obj.transform:Find("TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = data.level

            self.chooseNftObj[data.id] = obj

            CS.UIEventHandler.Get(obj.transform:Find("BtnCancel").gameObject):SetOnClick(function()
                self:onBtnCancel(data.id)
            end)

            return true
        end, true)
        index = index + 1
    end
    local posX = startX + index * nextX
    self.view.btnAddNft.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(2, startY)
    local width = (index + 1) * nextX
    -- content:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(width, 0)
end

function PnlRoutes:setViewChoose(type)
    self.view.viewRoute:SetActive(false)
    self.view.viewChoose:SetActive(true)

    self.warshipData = {}
    self.buildData = {}
    self.heroData = {}
    self.allData = {}
    self.daoArtifactData = {}
    self.nftItemData = {}

    local setDataRef = function(oldData, newData, itemType, tempData, type)
        for k, v in pairs(oldData) do
            newData[k] = v
        end
        newData.itemType = itemType
        newData.sort = 0

        if newData.ref == 0 then
            if tempData then
                if type == 1 then
                    if newData.id == tempData.id then
                        newData.ref = 3
                    end
                else
                    for k, v in pairs(tempData) do
                        if newData.id == v.id then
                            newData.ref = 3
                            break
                        end
                    end
                end

            end
            if newData.launchLessTick and newData.launchLessTick > 0 then
                newData.ref = 0 -- 3
            end
        end
        newData.sort = newData.quality * 10000000 + newData.ref * 10000000 + newData.cfgId
    end

    local view = self.view.viewChoose.transform
    if type == 1 then
        self.view.txtTitle.text = Utils.getText("route_SelectWarship")
        view:Find("ViewWarship").gameObject:SetActive(true)
        view:Find("ViewNft").gameObject:SetActive(false)
        for k, v in pairs(WarShipData.warShipData) do
            if v.chain ~= 0 then
                local data = {}
                setDataRef(v, data, PnlRoutes.FILTER_TYPE_WARSHIP, self.chooseNftData, 2)
                table.insert(self.warshipData, data)

            end

        end

        QuickSort.quickSort(self.warshipData, "sort", 1, #self.warshipData, "up")
        self:makeBtnNftInRoutes(view:Find("ViewWarship/ScrollView/Viewport/Content"), self.warshipData, type)
    else
        self.view.txtTitle.text = Utils.getText("route_SelectNFT")
        self.leftBtnViewBgBtnsBox.gameObject:SetActiveEx(false)
        view:Find("ViewWarship").gameObject:SetActive(false)
        view:Find("ViewNft").gameObject:SetActive(true)

        for k, v in pairs(WarShipData.warShipData) do
            if v.chain ~= 0 then
                local data = {}
                setDataRef(v, data, PnlRoutes.FILTER_TYPE_WARSHIP, self.chooseWarshipData, 1)

                table.insert(self.allData, data)
                table.insert(self.warshipData, data)
            end

        end
        for k, v in pairs(HeroData.heroDataMap) do
            if v.chain ~= 0 then
                local data = {}
                setDataRef(v, data, PnlRoutes.FILTER_TYPE_HERO, self.chooseWarshipData, 1)

                table.insert(self.allData, data)
                table.insert(self.heroData, data)
            end

        end
        for k, v in pairs(BuildData.buildData) do
            if v.pos.x == 0 and v.pos.z == 0 and v.chain ~= constant.NOTNFTID then
                local data = {}
                setDataRef(v, data, PnlRoutes.FILTER_TYPE_TOWER, self.chooseWarshipData, 1)

                table.insert(self.allData, data)
                table.insert(self.buildData, data)
            end
        end
        for k, v in pairs(ItemData.itemBagData) do
            local myCfg = cfg.getCfg("item", v.cfgId)
            if myCfg.itemType == constant.ITEM_ITEMTYPE_NFT_ITEM or myCfg.itemType == constant.ITEM_ITEMTYPE_DAO_ITEM then
                local data = {}
                data.quality = myCfg.quality
                data.ref = 0
                if myCfg.itemType == constant.ITEM_ITEMTYPE_NFT_ITEM then
                    setDataRef(v, data, PnlRoutes.FILTER_TYPE_NFT_ITEM, self.chooseWarshipData, 1)
                    table.insert(self.nftItemData, data)
                end
                if myCfg.itemType == constant.ITEM_ITEMTYPE_DAO_ITEM then
                    setDataRef(v, data, PnlRoutes.FILTER_TYPE_DAO_ITEM, self.chooseWarshipData, 1)
                    table.insert(self.daoArtifactData, data)
                end
                table.insert(self.allData, data)
            end
        end

        local showData = {}
        if self.filterType == PnlRoutes.FILTER_TYPE_ALL then
            showData = self.allData
        elseif self.filterType == PnlRoutes.FILTER_TYPE_WARSHIP then
            showData = self.warshipData
        elseif self.filterType == PnlRoutes.FILTER_TYPE_HERO then
            showData = self.heroData
        elseif self.filterType == PnlRoutes.FILTER_TYPE_TOWER then
            showData = self.buildData
        elseif self.filterType == PnlRoutes.FILTER_TYPE_DAO_ITEM then
            showData = self.daoArtifactData
        elseif self.filterType == PnlRoutes.FILTER_TYPE_NFT_ITEM then
            showData = self.nftItemData
        end
        QuickSort.quickSort(showData, "sort", 1, #showData, "up")
        self:makeBtnNftInRoutes(view:Find("ViewNft/ScrollView/Viewport/Content"), showData, type)

    end

end

function PnlRoutes:makeBtnNftInRoutes(content, allData, type)
    self:destoryBtnNftInRoutes()
    self:stopAllTimer()

    local startX = 15
    local startY = -15
    local nextX = 200
    local nextY = -200
    local index = 0

    for k, v in pairs(allData) do
        local temp = index
        local data = v
        ResMgr:LoadGameObjectAsync("BtnNftInRoutes", function(obj)
            local posX = startX + (temp % 5) * nextX
            local posY = startY + math.floor((temp / 5)) * nextY

            obj.transform:SetParent(content, false)
            obj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(posX, posY)
            self:setBtnNftInRoutesData(obj, data, type, temp)

            self.nftBtnList[data.id] = obj

            CS.UIEventHandler.Get(obj):SetOnClick(function()
                self:onBtnChooseNft(data, obj, type)
            end)

            return true
        end, true)
        index = index + 1
    end
    local height = math.ceil((index / 5)) * nextY + startY
    content:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, -height)

    self:refreshAttr(allData[1], type)
end

function PnlRoutes:setBtnNftInRoutesData(obj, data, type, temp)
    local myCfg = {}
    local icon = ""

    if temp == 0 then
        obj.transform:Find("Choose").gameObject:SetActive(true)
    else
        obj.transform:Find("Choose").gameObject:SetActive(false)
    end

    if data.itemType == PnlRoutes.FILTER_TYPE_WARSHIP then
        myCfg = cfg.getCfg("warShip", data.cfgId, data.level, data.quality)
        icon = gg.getSpriteAtlasName("Warship_A_Atlas", myCfg.icon .. "_A")
        obj.transform:Find("IconTop").gameObject:SetActiveEx(false)
    elseif data.itemType == PnlRoutes.FILTER_TYPE_HERO then
        myCfg = cfg.getCfg("hero", data.cfgId, data.level, data.quality)
        icon = gg.getSpriteAtlasName("Hero_A_Atlas", myCfg.icon .. "_A")
    elseif data.itemType == PnlRoutes.FILTER_TYPE_TOWER then
        myCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
        icon = gg.getSpriteAtlasName("Build_A_Atlas", myCfg.icon .. "_A")
        obj.transform:Find("IconTop").gameObject:SetActiveEx(false)
    elseif data.itemType == PnlRoutes.FILTER_TYPE_DAO_ITEM or data.itemType == PnlRoutes.FILTER_TYPE_NFT_ITEM then
        myCfg = cfg.getCfg("item", data.cfgId)
        icon = gg.getSpriteAtlasName("Item_Atlas", myCfg.icon)
        obj.transform:Find("IconTop").gameObject:SetActiveEx(false)
    end
    gg.setSpriteAsync(obj.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

    icon = string.format("Item_Bg_Atlas[%s]", "Item_Bg_" .. data.quality)
    gg.setSpriteAsync(obj.transform:GetComponent(UNITYENGINE_UI_IMAGE), icon)

    if type == 1 then
        obj.transform:Find("TxtColddown").gameObject:SetActive(true)
        obj.transform:Find("IconYes").gameObject:SetActive(false)
        obj.transform:Find("SliderLife").gameObject:SetActive(false)
        local fmt = {
            day = true,
            hour = true,
            min = false,
            sec = false
        }
        obj.transform:Find("TxtColddown"):GetComponent(UNITYENGINE_UI_TEXT).text =
            gg.time:dhms_string(myCfg.launchCD, fmt)
    else
        obj.transform:Find("TxtColddown").gameObject:SetActive(false)
        local isSelected = self:getIsSelected(data)
        obj.transform:Find("IconYes").gameObject:SetActive(isSelected)
        if data.curLife and data.life then
            local lifeValue = data.curLife / data.life
            obj.transform:Find("SliderLife").gameObject:SetActive(true)
            obj.transform:Find("SliderLife"):GetComponent(UNITYENGINE_UI_SLIDER).value = lifeValue
        else
            obj.transform:Find("SliderLife").gameObject:SetActive(false)
        end
    end

    if data.ref == 0 then
        obj.transform:Find("IconBan").gameObject:SetActive(false)
    else
        obj.transform:Find("IconBan").gameObject:SetActive(true)
        obj.transform:Find("IconBan/TxtCoolTime").gameObject:SetActive(false)
        obj.transform:Find("TxtColddown").gameObject:SetActive(false)
        -- print("aaaaaa", data.ref)
        if data.ref == 1 then
            obj.transform:Find("IconBan/TxtBan"):GetComponent(UNITYENGINE_UI_TEXT).text =
                Utils.getText("route_InRepair")
        elseif data.ref == 2 then
            obj.transform:Find("IconBan/TxtBan"):GetComponent(UNITYENGINE_UI_TEXT).text =
                Utils.getText("route_InBattle")
        elseif data.ref == 3 then
            if data.launchLessTick and data.launchLessTick == 0 then
                obj.transform:Find("IconBan/TxtBan"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                    "route_InTransit")
            else
                obj.transform:Find("IconBan/TxtBan"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                    "route_Cooling")
                obj.transform:Find("IconBan/TxtCoolTime").gameObject:SetActive(true)
                local timer = gg.timer:startLoopTimer(0, 1, -1, function()
                    local time = data.lessLaunchEnd - os.time()
                    obj.transform:Find("IconBan/TxtCoolTime"):GetComponent(UNITYENGINE_UI_TEXT).text =
                        gg.time:dhms_string(time)
                    if time <= 0 then
                        self:stopTimer(data.id)
                        obj.transform:Find("IconBan").gameObject:SetActive(false)
                    end
                end)
                self.timerList[data.id] = timer
            end
        elseif data.ref == 4 or data.ref == 5 or data.ref == 6 then
            obj.transform:Find("IconBan/TxtBan"):GetComponent(UNITYENGINE_UI_TEXT).text =
                Utils.getText("route_InBattle")
        elseif data.ref == 7 then
            obj.transform:Find("IconBan/TxtBan"):GetComponent(UNITYENGINE_UI_TEXT).text =
                Utils.getText("route_Training")
        elseif data.ref == 11 then
            obj.transform:Find("IconBan/TxtBan"):GetComponent(UNITYENGINE_UI_TEXT).text =
                Utils.getText("route_InBattle")

        end
    end
end

function PnlRoutes:stopTimer(id)
    if self.timerList[id] then
        gg.timer:stopTimer(self.timerList[id])
        self.timerList[id] = nil
    end
end

function PnlRoutes:onRenderAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, self.attrDataList, self.showAttrMap, self.showCompareAttrMap)
end

function PnlRoutes:refreshAttr(newData, type)
    local view = self.view

    if newData then
        local myCfg = {}
        local data = newData

        view.transform:Find("ViewChoose/IcomBg").gameObject:SetActive(true)
        view.transform:Find("ViewChoose/BgMsg").gameObject:SetActive(true)
        view.transform:Find("ViewChoose/AttrScrollView").gameObject:SetActive(true)
        view.transform:Find("ViewChoose/ViewSkill").gameObject:SetActive(true)

        self.chooseData = data
        local icon

        if data.itemType == PnlRoutes.FILTER_TYPE_WARSHIP then
            self.attrDataList = constant.WARSHIP_SHOW_ATTR
            myCfg = cfg.getCfg("warShip", data.cfgId, data.level, data.quality)
            self.showAttrMap = WarshipUtil.getWarshipAttr(data.cfgId, data.quality, data.level, 0, data.curLife)
            icon = gg.getSpriteAtlasName("Warship_A_Atlas", myCfg.icon .. "_A")
            view.nftIconTop.gameObject:SetActiveEx(false)

        elseif data.itemType == PnlRoutes.FILTER_TYPE_HERO then
            self.attrDataList = constant.HERO_SHOW_ATTR
            myCfg = cfg.getCfg("hero", data.cfgId, data.level, data.quality)
            self.showAttrMap = HeroUtil.getHeroAttr(data.cfgId, data.level, data.quality)
            icon = gg.getSpriteAtlasName("Hero_A_Atlas", myCfg.icon .. "_A")

        elseif data.itemType == PnlRoutes.FILTER_TYPE_TOWER then
            self.attrDataList = constant.BUILD_SHOW_ATTR
            myCfg = cfg.getCfg("build", data.cfgId, data.level, data.quality)
            self.showAttrMap = BuildUtil.getBuildAttr(data.cfgId, data.level, data.quality, 0)
            icon = gg.getSpriteAtlasName("Build_A_Atlas", myCfg.icon .. "_A")
            view.nftIconTop.gameObject:SetActiveEx(false)
        elseif data.itemType == PnlRoutes.FILTER_TYPE_DAO_ITEM or data.itemType == PnlRoutes.FILTER_TYPE_NFT_ITEM then
            view.nftIconTop.gameObject:SetActiveEx(false)
            myCfg = cfg.getCfg("item", data.cfgId)
            icon = gg.getSpriteAtlasName("Item_Atlas", myCfg.icon)
        end

        gg.setSpriteAsync(view.nftIcon, icon)

        view.txtLevel.text = data.level
        view.txtOriLevel.text = data.level
        view.txtName.text = Utils.getText(myCfg.languageNameID)
        view.txtHash.text = "#" .. data.id

        if data.itemType == PnlRoutes.FILTER_TYPE_DAO_ITEM or data.itemType == PnlRoutes.FILTER_TYPE_NFT_ITEM then
            self.view.attrScrollView.gameObject:SetActiveEx(false)
        else
            self.view.attrScrollView.gameObject:SetActiveEx(true)

            self.showCompareAttrMap = nil -- WarshipUtil.getWarshipAttr(data.cfgId, data.quality, data.level + 1, 0)

            local itemCount = #self.attrDataList
            local scrollViewLenth = AttrUtil.getAttrScrollViewLenth(itemCount)

            self.attrScrollView:setItemCount(#self.attrDataList)

            self.attrScrollView.transform:SetRectSizeY(scrollViewLenth)
        end

        self:setViewSkill(true, data, myCfg)

        if type == 2 then
            local isSelected = self:getIsSelected(data)
            self.view.btnSelelcted:SetActive(not isSelected)
            self.view.btnDesSelelct:SetActive(isSelected)
        end
    else

        view.transform:Find("ViewChoose/IcomBg").gameObject:SetActive(false)
        view.transform:Find("ViewChoose/BgMsg").gameObject:SetActive(false)
        view.transform:Find("ViewChoose/AttrScrollView").gameObject:SetActive(false)
        view.transform:Find("ViewChoose/ViewSkill").gameObject:SetActive(false)
        view.btnSelelcted:SetActive(false)
        view.btnDesSelelct:SetActive(false)

    end

end

function PnlRoutes:getIsSelected(data)
    local isSelected = false
    for k, v in pairs(self.chooseNftData) do
        if data.id == v.id then
            isSelected = true
            break
        end
    end
    return isSelected
end

function PnlRoutes:setViewSkill(isShow, newData, myCfg)
    local view = self.view

    if not isShow then
        view.viewSkill:SetActiveEx(false)
        return
    end

    local data = newData
    local myCfg = myCfg
    if data.itemType ~= PnlRoutes.FILTER_TYPE_WARSHIP and data.itemType ~= PnlRoutes.FILTER_TYPE_HERO then
        myCfg = nil
    end

    if data and myCfg then
        view.viewSkill:SetActiveEx(true)
        for i = 1, 5 do
            if data["skill" .. i] then
                local skillCfgId = data["skill" .. i]
                if skillCfgId and skillCfgId > 0 then
                    local level = data["skillLevel" .. i]
                    local skillCfg = SkillUtil.getSkillCfgMap()[skillCfgId][level]
                    self:setSkillWindow(i, level, skillCfg)
                else
                    self:setSkillWindow(i)
                end
            else
                self:setSkillWindow(i)
            end
        end
    else
        view.viewSkill:SetActiveEx(false)
    end

end

function PnlRoutes:setSkillWindow(temp, level, skillCfg)
    local skill = self.btnSkillTable[temp]
    skill.obj:SetActiveEx(true)
    self.btnSkillTable[temp].skillCfg = skillCfg

    if not skillCfg then
        skill.obj.transform:Find("IconQuestion").gameObject:SetActive(true)
        skill.commonItemItem:setActive(false)
        skill.layoutSlider:SetActiveEx(false)
        return
    end

    skill.commonItemItem:setActive(true)
    skill.commonItemItem:initInfo()
    skill.commonItemItem:setLevel(level)
    local icon = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")

    skill.commonItemItem:setIcon(icon)

    if self.warshipData.skillUp == temp then
        skill.layoutSlider:SetActiveEx(true)
    else
        skill.layoutSlider:SetActiveEx(false)
    end

    if self.showingType == PnlWarShip.VIEW_UPGRADE then
        skill.commonItemItem:setImgArrowActive(WarshipUtil.checkIsCanUpgradeWarshipSkill(skillCfg))
    end
end

function PnlRoutes:setBgTips()
    -- local cueWarshipCfg = cfg.getCfg("warShip", self.chooseWarshipData.cfgId, self.chooseWarshipData.level,
    --     self.chooseWarshipData.quality)
    local view = self.view

    if self.transportType == PnlRoutes.TRANSPORT_TYPE_HY then
        self.view.hy:SetActiveEx(true)
        self.view.mit:SetActiveEx(true)
        self.view.nft:SetActiveEx(false)

        local fmt = {
            day = true,
            hour = true,
            min = false,
            sec = false
        }
        local date = gg.time.dhms_time(fmt, self.withdrawCD)
        view.txtTips1.text = string.format(Utils.getText("route_QueryTxtOne"), date.day)

        local hyt = tonumber(self.view.inputFieldHydroxyl.text) or 0
        view.txtTipHydroxyl.text = math.max(0, hyt - tonumber(self.view.txtFreight.text))

        local mit = tonumber(self.view.inputFieldMit.text) or 0
        view.txtTipMit.text = mit

    elseif  self.transportType == PnlRoutes.TRANSPORT_TYPE_NFT then
        self.view.hy:SetActiveEx(false)
        self.view.mit:SetActiveEx(false)
        self.view.nft:SetActiveEx(true)

        view.txtTips1.text = Utils.getText("route_QueryTxtTwo")

        local nftCount = 0
        for k, v in pairs(self.chooseNftData) do
            nftCount = nftCount + 1
        end
        view.txtTipNft.text = nftCount
    end

    -- "Once confirmed,you battlesship will be in transit for %s hour,the battleship cannot be transported or traded until the cooldown is complete."
end

function PnlRoutes:setViewRecord()
    self:destoryBoxRecord()

    local startX = 0
    local startY = 0
    local nextY = -82
    local index = 0
    local content = self.view.transform:Find("ViewRoute/ViewRecord/Scroll View/Viewport/Content")

    for k, v in pairs(ChainBridgeData.launchBridgeRecrods) do
        local temp = index
        local data = v
        ResMgr:LoadGameObjectAsync("BoxRecord", function(obj)
            local posY = startX + temp * nextY

            obj.transform:SetParent(content, false)
            obj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(startX, posY)

            local time = os.date("!%Y-%m-%d %H:%M:%S", data.time)
            -- local time = os.date("!%c", data.time)

            local mit = data.mit / 1000
            local hyt = data.hyt / 1000
            local nftCount = 0
            for k, v in pairs(data.tokenIds) do
                nftCount = nftCount + 1
            end
            for k, v in pairs(data.itemIds) do
                nftCount = nftCount + 1
            end

            obj.transform:Find("txtTime"):GetComponent(UNITYENGINE_UI_TEXT).text = time
            obj.transform:Find("txtMit"):GetComponent(UNITYENGINE_UI_TEXT).text = mit
            obj.transform:Find("txtHydoxyL"):GetComponent(UNITYENGINE_UI_TEXT).text = hyt
            obj.transform:Find("txtNft"):GetComponent(UNITYENGINE_UI_TEXT).text = nftCount

            table.insert(self.boxRecordList, obj)
            return true
        end, true)
        index = index + 1
    end

    local height = (index + 1) * nextY
    content:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, -height)

end

return PnlRoutes
