
BuildingButtonUiBox = BuildingButtonUiBox or class("BuildingButtonUiBox", ggclass.UIBaseItem)

function BuildingButtonUiBox:ctor(obj, initData)
    UIBaseItem.ctor(self, obj)
    obj.gameObject:SetActive(true)
    self.initData = initData
end

function BuildingButtonUiBox:onInit()
    self.buttonUiBg = self:Find("ButtonUiBg").transform

    self.namePoint = self:Find("NamePoint").transform

    self.canvasGroup = self.transform:GetComponent("CanvasGroup")
    self:showButtonUi(false)
    self.btnInformation = self.buttonUiBg:Find("BtnInformation").gameObject
    self:setOnClick(self.btnInformation, gg.bind(self.onBtnInfomation, self))

    self.btnUpgrade = self.buttonUiBg:Find("BtnUpgrade").gameObject
    self:setOnClick(self.btnUpgrade, gg.bind(self.onBtnUpgrade, self))

    self.btnRecycle = self.buttonUiBg:Find("BtnRecycle").gameObject
    self.imgRecycleIcon = self.btnRecycle.transform:Find("icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self:setOnClick(self.btnRecycle, gg.bind(self.onBtnRecycle, self))

    self.btnTool = self.buttonUiBg:Find("BtnTool").gameObject
    self.imgToolIcon = self.btnTool.transform:Find("icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self:setOnClick(self.btnTool, gg.bind(self.onBtnTool, self))

    self.btnTool2 = self.buttonUiBg:Find("BtnTool2").gameObject
    self.imgToolIcon2 = self.btnTool2.transform:Find("icon"):GetComponent(UNITYENGINE_UI_IMAGE)
    self:setOnClick(self.btnTool2, gg.bind(self.onBtnTool2, self))

    self.btnSpeedUp = self.buttonUiBg:Find("BtnSpeedUp").gameObject
    self:setOnClick(self.btnSpeedUp, gg.bind(self.onBtnSpeedUp, self))
    self.txtBuildSpeedUpCost = self.btnSpeedUp.transform:Find("TxtBuildSpeedUpCost"):GetComponent(UNITYENGINE_UI_TEXT)

    self.btnMap = {
        ["btnInformation"] = self.btnInformation,
        ["btnUpgrade"] = self.btnUpgrade,
        ["btnRecycle"] = self.btnRecycle,
        ["btnTool"] = self.btnTool,
        ["btnTool2"] = self.btnTool2,
        ["btnSpeedUp"] = self.btnSpeedUp,
    }
end

function BuildingButtonUiBox:onBtnInfomation()
    if self.infomationCB then
        self.infomationCB()
    end
end

function BuildingButtonUiBox:onBtnUpgrade()
    if self.upgradeCB then
        self.upgradeCB()
    end
end

function BuildingButtonUiBox:onBtnRecycle()
    if self.recycleCB then
        self.recycleCB()
    end
end

function BuildingButtonUiBox:onBtnTool()
    if self.toolCB then
        self.toolCB()
    end
end

function BuildingButtonUiBox:onBtnTool2()
    if self.tool2CB then
        self.tool2CB()
    end
end

function BuildingButtonUiBox:onBtnSpeedUp()
    if self.speedUpCB then
        self.speedUpCB()
    end
end

--""
-- local needBtnMap = {
--     ["btnInformation"] = false,
--     ["btnSpeedUp"] = false,
--     ["btnUpgrade"] = false,
--     ["btnRecycle"] = false,
--     ["btnTool"] = false
-- }

function BuildingButtonUiBox:setNeedBtnMap(needBtnMap)
    for key, value in pairs(self.btnMap) do
        if needBtnMap[key] then
            value:SetActiveEx(true)
        else
            value:SetActiveEx(false)
        end
    end
end

function BuildingButtonUiBox:setBtnRecycleIcon(icon)
    gg.setSpriteAsync(self.imgRecycleIcon, icon)
end

function BuildingButtonUiBox:setBtnToolIcon(icon)
    gg.setSpriteAsync(self.imgToolIcon, icon)
end

function BuildingButtonUiBox:setBtnTool2Icon(icon)
    gg.setSpriteAsync(self.imgToolIcon2, icon)
end

function BuildingButtonUiBox:showButtonUi(isShow)
    self.buttonUiBg:SetActiveEx(isShow)
end

function BuildingButtonUiBox:getButtonUIActive()
    return self.buttonUiBg.gameObject.activeSelf
end

--""
local aniTime = 0.3
function BuildingButtonUiBox:playUiAni()
    if self.sequence then
        self.sequence:Complete()
    end
    self.buttonUiBg.localScale = Vector3(0.001, 0.001, 0)
    local targetPos = self.buttonUiBg.localPosition
    self.buttonUiBg.localPosition = Vector3(targetPos.x, targetPos.y - 2, targetPos.z)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence = sequence
    sequence:Append(self.buttonUiBg:DOScale(Vector3(0.025, 0.025, 0.025), aniTime):SetEase(CS.DG.Tweening.Ease.OutBack))
    sequence:Join(self.buttonUiBg:DOLocalMove(targetPos, aniTime):SetEase(CS.DG.Tweening.Ease.OutBack))
    self.canvasGroup.alpha = 0
    sequence:Join(self.canvasGroup:DOFade(1, aniTime):SetEase(CS.DG.Tweening.Ease.OutBack))
end

function BuildingButtonUiBox:completeAni()
    if self.sequence then
        self.sequence:Complete()
    end
end

--""
function BuildingButtonUiBox:setBtnInfomationCallBack(callback)
    self.infomationCB = callback
end

function BuildingButtonUiBox:setBtnUpgradeCallBack(callback)
    self.upgradeCB = callback
end

function BuildingButtonUiBox:setBtnRecycleCallBack(callback)
    self.recycleCB = callback
end

function BuildingButtonUiBox:setBtnToolCallBack(callback)
    self.toolCB = callback
end

function BuildingButtonUiBox:setBtnTool2CallBack(callback)
    self.tool2CB = callback
end

function BuildingButtonUiBox:setBtnSpeedUpCallBack(callback)
    self.speedUpCB = callback
end