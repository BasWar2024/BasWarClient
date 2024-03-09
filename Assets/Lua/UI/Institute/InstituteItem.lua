InstituteForceItem = InstituteForceItem or class("InstituteForceItem", ggclass.UIBaseItem)

function InstituteForceItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
end

function InstituteForceItem:onInit()
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    self.imgBg = self.transform:GetComponent("Image")
    self.layoutInfo = self:Find("LayoutInfo")
    self.imgIcon = self:Find("LayoutInfo/ImgIcon", "Image")
    self.imgLevel = self:Find("LayoutInfo/ImgLevel", "Image")
    self.btnInfo = self:Find("LayoutInfo/BtnInfo")
    self.txtDesc = self:Find("LayoutInfo/BgBottom/TxtDesc", "Text")
    self.ImgUnKnown = self:Find("ImgUnKnown")
    self.txtLevelMax = self:Find("LayoutInfo/TxtLevelMax", "Text")

    self.bgBottom = self:Find("LayoutInfo/BgBottom")
    self.layoutCost = self:Find("LayoutInfo/BgBottom/LayoutCost")
    self.costItemMap = {}
    self.costItemMap[constant.RES_STARCOIN] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost1/Text", "Text")
    self.costItemMap[constant.RES_TITANIUM] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost2/Text", "Text")
    self.costItemMap[constant.RES_GAS] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost3/Text", "Text")
    self.costItemMap[constant.RES_ICE] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost4/Text", "Text")
    self.costItemMap[constant.RES_CARBOXYL] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost5/Text", "Text")

    self:setOnClick(self.btnInfo, gg.bind(self.onBtnInfo, self))
end

function InstituteForceItem:onBtnInfo()
    print("onBtnInfo")
end

function InstituteForceItem:setData(data)
    self.data = data
    if not data then
        self.layoutInfo.transform:SetActiveEx(false)
        self.ImgUnKnown.transform:SetActiveEx(true)
        gg.setSpriteAsync(self.imgBg, "Unlockedsoldier_img")
        return
    end
    self.layoutInfo.transform:SetActiveEx(true)
    self.ImgUnKnown.transform:SetActiveEx(false)

    self.soliderData = BuildData.soliderLevelData[data[0].cfgId]
    if not self.soliderData then
        self:setData(nil)
        return
    end

    self.soliderCfg = data[self.soliderData.level]
    
    if self.soliderData and self.soliderData.level > 0 then
        self.txtDesc.transform:SetActiveEx(false)
        gg.setSpriteAsync(self.imgIcon, "Soldier1_icon")
        gg.setSpriteAsync(self.imgBg, "Soldierplate_img")
        self.imgLevel.transform:SetActiveEx(true)
        gg.setSpriteAsync(self.imgLevel, "Level_icon_" .. self.soliderData.level)

        if not data[self.soliderData.level + 1] then
            self.txtLevelMax.transform:SetActiveEx(true)
            self.bgBottom:SetActiveEx(false)
        else
            self.bgBottom:SetActiveEx(true)
            self.txtLevelMax.transform:SetActiveEx(false)
            self.layoutCost.transform:SetActiveEx(true)
            for key, value in pairs(self.costItemMap) do
                value.text = self.soliderCfg[constant.RES_2_CFG_KEY[key].levelUpKey]
            end
        end
    else
        self.txtDesc.transform:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, "Unlockedsoldier1_icon")
        gg.setSpriteAsync(self.imgBg, "Unlockedsoldier_img")
        self.imgLevel.transform:SetActiveEx(false)

        self.bgBottom:SetActiveEx(true)
        self.txtLevelMax.transform:SetActiveEx(false)
        self.layoutCost.transform:SetActiveEx(false)
    end
    self.layoutInfo.transform:SetActiveEx(true)
    self.ImgUnKnown.transform:SetActiveEx(false)
end

function InstituteForceItem:onClickItem()
    if self.data then
        gg.uiManager:openWindow("PnlForceUpgrade", {type = PnlForceUpgrade.TYPE_SOLIDER, cfg = self.soliderCfg, data = self.soliderData})
    end
end
-------------------------------------------------------------------
InstituteMineItem = InstituteMineItem or class("InstituteMineItem", ggclass.InstituteForceItem)

function InstituteMineItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
end

function InstituteMineItem:onInit()
    self:setOnClick(self.gameObject, gg.bind(self.onClickItem, self))
    self.imgBg = self.transform:GetComponent("Image")
    self.layoutInfo = self:Find("LayoutInfo")
    self.imgIcon = self:Find("LayoutInfo/ImgIcon", "Image")
    self.imgLevel = self:Find("LayoutInfo/ImgLevel", "Image")
    self.btnInfo = self:Find("LayoutInfo/BtnInfo")
    self.txtDesc = self:Find("LayoutInfo/BgBottom/TxtDesc", "Text")
    self.ImgUnKnown = self:Find("ImgUnKnown")
    self.txtLevelMax = self:Find("LayoutInfo/TxtLevelMax", "Text")

    self.bgBottom = self:Find("LayoutInfo/BgBottom")
    self.layoutCost = self:Find("LayoutInfo/BgBottom/LayoutCost")
    self.costItemMap = {}
    self.costItemMap[constant.RES_STARCOIN] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost1/Text", "Text")
    self.costItemMap[constant.RES_TITANIUM] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost2/Text", "Text")
    self.costItemMap[constant.RES_GAS] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost3/Text", "Text")
    self.costItemMap[constant.RES_ICE] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost4/Text", "Text")
    self.costItemMap[constant.RES_CARBOXYL] = self:Find("LayoutInfo/BgBottom/LayoutCost/imgCost5/Text", "Text")

    self:setOnClick(self.btnInfo, gg.bind(self.onBtnInfo, self))
end

function InstituteMineItem:onBtnInfo()
    print("onBtnInfo")
end

function InstituteMineItem:setData(data)
    self.data = data
    if not data or not BuildData.mineLevelData[data[0].cfgId] then
        self.layoutInfo.transform:SetActiveEx(false)
        self.ImgUnKnown.transform:SetActiveEx(true)
        gg.setSpriteAsync(self.imgBg, "Unlockedsoldier_img")
        return
    end
    self.layoutInfo.transform:SetActiveEx(true)
    self.ImgUnKnown.transform:SetActiveEx(false)

    self.mineData = BuildData.mineLevelData[data[0].cfgId]
    self.mineCfg = data[self.mineData.level]

    if self.mineData.level > 0 then
        self.txtDesc.transform:SetActiveEx(false)
        gg.setSpriteAsync(self.imgBg, "Soldierplate_img")
        gg.setSpriteAsync(self.imgIcon, "Mayfliesray_icon")
        self.imgLevel.transform:SetActiveEx(true)
        gg.setSpriteAsync(self.imgLevel, "Level_icon_" .. self.mineData.level)

        if MineUtil:getMineCfgMap()[self.mineData.cfgId][self.mineData.level + 1] then
            self.bgBottom.transform:SetActiveEx(true)
            self.txtDesc.transform:SetActiveEx(false)
            self.layoutCost:SetActiveEx(true)
            self.txtLevelMax.transform:SetActiveEx(false)

            for key, value in pairs(self.costItemMap) do
                value.text = self.mineCfg[constant.RES_2_CFG_KEY[key].levelUpKey]
            end
        else
            self.bgBottom.transform:SetActiveEx(false)
            self.txtLevelMax.transform:SetActiveEx(true)
        end
    else
        gg.setSpriteAsync(self.imgBg, "Unlockedsoldier_img")
        gg.setSpriteAsync(self.imgIcon, "HighExplosivemayflymines_icon")
        self.imgLevel.transform:SetActiveEx(false)
        self.bgBottom.transform:SetActiveEx(true)
        self.txtDesc.transform:SetActiveEx(true)
        self.layoutCost:SetActiveEx(false)
        self.txtLevelMax.transform:SetActiveEx(false)
    end
end

function InstituteMineItem:onClickItem()
    if self.data and BuildData.mineLevelData[self.data[0].cfgId] then
        gg.uiManager:openWindow("PnlForceUpgrade", {type = PnlForceUpgrade.TYPE_MINE, cfg = self.mineCfg, data = self.mineData})
    end
end
------------------------------------------------------------------
InstituteDrawItem = InstituteDrawItem or class("InstituteDrawItem", ggclass.UIBaseItem)

function InstituteDrawItem:ctor(obj)
    UIBaseItem.ctor(self, obj)
end

function InstituteDrawItem:onInit()
    self.imgBefore = self:Find("LayoutMessage/ImgBefore", "Image")
    self.imgAfter = self:Find("LayoutMessage/ImgAfter", "Image")
    self.btnCancel = self:Find("LayoutMessage/BtnCancel")
    self:setOnClick(self.btnCancel, gg.bind(self.onBtnCancel, self))
    self.btnInstant = self:Find("LayoutMessage/BtnInstant")
    self.txtInstantCost = self:Find("LayoutMessage/BtnInstant/TxtInstantCost", "Text")
    self:setOnClick(self.btnInstant, gg.bind(self.onBtnInstance, self))
    self.txtTime = self:Find("LayoutMessage/TxtTime", "Text")

    self.btnStart = self:Find("LayoutNone/BtnStart")
    self:setOnClick(self.btnStart, gg.bind(self.onBtnStart, self))

    self.layoutMessage = self:Find("LayoutMessage")
    self.layoutNone = self:Find("LayoutNone")
end

function InstituteDrawItem:setData(data)
    self.data = data
    if not data then
        self.layoutMessage:SetActiveEx(false)
        self.layoutNone:SetActiveEx(true)
        return
    end

    self.layoutMessage:SetActiveEx(true)
    self.layoutNone:SetActiveEx(false)

    self:stopTimer()
    self.timer = gg.timer:startLoopTimer(0, 0.3, -1, function()
        local time = data.lessTickEnd - os.time()
        if time <= 0 then
            self:stopTimer()
        end
        local hms = gg.time.dhms_time({day=false,hour=1,min=1,sec=1}, time)
        self.txtTime.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)

        self.txtInstantCost.text = math.ceil(time / 60 / 60) * cfg.global.ComposeSpeedCostPerHour.intValue
    end)
end

function UIBaseItem:stopTimer()
    if self.timer then
        gg.timer:stopTimer(self.timer)
        self.timer = nil
    end
end

function UIBaseItem:onRelease()
    self:stopTimer()
end

function InstituteDrawItem:onBtnCancel()
    print("onBtnCancel")
    if not self.data then
        return
    end
    ItemData.C2S_Player_ItemComposeCancel(self.data.item.id)
end

function InstituteDrawItem:onBtnInstance()
    print("onBtnInstance")
    if not self.data then
        return
    end
    ItemData.C2S_Player_ItemComposeSpeed(self.data.item.id)
end

function InstituteDrawItem:onBtnStart()
    gg.uiManager:openWindow("PnlItemBag", "Base")
end
