RedPointPnlBuild = class("RedPointPnlBuild", ggclass.RedPointBase)

--hero
function RedPointPnlBuild:ctor()
    ggclass.RedPointBase.ctor(self, {}, {})
end

function RedPointPnlBuild:onCheck()
end
-----------------------------------------------------------------------------
RedPointBuildTypeBase = class("RedPointBuildTypeBase", ggclass.RedPointBase)
function RedPointBuildTypeBase:ctor()
    ggclass.RedPointBase.ctor(self, {ggclass.RedPointPnlBuild}, {"onUpdateBuildData", "onInitBuildData"})
end

function RedPointBuildTypeBase:onCheck()
    for key, value in pairs(self:getList()) do
        local result = gg.buildingManager:checkBuildCountEnought(value.cfgId, value.quality)
        if result.isCanBuild then
            return true
        end
    end
    return false
end

-- override
function RedPointBuildTypeBase:getList()
    return {}
    --return gg.buildingManager.buildingTableOfEconomic
end
-----------------------------------------------------------------

RedPointBuildEconomic = class("RedPointBuildEconomic", ggclass.RedPointBuildTypeBase)
function RedPointBuildEconomic:ctor()
    ggclass.RedPointBase.ctor(self, {ggclass.RedPointPnlBuild}, {"onUpdateBuildData", "onInitBuildData"})
end

function RedPointBuildEconomic:getList()
    return gg.buildingManager.buildingTableOfEconomic
end

----------------------------------------------------------

RedPointBuildDevelopment = class("RedPointBuildDevelopment", ggclass.RedPointBuildTypeBase)
function RedPointBuildDevelopment:ctor()
    ggclass.RedPointBase.ctor(self, {ggclass.RedPointPnlBuild}, {"onUpdateBuildData", "onInitBuildData"})
end

function RedPointBuildDevelopment:getList()
    return gg.buildingManager.buildingTableOfDevelopment
end

-----------------------------------------------------

RedPointBuildDefense = class("RedPointBuildDefense", ggclass.RedPointBuildTypeBase)
function RedPointBuildDefense:ctor()
    ggclass.RedPointBase.ctor(self, {ggclass.RedPointPnlBuild}, {"onUpdateBuildData", "onInitBuildData"})
end

function RedPointBuildDefense:getList()
    return gg.buildingManager.buildingTableOfDefense
end