PnlUnionNft = class("PnlUnionNft", ggclass.UIBase)

PnlUnionNft.WAREHOUSE_NFT = 1

PnlUnionNft.warehouseBtnIconName = {
    [PnlUnionNft.WAREHOUSE_NFT] = "nft_icon_"
}

PnlUnionNft.warehouseTitle = {
    [PnlUnionNft.WAREHOUSE_NFT] = "guide_NFTWarehouse_Title"
}

function PnlUnionNft:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onUpdateUnionNft"}
end

function PnlUnionNft:onAwake()
    self.view = ggclass.PnlUnionNftView.new(self.pnlTransform)
    self.unionData = UnionData.unionData
    self.playerId = gg.playerMgr.localPlayer:getPid()

end

function PnlUnionNft:onShow()
    self:bindEvent()

    self.boxWarehouseNft = {}
    self.boxWarehouseAddNft = {}

    self.isUpdateNftsData = true
    self.inAddView = false
    self:onBtnNft()
end

function PnlUnionNft:onHide()
    self:releaseEvent()

    self:releaseBoxWarehouseNft()
    self:releaseBoxWarehouseAddNft()
end

function PnlUnionNft:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnNft):SetOnClick(function()
        self:onBtnNft()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnAddNft):SetOnClick(function()
        self:onBtnShowAddNft()
    end)
    CS.UIEventHandler.Get(view.btnCloseAdd):SetOnClick(function()
        self:onBtnCloseAdd()
    end)

    self:setOnClick(self.view.btnDonateDesc, gg.bind(self.onBtnDonateDesc, self))
end

function PnlUnionNft:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnNft)
    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnAddNft)
    CS.UIEventHandler.Clear(view.btnClose)

end

function PnlUnionNft:onDestroy()
    local view = self.view
    self.unionData = {}
    self.playerId = nil
end

function PnlUnionNft:onBtnNft()
    if self.isUpdateNftsData then
        UnionData.C2S_Player_QueryUnionNfts()
    else
        self:onChangeWarehouseType(PnlUnionNft.WAREHOUSE_NFT)
    end

end

function PnlUnionNft:onBtnClose()
    self:close()
end

function PnlUnionNft:onBtnShowAddNft()
    self.inAddView = true
    self:setViewWarehouseAddNft()
end

function PnlUnionNft:onBtnCloseAdd()
    self.inAddView = false
    self.view.viewAddNft:SetActiveEx(false)
end

function PnlUnionNft:onBtnDonateDesc()
    gg.uiManager:openWindow("PnlDesc", {title = Utils.getText("universal_RulesTitle"), desc = Utils.getText("guild_NftDonate_RulesTxt")})
end

function PnlUnionNft:onChangeWarehouseType(type)
    self.view.txtTitle.text = Utils.getText(PnlUnionNft.warehouseTitle[type])
    self.warehouseView = type

    for i = 1, #self.view.leftBtnIcon, 1 do
        local parentImage = self.view.leftBtnIcon[i].transform.parent:GetComponent(UNITYENGINE_UI_IMAGE)
        local icon = self.view.leftBtnIcon[i]
        local text = self.view.leftBtnText[i]
        if type == i then
            -- local iconName = gg.getSpriteAtlasName("Union_Atlas", PnlUnionNft.warehouseBtnIconName[i] .. "B")
            -- gg.setSpriteAsync(icon, iconName)
            text.color = Color.New(1, 1, 1, 1)
            parentImage.enabled = true
        else
            -- local iconName = gg.getSpriteAtlasName("Union_Atlas", PnlUnionNft.warehouseBtnIconName[i] .. "A")
            -- gg.setSpriteAsync(icon, iconName)
            text.color = Color.New(61 / 255, 151 / 255, 1, 1)
            parentImage.enabled = false
        end
    end

    if type == PnlUnionNft.WAREHOUSE_NFT then
        self.isUpdateNftsData = false
        local class = {
            isHero = true,
            isDefense = true,
            isWarship = true
        }
        self:setViewWarehouseNft(class)
    end
    if self.inAddView == true then
        self:setViewWarehouseAddNft()
    end

end

function PnlUnionNft:setViewWarehouseNft(class)
    self.view.warehouseNft:SetActiveEx(true)

    self.view.viewAddNft:SetActiveEx(false)

    self:releaseBoxWarehouseNft()

    local curUnionData = self.unionData
    local curData = {}
    local power = 0
    if class.isHero then
        for k, v in pairs(curUnionData.items) do
            if v.itemType == constant.ITEM_ITEMTYPE_HERO then
                local cfg = cfg.getCfg("hero", v.cfgId, v.level, v.quality)
                local data = {
                    id = v.id,
                    cfgId = v.cfgId,
                    level = v.level,
                    ownerPid = v.ownerPid,
                    ownerName = v.ownerName,
                    donateTime = v.donateTime,
                    cfg = cfg,
                    type = v.itemType,
                    skill1 = v.skill1,
                    skill2 = v.skill2,
                    skill3 = v.skill3,
                    skill4 = v.skill4,
                    skill5 = v.skill5
                }
                table.insert(curData, data)
                if v.ownerPid == self.playerId and cfg then
                    power = power + cfg.power
                end
            end
        end
    end
    if class.isDefense then
        for k, v in pairs(curUnionData.items) do
            if v.itemType == constant.ITEM_ITEMTYPE_TURRET then
                local cfg = cfg.getCfg("build", v.cfgId, v.level, v.quality)
                local data = {
                    id = v.id,
                    cfgId = v.cfgId,
                    level = v.level,
                    ownerPid = v.ownerPid,
                    ownerName = v.ownerName,
                    donateTime = v.donateTime,
                    cfg = cfg,
                    type = v.itemType
                }
                table.insert(curData, data)

                if v.ownerPid == self.playerId then
                    power = power + cfg.power
                end

            end
        end
    end
    if class.isWarship then
        for k, v in pairs(curUnionData.items) do
            if v.itemType == constant.ITEM_ITEMTYPE_WARSHIP then
                local cfg = cfg.getCfg("warShip", v.cfgId, v.level, v.quality)
                local data = {
                    id = v.id,
                    cfgId = v.cfgId,
                    level = v.level,
                    ownerPid = v.ownerPid,
                    ownerName = v.ownerName,
                    donateTime = v.donateTime,
                    cfg = cfg,
                    type = v.itemType,
                    skill1 = v.skill1,
                    skill2 = v.skill2,
                    skill3 = v.skill3,
                    skill4 = v.skill4,
                    skill5 = v.skill5
                }
                table.insert(curData, data)

                if v.ownerPid == self.playerId then
                    power = power + cfg.power
                end

            end
        end
    end
    local powerToPerContribute = cfg["global"].powerToPerContribute.intValue
    local nftMakeContributeInterval = cfg["global"].nftMakeContributeInterval.intValue
    local perHour = (power / powerToPerContribute) / (nftMakeContributeInterval / 3600)
    self.view.txtHashrate.text = power
    self.view.txtPerHour.text = Utils.scientificNotation(perHour, false)   --string.format("%.2f", perHour)
    self.view.txtNftContribution.text = Utils.scientificNotation(self.unionData.contriDegree)

    for k, v in pairs(curData) do
        ResMgr:LoadGameObjectAsync("BoxWarehouseNft", function(go)
            go.transform:SetParent(self.view.scrollViewNft, false)
            local id = v.id

            go.transform:Find("TitelOwner").gameObject:SetActiveEx(true)
            go.transform:Find("TitelUser").gameObject:SetActiveEx(false)
            go.transform:Find("TitelTime").gameObject:SetActiveEx(true)

            go.transform:Find("TitelLv/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = v.level

            -- print("fffff", Utils.getText(v.cfg.languageNameID))
            go.transform:Find("BgName/TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(v.cfg
                                                                                                           .languageNameID)
            go.transform:Find("TitelOwner/TxtOwner"):GetComponent(UNITYENGINE_UI_TEXT).text = v.ownerName
            go.transform:Find("TitelTime/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT).text = os.date("!%Y-%m-%d %H:%M",
                v.donateTime)

            gg.setSpriteAsync(go.transform:Find("BtnRetrieve"):GetComponent(UNITYENGINE_UI_IMAGE),
                "Button_Atlas[Button_icon_B]")
            go.transform:Find("BtnRetrieve/Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(242 / 255,
                231 / 255, 75 / 255, 1)
            go.transform:Find("BtnRetrieve/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                "guide_NFTWarehouse_Retrieve")

            local icon
            if v.type == constant.ITEM_ITEMTYPE_WARSHIP then
                icon = gg.getSpriteAtlasName("Warship_A_Atlas", v.cfg.icon .. "_A")
                go.transform:Find("IconTop").gameObject:SetActiveEx(false)
            elseif v.type == constant.ITEM_ITEMTYPE_HERO then
                icon = gg.getSpriteAtlasName("Hero_A_Atlas", v.cfg.icon .. "_A")
            elseif v.type == constant.ITEM_ITEMTYPE_TURRET then
                icon = gg.getSpriteAtlasName("Build_A_Atlas", v.cfg.icon .. "_A")
                go.transform:Find("IconTop").gameObject:SetActiveEx(false)
            end
            gg.setSpriteAsync(go.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE), icon)

            local isShowSkill = false
            for i = 1, 5, 1 do
                local key = "skill" .. i
                local child = "BoxSkill/Skill" .. i
                local value = v[key] or 0
                if value == 0 then
                    go.transform:Find(child).gameObject:SetActiveEx(false)
                else
                    local skillCfg = cfg.getCfg("skill", value)
                    if skillCfg then
                        go.transform:Find(child).gameObject:SetActiveEx(true)
                        local image = go.transform:Find(child):GetComponent(UNITYENGINE_UI_IMAGE)
                        local icon = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")

                        gg.setSpriteAsync(image, icon)
                    else
                        go.transform:Find(child).gameObject:SetActiveEx(false)
                    end
                    isShowSkill = true
                end
            end
            if isShowSkill then
                go.transform:Find("BoxSkill").gameObject:SetActiveEx(true)
            else
                go.transform:Find("BoxSkill").gameObject:SetActiveEx(false)
            end
            CS.UIEventHandler.Get(go.transform:Find("BtnRetrieve").gameObject):SetOnClick(function()
                self:onBtnRetrieve(id)
            end)

            self.boxWarehouseNft[id] = go
            return true
        end, true)
    end
end

function PnlUnionNft:onBtnRetrieve(id)
    local unionId = self.unionData.unionId
    local idList = {}
    table.insert(idList, id)
    UnionData.C2S_Player_UnionTakeBackNft(unionId, idList)
end

function PnlUnionNft:releaseBoxWarehouseNft()
    if self.boxWarehouseNft then
        for k, go in pairs(self.boxWarehouseNft) do
            CS.UIEventHandler.Clear(go.transform:Find("BtnRetrieve").gameObject)
            ResMgr:ReleaseAsset(go)
        end
        self.boxWarehouseNft = {}
    end
end

function PnlUnionNft:setViewWarehouseAddNft()
    self:releaseBoxWarehouseAddNft()
    self.view.viewAddNft:SetActiveEx(true)

    local curData = {}
    -- "" [7.4]""（""） 3.""NFT""，""，""
    -- for k, v in pairs(HeroData.heroDataMap) do
    --     if v.ref == 0 and v.chain > 0 then
    --         local cfg = cfg.getCfg("hero", v.cfgId, v.level, v.quality)
    --         local data = {
    --             id = v.id,
    --             cfgId = v.cfgId,
    --             level = v.level,
    --             cfg = cfg,
    --             curLife = v.curLife,
    --             type = constant.ITEM_ITEMTYPE_HERO,
    --             skill1 = v.skill1,
    --             skill2 = v.skill2,
    --             skill3 = v.skill3,
    --             skill4 = v.skill4,
    --             skill5 = v.skill5
    --         }
    --         table.insert(curData, data)
    --     end
    -- end
    -- for k, v in pairs(WarShipData.warShipData) do
    --     if v.ref == 0 and v.chain > 0 then
    --         local cfg = cfg.getCfg("warShip", v.cfgId, v.level, v.quality)
    --         local data = {
    --             id = v.id,
    --             cfgId = v.cfgId,
    --             level = v.level,
    --             cfg = cfg,
    --             curLife = v.curLife,
    --             type = constant.ITEM_ITEMTYPE_WARSHIP,
    --             skill1 = v.skill1,
    --             skill2 = v.skill2,
    --             skill3 = v.skill3,
    --             skill4 = v.skill4,
    --             skill5 = v.skill5
    --         }
    --         table.insert(curData, data)
    --     end
    -- end

    for k, v in pairs(BuildData.buildData) do
        if v.ref == 0 and v.chain > 0 and v.pos.x == 0 and v.pos.z == 0 then
            local buildCfg = cfg.getCfg("build", v.cfgId, v.level, v.quality)
            local data = {
                id = v.id,
                cfgId = v.cfgId,
                level = v.level,
                cfg = buildCfg,
                curLife = v.curLife,
                type = constant.ITEM_ITEMTYPE_TURRET
            }
            table.insert(curData, data)
        end
    end

    for k, v in pairs(curData) do
        local tick = 0 -- v.lessLaunch - os.time()
        if tick <= 0 then
            ResMgr:LoadGameObjectAsync("BoxWarehouseNft", function(go)
                go.transform:SetParent(self.view.scrollViewAddNft, false)
                local id = v.id

                go.transform:Find("TitelOwner").gameObject:SetActiveEx(false)
                go.transform:Find("TitelUser").gameObject:SetActiveEx(false)
                go.transform:Find("TitelTime").gameObject:SetActiveEx(false)
                go.transform:Find("IconUsing").gameObject:SetActiveEx(false)

                go.transform:Find("TitelLv/TxtLevel"):GetComponent(UNITYENGINE_UI_TEXT).text = v.level
                go.transform:Find("BgName/TxtName"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(v.cfg
                                                                                                               .languageNameID)
                go.transform:Find("BtnRetrieve/Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
                    "guide_NFTWarehouse_Add_Add")

                local image = go.transform:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
                local icon
                if v.type == constant.ITEM_ITEMTYPE_WARSHIP then
                    icon = gg.getSpriteAtlasName("Warship_A_Atlas", v.cfg.icon .. "_A")
                    go.transform:Find("IconTop").gameObject:SetActiveEx(false)
                elseif v.type == constant.ITEM_ITEMTYPE_HERO then
                    icon = gg.getSpriteAtlasName("Hero_A_Atlas", v.cfg.icon .. "_A")
                elseif v.type == constant.ITEM_ITEMTYPE_TURRET then
                    icon = gg.getSpriteAtlasName("Build_A_Atlas", v.cfg.icon .. "_A")
                    go.transform:Find("IconTop").gameObject:SetActiveEx(false)
                end
                gg.setSpriteAsync(image, icon)

                local isShowSkill = false
                for i = 1, 5, 1 do
                    local key = "skill" .. i
                    local child = "BoxSkill/Skill" .. i
                    local value = v[key] or 0
                    if value == 0 then
                        go.transform:Find(child).gameObject:SetActiveEx(false)
                    else
                        local skillCfg = cfg.getCfg("skill", value)
                        if skillCfg then
                            go.transform:Find(child).gameObject:SetActiveEx(true)
                            local image = go.transform:Find(child):GetComponent(UNITYENGINE_UI_IMAGE)
                            local icon = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")

                            gg.setSpriteAsync(image, icon)
                        else
                            go.transform:Find(child).gameObject:SetActiveEx(false)
                        end
                        isShowSkill = true
                    end
                end
                if isShowSkill then
                    go.transform:Find("BoxSkill").gameObject:SetActiveEx(true)
                else
                    go.transform:Find("BoxSkill").gameObject:SetActiveEx(false)
                end

                if v.curLife > 0 then
                    gg.setSpriteAsync(go.transform:Find("BtnRetrieve"):GetComponent(UNITYENGINE_UI_IMAGE),
                        "Button_Atlas[Button_icon_B]")
                    go.transform:Find("BtnRetrieve/Text"):GetComponent(UNITYENGINE_UI_TEXT).color = Color.New(242 / 255,
                        231 / 255, 75 / 255, 1)

                else
                    gg.setSpriteAsync(go.transform:Find("BtnRetrieve"):GetComponent(UNITYENGINE_UI_IMAGE),
                        "Button_Atlas[Button_icon_A]")
                    go.transform:Find("BtnRetrieve/Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
                        Color.New(1, 1, 1, 1)

                end

                CS.UIEventHandler.Get(go.transform:Find("BtnRetrieve").gameObject):SetOnClick(function()
                    self:onBtnAddNft(id, v.curLife)
                end)

                self.boxWarehouseAddNft[id] = go
                return true
            end, true)
        end
    end
end

function PnlUnionNft:onBtnAddNft(id, curLife)
    if curLife > 0 then
        local callbackYes = function()
            local unionId = self.unionData.unionId
            local idList = {}
            table.insert(idList, id)
            UnionData.C2S_Player_UnionDonateNft(unionId, idList)
        end

        local args = {
            txtTitel = Utils.getText("universal_Ask_Title"),
            txtTips = Utils.getText("guild_NFTWarehouse_DonateOrNot"),
            txtYes = Utils.getText("universal_DetermineButton"),
            txtNo = Utils.getText("universal_Ask_BackButton"),
            callbackYes = callbackYes
        }
        gg.uiManager:openWindow("PnlAlertNew", args)

    else
        gg.uiManager:showTip(Utils.getText("guild_NFTWarehouse_CannotContribute"))
    end

end

function PnlUnionNft:releaseBoxWarehouseAddNft()
    if self.boxWarehouseAddNft then
        for k, go in pairs(self.boxWarehouseAddNft) do
            CS.UIEventHandler.Clear(go.transform:Find("BtnRetrieve").gameObject)
            ResMgr:ReleaseAsset(go)
        end
        self.boxWarehouseAddNft = {}
    end

end

function PnlUnionNft:onUpdateUnionNft(args, warehouseView)
    self.unionData = UnionData.unionData
    self:onChangeWarehouseType(warehouseView)
end

return PnlUnionNft
