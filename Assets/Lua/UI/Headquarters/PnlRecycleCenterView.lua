PnlRecycleCenterView = class("PnlRecycleCenterView")

PnlRecycleCenterView.ctor = function(self, transform)

    self.transform = transform

    self.bgInfo = transform:Find("ViewHeadquarters/BoxInfo/BgInfo"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.iconRare = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/IconRare"):GetComponent(
        UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TxtName")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLv = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtlDurability = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TitelDurability/TxtlDurability")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.sliderDurability = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/SliderDurability/Fill")
        :GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtId = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TxtId"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnDismantel = transform:Find("ViewHeadquarters/BoxInfo/BoxButton/BtnDismantel").gameObject
    self.btnSell = transform:Find("ViewHeadquarters/BoxInfo/BoxButton/BtnSell").gameObject

    self.btnSwichRace = transform:Find("ViewHeadquarters/BtnSwichRace").gameObject
    self.txtSwich = transform:Find("ViewHeadquarters/BtnSwichRace/TxtSwich"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnSwichTrait = transform:Find("ViewHeadquarters/BtnSwichTrait").gameObject
    self.txtSwich = transform:Find("ViewHeadquarters/BtnSwichTrait/TxtSwich"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRaceAll = transform:Find("ViewHeadquarters/Race/BtnRaceAll").gameObject
    self.btnRaceHumanus = transform:Find("ViewHeadquarters/Race/BtnRaceHumanus").gameObject
    self.btnRaceCentra = transform:Find("ViewHeadquarters/Race/BtnRaceCentra").gameObject
    self.btnRaceScourge = transform:Find("ViewHeadquarters/Race/BtnRaceScourge").gameObject
    self.btnRaceEndari = transform:Find("ViewHeadquarters/Race/BtnRaceEndari").gameObject
    self.btnRaceTalus = transform:Find("ViewHeadquarters/Race/BtnRaceTalus").gameObject
    self.btnTraitAll = transform:Find("ViewHeadquarters/Trait/BtnTraitAll").gameObject
    self.btnTraitS = transform:Find("ViewHeadquarters/Trait/BtnTraitS").gameObject
    self.btnTraitA = transform:Find("ViewHeadquarters/Trait/BtnTraitA").gameObject
    self.btnTraitB = transform:Find("ViewHeadquarters/Trait/BtnTraitB").gameObject
    self.btnAll = transform:Find("ViewHeadquarters/BtnAll").gameObject
    self.btnClose = transform:Find("BtnClose").gameObject
    self.txtParice = transform:Find("ViewHeadquarters/TitelGet/TxtParice"):GetComponent(UNITYENGINE_UI_TEXT)

    self.content = transform:Find("ViewHeadquarters/ScrollView/Viewport/Content")

    self.attrScrollView = transform:Find("ViewHeadquarters/BoxInfo/BoxAttribute/BgAttribute/AttrScrollView")
    self.itemHeadquartersSkill = transform:Find("ViewHeadquarters/BoxInfo/BoxSkill/BgSkill/ItemHeadquartersSkill")
    self.boxInfo = transform:Find("ViewHeadquarters/BoxInfo").gameObject
    self.layoutInfo = transform:Find("ViewHeadquarters/LayoutInfo").gameObject
    self.txtSkillName = transform:Find("ViewHeadquarters/LayoutInfo/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtNum = transform:Find("ViewHeadquarters/LayoutInfo/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtDesc = transform:Find("ViewHeadquarters/LayoutInfo/TxtDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconSkillBg = transform:Find("ViewHeadquarters/LayoutInfo/IconBg"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.imgIcon = transform:Find("ViewHeadquarters/LayoutInfo/IconBg/Mask/ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.btnDismantelSkill = transform:Find("ViewHeadquarters/LayoutInfo/BtnDismantelSkill").gameObject
    self.btnSellSkill = transform:Find("ViewHeadquarters/LayoutInfo/BtnSellSkill").gameObject

    self.race = transform:Find("ViewHeadquarters/Race").gameObject
    self.trait = transform:Find("ViewHeadquarters/Trait").gameObject

    self.layoutLeft = transform:Find("ViewBg/LayoutLeft")

    self.boxSkill = transform:Find("ViewHeadquarters/BoxInfo/BoxSkill").gameObject

end

return PnlRecycleCenterView
