---: lua oopclass
--1.,,
--2.lua,()
--: blog.codingnow.com/cloud/LuaOO
--@script gg.base.class
--@usage
--local Point = class("Point")
--function Point:ctor(x,y,z)
--    self.x = x
--    self.y = y
--    self.z = z
--end
--
--local Vector3 = class("Vector3",Point)
--
--function Vector3:ctor(x,y,z)
--    Vector3.super.ctor(self,x,y,z)
--end
--
--function Vector3:__add(p2)
--    local p1 = self
--    local result = Vector3.new(p1.x+p2.x,p1.y+p2.y,p1.z+p2.z)
--    return result
--end
--
--function Vector3:__tostring()
--    return string.format("[%s,%s,%s]",self.x,self.y,self.z)
--end
--
--local function test()
--    local p1 = Vector3.new(1,1,1)
--    local p2 = Vector3.new(2,2,2)
--    local p3 = p1 + p2
--    print(string.format("%s + %s = %s",p1,p2,p3))
--    print(string.format("p1.x=%s,p1.y=%s,p1.z=%s",p1.x,p1.y,p1.z))
--end
--
--test()

ggclass = ggclass or {}

function _reload_class(name)
    local class_type = assert(ggclass[name],"try to reload a non-exist class")
    -- 
    for k,v in pairs(class_type.__vtb) do
        class_type.__vtb[k] = nil
    end
    for k,v in pairs(class_type.__nils) do
        class_type.__nils[k] = nil
    end
    --print(string.format("reload class,name=%s class_type=%s vtb=%s",name,class_type,vtb))
    return class_type
end

function reload_class(name)
    local class_type = assert(ggclass[name],"try to reload_class a non-exist class")
    _reload_class(name)
    for name,_ in pairs(class_type.__children) do
        reload_class(name)
    end
    return class_type
end

-- 
function class(name,...)
    local supers = {...}
    local class_type = ggclass[name] or {}
    if not class_type.__children then
        class_type.__children = {}
    end
    if class_type._supers then
        for _,super_class in ipairs(class_type._supers) do
            if super_class.__children then
                super_class.__children[name] = nil
            end
        end
    end
    for _,super_class in ipairs(supers) do
        if super_class.__children then
            super_class.__children[name] = true
        end
    end
    class_type.__name = name
    class_type.__supers = supers
    class_type.super = supers[1]
    class_type.init = false     --constructor
    class_type.ctor = false
    if not ggclass[name] then
        ggclass[name] = class_type
        class_type.__vtb = {}
        class_type.__nils = {}
        class_type.__index = class_type.__vtb
        local vtb = class_type.__vtb
        local nils = class_type.__nils
        local rawget = rawget
        local ipairs = ipairs
        setmetatable(class_type,{__index = class_type.__vtb})
        setmetatable(vtb,{__index = function (t,k)
            if nils[k] then
                return nil
            end
            local result = rawget(class_type,k)
            if result ~= nil then
                vtb[k] = result
                return result
            end
            for _,super_type in ipairs(class_type.__supers) do
                local result = super_type[k]
                if result ~= nil then
                    vtb[k] = result
                    return result
                end
            end
            nils[k] = true
        end})
    end

    class_type.new = function (...)
        local tmp = ...
        assert(tmp ~= class_type,string.format("must use %s.new(...) but not %s:new(...)",name,name))
        local self = {}
        self.__type = class_type
        setmetatable(self,class_type)
        do
            if class_type.init then
                class_type.init(self,...)
            elseif class_type.ctor then
                class_type.ctor(self,...)
            end
        end
        return self
    end
    reload_class(name)
    return class_type
end

function issubclass(cls1,cls2)
    if not cls1.__name then
        return false
    end
    if not cls2.__children then
        return false
    end
    return cls2.__children[cls1.__name] and true or false
end

function typename(obj)
    if ggclass[obj] then
        return obj.__name
    end
    if obj.__type then
        return obj.__type.__name
    end
    return type(obj)
end

function isinstance(obj,cls)
    if not cls then
        return false
    end
    local classname = assert(cls.__name,"parameter 2 must be a class")
    if typename(obj) == classname then
        return true
    end
    for classname,_ in pairs(cls.__children) do
        if isinstance(obj,ggclass[classname]) then
            return true
        end
    end
    return false
end
