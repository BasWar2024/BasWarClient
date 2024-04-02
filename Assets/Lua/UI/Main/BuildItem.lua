BuildingCardModel = BuildingCardModel or class("BuildingCardModel", ggclass.UIBaseItem)
function BuildingCardModel:ctor(obj, initData)
    ggclass.UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BuildingCardModel:onInit()
    self.layoutInfo = self:Find("LayoutInfo").transform
    self.icon = self.layoutInfo:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtName = self.layoutInfo:Find("Name"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDesc = self.layoutInfo:Find("Desc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBuildTime = self.layoutInfo:Find("TxtBuildTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtBuiltCount = self.layoutInfo:Find("TxtBuiltCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.layoutRes = self.layoutInfo:Find("LayoutRes")

    self.resMap = {}
    for i = 1, self.layoutRes.transform.childCount, 1 do
        local trans = self.layoutRes.transform:GetChild(i - 1)
        if constant[trans.name] then
            local resId = constant[trans.name]
            self.resMap[resId] = {}
            self.resMap[resId].transform = trans
            self.resMap[resId].text = trans:GetComponent(UNITYENGINE_UI_TEXT)
        end
    end

    self.layoutUnlock = self:Find("LayoutUnlock").transform
    self.unIcon = self.layoutUnlock:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.unlockIcon = self.layoutUnlock:Find("Icon"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUnlockName = self.layoutUnlock:Find("Name"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtUnlockDesc = self.layoutUnlock:Find("Desc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtAlert = self.layoutUnlock:Find("Alert"):GetComponent(UNITYENGINE_UI_TEXT)

    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
end

function BuildingCardModel:onClickItem(pos, isInstance)
    if not self.buildCountResult.isCanBuild then
        if self.buildCountResult.lockInfo then
            local lockBuildCfg = BuildUtil.getCurBuildCfg(self.buildCountResult.lockInfo.cfgId,
                self.buildCountResult.lockInfo.level, self.buildCountResult.lockInfo.quality)
            gg.uiManager:showTip(string.format(Utils.getText("build_Float_LevelNotEnough"),
                Utils.getText(lockBuildCfg.languageNameID)))
        else
            gg.uiManager:showTip(Utils.getText("build_Folat_Max"))
        end
        return
    end

    if self.data.cfgId == constant.BUILD_LIBERATORSHIP then

        BuildUtil.afterBuildingBuild(self.data, function()
            self.initData:close()

            -- local i = 1
            -- for k, v in pairs(gg.buildingManager.liberaborShipTable) do
            --     i = i + 1
            -- end
            -- local vec = constant.BUILD_LIBERATORSHIPPOSLIST[i]
            -- pos = Vector3(vec[1], 0, vec[2])

            -- gg.buildingManager:requestLoadBuilding(self.data.cfgId, gg.buildingManager:getNextLiberatorshopPos(), isInstance)
            gg.buildingManager:loadBuilding(self.data, nil, nil, BuildingManager.OWNER_OWN, pos, isInstance)
        end)
        return
    end

    gg.buildingManager:loadBuilding(self.data, nil, nil, BuildingManager.OWNER_OWN, pos)
    self.initData:close()
end

function BuildingCardModel:setData(data, buildCountResult)
    self.data = data
    self.buildCountResult = buildCountResult
    -- self.layoutUnlock:SetActiveEx(false)

    local buildTime = gg.time.dhms_time({
        day = false,
        hour = 1,
        min = 1,
        sec = 1
    }, data.levelUpNeedTick)
    self:refreshRes()

    if buildCountResult.isCanBuild then
        self.layoutInfo:SetActiveEx(true)
        self.layoutUnlock:SetActiveEx(false)
        self.txtName.text = Utils.getText(data.languageNameID)
        self.txtDesc.text = Utils.getText(data.shortDesc)
        local icon = gg.getSpriteAtlasName("Build_B_Atlas", data.icon .. "_B")
        gg.setSpriteAsync(self.icon, icon)

        if buildTime.hour > 0 then
            self.txtBuildTime.text = buildTime.hour .. "h" .. buildTime.min .. "m" .. buildTime.sec .. "s"
        elseif buildTime.min > 0 then
            self.txtBuildTime.text = buildTime.min .. "m" .. buildTime.sec .. "s"
        else
            self.txtBuildTime.text = buildTime.sec .. "s"
        end

        self.txtBuiltCount.text = buildCountResult.count .. "/" .. buildCountResult.canBuildCount
    else
        self.layoutInfo:SetActiveEx(false)
        self.layoutUnlock:SetActiveEx(true)

        self.txtUnlockName.text = Utils.getText(data.languageNameID)
        self.txtUnlockDesc.text = Utils.getText(data.shortDesc)

        local icon = gg.getSpriteAtlasName("Build_B_Atlas", data.icon .. "_B")
        gg.setSpriteAsync(self.unIcon, icon)

        if buildCountResult.lockInfo then
            local lockBuildCfg = BuildUtil.getCurBuildCfg(buildCountResult.lockInfo.cfgId,
                buildCountResult.lockInfo.level, buildCountResult.lockInfo.quality)
            self.txtAlert.text = string.format(Utils.getText("build_UpgradeToUnlock"),
                Utils.getText(lockBuildCfg.languageNameID), buildCountResult.lockInfo.level)
        else
            if buildCountResult.nextBaseLevel > 0 then
                local buildCfg = BuildUtil.getCurBuildCfg(constant.BUILD_BASE, 1, 0)
                self.txtAlert.text = string.format(Utils.getText("build_UpgradeToMore"),
                    Utils.getText(buildCfg.languageNameID), buildCountResult.nextBaseLevel)
            else

                self.txtAlert.text = Utils.getText("build_Max") -- "Built Full"
            end
        end
        return
    end
end

function BuildingCardModel:refreshRes()
    if not self.buildCountResult or not self.buildCountResult.isCanBuild then
        return
    end
    for key, value in pairs(self.resMap) do
        local resCfg = constant.RES_2_CFG_KEY[key]
        if key == constant.RES_ICE or key == constant.RES_TITANIUM or key == constant.RES_GAS then
            value.transform:SetActiveEx(true)
            local cost = self.data[resCfg.levelUpKey]
            value.text.text = Utils.getShowRes(cost)
            if cost > ResData.getRes(key) then
                value.text.color = constant.COLOR_RED
            else
                value.text.color = self:getResTextColor(key)
            end
        else
            value.transform:SetActiveEx(false)
        end
    end
end

function BuildingCardModel:getResTextColor(resKey)
    if resKey == constant.RES_ICE then
        -- 42E8F2
        return UnityEngine.Color(0x42 / 0xff, 0xE8 / 0xff, 0xF2 / 0xff, 1)
    end
    if resKey == constant.RES_GAS then
        -- 7EE34D
        return UnityEngine.Color(0x7E / 0xff, 0xE3 / 0xff, 0x4D / 0xff, 1)
    end
    if resKey == constant.RES_TITANIUM then
        -- A9A8AE
        return UnityEngine.Color(0xA9 / 0xff, 0xA8 / 0xff, 0xAE / 0xff, 1)
    end
    returnUnityEngine.Color(0xee / 0xff, 0xee / 0xff, 0xee / 0xff, 1)
end
