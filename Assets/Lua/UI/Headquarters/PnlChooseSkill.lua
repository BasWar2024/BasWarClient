PnlChooseSkill = class("PnlChooseSkill", ggclass.UIBase)

PnlChooseSkill.TYPE_HERO = 0
PnlChooseSkill.TYPE_WARSHIP = 1

-- args = {roleId = , skillIndex = , type = ,}
function PnlChooseSkill:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)

    self.layer = UILayer.normal
    self.events = {}
end

function PnlChooseSkill:onAwake()
    self.view = ggclass.PnlChooseSkillView.new(self.pnlTransform)
    self.curRace = 0
    self.curQuality = 0
    self.boxRaceSolider = {}
end

function PnlChooseSkill:onShow()
    self:bindEvent()

    self:setScrollView()
end

PnlChooseSkill.RACE_NAME = {
    [0] = "bag_All",
    [1] = "race_Human",
    [2] = "race_Centra",
    [3] = "race_Scourge",
    [4] = "race_Endari",
    [5] = "race_Talus"
}

PnlChooseSkill.QUAILTY_TYPE = {
    [0] = 0,
    [1] = 3,
    [2] = 2,
    [3] = 1
}

PnlChooseSkill.RACE_TYPE = {
    [0] = 0,
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
}

function PnlChooseSkill:setScrollView()
    self.view.qualityBg:SetActiveEx(false)
    self.view.raceBg:SetActiveEx(false)

    local quailtyName = {
        [0] = Utils.getText("bag_All"),
        [1] = "S",
        [2] = "A",
        [3] = "B"
    }

    self.view.txtBtnQuality.text = quailtyName[self.curQuality]
    self.view.txtBtnRace.text = Utils.getText(PnlChooseSkill.RACE_NAME[self.curRace])

    local warshipSkills = {}
    local heroSkills = {}
    for k, v in pairs(ItemData.itemBagData) do
        local itemCfg = cfg.getCfg("item", v.cfgId)
        if itemCfg.itemType == constant.ITEM_ITEMTYPE_SKILL_PIECES and itemCfg.skillCfgID then
            local skillCfg = cfg.getCfg("skill", itemCfg.skillCfgID[1], itemCfg.skillCfgID[2])

            if skillCfg and skillCfg.skillEquitType == 2 and
                (self.curQuality == 0 or PnlChooseSkill.QUAILTY_TYPE[self.curQuality] == skillCfg.quality) and
                (self.curRace == 0 or PnlChooseSkill.RACE_TYPE[self.curRace] == skillCfg.race) then
                local temp = {
                    data = v,
                    itemCfg = itemCfg,
                    skillCfg = skillCfg
                }

                if skillCfg.useSkillUnit == 1 then
                    table.insert(warshipSkills, temp)
                elseif skillCfg.useSkillUnit == 2 then
                    table.insert(heroSkills, temp)
                end
            end
        end
    end

    if self.curRace == 0 then
        self.view.viewSolider.gameObject:SetActiveEx(false)
    else
        local showSolider = {}
        for k, v in pairs(cfg["solider"]) do
            if v.level == 1 and v.belong == 1 and v.race == PnlChooseSkill.RACE_TYPE[self.curRace] then
                table.insert(showSolider, v)
            end
        end
        self:setViewSoliderData(showSolider)
    end

    local curTable = {}
    if self.args.type == PnlChooseSkill.TYPE_HERO then
        curTable = heroSkills
    else
        curTable = warshipSkills
    end

    self:releaseBoxSkillChoose()
    self.boxSkillChooseList = {}

    self.view.viewSkillData:SetActiveEx(false)
    self.view.bgQuality.gameObject:SetActiveEx(false)
    local isFirst = true
    for k, v in pairs(curTable) do
        ResMgr:LoadGameObjectAsync("BoxSkillChoose", function(go)
            go.transform:SetParent(self.view.content, false)

            local quality = v.itemCfg.quality
            UIUtil.setQualityBg(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), quality)
            -- local bgName = gg.getSpriteAtlasName("SkillBox_Atlas", string.format("skill%s_icon", quality))
            -- gg.setSpriteAsync(go.transform:GetComponent(UNITYENGINE_UI_IMAGE), bgName)

            local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", v.itemCfg.icon .. "_A1")
            gg.setSpriteAsync(go.transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE), iconName)

            local imgIconRace = go.transform:Find("IconRace"):GetComponent(UNITYENGINE_UI_IMAGE)
            if v.skillCfg.race < 5 then
                imgIconRace.transform:SetActiveEx(true)
                local iconRace = gg.getSpriteAtlasName("Skill_A1_Atlas",
                    constant.RACE_MESSAGE[v.skillCfg.race].iconSmall)
                gg.setSpriteAsync(imgIconRace, iconRace)
            else
                imgIconRace.transform:SetActiveEx(false)
            end

            go.transform:Find("Cound/TxtCound"):GetComponent(UNITYENGINE_UI_TEXT).text =
                string.format("x%d", v.data.num)

            go.transform:Find("Level/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT).text = string.format("LV.%d", v.skillCfg.level)

            go.transform:Find("TxtSkillName"):GetComponent(UNITYENGINE_UI_TEXT).text = Utils.getText(v.itemCfg
                                                                                                         .languageNameID)
            go.transform:Find("ImageSel").gameObject:SetActiveEx(false)

            CS.UIEventHandler.Get(go):SetOnClick(function()
                self:onBtnSkillChoose(v.data.cfgId)
            end)
            self.boxSkillChooseList[v.data.cfgId] = go
            if isFirst then
                isFirst = false
                self:onBtnSkillChoose(v.data.cfgId)
            end
            return true
        end, true)
    end
end

function PnlChooseSkill:setViewSoliderData(datas)
    self.view.viewSolider.gameObject:SetActiveEx(true)

    for i, v in ipairs(self.boxRaceSolider) do
        v:SetActiveEx(false)
    end

    local boxCount = #self.boxRaceSolider

    for i, v in ipairs(datas) do
        local iconName = gg.getSpriteAtlasName("Soldier_A_Atlas", v.icon .. "_A")

        if i <= boxCount then
            self.boxRaceSolider[i]:SetActiveEx(true)
            local icon = self.boxRaceSolider[i].transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
            gg.setSpriteAsync(icon, iconName)
        else
            ResMgr:LoadGameObjectAsync("BoxRaceSolider", function(go)
                go.transform:SetParent(self.view.viewSolider.transform, false)
                local icon = go.transform:Find("Mask/Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
                gg.setSpriteAsync(icon, iconName)
                table.insert(self.boxRaceSolider, go)
                return true
            end, true)
        end
    end
end

function PnlChooseSkill:releaseBoxRaceSolider()
    if self.boxRaceSolider then
        for k, v in pairs(self.boxRaceSolider) do
            ResMgr:ReleaseAsset(v)
        end
        self.boxRaceSolider = {}
    end
end

function PnlChooseSkill:releaseBoxSkillChoose()
    if self.boxSkillChooseList then
        for k, v in pairs(self.boxSkillChooseList) do
            CS.UIEventHandler.Clear(v)

            ResMgr:ReleaseAsset(v)
        end
        self.boxSkillChooseList = nil
    end
end

function PnlChooseSkill:onHide()
    self:releaseEvent()

    self:releaseBoxRaceSolider()
end

function PnlChooseSkill:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)
    CS.UIEventHandler.Get(view.btnQuality):SetOnClick(function()
        self:onBtnQuality()
    end)
    CS.UIEventHandler.Get(view.btnRace):SetOnClick(function()
        self:onBtnRace()
    end)
    CS.UIEventHandler.Get(view.btnStudy):SetOnClick(function()
        self:onBtnStudy()
    end)

    local count = self.view.qualityBg.transform.childCount - 1
    for i = 0, count, 1 do
        CS.UIEventHandler.Get(self.view.qualityBg.transform:GetChild(i).gameObject):SetOnClick(function()
            self:onBtnType(1, i)
        end)
    end

    count = self.view.raceBg.transform.childCount - 1
    for i = 0, count, 1 do
        CS.UIEventHandler.Get(self.view.raceBg.transform:GetChild(i).gameObject):SetOnClick(function()
            self:onBtnType(2, i)
        end)
    end

end

function PnlChooseSkill:releaseEvent()
    local view = self.view

    CS.UIEventHandler.Clear(view.btnClose)
    CS.UIEventHandler.Clear(view.btnQuality)
    CS.UIEventHandler.Clear(view.btnRace)
    CS.UIEventHandler.Clear(view.btnStudy)

    self:releaseBoxSkillChoose()
end

function PnlChooseSkill:onDestroy()
    local view = self.view

end

function PnlChooseSkill:onBtnClose()
    self:close()
end

function PnlChooseSkill:onBtnQuality()
    local bool = self.view.qualityBg.activeSelf
    self.view.qualityBg:SetActiveEx(not bool)
    self.view.raceBg:SetActiveEx(false)
    if not bool then
        self:setTypeView(self.view.qualityBg.transform, self.curQuality)
    end
end

function PnlChooseSkill:onBtnRace()
    local bool = self.view.raceBg.activeSelf
    self.view.raceBg:SetActiveEx(not bool)
    self.view.qualityBg:SetActiveEx(false)
    if not bool then
        self:setTypeView(self.view.raceBg.transform, self.curRace)
    end
end

function PnlChooseSkill:onBtnType(type, num)
    if type == 1 then
        if self.curQuality ~= num then
            self.curQuality = num
            self:setScrollView()
        else
            self.view.qualityBg:SetActiveEx(false)
        end
    else
        if self.curRace ~= num then
            self.curRace = num
            self:setScrollView()
        else
            self.view.raceBg:SetActiveEx(false)
        end
    end
end

function PnlChooseSkill:setTypeView(parent, curNum)
    local count = parent.childCount - 1

    for i = 0, count, 1 do
        parent:GetChild(i):GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 0)
        parent:GetChild(i):Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
            Color.New(0x81 / 0xff, 0x82 / 0xff, 0x83 / 0xff, 1)
    end

    parent:GetChild(curNum):GetComponent(UNITYENGINE_UI_IMAGE).color = Color.New(1, 1, 1, 1)
    parent:GetChild(curNum):Find("Text"):GetComponent(UNITYENGINE_UI_TEXT).color =
        Color.New(0xed / 0xff, 0xf2 / 0xff, 0xff / 0xff, 1)

end

function PnlChooseSkill:onBtnSkillChoose(skillId)
    self.curSkillId = skillId

    self:setViewSkillData(skillId)
end

PnlChooseSkill.QUAILTYBG_NAME = {
    [1] = "color_icon_A",
    [2] = "color_icon_B",
    [3] = "color_icon_C",
    [4] = "color_icon_D",
    [5] = "color_icon_E"
}

function PnlChooseSkill:setViewSkillData(skillId)
    local view = self.view

    local itemCfg = cfg.getCfg("item", skillId)
    local skillCfg = cfg.getCfg("skill", itemCfg.skillCfgID[1], itemCfg.skillCfgID[2])

    local quality = skillCfg.quality

    view.viewSkillData:SetActiveEx(true)
    view.bgQuality.gameObject:SetActiveEx(true)
    local iconBg = gg.getSpriteAtlasName("QualityBg_Atlas", PnlChooseSkill.QUAILTYBG_NAME[quality])
    gg.setSpriteAsync(view.bgQuality, iconBg)
    if skillCfg.race >= 5 then
        view.iconRace.gameObject:SetActiveEx(false)
    else
        view.iconRace.gameObject:SetActiveEx(true)
        local iconRace = gg.getSpriteAtlasName("Skill_A1_Atlas", constant.RACE_MESSAGE[skillCfg.race].iconSmall)
        gg.setSpriteAsync(view.iconRace, iconRace)
    end

    UIUtil.setQualityBg(view.skillBg, quality)

    local iconName = gg.getSpriteAtlasName("Skill_A1_Atlas", skillCfg.icon .. "_A1")
    gg.setSpriteAsync(view.iconSelSkill, iconName)

    view.txtSkillLevel.text = string.format("LV.%d", skillCfg.level)
    view.txtSkillName.text = Utils.getText(skillCfg.languageNameID)
    view.txtDec.text = Utils.getText(itemCfg.languageDescID)

    for k, go in pairs(self.boxSkillChooseList) do
        go.transform:Find("ImageSel").gameObject:SetActiveEx(false)
    end
    self.boxSkillChooseList[skillId].transform:Find("ImageSel").gameObject:SetActiveEx(true)
end

function PnlChooseSkill:onBtnStudy()
    local yesCallback
    if self.args.type == PnlChooseSkill.TYPE_HERO then
        yesCallback = function()
            HeroData.C2S_Player_HeroPutonSkill(self.args.roleId, self.args.skillIndex, self.curSkillId)
            self:close()
        end
    else
        yesCallback = function()
            WarShipData.C2S_Player_WarShipPutonSkill(self.args.roleId, self.args.skillIndex, self.curSkillId)
            self:close()
        end
    end
    local itemCfg = cfg.getCfg("item", self.curSkillId)
    local skillCfg = cfg.getCfg("skill", itemCfg.skillCfgID[1], itemCfg.skillCfgID[2])

    local txtTitel = Utils.getText(skillCfg.languageNameID)
    local txtTips = Utils.getText(itemCfg.languageDescID)
    local txtNo = Utils.getText("universal_Ask_BackButton")
    local txtYes = Utils.getText("headquarters_LearnSkill_LearnBtn")

    local args = {
        txtTitel = txtTitel,
        txtTips = txtTips,
        txtYes = txtYes,
        callbackYes = yesCallback,
        txtNo = txtNo,
        bigSize = true
    }
    gg.uiManager:openWindow("PnlAlertNew", args)
end

return PnlChooseSkill
