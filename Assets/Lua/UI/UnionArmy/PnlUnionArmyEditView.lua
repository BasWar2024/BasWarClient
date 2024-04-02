
PnlUnionArmyEditView = class("PnlUnionArmyEditView")

PnlUnionArmyEditView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.btnQuickEdit = transform:Find("Root/BtnQuickEdit").gameObject
    self.btnSave = transform:Find("Root/BtnSave").gameObject

    self.txtInfoName = transform:Find("Root/LayoutInfo/BgName/TxtInfoName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtInfoLevel = transform:Find("Root/LayoutInfo/TxtInfoLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtRealLevel = transform:Find("Root/LayoutInfo/TxtInfoLevel/TxtRealLevel"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRealLevel = transform:Find("Root/LayoutInfo/TxtInfoLevel/TxtRealLevel/BtnRealLevel").gameObject
    self.txtExplain = transform:Find("Root/LayoutInfo/TxtInfoLevel/TxtRealLevel/BtnRealLevel/BgExplain/TxtExplain"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnUse = transform:Find("Root/LayoutInfo/BtnUse").gameObject
    
    self.txtInfoId = transform:Find("Root/LayoutInfo/BgName/TxtInfoId"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutInfo = transform:Find("Root/LayoutInfo")
    self.commonItemItem = self.layoutInfo:Find("CommonItemItem")
    self.commonHeroItem = self.layoutInfo:Find("CommonHeroItem")

    self.attrScrollView = self.layoutInfo:Find("AttrScrollView")
    self.layoutSkills = self.layoutInfo:Find("LayoutSkills")
    self.skillScrollView = self.layoutSkills:Find("SkillScrollView")
    
    -- self.btnRecycle = transform:Find("Root/LayoutInfo/BgName/BtnRecycle").gameObject

    self.unionArmyEditItemList = {}
    self.armys = transform:Find("Root/LayoutArmys/Armys")
    for i = 1, 5, 1 do
        table.insert(self.unionArmyEditItemList, self.armys:GetChild(i - 1))
    end

    self.layoutWarshipSelect = transform:Find("Root/LayoutArmys/LayoutWarshipSelect")
    self.commonItemWarship = self.layoutWarshipSelect:Find("CommonItemWarship")
    self.btnSetWarship = self.layoutWarshipSelect:Find("BtnSetWarship").gameObject

    self.layoutWarShip = transform:Find("Root/LayoutWarShip")
    self.warshipScrollView = self.layoutWarShip:Find("WarshipScrollView")

    self.layoutHero = transform:Find("Root/LayoutHero")
    self.heroScrollView = self.layoutHero:Find("HeroScrollView")

    self.layoutSoldier = transform:Find("Root/LayoutSoldier")
    self.soldierScrollView = self.layoutSoldier:Find("SoldierScrollView")

    self.titlesMap = {}
    self.layoutSettingTitles = transform:Find("Root/LayoutSettingTitles")

    self.titlesMap[PnlUnionArmyEdit.TYPE_WARSHIP] = self:getTitleItem(self.layoutSettingTitles:GetChild(0))
    self.titlesMap[PnlUnionArmyEdit.TYPE_HERO] = self:getTitleItem(self.layoutSettingTitles:GetChild(1))
    self.titlesMap[PnlUnionArmyEdit.TYPE_SOLDIER] = self:getTitleItem(self.layoutSettingTitles:GetChild(2))
end

function PnlUnionArmyEditView:getTitleItem(obj)
    local item = {}
    item.icon = obj:Find("Icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    item.txtBtn = obj:Find("TxtBtn"):GetComponent(UNITYENGINE_UI_TEXT)
    item.txtSelect = obj:Find("TxtSelect"):GetComponent(UNITYENGINE_UI_TEXT)
    item.imgSelect = obj:Find("ImgSelect"):GetComponent(UNITYENGINE_UI_IMAGE)
    return item
end

return PnlUnionArmyEditView