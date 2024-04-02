ResourcesManager = class("ResourcesManager")

function ResourcesManager:ctor()
    self.spriteMap = {}
    self:preLoadSprite()

    ResMgr.CheckAtlasCanRelease = gg.bind(self.checkAtlasCanRelease, self)

    self.notReleaseAtlasMap = {
        ["Common_Atlas"] = true,
        ["Button_Atlas"] = true,
        ["ResIcon_200_Atlas"] = true,
        ["AttributeIcon_Atlas"] = true,
        ["Item_Bg_Atlas"] = true,
        ["Head_Atlas"] = true,
        ["BuildButton_Atlas"] = true,
    }
end

function ResourcesManager:checkAtlasCanRelease(atlasName)
    return self.notReleaseAtlasMap[atlasName] ~= true
end

function ResourcesManager:preLoadSprite()
    local preloadList = {
        "Button_Atlas[button 01_button_A]",
        "Button_Atlas[button 01_button_B]",
        "Button_Atlas[Button 04_button_A]",
        "Button_Atlas[Button 05_button_A]",
        "Button_Atlas[Button 05_button_B]",
        "Button_Atlas[Button 05_button_C]",
        "Button_Atlas[Button 06_button_A]",
        "Button_Atlas[Button 06_button_B]",
        "Button_Atlas[Close_icon]",
        "Button_Atlas[Close_icon_B]",
    }
    for index, value in ipairs(preloadList) do
        ResMgr:LoadSpriteAsync(value, function(sprite)
            self.spriteMap[value] = sprite
        end)
    end
end

function ResourcesManager:LoadSpriteAsync(spriteName, func)
    if self.spriteMap[spriteName] ~= nil then
        func(self.spriteMap[spriteName])
    else
        return ResMgr:LoadSpriteAsync(spriteName, func)
    end
end
