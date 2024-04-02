
PnlPlanetView = class("PnlPlanetView")

PnlPlanetView.ctor = function(self, transform)
    self.transform = transform
    self.btnReturn = transform:Find("BtnReturn").gameObject
    self.btnBag = transform:Find("BtnBag").gameObject
    --self.btnBuild = transform:Find("BtnBuild").gameObject

    -- self.btnPack = transform:Find("BtnPack").gameObject

    self.layoutBattle = transform:Find("LayoutBattle")
    self.btnAttack = transform:Find("LayoutBattle/BtnAttack").gameObject
    self.txtAttackCost = self.btnAttack.transform:Find("TxtCost"):GetComponent(UNITYENGINE_UI_TEXT)
    self.imgBtnGray = self.btnAttack.transform:Find("ImgGray"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.btnUnionAttack = transform:Find("LayoutBattle/BtnUnionAttack").gameObject

    self.heroItem = self.layoutBattle:Find("HeroItem")
    self.heroCommonItemItem = CommonItemItem.new(self.heroItem:Find("CommonItemItem"))

    self.heroSkill = self.heroItem:Find("HeroSkill")
    self.skillCommonItemItem = CommonItemItem.new(self.heroSkill:Find("CommonItemItem"))
    
    self.soldierScrollView = self.layoutBattle:Find("SoldierScrollView")

    --self.layoutRes = transform:Find("LayoutRes")
    -- self.txtCarbovyl = transform:Find("LayoutRes/RES_CARBOXYL/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)
    -- self.txtIntegral = transform:Find("LayoutRes/RES_INTEGRAL/TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)

    self.integralItem = transform:Find("LayoutBattle/LayoutRes/RES_INTEGRAL")
    self.txtIntegral = self.integralItem:Find("TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutRes = transform:Find("LayoutBattle/LayoutRes")
    self.resMap = {}
    for i = 1, self.layoutRes.childCount do
        local item = self.layoutRes:GetChild(i - 1)
        local resId = constant[item.name]
        if resId then
            self.resMap[resId] = {} 
            self.resMap[resId].item = item
            self.resMap[resId].TxtCount = item:Find("TxtCount"):GetComponent(UNITYENGINE_UI_TEXT)
        end
    end
end

return PnlPlanetView