PvpStageBox = PvpStageBox or class("PvpStageBox", ggclass.UIBaseItem)
function PvpStageBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    self.initData = initData
end

function PvpStageBox:onInit()
    self.txtStage = self:Find("BgStage/TxtStage"):GetComponent(typeof(CS.TextYouYU))
    self.imgStage = self:Find("BgStage/ImgStage"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.layoutStars = self:Find("BgStage/LayoutStars").transform
    self.starsList = {}
    for i = 1, self.layoutStars.childCount do
        local trans = self.layoutStars:GetChild(i - 1)
        self.starsList[i] = {}
        self.starsList[i].trans = trans
        self.starsList[i].imgStar = trans.transform:Find("ImgStar"):GetComponent(UNITYENGINE_UI_IMAGE)
    end

    self.sliderStage = self:Find("SliderStage"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.textSliderStage = self.sliderStage.transform:Find("TextSliderStage"):GetComponent(UNITYENGINE_UI_TEXT)
    self.textSliderStage2 = self.textSliderStage.transform:Find("TextSliderStage2"):GetComponent(UNITYENGINE_UI_TEXT)

end

function PvpStageBox:setBlade(blade)
    local stageCfg, nextStageCfg = PvpUtil.bladge2StageCfg(blade)

    gg.setSpriteAsync(self.imgStage, string.format("PvpStage_Atlas[dan_icon_%s]", stageCfg.stage))
    self.txtStage:SetLanguageKey("pvpStageName_" .. stageCfg.stage)
    local starPos = PvpStageBox.starPos[stageCfg.maxShowStar]

    for key, value in pairs(self.starsList) do
        if key <= stageCfg.maxShowStar then
            value.trans:SetActiveEx(true)
            value.trans.anchoredPosition = starPos[key]
            value.imgStar.gameObject:SetActiveEx(stageCfg.showStar >= key)
        else
            value.trans:SetActiveEx(false)
        end
    end

    if nextStageCfg then
        self.sliderStage.gameObject:SetActiveEx(true)
        self.sliderStage.value = blade / nextStageCfg.startBladge

        self.textSliderStage.text = blade --stageCfg.showStar
        self.textSliderStage2.text = "/" .. nextStageCfg.startBladge
    else
        self.sliderStage.gameObject:SetActiveEx(false)
    end
end

PvpStageBox.starPos = {
    [1] = {
            [1] = UnityEngine.Vector2(0, -34.8)
    },

    [2] = {
            [1] = UnityEngine.Vector2(-56, -14), 
            [2] = UnityEngine.Vector2(56, -14),
    },

    [3] = {
            [1] = UnityEngine.Vector2(-65.6, -14),
            [2] = UnityEngine.Vector2(0, -34.8),
            [3] = UnityEngine.Vector2(65.6, -14),
    },

    [4] = {
        [1] = UnityEngine.Vector2(-122.9,33.002),
        [2] = UnityEngine.Vector2(-65.6, -14),
        [3] = UnityEngine.Vector2(65.6, -14),
        [4] = UnityEngine.Vector2(122.9, 33.002),
    },

    [5] = {
        [1] = UnityEngine.Vector2(-122.9,33.002),
        [2] = UnityEngine.Vector2(-65.6, -14),
        [3] = UnityEngine.Vector2(0, -34.8),
        [4] = UnityEngine.Vector2(65.6, -34.8),
        [5] = UnityEngine.Vector2(122.9, 33.002),
    },
}
