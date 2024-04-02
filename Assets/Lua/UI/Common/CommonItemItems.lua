CommonNormalItem = CommonNormalItem or class("CommonNormalItem", ggclass.UIBaseItem)
function CommonNormalItem:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonNormalItem:onInit()
    self.imgBg = self:Find("ImgBg", UNITYENGINE_UI_IMAGE)
    self.imgIcon = self:Find("Mask/ImgIcon", UNITYENGINE_UI_IMAGE)
end

function CommonNormalItem:reset()
    self:setQuality(0)
    self:setIcon()
end

--""
function CommonNormalItem:setQuality(quality)
    quality = quality or 0
    local icon = "Item_Bg_" .. quality
    icon = string.format("Item_Bg_Atlas[%s]", icon)
    gg.setSpriteAsync(self.imgBg, icon)
end

function CommonNormalItem:setIcon(icon)
    if icon then
        gg.setSpriteAsync(self.imgIcon, icon)
    else
        self.imgIcon.transform:SetActiveEx(false)
    end
end

------------------------------------------------------------------
--""setQuality""setIcon
CommonItemItem = CommonItemItem or class("CommonItemItem", ggclass.UIBaseItem)

function CommonItemItem:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonItemItem:onInit()
    self.imgBg = self:Find("ImgBg", "Image")
    self.imgIcon = self:Find("Mask/ImgIcon", "Image")
    -- self.txtForge = self:Find("TxtForge", "Text")
    self.bgLevel = self:Find("BgLevel")
    self.txtLevel = self:Find("BgLevel/TxtLevel", "Text")
    self.imgArrowUp = self:Find("BgLevel/ImgArrowUp", "Image")
    self:initInfo()
end

function CommonItemItem:initInfo()
    self:setLevel(false)
    -- self.txtForge.text = ""
    self:setImgArrowActive(false)
    self:setQuality(0)
    -- self:setIcon(false)
end

--""
function CommonItemItem:setQuality(quality)
    quality = quality or 0
    local sprite = ""
    sprite = "Item_Bg_" .. quality
    local icon = gg.getSpriteAtlasName("Item_Bg_Atlas", sprite)
    gg.setSpriteAsync(self.imgBg, icon)
end

function CommonItemItem:setIcon(icon)
    if icon then
        self.imgIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, icon)
    else
        self.imgIcon.gameObject:SetActiveEx(false)
    end
end

function CommonItemItem:setLevel(level)
    if level then
        self.bgLevel:SetActiveEx(true)
        self.txtLevel.text = level
    else
        self.bgLevel:SetActiveEx(false)
    end
end

function CommonItemItem:setImgArrowActive(isActive)
    if isActive then
        self.txtLevel.transform.anchoredPosition = CS.UnityEngine.Vector2(-14.3, self.txtLevel.transform.anchoredPosition.y)
    else
        self.txtLevel.transform.anchoredPosition = CS.UnityEngine.Vector2(-5, self.txtLevel.transform.anchoredPosition.y)
    end
    self.imgArrowUp.gameObject:SetActiveEx(isActive)
end

------------------------------------------------------------------
--""setQuality""setIcon
CommonLongItem = CommonLongItem or class("CommonLongItem", ggclass.UIBaseItem)

function CommonLongItem:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonLongItem:onInit()
    self.imgBg = self:Find("ImgBg", "Image")
    self.imgIcon = self:Find("Mask/ImgIcon", "Image")
    self:initInfo()
end

function CommonLongItem:initInfo()
    self:setQuality()
end

--""
function CommonLongItem:setQuality(quality)
    quality = quality or 1
    local sprite = ""
    sprite = "longframe_icon_" .. quality
    local icon = gg.getSpriteAtlasName("Item_Bg_Atlas", sprite)
    gg.setSpriteAsync(self.imgBg, icon)
end

function CommonLongItem:setIcon(icon)
    if icon then
        self.imgIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, icon)
    else
        self.imgIcon.gameObject:SetActiveEx(false)
    end
end

---------------------------------------------------------------
CommonItemItemD1 = CommonItemItemD1 or class("CommonItemItemD1", ggclass.UIBaseItem)
function CommonItemItemD1:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonItemItemD1:onInit()
    self.imgBg = self:Find("ImgBg", "Image")
    self.imgIcon = self:Find("ImgIcon", "Image")
    self:initInfo()
end

function CommonItemItemD1:initInfo()
end

--""

function CommonItemItemD1:setQuality(quality)
    quality = quality or 0
    local icon = "Item_Bg_" .. quality
    icon = string.format("Item_Bg_Atlas[%s]", icon)
    gg.setSpriteAsync(self.imgBg, icon)
end

function CommonItemItemD1:setIcon(icon)
    if icon then
        self.imgIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, icon)
    else
        self.imgIcon.gameObject:SetActiveEx(false)
    end
end

---------------------------------------------------------------
CommonItemItemD2 = CommonItemItemD2 or class("CommonItemItemD2", ggclass.UIBaseItem)
function CommonItemItemD2:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonItemItemD2:onInit()
    self.imgBg = self:Find("ImgBg", "Image")
    self.imgIcon = self:Find("mask/ImgIcon", "Image")

    self.layoutQuality = self:Find("LayoutQuality").transform
    self.qualityList = {}
    for i = 1, 6 do
        local index = i - 1
        self.qualityList[index] = self.layoutQuality:Find("Quality" .. index)
    end

    self:initInfo()
end

function CommonItemItemD2:initInfo()
end

--""
function CommonItemItemD2:setQuality(quality)
    local sprite = ""
    if not quality then
        sprite = "Item_Bg_D2_0"
    else
        sprite = "Item_Bg_D2_" .. quality
    end
    local icon = gg.getSpriteAtlasName("Institute_Atlas", sprite)
    gg.setSpriteAsync(self.imgBg, icon)

    for key, value in pairs(self.qualityList) do
        value:SetActiveEx(key == quality)
    end
end

function CommonItemItemD2:setIcon(icon)
    if icon then
        self.imgIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, icon)
    else
        self.imgIcon.gameObject:SetActiveEx(false)
    end
end

---------------------------------------------------------------
CommonBagItem = CommonBagItem or class("CommonBagItem", ggclass.UIBaseItem)
function CommonBagItem:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonBagItem:onInit()
    self.imgBg = self:Find("ImgBg", "Image")
    self.imgIcon = self:Find("Mask/ImgIcon", "Image")
    self.txtLevel = self:Find("TxtLevel", "Text")
    self:initInfo()
end

function CommonBagItem:initInfo()
    self:setLevel(false)
end

--""
function CommonBagItem:setQuality(quality)
    local icon = ""
    if not quality then
        icon = "Item_Bg_0"
    else
        icon =  "Item_Bg_" .. quality
    end
    icon = string.format("Item_Bg_Atlas[%s]", icon)
    gg.setSpriteAsync(self.imgBg, icon)
end

function CommonBagItem:setIcon(icon)
    if icon then
        self.imgIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, icon)
    else
        self.imgIcon.gameObject:SetActiveEx(false)
    end
end

function CommonBagItem:setLevel(level)
    if level then
        self.txtLevel.gameObject:SetActiveEx(true)
        self.txtLevel.text = level
    else
        self.txtLevel.gameObject:SetActiveEx(false)
    end
end

----------------------------"" + ""
CommonHeroItem = CommonHeroItem or class("CommonHeroItem", ggclass.UIBaseItem)
function CommonHeroItem:ctor(obj)
    ggclass.UIBaseItem.ctor(self, obj)
end

function CommonHeroItem:onInit()
    self.imgBg = self:Find("ImgBg", UNITYENGINE_UI_IMAGE)

    self.imgIcon = self:Find("Mask/ImgIcon", UNITYENGINE_UI_IMAGE)
end

function CommonHeroItem:initInfo()
    self:setQuality(0)
    self:setIcon()
end

--""
function CommonHeroItem:setQuality(quality)
    quality = quality or 0
    local icon = "Item_Bg_" .. quality
    icon = string.format("Item_Bg_Atlas[%s]", icon)
    gg.setSpriteAsync(self.imgBg, icon)
end

function CommonHeroItem:setIcon(atlas, icon)
    if icon then
        self.imgIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, string.format("%s[%s_A]", atlas, icon))
    else
        self.imgIcon.gameObject:SetActiveEx(false)
    end
end

function CommonHeroItem:setIcon2(icon)
    if icon then
        self.imgIcon.gameObject:SetActiveEx(true)
        gg.setSpriteAsync(self.imgIcon, icon)
    else
        self.imgIcon.gameObject:SetActiveEx(false)
    end
end