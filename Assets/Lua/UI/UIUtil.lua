UIUtil = class("UIUtil")

-- 
function UIUtil.getComponent(trans, ctype, path)
    assert(trans ~= nil)
    assert(ctype ~= nil)

    local targetTrans = trans
    if path ~= nil and type(path) == "string" and #path > 0 then
        targetTrans = trans:Find(path)
    end
    if targetTrans == nil then return nil end
    local cmp = targetTrans:GetComponent(ctype)
    if cmp ~= nil then return cmp end
    return targetTrans:GetComponentInChildren(ctype)
end