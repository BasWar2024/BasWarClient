PnlPlayerInformation = class("PnlPlayerInformation", ggclass.UIBase)
PnlPlayerInformation.closeType = ggclass.UIBase.CLOSE_TYPE_NONE

PnlPlayerInformation.BTN_INFORMATION = 1
PnlPlayerInformation.BTN_UPGRAD = 2
PnlPlayerInformation.BTN_EXCHANGE = 3
PnlPlayerInformation.BTN_FARMING = 4
PnlPlayerInformation.BTN_HEROCLUB = 5
PnlPlayerInformation.BTN_PEOPLE = 6
PnlPlayerInformation.BTN_PIT = 7
PnlPlayerInformation.BTN_RESEARCH = 8
PnlPlayerInformation.BTN_RECYCLE = 9
PnlPlayerInformation.BTN_SHOVEL = 10
PnlPlayerInformation.BTN_REFUSED = 11
PnlPlayerInformation.BTN_ACCEPT = 12
PnlPlayerInformation.BTN_EDIT_ARMY = 13
PnlPlayerInformation.BTN_SHRINE = 14
PnlPlayerInformation.BTN_REBACK = 15


PnlPlayerInformation.btnBuildToolInfo = {
    [PnlPlayerInformation.BTN_INFORMATION] = {
        icon = "Information_icon",
        text = "main_BuildIcon_Info",
        event = "onBtnInformation"
    },
    [PnlPlayerInformation.BTN_UPGRAD] = {
        icon = "Ungrade_icon",
        text = "main_BuildIcon_Upgrade",
        event = "onBtnUpgrade"
    },
    [PnlPlayerInformation.BTN_EXCHANGE] = {
        icon = "Exchange_icon",
        text = "main_BuildIcon_Exchange",
        event = "onBtnExchange"
    },
    [PnlPlayerInformation.BTN_FARMING] = {
        icon = "Farming_icon",
        text = "main_BuildIcon_Train",
        event = "onBtnFarming"
    },
    [PnlPlayerInformation.BTN_HEROCLUB] = {
        icon = "Hero club_icon",
        text = "main_BuildIcon_Info",
        event = "onBtnHeroClub"
    },
    [PnlPlayerInformation.BTN_PEOPLE] = {
        icon = "People_icon",
        text = "main_BuildIcon_Info",
        event = "onBtnPeople"
    },
    [PnlPlayerInformation.BTN_PIT] = {
        icon = "Pit_icon",
        text = "main_BuildIcon_Info",
        event = "onBtnPit"
    },
    [PnlPlayerInformation.BTN_RESEARCH] = {
        icon = "Research institute_icon",
        text = "main_BuildIcon_Research",
        event = "onBtnResearchInstitute"
    },
    [PnlPlayerInformation.BTN_RECYCLE] = {
        icon = "Recycle_icon",
        text = "main_BuildIcon_Retrieve",
        event = "onBtnRecycle"
    },

    [PnlPlayerInformation.BTN_SHOVEL] = {
        icon = "Shovel_icon",
        text = "main_BuildIcon_Remove",
        event = "onBtnShovel"
    },
    [PnlPlayerInformation.BTN_REFUSED] = {
        icon = "Refused_icon",
        text = "main_BuildIcon_Cancel",
        event = "onBtnRefused"
    },
    [PnlPlayerInformation.BTN_ACCEPT] = {
        icon = "Accept_icon",
        text = "main_BuildIcon_Confirm",
        event = "onBtnAccept"
    },
    [PnlPlayerInformation.BTN_EDIT_ARMY] = {
        icon = "People_icon",
        text = "main_BuildIcon_Formation",
        event = "onBtnEditArmy"
    },
    [PnlPlayerInformation.BTN_SHRINE] = {
        icon = "Addition_icon",
        text = "main_BuildIcon_Shrine",
        event = "onBtnShrine"
    },
    [PnlPlayerInformation.BTN_REBACK] = {
        icon = "reback_icon",
        text = "main_BuildIcon_Recycle",
        event = "onBtnReback"
    }
}

function PnlPlayerInformation:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.information
    self.events = {"onVipPledgeChange", "onPlayerInfoChange", "onShowPlayerInfo", "onSetOtherPlayerInfo",
                   "onViewOpenOrHide", "onResAniFinishOnce", "onResAnimation", "onShowNovice", "onFlyResAnimEnd",
                   "onRefreshResTxt", "onShowBuildButton", "onShowBuildButtonAccept", "onEditModeChange",
                   "onDelayChange", "onRefreshBuildNum", "onShowPlanetInformation", "onUnionPersonGridsChange",
                   "onOnlyHyMit"}

    self.starCion = 0
    self.gas = 0
    self.titanium = 0
    self.ice = 0
    self.carboxyl = 0
    self.showResType = 0

    self.showingResCountMap = {}
    self.resStartAnimationMap = {}
    self.playingResAniMap = {}
    self.playingResIconAniMap = {}

    self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE

end

function PnlPlayerInformation:onAwake()
    self.view = ggclass.PnlPlayerInformationView.new(self.transform)
    local view = self.view
end

function PnlPlayerInformation:onShow()
    self:bindEvent()

    self:setBoxBuildButton()

    self:setTxtPlayerName(PlayerData.getName())

    for key, value in pairs(constant.RES_2_CFG_KEY) do
        self:setResText(key, ResData.getRes(key))
    end

    self:refreshPvpScore()
    self:refreshHeadIcon()
    self:refreshImgChain()
    self.isShowBox = false
    self:showBoxResDetailed(self.isShowBox)
    self:onVipPledgeChange()
    self:closeOtherPlayerInfo()
    self:onShowBuildButton(nil, false)
    self:onEditModeChange()

    self:onViewOpenOrHide()

    self:setDelay(gg.client.gameServer.delay)

    self:onOnlyHyMit(_, false)

    self:refreshAudit()
end

function PnlPlayerInformation:refreshAudit()
    local view = self.view
    if IsAuditVersion() then
        view.mit:SetActiveEx(false)
        view.carboxyl:SetActiveEx(false)
        -- view.btnTesseract:SetActiveEx(false)

        view.btnStartCoinAdd:SetActiveEx(false)
        view.btnTitaniumAdd:SetActiveEx(false)
        view.btnGasAdd:SetActiveEx(false)
        view.btnStartCoinAdd:SetActiveEx(false)
        view.btnIceAdd:SetActiveEx(false)
        view.btnVip:SetActiveEx(false)
        
    end
end

function PnlPlayerInformation:onDelayChange(_, delay)
    self:setDelay(delay)
end

function PnlPlayerInformation:setDelay(delay)
    delay = delay or 0
    delay = math.min(999, delay)
    self.view.txtDelay.text = delay .. "ms"

    if delay < 150 then
        gg.setSpriteAsync(self.view.imgDelay, "Common_Atlas[WiFi_icon_A]")

        -- self.view.txtDelay.color = CS.UnityEngine.Color.green
    elseif delay < 450 then
        gg.setSpriteAsync(self.view.imgDelay, "Common_Atlas[WiFi_icon_B]")
        -- self.view.txtDelay.color = CS.UnityEngine.Color.yellow
    else
        gg.setSpriteAsync(self.view.imgDelay, "Common_Atlas[WiFi_icon_C]")
        -- self.view.txtDelay.color = CS.UnityEngine.Color.red
    end
end

function PnlPlayerInformation:onPlayerInfoChange()
    self:setTxtPlayerName(PlayerData.getName())
    self:refreshHeadIcon()
    self:refreshPvpScore()
    self:refreshImgChain()

end

function PnlPlayerInformation:onHide()
    self:releaseEvent()
    self:releaseBoxBuildButton()
end

function PnlPlayerInformation:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnMit):SetOnClick(function()
        self:onBtnMit()
    end)
    CS.UIEventHandler.Get(view.btnCarboxyl):SetOnClick(function()
        self:onBtnMit()
    end)
    CS.UIEventHandler.Get(view.btnStartCoin):SetOnClick(function()
        self:onBtnRes(constant.RES_STARCOIN, view.btnStartCoin)
    end)
    CS.UIEventHandler.Get(view.btnGas):SetOnClick(function()
        self:onBtnRes(constant.RES_GAS, view.btnGas)
    end)
    CS.UIEventHandler.Get(view.btnTitanium):SetOnClick(function()
        self:onBtnRes(constant.RES_TITANIUM, view.btnTitanium)
    end)
    CS.UIEventHandler.Get(view.btnIce):SetOnClick(function()
        self:onBtnRes(constant.RES_ICE, view.btnIce)
    end)

    self:setOnClick(view.tesseract, gg.bind(self.onBtnRes, self, constant.RES_TESSERACT, view.iconTesseract))

    -- CS.UIEventHandler.Get(view.btnLevel):SetOnClick(function()
    --     self:onBtnLevel()
    -- end)
    CS.UIEventHandler.Get(view.btnPlayerName):SetOnClick(function()
        self:onBtnPlayerName()
    end)
    self:setOnClick(view.playerInformation.gameObject, gg.bind(self.onBtnPlayerName, self))

    -- CS.UIEventHandler.Get(view.btnPvpScore):SetOnClick(function()
    --     self:onBtnPvpScore()
    -- end)
    self:setOnClick(view.mit, gg.bind(self.onBtnRes, self, constant.RES_MIT, view.iconMit))
    self:setOnClick(view.carboxyl, gg.bind(self.onBtnRes, self, constant.RES_CARBOXYL, view.carboxyl))

    self:setOnClick(view.btnVip, gg.bind(self.onBtnVip, self))
    self:setOnClick(view.btnTesseract, gg.bind(self.onBtnChangeRes, self, constant.RES_TESSERACT))
    self:setOnClick(view.btnStartCoinAdd, gg.bind(self.onBtnChangeRes, self, constant.RES_STARCOIN))
    self:setOnClick(view.btnGasAdd, gg.bind(self.onBtnChangeRes, self, constant.RES_GAS))
    self:setOnClick(view.btnTitaniumAdd, gg.bind(self.onBtnChangeRes, self, constant.RES_TITANIUM))
    self:setOnClick(view.btnIceAdd, gg.bind(self.onBtnChangeRes, self, constant.RES_ICE))

    gg.event:addListener("onHideBoxResDetailed", self)
    gg.event:addListener("onShowPlayerInformation", self)

end

function PnlPlayerInformation:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnMit)
    CS.UIEventHandler.Clear(view.btnStartCoin)
    CS.UIEventHandler.Clear(view.btnGas)
    CS.UIEventHandler.Clear(view.btnTitanium)
    CS.UIEventHandler.Clear(view.btnIce)
    CS.UIEventHandler.Clear(view.btnCarboxyl)
    CS.UIEventHandler.Clear(view.btnPlayerName)
    -- CS.UIEventHandler.Clear(view.btnPvpScore)

    gg.event:removeListener("onShowPlayerInformation", self)
    gg.event:removeListener("onHideBoxResDetailed", self)

end

function PnlPlayerInformation:onDestroy()
    local view = self.view
    for key, value in pairs(self.playingResIconAniMap) do
        if value and value.DOKill then
            value:DOKill()
            self.playingResIconAniMap[key] = nil
        end
    end
end

function PnlPlayerInformation:onBtnMit()
    -- ResData.C2S_Player_Exchange_Rate(ResData.TIP_TYPE_EXCHANGE_CARBOXYL)
    -- gg.uiManager:openWindow("PnlShop")
end

function PnlPlayerInformation:onBtnChangeRes(resId)
    -- ResData.C2S_Player_Exchange_Rate(ResData.TIP_TYPE_EXCHANGE_TESSERACT)
    local res2Type = {
        [constant.RES_TESSERACT] = PnlShop.TYPE_TESSRACT_BUY,
        [constant.RES_STARCOIN] = PnlShop.TYPE_EXCHANGE_RES,
        [constant.RES_GAS] = PnlShop.TYPE_EXCHANGE_RES,
        [constant.RES_TITANIUM] = PnlShop.TYPE_EXCHANGE_RES,
        [constant.RES_ICE] = PnlShop.TYPE_EXCHANGE_RES
    }
    local args = {
        shopType = res2Type[resId],
        resId = resId
    }
    gg.uiManager:openWindow("PnlShop", args)
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnRes(resType, targetObj)
    if not self.isShowBox or self.showResType ~= resType then
        self.isShowBox = true
    else
        self.isShowBox = false
    end
    self.showResType = resType
    self:showBoxResDetailed(self.isShowBox, resType, targetObj)
end

function PnlPlayerInformation:onBtnLevel()
    gg.uiManager:showTip("currently unavailable")
end

function PnlPlayerInformation:onBtnPlayerName()
    gg.uiManager:openWindow("PnlPlayerDetailed")
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnPvpScore()
    gg.uiManager:showTip("currently unavailable")
end

function PnlPlayerInformation:onBtnVip()
    gg.uiManager:openWindow("PnlPledge")
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onVipPledgeChange()

    if not VipData.vipData or not next(VipData.vipData) then
        return 
    end

    self.view.txtVip.text = VipData.vipData.vipLevel
    local vipIcon = "VIP_icon_" .. VipData.vipData.vipLevel
    local icon = gg.getSpriteAtlasName("Pledge_Atlas", vipIcon)
    -- gg.setSpriteAsync(self.view.imgVipIcon, icon)
end

function PnlPlayerInformation:setTxtPlayerName(txt)
    self.view.txtPlayerName.text = txt
end

function PnlPlayerInformation:refreshPvpScore()
    self.view.txtPvpScore.text = PlayerData.myInfo.badge
end

function PnlPlayerInformation:refreshHeadIcon()
    gg.setSpriteAsync(self.view.iconHead, Utils.getHeadIcon(PlayerData.myInfo.headIcon))
end

function PnlPlayerInformation:refreshImgChain()
    self.view.imgChain.gameObject:SetActiveEx(false)
    local chain = PlayerData.chainId
    local chainName = constant.getNameByChain(chain)
    if chainName ~= "NONE" and chainName ~= "UNKNOW" then
        gg.setSpriteAsync(self.view.imgChain, constant.CHAIN_ICON_NAME[chainName], function(image, sprite)
            image.sprite = sprite
            image.color = Color.New(1, 1, 1, 1)
            image:SetNativeSize()
            image.gameObject:SetActiveEx(true)
        end)
    end
end

function PnlPlayerInformation:onRefreshResTxt(args, resCfgId, count)
    if self.resStartAnimationMap[resCfgId] then
        return
    end

    self:refreshRes(resCfgId, count)
end

function PnlPlayerInformation:refreshRes(resCfgId, count)
    if resCfgId == constant.RES_BADGE then
    else
        self:setResText(resCfgId, count)
    end
end

function PnlPlayerInformation:onShowPlayerInfo(args, bool)
    self.view.transform:Find("PlayerInformation").gameObject:SetActive(bool)
    self:onShowNovice()
end

function PnlPlayerInformation:onShowNovice()
    -- self.view.transform:Find("PlayerInformation/Novice").gameObject:SetActive(false)
    -- if gg.buildingManager:getOwnBase().buildData.level > 5 then
    --     self.view.transform:Find("PlayerInformation/Novice").gameObject:SetActive(false)
    -- else
    --     self.view.transform:Find("PlayerInformation/Novice").gameObject:SetActive(true)
    -- end
end

PnlPlayerInformation.RES_NAME = {
    [constant.RES_STARCOIN] = "Star Coin",
    [constant.RES_GAS] = "Gas",
    [constant.RES_TITANIUM] = "Titanium",
    [constant.RES_ICE] = "Ice",
    [constant.RES_CARBOXYL] = "Hydroxyl"
}

function PnlPlayerInformation:onHideBoxResDetailed(BoxResDetailed)
    self.isShowBox = false
    self:showBoxResDetailed(self.isShowBox)
end

function PnlPlayerInformation:onUnionPersonGridsChange()
    if self.isShowingResDetail then
        self:showBoxResDetailed(self.isShowingResDetail, self.showingResTypeDetail, self.targetObjResDetail)
    end
end

function PnlPlayerInformation:showBoxResDetailed(bool, resType, targetObj)
    local view = self.view
    view.boxResDetailed.gameObject:SetActive(bool)

    self.isShowingResDetail = bool
    self.showingResTypeDetail = resType
    self.targetObjResDetail = targetObj

    if not bool then
        return
    end

    local pos = self.pnlTransform:InverseTransformPoint(targetObj.transform.position)
    view.boxResDetailed.anchoredPosition = Vector2.New(pos.x, pos.y - view.boxResDetailed.rect.height / 2 - 70)
    view.txtType.text = Utils.getText(constant.RES_2_CFG_KEY[resType].languageKey)

    view.boxDetailedTextMap.count.text.text = string.format("%.0f", ResData.getRes(resType) / 1000) -- Utils.getShowRes(ResData.getRes(resType))
    if resType == constant.RES_MIT or resType == constant.RES_CARBOXYL or resType == constant.RES_TESSERACT then
        view.layoutTexts:SetActiveEx(false)
        view.scrollViewDesc.transform:SetActiveEx(true)
        if resType == constant.RES_MIT then
            -- view.txtBoxResDetailedDesc.text = Utils.getText("mit_desc")
            view.txtBoxResDetailedDesc:SetLanguageKey("mit_desc")
        elseif resType == constant.RES_CARBOXYL then
            -- view.txtBoxResDetailedDesc.text = Utils.getText("hy_desc")
            view.txtBoxResDetailedDesc:SetLanguageKey("hy_desc")
        elseif resType == constant.RES_TESSERACT then
            view.txtBoxResDetailedDesc:SetLanguageKey("tess_desc")
        end
    else

        view.layoutTexts:SetActiveEx(true)
        view.scrollViewDesc.transform:SetActiveEx(false)
        local ratio = 3600 / cfg.global.BaseMakeResCD.intValue
        -- local base = gg.buildingManager.perMakeRes[resType] * ratio
        -- local planet = gg.galaxyManager.productionRes[resType] * 2 / 1000

        local storage = gg.buildingManager.resMax[resType]
        -- local protect = gg.buildingManager:getBlackHoleVaultProtect() * ResData.getRes(resType)
        local protect =  gg.buildingManager:getBlackHoleVaultProtect() * storage

        local baseProduction = gg.buildingManager.perMakeRes[resType] * ratio
        local unionProduct = 0
        if UnionData.starmapMatchPersonalGrids then

            for _, grid in pairs(UnionData.starmapMatchPersonalGrids.list) do
                local gridCfg = gg.galaxyManager:getGalaxyCfg(grid.gridCfgId)
                -- print("aaaaa", grid.gridCfgId)
                for key, value in pairs(gridCfg.perMakeRes) do

                    if value[1] == resType then
                        unionProduct = unionProduct + value[2] * 3600 / cfg.global.LeagueMakeResCD.intValue
                    end
                end
            end
        end

        view.boxDetailedTextMap.product.text.text = Utils.getShowRes(baseProduction + unionProduct)
        view.boxDetailedTextMap.baseProduct.text.text = Utils.getShowRes(baseProduction)
        view.boxDetailedTextMap.unionProduct.text.text = Utils.getShowRes(unionProduct)

        view.boxDetailedTextMap.storage.text.text = Utils.getShowRes(storage)
        view.boxDetailedTextMap.protect.text.text = Utils.getShowRes(protect)
    end
end

function PnlPlayerInformation:onSetOtherPlayerInfo(event, isShow, info, isPlanet)
    self.isShowingOther = isShow
    self.isPlanet = isPlanet

    if not isShow then
        self.isPlanet = isPlanet
        self:closeOtherPlayerInfo()
        self:onViewOpenOrHide()
        return
    end
    local view = self.view
    self.transform:SetActiveEx(true)

    self:onViewOpenOrHide()
    if isPlanet then
        local cueCfg = gg.galaxyManager:getGalaxyCfg(info.cfgId)

        view.bg:SetActiveEx(false)
        view.playerInformation:SetActiveEx(false)
        view.otherPlayerInformation:SetActiveEx(false)
        self.isPlanet = isShow
        view.planetInformation:SetActiveEx(true)
        view.txtPlanet.text = cueCfg.name
        if info.owner then
            view.bgOwner:SetActiveEx(true)
            view.txtOwner.text = info.owner.playerName
        else
            view.bgOwner:SetActiveEx(false)
        end
        if cueCfg.perMakeRes[1] then
            view.bgYield:SetActiveEx(true)
            local resId = cueCfg.perMakeRes[1][1]
            local resIconName = gg.getSpriteAtlasName("ResIcon_E_Atlas",
                constant.RES_2_CFG_KEY[resId].iconNameHead .. "E1")
            gg.setSpriteAsync(view.imgYield, resIconName)
            local globalCfg = cfg["global"]

            local makeResTime = globalCfg.LeagueMakeResCD.intValue
            if cueCfg.belongType == 1 then
                makeResTime = globalCfg.LeagueMakeHYCD.intValue
            end
            local makeRes = cueCfg.perMakeRes[1][2]

            local perMakeRes = makeRes / 1000 * (3600 / makeResTime)

            view.txtYield.text = string.format("%0.0f /h", perMakeRes)
        else
            view.bgYield:SetActiveEx(false)
        end
        if cueCfg.point > 0 then
            local point = cueCfg.point * 3600 / cfg.global.StarMakePointCD.intValue
            view.bgPoints:SetActiveEx(true)
            view.txtPoints.text = string.format("%0.0f /h", point)
        else
            view.bgPoints:SetActiveEx(false)
        end
        self.buildNum = 0
        self.towerCount = cueCfg.towerCount
        for k, v in pairs(info.builds) do
            if v.isNormal or v.chain > 0 then
                self.buildNum = self.buildNum + 1
            end
        end
        view.txtDefenses.text = string.format("%s/%s", self.buildNum, self.towerCount)

    else
        if info then
            view.bg:SetActiveEx(true)

            view.playerInformation:SetActiveEx(false)
            view.otherPlayerInformation:SetActiveEx(true)
            view.planetInformation:SetActiveEx(false)
            view.txtOtherName.text = info.playerName
            view.txtOtherScore.text = info.playerScore
            gg.setSpriteAsync(view.imgOtherPlayerHead, Utils.getHeadIcon(info.playerHead))
        end
    end
end

function PnlPlayerInformation:onShowPlanetInformation(args, bool)
    self.view.planetInformation:SetActiveEx(bool)
end

function PnlPlayerInformation:onRefreshBuildNum(args, index)
    self.buildNum = self.buildNum + index
    self.view.txtDefenses.text = string.format("%s/%s", self.buildNum, self.towerCount)
end

function PnlPlayerInformation:onViewOpenOrHide(_, openOrHideView)
    local view = self.view

    -- if self.isShowingOther then
    --     return
    -- end

    if openOrHideView and openOrHideView.layer >= self.layer then
        return
    end

    local upperView = nil
    for key, value in pairs(gg.uiManager.openWindows) do
        if value.layer < self.layer then
            if not upperView then
                upperView = value
            else
                if value.layer > upperView.layer then
                    upperView = value
                elseif upperView.transform and value.transform and upperView.transform:GetSiblingIndex() <
                    value.transform:GetSiblingIndex() then
                    upperView = value
                end
            end
        end
    end

    local showType = ggclass.UIBase.INFOMATION_NORMAL
    if upperView then
        showType = upperView.infomationType
    end
    
    if not IsAuditVersion() then
        view.mit:SetActiveEx(true)
        view.carboxyl:SetActiveEx(true)
    end

    if showType == ggclass.UIBase.INFOMATION_NORMAL then
        self.transform:SetActiveEx(true)
        view.playerInformation:SetActiveEx(true)
        view.resourceUI:SetActiveEx(true)
        view.bg:SetActiveEx(true)
        view.txtDelay:SetActiveEx(true)

        if self.isPlanet then
            view.planetInformation:SetActiveEx(true)
            view.otherPlayerInformation:SetActiveEx(false)
            view.playerInformation:SetActiveEx(false)
        else
            view.planetInformation:SetActiveEx(false)

            view.otherPlayerInformation:SetActiveEx(self.isShowingOther)
            view.playerInformation:SetActiveEx(not self.isShowingOther)
        end

    elseif showType == ggclass.UIBase.INFOMATION_HIDE then
        self.transform:SetActiveEx(false)

    elseif showType == ggclass.UIBase.INFOMATION_RES then
        self.transform:SetActiveEx(true)
        view.playerInformation:SetActiveEx(false)
        view.otherPlayerInformation:SetActiveEx(false)

        view.resourceUI:SetActiveEx(true)
        view.bg:SetActiveEx(false)

        view.txtDelay:SetActiveEx(false)
        view.planetInformation:SetActiveEx(false)

    elseif showType == ggclass.UIBase.INFOMATION_BASE_RES then
        self.transform:SetActiveEx(true)
        view.playerInformation:SetActiveEx(false)
        view.otherPlayerInformation:SetActiveEx(false)

        view.resourceUI:SetActiveEx(true)
        view.bg:SetActiveEx(false)

        view.txtDelay:SetActiveEx(false)

        view.mit:SetActiveEx(false)
        view.carboxyl:SetActiveEx(false)

        view.planetInformation:SetActiveEx(false)

    end
end

function PnlPlayerInformation:closeOtherPlayerInfo()
    local view = self.view
    view.bg:SetActiveEx(true)
    view.playerInformation:SetActiveEx(true)
    view.otherPlayerInformation:SetActiveEx(false)
    view.planetInformation:SetActiveEx(false)

end

function PnlPlayerInformation:onShowPlayerInformation(args, bool)
    self.view.playerInformation.gameObject:SetActive(bool)
end

PnlPlayerInformation.lastDuration = 0.5
function PnlPlayerInformation:playResAni(resType, resPerObj, index, loadCount, flyId)
    local endCallBack = function()
        if index == loadCount and flyId == gg.resEffectManager.fly3dRes2TargetOnPnlPlayerInformationId then
            self.resStartAnimationMap = {}
            for key, value in pairs(constant.RES_2_CFG_KEY) do
                self:refreshRes(key, -1)
            end
        end
    end

    if self.playingResAniMap[resType] then
        self.playingResAniMap[resType]:Complete()
        self.playingResAniMap[resType] = nil
    end

    local sequence = CS.DG.Tweening.DOTween.Sequence()
    self.playingResAniMap[resType] = sequence
    local beginValue = self.showingResCountMap[resType] or 0
    local endValue = beginValue + resPerObj
    local duration = ResEffectManager.FLY_2_TARGET_Inteval

    if index == loadCount then
        duration = PnlPlayerInformation.lastDuration
    end

    if index == loadCount and flyId == gg.resEffectManager.fly3dRes2TargetOnPnlPlayerInformationId then
        endValue = ResData.getRes(resType)
    end

    local getter = function()
        return beginValue
    end
    local setter = function(value)
        self:refreshRes(resType, math.min(math.ceil(value), ResData.getRes(resType)))
    end
    sequence:Append(CS.DG.Tweening.DOTween.To(getter, setter, endValue, duration))
    sequence:AppendCallback(endCallBack)
end

function PnlPlayerInformation:setResText(resType, count)
    if count < 0 then
        count = ResData.getRes(resType)
    end
    self.showingResCountMap[resType] = count

    if resType ~= constant.RES_BADGE or resType ~= constant.RES_ITEM then
        count = count / 1000
    end

    local showCount = string.upper(Utils.scientificNotationInt(count))

    if resType == constant.RES_MIT then
        self.view.txtMit.text = showCount

    elseif resType == constant.RES_CARBOXYL then
        self.view.txtCarboxyl.text = showCount

    elseif resType == constant.RES_TESSERACT then
        self.view.txtTesseract.text = showCount

    else
        if not self.view.resItemMap[resType] then
            return
        end

        self.view.resItemMap[resType].text.text = showCount
        if gg.buildingManager.resMax then
            local resMax = gg.buildingManager.resMax[resType] / 1000
            local percent = math.min(count / resMax, 1)
            self.view.resItemMap[resType].scrollbar.size = percent
            -- local bindPersent = math.min(ResData.bindResources[resType] / resMax, 1)

            local bindPersent
            if count > resMax then
                bindPersent = math.min(ResData.getRes(resType) / count, 1)
            else
                bindPersent = math.min(ResData.getRes(resType) / resMax, 1)
            end
            self.view.resItemMap[resType].imgUnBind.fillAmount = bindPersent
        end
    end
end

function PnlPlayerInformation:onResAnimation(event, args)
    if args.buildId > 0 or args.animationId == 1 or args.animationId == 2 or args.animationId == 3 or args.animationId ==
        4 then
        self.resStartAnimationMap[args.resCfgId] = true
    end
end

function PnlPlayerInformation:onResAniFinishOnce(args, resType, resPerObj, index, loadCount, flyId)
    if self.playingResIconAniMap[resType] then
        self.playingResIconAniMap[resType]:Complete()
        self.playingResIconAniMap[resType]:Kill()
        self.playingResIconAniMap[resType] = nil
    end
    local obj = self:getResFlyTargetObj(resType)
    obj.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    self.playingResIconAniMap[resType] = sequence

    -- local resAniData = ResEffectManager.res2Data[resType]
    -- AudioFmodMgr:Play2DOneShot(resAniData.audio.event, resAniData.audio.bank)

    sequence:Append(obj.transform:DOPunchScale(CS.UnityEngine.Vector3(1.2, 1.2, 1.2), 0.1):SetEase(CS.DG.Tweening.Ease
                                                                                                       .InSine))
    sequence:AppendCallback(function()
        obj.transform.localScale = CS.UnityEngine.Vector3(1, 1, 1)
        self.playingResIconAniMap[resType] = nil
    end)
    self:playResAni(resType, resPerObj, index, loadCount, flyId)
end

function PnlPlayerInformation:onFlyResAnimEnd()
    self.resStartAnimationMap = {}
    if index == loadCount and flyId == gg.resEffectManager.fly3dRes2TargetOnPnlPlayerInformationId then
        for key, value in pairs(constant.RES_2_CFG_KEY) do
            self:setResText(key, -1)
        end
    end
end

function PnlPlayerInformation:getResFlyTargetObj(resType)
    return self.view.resFlyTargetMap[resType]
end

function PnlPlayerInformation:setBoxBuildButton()
    self:releaseBoxBuildButton()

    self.btnBuildToolList = {}

    for k, v in pairs(PnlPlayerInformation.btnBuildToolInfo) do
        ResMgr:LoadGameObjectAsync("BtnBuildTool", function(go)
            go.transform:SetParent(self.view.boxBuildButtonList, false)

            local iconName = gg.getSpriteAtlasName("BuildButton_Atlas", v.icon)
            local iconImg = go.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)

            gg.setSpriteAsync(iconImg, iconName)

            go.transform:Find("Text"):GetComponent(typeof(CS.TextYouYU)):SetLanguageKey(v.text) -- = Utils.getText(v.text)

            CS.UIEventHandler.Get(go):SetOnClick(function()
                self[v.event](self)
            end, "event:/UI_button_click", "se_UI", false)
            self.btnBuildToolList[k] = go
            return true
        end, true)
    end
end

function PnlPlayerInformation:releaseBoxBuildButton()
    if self.btnBuildToolList then
        for k, v in pairs(self.btnBuildToolList) do

            ResMgr:ReleaseAsset(v)
        end
        self.btnBuildToolList = nil
    end
end

function PnlPlayerInformation:onShowBuildButton(args, isShow, butMap, build)
    self.view.boxBuildButton:SetActiveEx(isShow)
    if isShow then
        -- for k, v in pairs(butMap) do
        --     self.btnBuildToolList[k]:SetActiveEx(v)
        -- end

        for key, value in pairs(self.btnBuildToolList) do
            value:SetActiveEx(butMap[key] == true)
        end

        self.selBuild = build

        if build.buildCfg.type == constant.BUILD_CLUTTER then
            self.view.txtBuildName.text = build.buildCfg.name
        else
            self.view.txtBuildName.text = string.format("%s (Lv.%s)", Utils.getText(build.buildCfg.languageNameID),
                build.buildCfg.level)
        end

        self:refreshEdit()
    else
        self.selBuild = nil
    end
end

function PnlPlayerInformation:onShowBuildButtonAccept(args, isShow)
    self.btnBuildToolList[PnlPlayerInformation.BTN_ACCEPT]:SetActiveEx(isShow)
end

function PnlPlayerInformation:onBtnRefused()
    if self.selBuild then
        self.selBuild:onBtnFork()
    end
    self:onShowBuildButton(nil, false)
end

function PnlPlayerInformation:onBtnAccept()
    if self.selBuild then
        self.selBuild:onBtnTick()
    else
        self:onShowBuildButton(nil, false)
    end
end

function PnlPlayerInformation:onBtnEditArmy()
    gg.uiManager:openWindow("PnlPersonalArmy")
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnShrine()
    gg.uiManager:openWindow("PnlShrine", {
        buildId = self.selBuild.buildData.id
    })
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnExchange()
    self.selBuild:onBtnTool(1)
    gg.buildingManager:cancelBuildOrMove()

end

function PnlPlayerInformation:onBtnFarming()
    self.selBuild:onBtnTool(1)
    gg.buildingManager:cancelBuildOrMove()

end

function PnlPlayerInformation:onBtnHeroClub()

end

function PnlPlayerInformation:onBtnInformation()
    gg.uiManager:openWindow("PnlBuildInfo", {
        buildInfo = self.selBuild.buildData,
        type = ggclass.PnlBuildInfo.TYPE_INFO
    })

    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnPeople()

end

function PnlPlayerInformation:onBtnPit()

end

function PnlPlayerInformation:onBtnRecycle()
    if self.selBuild then
        self.selBuild:onBtnRecycle()
    end
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnReback()
    gg.uiManager:openWindow("PnlRecycleCenter")

    gg.buildingManager:cancelBuildOrMove()
end


function PnlPlayerInformation:onBtnResearchInstitute()
    if self.selBuild then
        local data = {
            buildData = self.selBuild.buildData,
            buildCfg = self.selBuild.buildCfg,
            -- totalTrainTime = self.selBuild.totalTrainTime
        }
        gg.uiManager:openWindow("PnlInstitute", data)

        -- gg.uiManager:openWindow("PnlInstitute")
    end

    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnShovel()
    if self.selBuild then
        self.selBuild:onBtnRecycle()
    end
    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onBtnUpgrade()
    if self.selBuild then
        gg.uiManager:openWindow("PnlBuildInfo", {
            buildInfo = self.selBuild.buildData,
            type = ggclass.PnlBuildInfo.TYPE_UPGRADE
        })
    end

    gg.buildingManager:cancelBuildOrMove()
end

function PnlPlayerInformation:onOnlyHyMit(_, bool)
    local resourceUI = self.view.resourceUI.transform

    resourceUI:Find("Tesseract").gameObject:SetActiveEx(not bool)
    resourceUI:Find("Gas").gameObject:SetActiveEx(not bool)
    resourceUI:Find("Ice").gameObject:SetActiveEx(not bool)
    resourceUI:Find("Titanium").gameObject:SetActiveEx(not bool)
    resourceUI:Find("StarCoin").gameObject:SetActiveEx(not bool)

    if bool then
        self.view.mit.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(-33.8)
        self.view.carboxyl.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(-33.8)
    else
        self.view.mit.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(-112)
        self.view.carboxyl.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(-112)
    end
end

---------------------------edit
function PnlPlayerInformation:initEdit()
    local view = self.view

    self.isInitEdit = true
    self.editBuildingItem = EditBuildingItem.new(self.view.editBuildingItem)
    self.inputBuildCount = view.layoutEditBuild:Find("InputBuildCount"):GetComponent(UNITYENGINE_UI_INPUTFIELD)
    self.btnEditBuild = view.layoutEditBuild:Find("BtnEditBuild").gameObject
    self:setOnClick(self.btnEditBuild, gg.bind(self.onBtnEditBuild, self))
end

function PnlPlayerInformation:refreshEdit()
    if not EditData.isEditMode then
        return
    end

    if self.selBuild and self.showingEditBuild ~= self.selBuild then
        self.showingEditBuild = self.selBuild

        if self.selBuild.buildData then
            self.editBuildingItem:setActive(true)
            self.editBuildingItem:setData(self.selBuild.buildData)
        else
            self.editBuildingItem:setActive(false)
        end
    end
end

function PnlPlayerInformation:onEditModeChange()
    local view = self.view
    view.layoutEditBuild:SetActiveEx(EditData.isEditMode)

    if EditData.isEditMode and not self.isInitEdit then
        self:initEdit()
    end
end

function PnlPlayerInformation:onBtnEditBuild()
    self.autoBuildCount = tonumber(self.inputBuildCount.text)
    if self.autoBuildCount and self.autoBuildCount > 0 then
        self:startAutoBuild()
    end
end

function PnlPlayerInformation:startAutoBuild()
    if self.autoBuildCount <= 0 then
        return
    end
    self.autoBuildCount = self.autoBuildCount - 1

    gg.buildingManager:loadBuilding(self.showingEditBuild.buildCfg, nil, nil, BuildingManager.OWNER_OWN, nil)
    gg.timer:startTimer(0.5, function()
        self:onBtnAccept()
        gg.timer:startTimer(0.5, function()
            self:startAutoBuild()
        end)
    end)
end

-- override
function PnlPlayerInformation:getGuideRectTransform(guideCfg)
    if guideCfg.otherArgs[1] == "btnBuildToolList" then
        return self.btnBuildToolList[PnlPlayerInformation[guideCfg.otherArgs[2]]]
    end

    return ggclass.UIBase.getGuideRectTransform(self, guideCfg)
end

-- override
function PnlPlayerInformation:triggerGuideClick(guideCfg)
    if guideCfg.otherArgs[1] == "btnBuildToolList" then
        if PnlPlayerInformation[guideCfg.otherArgs[2]] == PnlPlayerInformation.BTN_ACCEPT and guideCfg.otherArgs[3] ==
            "fakeBuildShowSpeedUp" then
            local building = gg.buildingManager.selectedBuilding

            self:onShowBuildButton(nil, false)
            building.view.buildingTimeBarBox:setStatickMessage(building.buildCfg.levelUpNeedTick)
            building.view.buildingTimeBarBox.transform:SetActiveEx(true)
        else
            local funcName = PnlPlayerInformation.btnBuildToolInfo[PnlPlayerInformation[guideCfg.otherArgs[2]]].event
            self[funcName](self)
        end

        return
    end

    ggclass.UIBase.triggerGuideClick(self, guideCfg)
end

return PnlPlayerInformation
