PnlHeroHut = class("PnlHeroHut", ggclass.UIBase)

function PnlHeroHut:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload, true)
    self.layer = UILayer.normal
    self.events = {"onHeroChange"}
    self.showViewAudio = constant.AUDIO_WINDOW_OPEN
    self.needBlurBG = false
    -- self.openTweenType = UiTweenUtil.OPEN_VIEW_TYPE_FADE
end

PnlHeroHut.SHOWING_TYPE_INFO = 1
PnlHeroHut.SHOWING_TYPE_UPGRADE = 2

function PnlHeroHut:onAwake()
    self.view = ggclass.PnlHeroHutView.new(self.pnlTransform)
    local view = self.view
    self.attrItemList = {}
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))

    self.attrUpgradeItemList = {}
    self.attrUpgradeScrollView = UIScrollView.new(self.view.attrUpgradeScrollView, "CommonAttrItem",
        self.attrUpgradeItemList)
    self.attrUpgradeScrollView:setRenderHandler(gg.bind(self.onRenderUpgradeAttr, self))

    self.skillItemList = {}
    self.skillScrollView = UIScrollView.new(view.skillScrollView, "HeroHudSkillItem", self.skillItemList)
    self.skillScrollView:setRenderHandler(gg.bind(self.onRenderSkillItem, self))

    self.heroItemList = {}
    self.heroScrollView = UILoopScrollView.new(view.heroScrollView, self.heroItemList)
    self.heroScrollView:setRenderHandler(gg.bind(self.onRenderHeroItem, self))

    view.commonUpgradeNewBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeNewBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
    view.commonUpgradeNewBox:setExchangeInfoFunc(gg.bind(self.exchangeInfoFunc, self))

    self.showingTypeMap = {
        [PnlHeroHut.SHOWING_TYPE_INFO] = {
            type = PnlHeroHut.SHOWING_TYPE_INFO,
            part = view.layoutInfo,
            func = gg.bind(self.refreshInfo, self)
        },

        [PnlHeroHut.SHOWING_TYPE_UPGRADE] = {
            type = PnlHeroHut.SHOWING_TYPE_UPGRADE,
            part = view.layoutUpgrade,
            func = gg.bind(self.refreshUpgrade, self)
        }
    }

    self.attentionUpgradeBox = AttentionUpgradeBox.new(self.view.attentionUpgradeBox)
end

function PnlHeroHut:onShow()
    self:bindEvent()
    self.showingHero = nil
    self.view.commonUpgradeNewBox:open()
    self.showingType = PnlHeroHut.SHOWING_TYPE_UPGRADE
    self.showingHero = self.args.showingData
    self:initMessage()

end

function PnlHeroHut:initMessage()
    local view = self.view
    self:selectSkill(nil)
    self.showingType = self.showingType or PnlHeroHut.SHOWING_TYPE_INFO
    self:refreshViewByType(self.showingType)
end

function PnlHeroHut:refreshViewByType(showingType)
    local view = self.view
    view.btnClose:SetActiveEx(showingType ~= PnlHeroHut.SHOWING_TYPE_INFO)

    self.showingType = showingType
    local showingTypeData = self.showingTypeMap[showingType]

    if not showingTypeData then
        self:refreshViewByType(PnlHeroHut.SHOWING_TYPE_INFO)
        return
    end

    for key, value in pairs(self.showingTypeMap) do
        value.part:SetActiveEx(key == showingType)
    end
    if showingTypeData.func then
        showingTypeData.func()
    end
end

function PnlHeroHut:refreshInfo()
    self.heroDataList = {}
    for key, value in pairs(HeroData.heroDataMap) do
        table.insert(self.heroDataList, value)
    end

    local itemCount = math.ceil(#self.heroDataList / 5)
    self.heroScrollView:setDataCount(itemCount)
    self:setShowingHero(self.showingHero or HeroData.ChooseingHero or self.heroDataList[1])
end

function PnlHeroHut:setShowingHero(hero)
    local view = self.view
    self.showingHero = hero

    if not self.showingHero then
        view.txtEmpty.gameObject:SetActiveEx(true)
        view.layoutHeroInfo:SetActiveEx(false)
        view.btnRecycle:SetActiveEx(false)
        view.txtInfoId.gameObject:SetActiveEx(false)
        return
    end

    if hero.chain > 0 then
        view.btnRecycle:SetActiveEx(true)
        view.txtInfoId.gameObject:SetActiveEx(true)
    else
        view.btnRecycle:SetActiveEx(false)
        view.txtInfoId.gameObject:SetActiveEx(false)
    end
    view.btnRecycle:SetActiveEx(true)

    view.txtEmpty.gameObject:SetActiveEx(false)
    view.layoutHeroInfo:SetActiveEx(true)

    self.showingHeroCfg = HeroUtil.getHeroCfg(self.showingHero.cfgId, self.showingHero.level, self.showingHero.quality)

    for key, value in pairs(self.heroItemList) do
        value:refreshChoosing()
    end

    view.txtInfoName.text = Utils.getText(self.showingHeroCfg.languageNameID)
    view.txtInfoId.text = self.showingHero.id
    gg.setSpriteAsync(view.imgIcon, gg.getSpriteAtlasName("Icon_E_Atlas", self.showingHeroCfg.icon .. "_E"))

    -- local level = math.min(self.args.buildData.level, self.showingHero.level)
    view.txtInfoLevel.text = self.showingHero.level

    -- if level < self.showingHero.level then
    --     view.txtRealLevel.transform:SetActiveEx(true)
    --     view.txtRealLevel.text = self.showingHero.level
    -- else
    --     view.txtRealLevel.transform:SetActiveEx(false)
    -- end
    view.txtRealLevel.transform:SetActiveEx(false)
    self:refreshInfoAttr()
    self:refreshSkill()
end

function PnlHeroHut:refreshInfoAttr()
    if not self.showingHero then
        self.attrScrollView:setItemCount(0)
        return
    end
    local view = self.view
    self.heroAttrMap = HeroUtil.getHeroAttr(self.showingHero.cfgId, self.showingHero.level, self.showingHero.quality)
    self.compareHeroAttrMap = {}
    self.attrDataList = constant.HERO_SHOW_ATTR
    local attrCount = #self.attrDataList
    self.attrScrollView:setItemCount(attrCount)
end

function PnlHeroHut:refreshSkill()
    if not self.showingHero then
        self.skillScrollView:setItemCount(0)
        return
    end

    self.skillDataList = {}
    for i = 1, 3 do
        local skillCfgId = self.showingHero["skill" .. i]

        if skillCfgId and skillCfgId > 0 then
            self.skillDataList[i] = {}
            self.skillDataList[i].index = i
            self.skillDataList[i].level = self.showingHero["skillLevel" .. i]
            self.skillDataList[i].skillCfg = SkillUtil.getSkillCfgMap()[skillCfgId][self.skillDataList[i].level]
        end
    end
    self.skillScrollView:setItemCount(3)
end

function PnlHeroHut:onBtnRealLevel()
    self.view.bgExplain:SetActiveEx(true)
    self.view.btnCloseExplain:SetActiveEx(true)
end

function PnlHeroHut:onBtnCloseExplain()
    self.view.bgExplain:SetActiveEx(false)
    self.view.btnCloseExplain:SetActiveEx(false)
end

function PnlHeroHut:onBtnInfoUpgrade()
    self:refreshViewByType(PnlHeroHut.SHOWING_TYPE_UPGRADE)
end

function PnlHeroHut:onBtnApply()
    if not HeroData.ChooseingHero or self.showingHero.id ~= HeroData.ChooseingHero.id then
        HeroData.C2S_Player_SetUseHero(self.showingHero.id)
    end
end

function PnlHeroHut:onRenderHeroItem(obj, index)
    for i = 1, 5 do
        local subIndex = (index - 1) * 5 + i
        local item = HeroHutHeroItem:getItem(obj.transform:GetChild(i - 1), self.heroItemList, self)
        item:setData(self.heroDataList[subIndex])
    end
end

function PnlHeroHut:refreshUpgrade()
    local view = self.view

    self.showingHeroCfg = HeroUtil.getHeroCfg(self.showingHero.cfgId, self.showingHero.level, self.showingHero.quality)

    if not self.showingHeroCfg then
        return
    end
    view.commonUpgradeNewBox:setMessage(self.showingHeroCfg, self.showingHero.lessTickEnd)
    view.txtUpgradeLevel.text = self.showingHero.level
    view.txtUpgradeName.text = Utils.getText(self.showingHeroCfg.languageNameID)
    view.txtDesc.text = Utils.getText(self.showingHeroCfg.desc)
    if self.showingHero.chain > 0 then
        view.txtUpgradeId.text = self.showingHero.id
        view.txtUpgradeId.gameObject:SetActiveEx(true)
    else
        view.txtUpgradeId.gameObject:SetActiveEx(false)
    end
    local iconName = self.showingHeroCfg.icon .. "_C"
    if self.lastIconName ~= iconName then
        gg.setSpriteAsync(view.imgHero, iconName)
        gg.setSpriteAsync(view.imgHero1, iconName)
        self.lastIconName = iconName
    end

    self:refreshLevel()
    self:refreshUpgradeAttr()
end

function PnlHeroHut:refreshLevel()
    local view = self.view
    local isLevelMax =
        HeroUtil.getHeroCfg(self.showingHero.cfgId, self.showingHero.level + 1, self.showingHero.quality) == nil

    if isLevelMax then
        self.attentionUpgradeBox.transform:SetActiveEx(false)
        view.levelMax:SetActiveEx(true)
        view.levelUpgrade:SetActiveEx(false)
        view.txtMaxLevel.text = self.showingHero.level
        self.view.commonUpgradeNewBox:close()
    elseif not self.attentionUpgradeBox:checkHero(self.showingHeroCfg) then
        self.attentionUpgradeBox.transform:SetActiveEx(true)
        view.levelMax:SetActiveEx(false)
        view.levelUpgrade:SetActiveEx(true)
        self.view.commonUpgradeNewBox:close()
    else
        self.attentionUpgradeBox.transform:SetActiveEx(false)
        view.levelMax:SetActiveEx(false)
        view.levelUpgrade:SetActiveEx(true)
        view.txtCurLevel.text = self.showingHero.level
        view.txtNextLevel.text = self.showingHero.level + 1
        self.view.commonUpgradeNewBox:open()
    end
end

function PnlHeroHut:onRenderUpgradeAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    local attrShowType = item:setAttrShowType(CommonAttrItem.TYPE_NORMAL)
    if self.showingType == PnlHeroHut.SHOWING_TYPE_INFO then
        attrShowType = CommonAttrItem.TYPE_SINGLE_TEXT
    end
    item:setData(index, self.attrUpgradeDataList, self.heroUpgradeAttrMap, self.compareHeroUpgradeAttrMap, attrShowType)
end

function PnlHeroHut:refreshUpgradeAttr()
    self.heroUpgradeAttrMap = HeroUtil.getHeroAttr(self.showingHero.cfgId, self.showingHero.level,
        self.showingHero.quality)
    self.compareHeroUpgradeAttrMap = HeroUtil.getHeroAttr(self.showingHero.cfgId, self.showingHero.level + 1,
        self.showingHero.quality)
    self.attrUpgradeDataList = AttrUtil.getAttrChangeCfgList(constant.HERO_SHOW_ATTR, self.heroUpgradeAttrMap,
        self.compareHeroUpgradeAttrMap)
    self.attrUpgradeScrollView:setItemCount(#self.attrUpgradeDataList)
end

function PnlHeroHut:onBtnUpgradeReturn()
    self:refreshViewByType(PnlHeroHut.SHOWING_TYPE_INFO)
end

function PnlHeroHut:selectSkill(index)
    for key, value in pairs(self.skillItemList) do
        value:setSelect(index)
    end
end

function PnlHeroHut:onRenderHeroAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setAttrShowType(CommonAttrItem.TYPE_NORMAL)
    local attrShowType = CommonAttrItem.TYPE_NORMAL
    if self.showingType == PnlHeroHut.SHOWING_TYPE_INFO then
        attrShowType = CommonAttrItem.TYPE_SINGLE_TEXT
    end
    item:setData(index, self.attrDataList, self.heroAttrMap, self.compareHeroAttrMap, attrShowType)
end

function PnlHeroHut:onRenderSkillItem(obj, index)
    local item = HeroHutSkillItem:getItem(obj, self.skillItemList, self)
    item:setData(self.skillDataList[index])
end

function PnlHeroHut:onHide()
    self:releaseEvent()
    gg.timer:stopTimer(self.upgradeTimer)
    self.view.commonUpgradeNewBox:close()
end

function PnlHeroHut:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:close()
    end)

    self:setOnClick(view.btnInfoClose, gg.bind(self.close, self))

    self:setOnClick(view.btnRecycle, function()
        self:onBtnRecycle()
    end)

    self:setOnClick(view.btnRealLevel, gg.bind(self.onBtnRealLevel, self))
    self:setOnClick(view.btnCloseExplain, gg.bind(self.onBtnCloseExplain, self))

    self:setOnClick(view.btnUpgrade, gg.bind(self.onBtnInfoUpgrade, self))
    self:setOnClick(view.btnApply, gg.bind(self.onBtnApply, self))
    self:setOnClick(view.btnUpgradeReturn, gg.bind(self.onBtnUpgradeReturn, self))
end

function PnlHeroHut:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlHeroHut:onDestroy()
    local view = self.view
    self.attrScrollView:release()
    view.commonUpgradeNewBox:release()
    self.skillScrollView:release()
    self.heroScrollView:release()
    self.attentionUpgradeBox:release()
end

function PnlHeroHut:onBtnRecycle()
    if not self.showingHero then
        return
    end

    local callbackYes = function()

    end

    local args = {
        txt = string.format(Utils.getText("recycle_Text"), Utils.getText(self.showingHeroCfg.languageNameID)),
        callbackYes = callbackYes
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlHeroHut:onBtnInstant()
    if self.showingHero then
        HeroData.C2S_Player_HeroLevelUp(self.showingHero.id, 1)
    end
end

function PnlHeroHut:onBtnUpgrade(isOnExchange)
    if not self.showingHero then
        return
    end
    if isOnExchange then
        HeroData.C2S_Player_HeroLevelUp(self.showingHero.id, 0)
    else -- if not HeroUtil.checkHeroBusy(true) then
        HeroData.C2S_Player_HeroLevelUp(self.showingHero.id, 0)
    end
    -- gg.resEffectManager:explodeUiRes(self.__name, self.view.commonUpgradeNewBox.transform.position, 
    -- self.view.commonUpgradeNewBox.transform.position, nil, "StarCoin2D")
end

function PnlHeroHut:exchangeInfoFunc()
    local isBusy, cost, busyType = HeroUtil.checkHeroBusy(false)
    if isBusy then
        local text = ""
        if busyType == HeroUtil.HERO_UPGRADING_TYPE_SKILL then
            text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        elseif busyType == HeroUtil.HERO_UPGRADING_TYPE_LEVEL then
            text = Utils.getText("universal_Ask_FinishAndExchangeRes")
        end
        return {
            extraExchangeCost = cost,
            text = text
        }
    end
end

function PnlHeroHut:onClickSkillInfo(skillIndex)
end

function PnlHeroHut:onHeroChange()
    self.showingHero = HeroData.heroDataMap[self.showingHero.id]

    if self.showingHero then
        -- self.showingHero = nil
        self.showingHeroCfg = HeroUtil.getHeroCfg(self.showingHero.cfgId, self.showingHero.level,
            self.showingHero.quality)
    else
        self.showingHeroCfg = nil
    end
    self:initMessage()
end

return PnlHeroHut
