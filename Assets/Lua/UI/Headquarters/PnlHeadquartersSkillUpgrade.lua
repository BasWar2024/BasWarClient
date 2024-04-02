PnlHeadquartersSkillUpgrade = class("PnlHeadquartersSkillUpgrade", ggclass.UIBase)

-- args = {
--     skillCfgId = ,
--     skillLevel = ,
--     skillIndex = ,
--     upgradeTick = ,
--     roleId = ,
--     type = ,
-- }

function PnlHeadquartersSkillUpgrade:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {"onUpgradeSkill"}
end

function PnlHeadquartersSkillUpgrade:onAwake()
    self.view = ggclass.PnlHeadquartersSkillUpgradeView.new(self.pnlTransform)

end

function PnlHeadquartersSkillUpgrade:onShow()
    self:bindEvent()

    self:onUpgradeSkill()

    if self.args.skillIndex == 1 then
        self.view.txtSkillType.text = Utils.getText("headquarters_Skills_Inherent")
        self.view.btnChange.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
            "headquarters_Skills_ResetBtn")
    else
        self.view.txtSkillType.text = Utils.getText("headquarters_Skills_Loadable")
        self.view.btnChange.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(
            "headquarters_Skills_ForgetBtn")
    end
end

function PnlHeadquartersSkillUpgrade:onUpgradeSkill(args, data)
    if data then
        if self.args.roleId ~= data.id then
            return
        end
        if self.args.skillIndex ~= data.skillUp and data.skillUp ~= 0 then
            return
        end
        local skillLevelName = "skillLevel" .. self.args.skillIndex
        self.args.upgradeTick = data.skillUpLessTickEnd
        self.args.skillLevel = data[skillLevelName]
    end

    self.curCfg = cfg.getCfg("skill", self.args.skillCfgId, self.args.skillLevel)
    self:setInfo()
end

function PnlHeadquartersSkillUpgrade:setInfo()
    local view = self.view
    view.txtTitle.text = Utils.getText(self.curCfg.languageNameID)
    -- local bgName = gg.getSpriteAtlasName("SkillBox_Atlas", string.format("skill%s_icon", self.curCfg.quality))
    -- gg.setSpriteAsync(view.bgSkill, bgName)
    UIUtil.setQualityBg(view.bgSkill, self.curCfg.quality)

    local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", self.curCfg.icon .. "_A1")
    gg.setSpriteAsync(view.iconSkill, iconName)

    self:stopUpgradingTimer()

    local tick = self.args.upgradeTick - os.time()
    if tick > 0 then
        -- view.txtUpgrading.gameObject:SetActiveEx(true)
        view.txtUpgradeTime.text = gg.time:getTick(tick)
        self.upgradingTimer = gg.timer:startLoopTimer(0, 0.3, -1, function()
            local curTick = self.args.upgradeTick - os.time()
            if curTick < 0 then
                -- view.txtUpgrading.gameObject:SetActiveEx(false)
                self:stopUpgradingTimer()
            end
            view.txtUpgradeTime.text = gg.time:getTick(curTick)
        end)
    else
        -- view.txtUpgrading.gameObject:SetActiveEx(false)
    end

    local nextLevel = cfg.getCfg("skill", self.args.skillCfgId, self.args.skillLevel + 1)
    if nextLevel then
        view.levelMax:SetActiveEx(false)
        view.levelUpgrade:SetActiveEx(true)
        view.layoutBtns:SetActiveEx(true)
        view.txtCurLevel.text = self.args.skillLevel
        view.txtNextLevel.text = self.args.skillLevel + 1
        self:setBtnCost(tick)
        self:setNeedShard()
    else
        view.levelMax:SetActiveEx(true)
        view.levelUpgrade:SetActiveEx(false)
        view.layoutBtns:SetActiveEx(false)
        view.txtMaxLevel.text = self.args.skillLevel
    end

    view.txtDesc.text = Utils.getText(self.curCfg.desc)
end

function PnlHeadquartersSkillUpgrade:setNeedShard()
    if self.curCfg.levelUpShard then
        self:releaseBoxSkillShard()
        self.boxSkillShardList = {}

        for i, v in ipairs(self.curCfg.levelUpShard) do
            ResMgr:LoadGameObjectAsync("BoxSkillShard", function(go)
                go.transform:SetParent(self.view.viewSkillShard, false)
                local itemCfgId = v[1]
                local needCound = v[2]
                local itemCfg = cfg.getCfg("item", itemCfgId)
                local quality = itemCfg.quality or 0
                UIUtil.setQualityBg(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), quality)

                local bgName = gg.getSpriteAtlasName("Skill_A1_Atlas", string.format("debris%s_icon", itemCfg.quality))
                gg.setSpriteAsync(go.transform:Find("BgSkillChip"):GetComponent(UNITYENGINE_UI_IMAGE), bgName)

                local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", itemCfg.icon .. "_A1")
                gg.setSpriteAsync(
                    go.transform:Find("BgSkillChip/Mask/IconSkillChip"):GetComponent(UNITYENGINE_UI_IMAGE), iconName)

                local curCound = 0
                for k, v in pairs(ItemData.itemBagData) do
                    if v.cfgId == itemCfgId then
                        curCound = curCound + v.num
                    end
                end
                go.transform:Find("TxtCound"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    string.format("%s/%s", curCound, needCound)

                table.insert(self.boxSkillShardList, go)
                return true
            end, true)
        end
    end
end

function PnlHeadquartersSkillUpgrade:releaseBoxSkillShard()
    if self.boxSkillShardList then
        for k, go in pairs(self.boxSkillShardList) do
            ResMgr:ReleaseAsset(go)
        end

        self.boxSkillShardList = nil
    end
end

function PnlHeadquartersSkillUpgrade:setBtnCost(tick)
    if tick > 0 then
        self.view.upgrade:SetActiveEx(false)
        self.view.txtHy.text = Utils.scientificNotation(ResUtil.getSpeedUpCost(tick) / 1000)
    else
        self.view.upgrade:SetActiveEx(true)
        local resList = {
            [constant.RES_STARCOIN] = self.curCfg.levelUpNeedStarCoin,
            [constant.RES_ICE] = self.curCfg.levelUpNeedIce,
            [constant.RES_CARBOXYL] = self.curCfg.levelUpNeedCarboxyl,
            [constant.RES_TITANIUM] = self.curCfg.levelUpNeedTitanium,
            [constant.RES_GAS] = self.curCfg.levelUpNeedGas,
            [constant.RES_TESSERACT] = self.curCfg.levelUpNeedTesseract
        }
        for k, v in pairs(self.view.upgradeCostList) do
            v.gameObject:SetActiveEx(false)
        end
        self.resList = {}
        for k, v in pairs(resList) do
            if v > 0 then
                self.view.upgradeCostList[k].gameObject:SetActiveEx(true)
                self.view.upgradeCostList[k]:Find("Txt"):GetComponent(UNITYENGINE_UI_TEXT).text =
                    Utils.scientificNotation(v / 1000)

                -- print("aaaaa", v, "bbbb", ResData.getRes(k))
                if v > ResData.getRes(k) then
                    self.view.upgradeCostList[k]:Find("Txt"):GetComponent(UNITYENGINE_UI_TEXT).color =
                        Color.New(1, 0, 0)
                else
                    self.view.upgradeCostList[k]:Find("Txt"):GetComponent(UNITYENGINE_UI_TEXT).color =
                        Color.New(1, 1, 1)
                end
            else
                self.view.upgradeCostList[k].gameObject:SetActiveEx(false)
            end

            table.insert(self.resList, {
                resId = k,
                count = v
            })
        end

        -- local hyCost = ResUtil.getExchangeResCostTesseract(self.resList) +
        --                    ResUtil.getSpeedUpCost(self.curCfg.levelUpNeedTick)
        -- self.view.txtHy.text = Utils.scientificNotation(hyCost / 1000)

        -- self.view.txtSlider.text = gg.time:getTick(self.curCfg.levelUpNeedTick)
    end
end

function PnlHeadquartersSkillUpgrade:stopUpgradingTimer()
    if self.upgradingTimer then
        gg.timer:stopTimer(self.upgradingTimer)
        self.upgradingTimer = nil
    end
end

function PnlHeadquartersSkillUpgrade:onHide()
    self:releaseEvent()

    self:stopUpgradingTimer()

    self:releaseBoxSkillShard()

end

function PnlHeadquartersSkillUpgrade:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnFinish):SetOnClick(function()
        self:onBtnFinish()
    end)
    CS.UIEventHandler.Get(view.btnUpgrade):SetOnClick(function()
        self:onBtnUpgrade()
    end)
    CS.UIEventHandler.Get(view.btnChange):SetOnClick(function()
        self:onBtnChange()
    end)

end

function PnlHeadquartersSkillUpgrade:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnFinish)
    CS.UIEventHandler.Clear(view.btnUpgrade)
    CS.UIEventHandler.Clear(view.btnChange)

end

function PnlHeadquartersSkillUpgrade:onDestroy()
    local view = self.view

end

function PnlHeadquartersSkillUpgrade:onBtnClose()
    self:close()
end

function PnlHeadquartersSkillUpgrade:onBtnFinish()
    if self.args.type == 1 then
        HeroData.C2S_Player_HeroSkillUp(self.args.roleId, self.args.skillIndex, 1)
    else
        WarShipData.C2S_Player_WarShipSkillUp(self.args.roleId, self.args.skillIndex, 1)
    end
end

function PnlHeadquartersSkillUpgrade:onBtnUpgrade()
    local func = function()
        if self.args.type == 1 then
            HeroData.C2S_Player_HeroSkillUp(self.args.roleId, self.args.skillIndex, 0)
        else
            WarShipData.C2S_Player_WarShipSkillUp(self.args.roleId, self.args.skillIndex, 0)
        end
    end
    local exchangeInfo = {
        text = Utils.getText("universal_Ask_ExchangeRes")
    }
    if Utils.checkIsEnoughtLevelUpRes(self.curCfg, true, func, exchangeInfo) then
        func()
    end
end

function PnlHeadquartersSkillUpgrade:onBtnChange()
    local skillCfgId = self.args.skillCfgId
    local skillLevel = self.args.skillLevel
    local skillCfg = cfg.getCfg("skill", skillCfgId, skillLevel)

    if not skillCfg.forgetRewardShard[1] then
        return
    end
    local yesCallback
    local txtTitel = Utils.getText("universal_Ask_Title")
    local txtTips = Utils.getText("headquarters_Ask_Forget")
    local txtTipsRed = Utils.getText("headquarters_Ask_ReturnTips")
    local txtNo = Utils.getText("universal_Ask_BackButton")
    local txtYes = Utils.getText("universal_DetermineButton")

    if self.args.skillIndex == 1 then
        txtTips = Utils.getText("headquarters_Ask_Reset")

        if self.args.type == 1 then
            yesCallback = function()
                HeroData.C2S_Player_HeroResetSkill(self.args.roleId, self.args.skillIndex)
                self:close()
            end
        else
            yesCallback = function()
                WarShipData.C2S_Player_WarShipResetSkill(self.args.roleId, self.args.skillIndex)
                self:close()
            end
        end
    else
        txtTips = Utils.getText("headquarters_Ask_Forget")

        if self.args.type == 1 then
            yesCallback = function()
                HeroData.C2S_Player_HeroForgetSkill(self.args.roleId, self.args.skillIndex)
                self:close()
            end
        else
            yesCallback = function()
                WarShipData.C2S_Player_WarShipForgetSkill(self.args.roleId, self.args.skillIndex)
                self:close()
            end
        end
    end

    local args = {
        txtTitel = txtTitel,
        txtTips = txtTips,
        txtTipsRed = txtTipsRed,
        txtYes = txtYes,
        callbackYes = yesCallback,
        txtNo = txtNo,
        skillCfgId = self.args.skillCfgId,
        skillLevel = self.args.skillLevel,
        type = self.args.skillIndex
    }
    gg.uiManager:openWindow("PnlAlertResetSkill", args)

end

return PnlHeadquartersSkillUpgrade
