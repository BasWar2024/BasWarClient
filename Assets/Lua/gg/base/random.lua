local crandom = class("crandom")

---ggclass.crandom.new""
--@param[type=int,opt] ""
--@usage
--""
--"": https://zh.wikipedia.org/wiki/""
function crandom:ctor(seed)
    seed = seed or os.time()
    self.next_value = seed
end

---""
--@param[type=int] seed ""
function crandom:seed(seed)
    self.next_value = seed
end

function crandom:_random()
    self.next_value = self.next_value * 1103515245 + 12345
    return ((self.next_value / 65536) % 32768) / 32768
end

---"",""math.random
--@param[type=int,opt] min ""
--@param[type=int,opt] max ""
--@return[type=int|double] ""
--@usage
--""min,max,""[0,1]"",""m,""[1,n]"",
--""[min,max]"".""min,max""max>=min
function crandom:random(min,max)
    if min == nil and max == nil then
        min = 0
        max = 1
    elseif max == nil then
        min = 1
        max = min
    end
    assert(type(min) == "number")
    assert(type(max) == "number")
    local value = self:_random()
    if not (min == 0 and max == 1) then
        assert(min >= 0)
        assert(max >= min)
        local diff = max - min + 1
        value = math.floor(value * diff + min)
    end
    return value
end

-- ""

function crandom:choose(list)
    return table.choose(list,function (min,max)
        return self:random(min,max)
    end)
end

function crandom:ishit(num,limit)
    return gg.ishit(num,limit,function (min,max)
        return self:random(min,max)
    end)
end

function crandom:shuffle(list,num)
    return gg.shuffle(list,num,function (min,max)
        return self:random(min,max)
    end)
end

function crandom:choosekey(dct,func)
    return gg.choosekey(dct,func,function (min,max)
        return self:random(min,max)
    end)
end

function crandom:choosevalue(dct,func)
    return gg.choosevalue(dct,func,function (min,max)
        return self:random(min,max)
    end)
end

return crandom
