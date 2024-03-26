EffectUtil = EffectUtil or {}
EffectUtil.imgMatGray = nil

function EffectUtil.setGray(obj, isGray, isDeep)
    local transform = obj.transform
    local image = transform:GetComponent(UNITYENGINE_UI_IMAGE)
    if image then
        if isGray then
            EffectUtil.setGrayMat(image)
        else
            image.material = nil
        end
    end

    local text = transform:GetComponent(UNITYENGINE_UI_TEXT)
    if text then
        if isGray then
            EffectUtil.setGrayMat(text)
        else
            text.material = nil
        end
    end

    if isDeep and transform.childCount > 0 then
        for key, value in pairs(transform) do
            EffectUtil.setGray(value, isGray, isDeep)
        end
    end
end

function EffectUtil.setGrayMat(componnent)
    if EffectUtil.imgMatGray then
        componnent.material = EffectUtil.imgMatGray
    else
        ResMgr:LoadMaterialAsync("imgGray", function(material)
            EffectUtil.imgMatGray = material
            componnent.material = EffectUtil.imgMatGray
            -- ResMgr:ReleaseAssetMaterial(material)
        end)
    end
end

function EffectUtil.initGrayMat()
    if not EffectUtil.imgMatGray then
        ResMgr:LoadMaterialAsync("imgGray", function(material)
            EffectUtil.imgMatGray = material
        end)
    end
end
