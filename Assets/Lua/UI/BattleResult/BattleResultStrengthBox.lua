BattleResultStrengthBox = BattleResultStrengthBox or class("BattleResultStrengthBox", ggclass.UIBaseItem)

function BattleResultStrengthBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function BattleResultStrengthBox:onInit()
    self.btnUpgradeSkill = self:Find("LayoutBtns/BtnUpgradeSkill")
    self:setOnClick(self.btnUpgradeSkill, gg.bind(self.onBtnUpgradeSkill, self))
    self.btnUpgradeSoldiers = self:Find("LayoutBtns/BtnUpgradeSoldiers")
    self:setOnClick(self.btnUpgradeSoldiers, gg.bind(self.onBtnUpgradeSoldiers, self))
    self.btnUpgradeHeros = self:Find("LayoutBtns/BtnUpgradeHeros")
    self:setOnClick(self.btnUpgradeHeros, gg.bind(self.onBtnUpgradeHeros, self))
    self.btnAddHeros = self:Find("LayoutBtns/BtnAddHeros")
    self:setOnClick(self.btnAddHeros, gg.bind(self.onBtnAddHeros, self))
end

function BattleResultStrengthBox:onBtnUpgradeSkill()
    gg.uiManager:openWindow("PnlHeadquarters")
end

function BattleResultStrengthBox:onBtnUpgradeSoldiers()

    local args = {}

    for key, value in pairs(BuildData.buildData) do
        if value.cfgId == constant.BUILD_HYPERSPACERESEARCH then
            args.buildData = value
            args.buildCfg = BuildUtil.getCurBuildCfg(value.cfgId, value.level, value.quality)
        end
    end

    gg.uiManager:openWindow("PnlInstitute", args)
end

function BattleResultStrengthBox:onBtnUpgradeHeros()
    gg.uiManager:openWindow("PnlHeadquarters")
end

function BattleResultStrengthBox:onBtnAddHeros()
    gg.uiManager:openWindow("PnlDrawCard")
end
