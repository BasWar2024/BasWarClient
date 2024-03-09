math.max_int32 = (2<<32)-1
math.deg2Rad = math.pi / 180
math.rad2Deg = 180 / math.pi
--math.nan = 0/0


function math.round(num,n)
    n = n or 0
    n = 10 ^ n
    return math.floor(num * n + 0.5) / n
end

function math.sign(num)
    if num > 0 then
        num = 1
    elseif num < 0 then
        num = -1
    else
        num = 0
    end

    return num
end

function math.clamp(num, min, max)
    if num < min then
        num = min
    elseif num > max then
        num = max
    end
    return num
end

local clamp = math.clamp

function math.lerp(from, to, t)
    return from + (to - from) * math.clamp(t, 0, 1)
end

function math.overlaps(rectTransA, rectTransB)
    return math.getWorldRect(rectTransA):Overlaps(math.getWorldRect(rectTransB))
end

function math.getWorldRect(rectTrans)
    local sizeDelta = rectTrans.sizeDelta
    local rectTransformWidth = sizeDelta.x * rectTrans.lossyScale.x
    local rectTransformHeight = sizeDelta.y * rectTrans.lossyScale.y

    local position = rectTrans.position

    return UnityEngine.Rect(position.x, position.y - rectTransformHeight * rectTrans.pivot.y, rectTransformWidth, rectTransformHeight);
end