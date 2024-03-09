PnlHeroHut = class("PnlHeroHut", ggclass.UIBase)

function PnlHeroHut:ctor(args, onload)
    ggclass.UIBase.ctor(self, args, onload)
    self.layer = UILayer.normal
    self.events = {"onHeroChange",}
    self.showingType = PnlHeroHut.SHOWING_TYPE.skill
    self.attrItemList = {}
    self.skillItemList = {}
end

PnlHeroHut.SHOWING_TYPE = {
    ["skill"] = 1,
    ["upgrade"] = 2,
}

function PnlHeroHut:onAwake()
    self.view = ggclass.PnlHeroHutView.new(self.transform)
    self.attrScrollView = UIScrollView.new(self.view.attrScrollView, "CommonAttrItem", self.attrItemList)
    self.attrScrollView:setRenderHandler(gg.bind(self.onRenderHeroAttr, self))
    for i = 1, 3 do
        self.skillItemList[i] = HeroHutSkillItem.new(self.view.layoutSkill.transform:GetChild(i - 1), self)
    end
end

function PnlHeroHut:onShow()
    self:bindEvent()
    self:initMessage()
end

function PnlHeroHut:initMessage()
    self.showingType = PnlHeroHut.SHOWING_TYPE.skill
    self:refreshHero()
    self:refreshImgEnoughtUpgrade()
    self:refreshUpgrade()
    self:refreshShowingType()
end

function PnlHeroHut:refreshShowingType()
    local view = self.view
    view.layoutSkill:SetActiveEx(self.showingType == PnlHeroHut.SHOWING_TYPE.skill)
    view.layoutUpgrade:SetActiveEx(self.showingType == PnlHeroHut.SHOWING_TYPE.upgrade)
    view.btnRecycle:SetActiveEx(self.showingType == PnlHeroHut.SHOWING_TYPE.skill)

    for key, value in pairs(self.attrItemList) do
        value:setAddAttrActive(self.showingType == PnlHeroHut.SHOWING_TYPE.upgrade)
    end
    if PnlHeroHut.SHOWING_TYPE.upgrade then
        for key, value in pairs(self.skillItemList) do
            value:setSelect(false)
        end
    end
end

function PnlHeroHut:setSelectSkill(index)
    for key, value in ipairs(self.skillItemList) do
        value:setSelect(key == index)
    end
end

function PnlHeroHut:refreshUpgrade()
    local view = self.view
    if not self.ChooseingHeroCfg then
        return
    end

    view.commonUpgradeBox:setMessage(self.ChooseingHeroCfg, HeroData.ChooseingHero.lessTickEnd)
end

function PnlHeroHut:refreshHero()
    local data = HeroData.ChooseingHero
    self.ChooseingHero = data
    local view = self.view
    if data then
        self.nextLevelHeroCfg = HeroUtil:getHeroCfgMap()[data.cfgId][data.level + 1]
        local curCfg = HeroUtil:getChooseHeroCfg()
        self.ChooseingHeroCfg = curCfg
        view.txtName.text = curCfg.name
        view.txtLevel.text = data.level
        self.attrScrollView:setItemCount(#PnlHeroHut.index2Attr)
        view.sliderLife.value = data.curLife / data.life
        view.sliderLife.transform:SetActiveEx(true)
        view.txtSliderLife.text = string.format("%s/%s", data.curLife, data.life)
        view.txtDesc.text = curCfg.desc
        for i = 1, 3 do
            self.skillItemList[i]:setData(data["skillLevel" .. i], i)
        end
        gg.timer:stopTimer(self.upgradeTimer)
        if self.ChooseingHero.lessTick > 0 then
            view.sliderUpgrade.transform:SetActiveEx(true)
            self.upgradeTimer = gg.timer:startLoopTimer(0, 0.3, 99999999, function()
                local time = self.ChooseingHero.lessTickEnd - os.time()
                if time > 0 then
                    local hms = gg.time.dhms_time({day=0,hour=1,min=1,sec=1}, time)
                    view.txtSliderUpgrade.text = string.format("%sh%sm%ss", hms.hour, hms.min, hms.sec)
                    view.sliderUpgrade.value = (self.ChooseingHero.lessTick - time)  / self.ChooseingHero.lessTick
                else
                    gg.timer:stopTimer(self.upgradeTimer)
                    view.txtSliderUpgrade.text = "0h0m0s"
                    view.sliderUpgrade.value = 1
                    view.sliderUpgrade.transform:SetActiveEx(false)
                end
            end)
        else
            view.sliderUpgrade.transform:SetActiveEx(false)
        end
    else
        self.attrScrollView:setItemCount(0)
        view.txtName.text = "empty"
        view.txtLevel.text = "0"
        view.sliderUpgrade.transform:SetActiveEx(false)
        view.sliderLife.transform:SetActiveEx(false)
        for i = 1, 3 do
            self.skillItemList[i]:setData(0, i)
        end
    end
end

function PnlHeroHut:refreshImgEnoughtUpgrade()
    self.view.imgEnoughtUpgrade.gameObject:SetActiveEx(HeroUtil:checkIsEnoughtUpgrade())
end

PnlHeroHut.index2Attr = {
    cfg.attribute[1],
    cfg.attribute[2],
    cfg.attribute[3],
    cfg.attribute[4],
}

function PnlHeroHut:onRenderHeroAttr(obj, index)
    local item = CommonAttrItem:getItem(obj, self.attrItemList)
    item:setData(index, PnlHeroHut.index2Attr, self.ChooseingHeroCfg, self.nextLevelHeroCfg)
    item:setAddAttrActive(self.SHOWING_TYPE == self.SHOWING_TYPE.upgrade)
end

function PnlHeroHut:onHide()
    self:releaseEvent()
    gg.timer:stopTimer(self.upgradeTimer)

    for key, value in pairs(self.attrItemList) do
        value:release()
    end
    self.attrItemList = {}
end

function PnlHeroHut:bindEvent()
    local view = self.view

    CS.UIEventHandler.Get(view.btnBG):SetOnClick(function()
        self:onBtnBG()
    end)
    CS.UIEventHandler.Get(view.btnClose):SetOnClick(function()
        self:onBtnClose()
    end)

    self:setOnClick(view.btnLevel, function ()
        self:onBtnLevel()
    end)

    self:setOnClick(view.btnRecycle, function ()
        self:onBtnRecycle()
    end)

    view.commonUpgradeBox:setInstantCallback(gg.bind(self.onBtnInstant, self))
    view.commonUpgradeBox:setUpgradeCallback(gg.bind(self.onBtnUpgrade, self))
end

function PnlHeroHut:releaseEvent()
    local view = self.view
    CS.UIEventHandler.Clear(view.btnBG)
    CS.UIEventHandler.Clear(view.btnClose)
end

function PnlHeroHut:onDestroy()
    local view = self.view
    for key, value in pairs(self.skillItemList) do
        value:release()
    end
    self.attrScrollView:release()
    view.commonUpgradeBox:release()
end

function PnlHeroHut:onBtnBG()

end

function PnlHeroHut:onBtnClose()
    self:close()
end

function PnlHeroHut:onBtnLevel()
    if not HeroData.ChooseingHero then
        return
    end

    if self.showingType == self.SHOWING_TYPE.skill then
        self.showingType = self.SHOWING_TYPE.upgrade
    else
        self.showingType = self.SHOWING_TYPE.skill
    end
    self:refreshShowingType()
end

function PnlHeroHut:onBtnRecycle()
    if not HeroData.ChooseingHero then
        return
    end
    local callbackYes = function ()
        ItemData.C2S_Player_Move2ItemBag(HeroData.ChooseingHero.id, 10)
    end
    local args = {
        txt = string.format("Are you sure want to recycle %s?", self.ChooseingHeroCfg.name),
        callbackYes = callbackYes,
    }
    gg.uiManager:openWindow("PnlAlert", args)
end

function PnlHeroHut:onBtnInstant()
    if HeroData.ChooseingHero then
        if HeroData.ChooseingHero.lessTick > 0 then
            HeroData.C2S_Player_SpeedUp_HeroLevelUp(HeroData.ChooseingHero.id)
        else
            HeroData.C2S_Player_HeroLevelUp(HeroData.ChooseingHero.id, 1)
        end
    end
end

function PnlHeroHut:onBtnUpgrade()
    if HeroData.ChooseingHero then
        HeroData.C2S_Player_HeroLevelUp(HeroData.ChooseingHero.id, 0)
    end
end

function PnlHeroHut:onClickSkillInfo(skillIndex)
end

function PnlHeroHut:onHeroChange()
    self:initMessage()
end

return PnlHeroHut