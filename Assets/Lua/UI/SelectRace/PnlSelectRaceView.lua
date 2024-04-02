
PnlSelectRaceView = class("PnlSelectRaceView")

PnlSelectRaceView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject

    self.layoutQuestion = transform:Find("Root/LayoutQuestion")
    self.selectScrollView = self.transform:Find("Root/LayoutQuestion/SelectScrollView")
    self.txtQuextion = self.transform:Find("Root/LayoutQuestion/TxtQuestion"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutConfirm = transform:Find("Root/LayoutConfirm")
    self.txtRace = self.layoutConfirm:Find("TxtRace"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnConfirm = self.layoutConfirm:Find("BtnConfirm").gameObject
    self.btnCloseConfirm = self.layoutConfirm:Find("ViewBg/Bg/BtnClose").gameObject
    self.imgHead = self.layoutConfirm:Find("ImgHead"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.txtFinalName = self.layoutConfirm:Find("TxtFinalName"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutChangeRace = transform:Find("Root/LayoutChangeRace")
    self.arrows = self.layoutChangeRace:Find("Arrows")

    self.layoutRaces = self.layoutChangeRace:Find("LayoutRaces")
    self.btnRaceMap = {}
    for i = 1, self.layoutRaces.childCount do
        local obj = self.layoutRaces:GetChild(i - 1)
        self.btnRaceMap[constant[obj.name]] = {}
        self.btnRaceMap[constant[obj.name]].btn = obj.gameObject
        obj.transform:GetComponent(UNITYENGINE_UI_IMAGE).alphaHitTestMinimumThreshold = 0.5
        self.btnRaceMap[constant[obj.name]].imgSelect = obj.transform:Find("ImgSelect"):GetComponent(UNITYENGINE_UI_IMAGE)
        self.btnRaceMap[constant[obj.name]].imgGray = obj.transform:Find("ImgGray"):GetComponent(UNITYENGINE_UI_IMAGE)
        --self.btnRaceMap[constant[obj.name]].btn.
    end
    self.txtBackground = self.layoutChangeRace:Find("TxtBackground"):GetComponent(typeof(CS.TextYouYU))
    self.txtBackground2 = self.layoutChangeRace:Find("TxtBackground2"):GetComponent(typeof(CS.TextYouYU))

    self.btnJoin = self.layoutChangeRace:Find("BtnJoin").gameObject

    self.raceSpineMap = {}
    self.layoutRaceSpine = self.layoutChangeRace:Find("LayoutRaceSpine")
    self.raceSpineMap[constant.RACE_CENTRA] = self.layoutRaceSpine:Find("CENTRA")
    self.raceSpineMap[constant.RACE_SCOURGE] = self.layoutRaceSpine:Find("SCOURGE")
    self.raceSpineMap[constant.RACE_ENDARI] = self.layoutRaceSpine:Find("ENDARI")
    self.raceSpineMap[constant.RACE_TALUS] = self.layoutRaceSpine:Find("TALUS")

    self.playerDetailedSelectHeadBox = transform:Find("PlayerDetailedSelectHeadBox")

    self.layoutVideo = gg.uiManager.uiRoot.informationNode:Find("LayoutVideo")
    -- self.layoutVideo = transform:Find("LayoutVideo")
    self.btnSkip = self.layoutVideo:Find("BtnSkip").gameObject
    self.videoPlayer = self.layoutVideo:Find("VideoPlayer"):GetComponent(typeof(CS.UnityEngine.Video.VideoPlayer))
end

return PnlSelectRaceView