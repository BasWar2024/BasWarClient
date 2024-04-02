PnlDraftView = class("PnlDraftView")

PnlDraftView.ctor = function(self, transform)

    self.transform = transform

    self.txtTitle = transform:Find("ViewBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewBg/Bg/BtnClose").gameObject
    self.txtNum = transform:Find("ViewTrain/BoxNum/TxtNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtMaxNum = transform:Find("ViewTrain/BoxNum/TxtNum/TxtMaxNum"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTrainingCount = transform:Find("ViewTrain/BoxNum/TxtTrainingCount"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtTrainingTime = transform:Find("ViewTrain/BoxNum/TxtTrainingCount/TxtTrainingTime"):GetComponent(UNITYENGINE_UI_TEXT)
    

    self.btnReduce = transform:Find("ViewTrain/BoxTrain/TrainScrollbar/BtnReduce").gameObject
    self.btnIncrease = transform:Find("ViewTrain/BoxTrain/TrainScrollbar/BtnIncrease").gameObject
    self.txtTrainCount = transform:Find("ViewTrain/BoxTrain/TrainScrollbar/TxtTrainCount"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.btnQuickTrain = transform:Find("ViewTrain/BoxTrain/BtnQuickTrain").gameObject
    self.txtQuickCost = transform:Find("ViewTrain/BoxTrain/BtnQuickTrain/TxtQuickCost")
        :GetComponent(UNITYENGINE_UI_TEXT)
    self.btnTrain = transform:Find("ViewTrain/BoxTrain/BtnTrain").gameObject
    self.txtTime = transform:Find("ViewTrain/BoxTrain/BtnTrain/TxtTime"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCostStar = transform:Find("ViewTrain/BoxTrain/BtnTrain/BoxCost/TxtCostStar"):GetComponent(
        UNITYENGINE_UI_TEXT)
    self.txtCostIce = transform:Find("ViewTrain/BoxTrain/BtnTrain/BoxCost/TxtCostIce"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCostGas = transform:Find("ViewTrain/BoxTrain/BtnTrain/BoxCost/TxtCostGas"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtCostTi = transform:Find("ViewTrain/BoxTrain/BtnTrain/BoxCost/TxtCostTi"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtWaring = transform:Find("ViewTrain/BoxTrain/TxtWaring"):GetComponent(UNITYENGINE_UI_TEXT)

    self.trainScrollbar = transform:Find("ViewTrain/BoxTrain/TrainScrollbar/Scrollbar"):GetComponent(
        UNITYENGINE_UI_SCROLLBAR)

    self.fillYellow = transform:Find("ViewTrain/BoxNum/SliderBgNum/FillYellow"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.fillBlue = transform:Find("ViewTrain/BoxNum/SliderBgNum/FillBlue"):GetComponent(UNITYENGINE_UI_IMAGE)
    self.fillBlueDown = transform:Find("ViewTrain/BoxNum/SliderBgNum/FillBlueDown"):GetComponent(UNITYENGINE_UI_IMAGE)

    self.bgWaringFull = transform:Find("ViewTrain/BoxTrain/BgWaringFull").gameObject
    self.trainScrollbarObj = transform:Find("ViewTrain/BoxTrain/TrainScrollbar").gameObject
    self.txtWaringFull = transform:Find("ViewTrain/BoxTrain/BgWaringFull/TxtWaringFull"):GetComponent(UNITYENGINE_UI_TEXT)
end

return PnlDraftView
