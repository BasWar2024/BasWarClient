BuildInfoTechnoItem = BuildInfoTechnoItem or class("BuildInfoTechnoItem", ggclass.UIBaseItem)

function BuildInfoTechnoItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BuildInfoTechnoItem:onInit()
    self.txtName = self:Find("TxtName", "Text")
    self.imgIcon = self:Find("ImgIcon", "Image")

    self:setOnClick(self.gameObject, gg.bind(self.onBtnItem, self) )
end

function BuildInfoTechnoItem:onRelease()
end

function BuildInfoTechnoItem:onBtnItem()
    self.initData:showTescDesc(self)
end

function BuildInfoTechnoItem:setData(technologyCfg, count)
    self.curCfg = nil
    for key, value in pairs(cfg[technologyCfg.type]) do
        local isMatch = true

        if technologyCfg.level and technologyCfg.level ~= value.level then
            isMatch = false
        end

        if technologyCfg.quality and technologyCfg.quality ~= value.quality then
            isMatch = false
        end

        if isMatch and technologyCfg.targetCfgId == value.cfgId then
            self.curCfg = value
        end
    end

    if self.curCfg then
        -- if self.curCfg.icon then
        --     -- self.commonItemItem:setIcon(self.curCfg.icon)
        -- end

        if technologyCfg.type == "solider" then
            self.imgIcon.transform.sizeDelta = CS.UnityEngine.Vector2(300, 300)
            local icon = gg.getSpriteAtlasName("Soldier_A_Atlas", self.curCfg.icon .. "_A")
            gg.setSpriteAsync(self.imgIcon, icon)
        else
            self.imgIcon.transform.sizeDelta = CS.UnityEngine.Vector2(300, 350)
            local icon = gg.getSpriteAtlasName("Build_B_Atlas", self.curCfg.icon .. "_B")
            gg.setSpriteAsync(self.imgIcon, icon)
        end
        --self.txtName.text = Utils.getText(self.curCfg.languageNameID) .. " X" ..  count
        self.txtName.text = " X" ..  count
    end
end
-----------------------------------------------------------------------------------------------------------------

BuildInfoPrepareItem = BuildInfoPrepareItem or class("BuildInfoPrepareItem", ggclass.UIBaseItem)

function BuildInfoPrepareItem:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BuildInfoPrepareItem:onInit()
    self.txtName = self:Find("TxtName", "Text")
    self.imgIcon = self:Find("ImgIcon", "Image")
    self.btnJump = self:Find("BtnJump")
    self.txtCount = self:Find("TxtCount", "Text")
    self.imgStage = self:Find("ImgStage", "Image")
    -- self.btnJump:SetActiveEx(false)
    
    self:setOnClick(self.btnJump, gg.bind(self.onBtnJump, self))
end

function BuildInfoPrepareItem:onRelease()
    -- self.commonItemItem:release()
end

function BuildInfoPrepareItem:onBtnJump()
    gg.buildingManager:cancelBuildOrMove()

    if self.data.isConstruction then
        local args = {
            id = self.initData.buildInfo.id,
            level = self.initData.buildInfo.level,
            totalConstruction = self.data.totalCon,
            curConstruction = self.initData.buildCfg.levelUpNeedConstruction
        }
        gg.uiManager:openWindow("PnlConstruction", args)
        return
    end

    if self.data.notEnoughtLevelBuildCount > 0 then
        -- gg.guideManager:addOtherGuide(GuideManager:getBuildUpgradeGuideCfg(self.data.cfgId, 1, nil, {
        --     levelLessThen = self.data.level,
        -- }), GuideManager.OTHER_GUIDE_UPGRADE_BUILD)

        for key, value in pairs(BuildData.buildData) do
            if value.cfgId == self.data.cfgId and value.level < self.data.level then
                gg.uiManager:openWindow("PnlBuildInfo", {buildInfo = value, type = PnlBuildInfo.TYPE_UPGRADE})
                return
            end
        end
    else
        gg.guideManager:addOtherGuide(gg.guideManager:getBuildGuideCfg(self.data.cfgId, 1), GuideManager.OTHER_GUIDE_TYPE_PNLBUILD_BUILD)
        gg.uiManager:openWindow("PnlBuild", {type = self.buildCfg.type})
    end
    self.initData:close()
end

function BuildInfoPrepareItem:setData(data)
    self.data = data

    if data.isConstruction then
        gg.setSpriteAsync(self.imgIcon, "AttributeIcon_Atlas[build_icon]")
        self.txtName.text = Utils.getText("attri_buildPoints")
        self.txtCount.text =  data.totalCon .. "/" .. data.buildCfg.levelUpNeedConstruction

    else
        local buildCfg = BuildUtil.getCurBuildCfg(data.cfgId, data.level, data.quality)
        self.buildCfg = buildCfg
    
        gg.setSpriteAsync(self.imgIcon, gg.getSpriteAtlasName("Build_B_Atlas", buildCfg.icon .. "_B"))
        self.txtName.text = string.format(Utils.getText("percondition_Content"), buildCfg.level, Utils.getText(buildCfg.languageNameID), data.needCount)
        self.txtCount.text =  data.count .. "/" .. data.needCount
    
        if data.isUnlock then
            gg.setSpriteAsync(self.imgStage, "Common_Atlas[Complete_icon]")
            self.btnJump:SetActiveEx(false)
            self.txtCount.color = UnityEngine.Color(0x76/0xff, 0xf7/0xff, 0xff/0xff, 1)
        else
            gg.setSpriteAsync(self.imgStage, "Common_Atlas[Uncomplete_icon]")
            self.btnJump:SetActiveEx(true)
            self.txtCount.color = UnityEngine.Color(0xff/0xff, 0x86/0xff, 0x44/0xff, 1)
        end
    end
end

-----------------------------------------------------------------------------------------------------------------

PledgeDescItem = PledgeDescItem or class("PledgeDescItem", ggclass.UIBaseItem)

function PledgeDescItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
    -- self.initData = initData
end

function PledgeDescItem:onInit()
    self.bg = self:Find("Bg")
    self.imgVipIcon = self:Find("ImgVipIcon", "Image")
    self.layoutContent = self:Find("LayoutContent").transform

    self.descMap = {}
    for i = 1, self.layoutContent.childCount do
        local child = self.layoutContent:GetChild(i - 1)

        self.descMap[child.name] = {}
        self.descMap[child.name].transform = child

        self.descMap[child.name].text = child:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
        self.descMap[child.name].image = child:Find("Image"):GetComponent(UNITYENGINE_UI_IMAGE)
        self.descMap[child.name].txtSub = child:Find("TxtSub"):GetComponent(UNITYENGINE_UI_TEXT)
    end
end

function PledgeDescItem:setData(data, index)
    self.bg:SetActiveEx(index % 2 == 0)
    self.descMap.level.text.text = "vip" .. data.cfgId
    local vipIcon = "VIP_icon_" .. data.cfgId
    local icon = gg.getSpriteAtlasName("Pledge_Atlas", vipIcon)
    gg.setSpriteAsync(self.imgVipIcon, icon)
    
    self.descMap.mit.text.text = Utils.getShowRes(data.minMit)
    if data.carboxylRatio > 0 then
        -- gg.setSpriteAsync(self.descMap.hydroxyl.image, "Yes_icon")
        self.descMap.hydroxyl.image.gameObject:SetActiveEx(true)
        self.descMap.hydroxyl.txtSub.gameObject:SetActiveEx(false)
    else
        -- gg.setSpriteAsync(self.descMap.hydroxyl.image, "No_icon")
        self.descMap.hydroxyl.image.gameObject:SetActiveEx(false)
        self.descMap.hydroxyl.txtSub.gameObject:SetActiveEx(true)

    end

    self.descMap.starPlus.text.text = self:getRatioStr(data.starCoinRatio)
    self.descMap.icePlus.text.text = self:getRatioStr(data.iceRatio)
    self.descMap.gasPlus.text.text = self:getRatioStr(data.gasRatio)
    self.descMap.tiPlus.text.text = self:getRatioStr(data.titaniumRatio)
    self.descMap.hydroxylPlus.text.text = self:getRatioStr(data.carboxylRatio)
end

function PledgeDescItem:getRatioStr(ratio)
    if ratio <= 0 then
        return "+0"
    end

    local addRatio = math.max(ratio - 1, 0)
    return "+" .. addRatio * 100 .. "%"
end
