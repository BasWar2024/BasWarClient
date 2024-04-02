UIUtil = class("UIUtil")

-- ""
function UIUtil.getComponent(trans, ctype, path)
    assert(trans ~= nil)
    assert(ctype ~= nil)

    local targetTrans = trans
    if path ~= nil and type(path) == "string" and #path > 0 then
        targetTrans = trans:Find(path)
    end
    if targetTrans == nil then
        return nil
    end
    local cmp = targetTrans:GetComponent(ctype)
    if cmp ~= nil then
        return cmp
    end
    return targetTrans:GetComponentInChildren(ctype)
end

-- row ""
-- line ""
function UIUtil.loadScrollView(dataList, startX, startY, nextX, nextY, row, line, parent, goName, callback)
    local index = 0

    for k, v in pairs(dataList) do
        local temp = index
        local curRow = temp
        local curLine = temp

        if row > 0 then
            curRow = temp % row
            curLine = math.floor((temp / row))
        elseif line > 0 then
            curRow = math.floor((temp / line))
            curLine = temp % line
        end
        local data = v
        ResMgr:LoadGameObjectAsync(goName, function(obj)
            local posX = startX + curRow * nextX
            local posY = startY + curLine * nextY
            obj.transform:SetParent(parent, false)
            obj.transform:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).anchoredPosition = Vector2.New(posX, posY)

            if callback then
                callback(obj, data)
            end

            return true
        end, true)
        index = index + 1
    end
    if row > 0 then
        local heigh = (index + 1) * nextY
        parent:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(0, -heigh)
        parent:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosY(0)
    elseif line > 0 then
        local width = (index + 1) * nextX
        parent:GetComponent(UNITYENGINE_UI_RECTTRANSFORM).sizeDelta = Vector2.New(width, 0)
        parent:GetComponent(UNITYENGINE_UI_RECTTRANSFORM):SetRectPosX(0)
    end

end

function UIUtil.setQualityBg(icon, quality)
    quality = quality or 0
    local iconQ = "Item_Bg_" .. quality
    gg.setSpriteAsync(icon, string.format("Item_Bg_Atlas[%s]", iconQ))
end

