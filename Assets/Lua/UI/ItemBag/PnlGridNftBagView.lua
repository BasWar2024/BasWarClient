PnlGridNftBagView = class("PnlGridNftBagView")

PnlGridNftBagView.ctor = function(self, transform)

    self.transform = transform

    self.bgInfo = transform:Find("ViewBg/Bg/BgInfo"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.iconRare = transform:Find("ViewBuildItems/BoxInfo/BoxNftName/BgName/IconRare"):GetComponent(
        UNITYENGINE_UI_IMAGE)

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtName = transform:Find("ViewBuildItems/BoxInfo/BoxNftName/BgName/TxtName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLv = transform:Find("ViewBuildItems/BoxInfo/BoxNftName/BgName/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtlDurability = transform:Find("ViewBuildItems/BoxInfo/BoxNftName/BgName/TitelDurability/TxtlDurability")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.sliderDurability = transform:Find("ViewBuildItems/BoxInfo/BoxNftName/BgName/SliderDurability/Fill")
        :GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtId = transform:Find("ViewBuildItems/BoxInfo/BoxNftName/BgName/TxtId"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnBuild = transform:Find("ViewBuildItems/BoxInfo/BtnBuild").gameObject
    self.btnSwichRace = transform:Find("ViewBuildItems/BtnSwichRace").gameObject
    self.txtSwich = transform:Find("ViewBuildItems/BtnSwichRace/TxtSwich"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnSwichTrait = transform:Find("ViewBuildItems/BtnSwichTrait").gameObject
    self.txtSwich = transform:Find("ViewBuildItems/BtnSwichTrait/TxtSwich"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRaceAll = transform:Find("ViewBuildItems/Race/BtnRaceAll").gameObject
    self.btnRaceHumanus = transform:Find("ViewBuildItems/Race/BtnRaceHumanus").gameObject
    self.btnRaceCentra = transform:Find("ViewBuildItems/Race/BtnRaceCentra").gameObject
    self.btnRaceScourge = transform:Find("ViewBuildItems/Race/BtnRaceScourge").gameObject
    self.btnRaceEndari = transform:Find("ViewBuildItems/Race/BtnRaceEndari").gameObject
    self.btnRaceTalus = transform:Find("ViewBuildItems/Race/BtnRaceTalus").gameObject
    self.btnTraitAll = transform:Find("ViewBuildItems/Trait/BtnTraitAll").gameObject
    self.btnTraitL = transform:Find("ViewBuildItems/Trait/BtnTraitL").gameObject
    self.btnTraitSsr = transform:Find("ViewBuildItems/Trait/BtnTraitSsr").gameObject
    self.btnTraitS = transform:Find("ViewBuildItems/Trait/BtnTraitS").gameObject
    self.btnTraitA = transform:Find("ViewBuildItems/Trait/BtnTraitA").gameObject
    self.btnTraitB = transform:Find("ViewBuildItems/Trait/BtnTraitB").gameObject

    self.btnAll = transform:Find("ViewBuildItems/BtnAll"):GetComponent(UNITYENGINE_UI_TOGGLE)

    self.txtNum = transform:Find("ViewBuildItems/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("BtnClose").gameObject

    self.content = transform:Find("ViewBuildItems/ScrollView/Viewport/Content")

    self.attrScrollView = transform:Find("ViewBuildItems/BoxInfo/BoxAttribute/BgAttribute/AttrScrollView")
    self.itemHeadquartersSkill = transform:Find("ViewBuildItems/BoxInfo/BoxSkill/BgSkill/ItemHeadquartersSkill")
    self.boxInfo = transform:Find("ViewBuildItems/BoxInfo").gameObject

    self.race = transform:Find("ViewBuildItems/Race").gameObject
    self.trait = transform:Find("ViewBuildItems/Trait").gameObject

end

return PnlGridNftBagView
