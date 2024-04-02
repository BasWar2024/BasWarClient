
PnlTaskView = class("PnlTaskView")

PnlTaskView.ctor = function(self, transform)

    self.transform = transform

    self.fullViewOptionBtnBox = transform:Find("Root/FullViewOptionBtnBox")

    self.txtTitle = transform:Find("ViewFullBg/Bg/TxtTitle"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnClose = transform:Find("ViewFullBg/Bg/BtnClose").gameObject
    
--Charatcer
    self.layoutCharatcer = transform:Find("Root/LayoutCharatcer")
    self.txtChapterName = transform:Find("Root/LayoutCharatcer/LayoutCharacterInfo/TxtChapterName"):GetComponent(UNITYENGINE_UI_TEXT)
    self.txtChapterDesc = transform:Find("Root/LayoutCharatcer/LayoutCharacterInfo/TxtChapterDesc"):GetComponent(UNITYENGINE_UI_TEXT)
    self.sliderProgress = transform:Find("Root/LayoutCharatcer/LayoutCharacterInfo/SliderProgress"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtProgress = transform:Find("Root/LayoutCharatcer/LayoutCharacterInfo/SliderProgress/TxtProgress"):GetComponent(UNITYENGINE_UI_TEXT)
    self.btnChapterFetch = transform:Find("Root/LayoutCharatcer/LayoutCharacterInfo/BtnChapterFetch").gameObject
    self.txtChapterFinish = transform:Find("Root/LayoutCharatcer/LayoutCharacterInfo/TxtChapterFinish"):GetComponent(UNITYENGINE_UI_TEXT)

    self.layoutChapterReward = transform:Find("Root/LayoutCharatcer/LayoutCharacterInfo/LayoutChapterReward")

    self.taskChapterRewardItemList = {}
    for i = 1, 2, 1 do
        local item = {}
        self.taskChapterRewardItemList[i] = item
        item.transform = self.layoutChapterReward:GetChild(i - 1)
        item.icon = item.transform:Find("ImgIcon"):GetComponent(UNITYENGINE_UI_IMAGE)
        item.text = item.transform:Find("Text"):GetComponent(UNITYENGINE_UI_TEXT)
    end

    self.mainTaskScrollView = transform:Find("Root/LayoutCharatcer/MainTaskScrollView")

-- branch
    self.layoutBranch = transform:Find("Root/LayoutBranch")
    self.branchTaskScrollView = self.layoutBranch:Find("BranchTaskScrollView")

--daily
    self.layoutDailyTask = transform:Find("Root/LayoutDailyTask")
    self.txtTaskTitle = self.layoutDailyTask:Find("LayoutDailyInfo/ImgTitle/TxtTitleTimeDesc/TxtTaskTitle"):GetComponent(UNITYENGINE_UI_TEXT)

    self.dailyTaskScrollView = self.layoutDailyTask:Find("DailyTaskScrollView")

    self.layoutDailyInfo = self.layoutDailyTask:Find("LayoutDailyInfo")
    self.sliderDailyProgress = self.layoutDailyInfo:Find("SliderDailyProgress"):GetComponent(UNITYENGINE_UI_SLIDER)
    self.txtDailyProgress = self.layoutDailyInfo:Find("BgProgress/TxtDailyProgress"):GetComponent(UNITYENGINE_UI_TEXT)
    self.activityRewardScrollView = self.layoutDailyInfo:Find("ActivityRewardScrollView")

    self.taskActivationInfoBox = self.layoutDailyTask:Find("TaskActivationInfoBox")
end

return PnlTaskView