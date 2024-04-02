local UIRoot = class("UIRoot")

function UIRoot:ctor(param)

    local GameObject = CS.UnityEngine.GameObject
    self.gameObject = GameObject.Find("UIRoot")
    self.transform = self.gameObject.transform

    -- self.uiCamera = self.transform:Find("UICamera"):GetComponent("Camera")
    self.sceneNode = self.transform:Find("SceneNode")
    self.mainNode = self.transform:Find("MainNode")
    self.normalNode = self.transform:Find("NormalNode")
    self.informationNode = self.transform:Find("InformationNode")
    self.popUpNode = self.transform:Find("PopUpNode")
    self.tipsNode = self.transform:Find("TipsNode")
    self.debugNode = self.transform:Find("DebugNode")

    self.screenFXNode = self.transform:Find("ScreenFXNode") -- ""
    self.eventSystem = self.transform:Find("EventSystem"):GetComponent("EventSystem")
    self.UIBlurEffectVolume = CS.UnityEngine.Rendering.VolumeManager.instance.stack:GetComponent(typeof(
        CS.UIBlurEffectVolume))
    self.FloorTextureVolume = CS.UnityEngine.Rendering.VolumeManager.instance.stack:GetComponent(typeof(
        CS.FloorTextureVolume))

    local height = UnityEngine.Screen.height
    local width = UnityEngine.Screen.width

    -- self.sceneNode:GetComponent("CanvasScaler").referenceResolution = Vector2.New(width, height)
    -- self.mainNode:GetComponent("CanvasScaler").referenceResolution = Vector2.New(width, height)
    -- self.normalNode:GetComponent("CanvasScaler").referenceResolution = Vector2.New(width, height)
    -- self.popUpNode:GetComponent("CanvasScaler").referenceResolution = Vector2.New(width, height)
    -- self.tipsNode:GetComponent("CanvasScaler").referenceResolution = Vector2.New(width, height)
    -- self.screenFXNode:GetComponent("CanvasScaler").referenceResolution = Vector2.New(width, height)
    if string.match(UnityEngine.SystemInfo.deviceModel, "iPad") then
        self.sceneNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
        self.mainNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
        self.normalNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
        self.informationNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
        self.popUpNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
        self.tipsNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
        self.debugNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
        self.screenFXNode:GetComponent("CanvasScaler").matchWidthOrHeight = 0
    end

end

return UIRoot
