PnlHeadquartersView = class("PnlHeadquartersView")

PnlHeadquartersView.ctor = function(self, transform)

    self.transform = transform

    self.iconBg = transform:Find("ViewFullBg/Bg/IconBg"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject

    self.btnShip = transform:Find("ViewHeadquarters/BoxNft/BgImage/BtnShip").gameObject
    self.btnHero = transform:Find("ViewHeadquarters/BoxNft/BgImage/BtnHero").gameObject
    self.btnTower = transform:Find("ViewHeadquarters/BoxNft/BgImage/BtnTower").gameObject

    self.txtType = transform:Find("ViewHeadquarters/BoxNft/BgImage/TxtType"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnSwich = transform:Find("ViewHeadquarters/BoxNft/BgImage/BtnSwich").gameObject
    self.txtSwich = transform:Find("ViewHeadquarters/BoxNft/BgImage/BtnSwich/TxtSwich")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.bgSwich = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich").gameObject

    self.btnTraitAll = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Trait/BtnTraitAll").gameObject
    self.btnTraitL = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Trait/BtnTraitL").gameObject
    self.btnTraitSsr = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Trait/BtnTraitSsr").gameObject
    self.btnTraitSr = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Trait/BtnTraitSr").gameObject
    self.btnTraitR = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Trait/BtnTraitR").gameObject
    self.btnTraitN = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Trait/BtnTraitN").gameObject

    self.btnRaceAll = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Race/BtnRaceAll").gameObject
    self.btnRaceHumanus = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Race/BtnRaceHumanus").gameObject
    self.btnRaceTalus = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Race/BtnRaceTalus").gameObject
    self.btnRaceCentra = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Race/BtnRaceCentra").gameObject
    self.btnRaceEndari = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Race/BtnRaceEndari").gameObject
    self.btnRaceScourge = transform:Find("ViewHeadquarters/BoxNft/BgImage/BgSwich/Race/BtnRaceScourge").gameObject

    self.txtNoDefense = transform:Find("ViewHeadquarters/BoxNft/BgImage/TxtNoDefense").gameObject

    self.boxInfo = transform:Find("ViewHeadquarters/BoxInfo").gameObject
    self.iconRare = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/IconRare"):GetComponent(
        UNITYENGINE_UI_IMAGE)
    self.txtName = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TxtName")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.txtId = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TxtId"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtLv = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TxtLv"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnUpgrade = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/BtnUpgrade").gameObject
    self.txtlDurability = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TitelDurability/TxtlDurability")
        :GetComponent(UNITYENGINE_UI_TEXT)

    self.btnWrench = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/BtnWrench").gameObject
    self.btnFixAll = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/BtnFixAll").gameObject
    self.btnRefreshInfo = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/BtnRefreshInfo").gameObject

    self.sliderDurability = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/SliderDurability/Fill")
        :GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtWrenchTime = transform:Find("ViewHeadquarters/BoxInfo/BoxNftName/BgName/TxtWrenchTime"):GetComponent(
        UNITYENGINE_UI_TEXT)

    self.btnSet = transform:Find("ViewHeadquarters/BtnSet").gameObject

    self.btnDismantle = transform:Find("ViewHeadquarters/BtnDismantle").gameObject

    self.nftContent = transform:Find("ViewHeadquarters/BoxNft/BgImage/ScrollView/Viewport/Content")

    self.txtNftCount = transform:Find("ViewHeadquarters/BoxNft/BgImage/TxtNftCount"):GetComponent(UNITYENGINE_UI_TEXT)

    self.attrScrollView = transform:Find("ViewHeadquarters/BoxInfo/BoxAttribute/BgAttribute/AttrScrollView")

    self.boxSkill = transform:Find("ViewHeadquarters/BoxInfo/BoxSkill").gameObject

    self.itemSkillList = {
        [1] = transform:Find("ViewHeadquarters/BoxInfo/BoxSkill/BgSkill/ViewSkills/ItemHeadquartersSkill"),
        [2] = transform:Find("ViewHeadquarters/BoxInfo/BoxSkill/BgSkill/ViewSkills/ItemHeadquartersSkill2"),
        [3] = transform:Find("ViewHeadquarters/BoxInfo/BoxSkill/BgSkill/ViewSkills/ItemHeadquartersSkill3"),
        [4] = transform:Find("ViewHeadquarters/BoxInfo/BoxSkill/BgSkill/ViewSkills/ItemHeadquartersSkill4")

    }

    self.bgArmy = transform:Find("ViewHeadquarters/BgArmy").gameObject
    self.txtArmyId = transform:Find("ViewHeadquarters/BgArmy/ImageArmy/Text"):GetComponent(UNITYENGINE_UI_TEXT)
    self.iconArmySolider = transform:Find("ViewHeadquarters/BgArmy/BoxSolider/Mask/Icon"):GetComponent(
        UNITYENGINE_UI_IMAGE)

    self.boxLocation =  transform:Find("ViewHeadquarters/BoxInfo/BoxLocation").gameObject
    self.txtLocation = transform:Find("ViewHeadquarters/BoxInfo/BoxLocation/BgLocation/ViewLocation/TxtLocation"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnRecycle = transform:Find("ViewHeadquarters/BoxInfo/BoxLocation/BgLocation/ViewLocation/BtnRecycle").gameObject
    self.txtState = transform:Find("ViewHeadquarters/BoxInfo/BoxLocation/BgLocation/ViewLocation/TxtState"):GetComponent(UNITYENGINE_UI_TEXT)

end

return PnlHeadquartersView
