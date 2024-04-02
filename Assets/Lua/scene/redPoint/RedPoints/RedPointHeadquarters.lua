RedPointHeadquarters = class("RedPointHeadquarters", ggclass.RedPointBase)

function RedPointHeadquarters:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointMainMenu}, {})
end

function RedPointHeadquarters:onCheck()
    return false
end

-----------------------------------------------------------------------------

RedPointHeadquartersSwitch = class("RedPointHeadquartersSwitch", ggclass.RedPointBase)

function RedPointHeadquartersSwitch:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointHeadquarters}, {})
end

function RedPointHeadquartersSwitch:onCheck()
    return false
end

-----------------------------------------------------------------------------

RedPointHeadquartersWarship = class("RedPointHeadquartersWarship", ggclass.RedPointBase)

function RedPointHeadquartersWarship:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointHeadquartersSwitch}, {"onAutoPushChange"})
end

function RedPointHeadquartersWarship:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_NEW_WARSHIP)
    return status and status > 0
end

-------------------------------------------------------------------------

RedPointHeadquartersHero = class("RedPointHeadquartersHero", ggclass.RedPointBase)

function RedPointHeadquartersHero:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointHeadquartersSwitch}, {"onAutoPushChange"})
end

function RedPointHeadquartersHero:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_NEW_HERO)
    return status and status > 0
end

-----------------------------------------------------------------

RedPointHeadquartersNewBuild = class("RedPointHeadquartersNewBuild", ggclass.RedPointBase)

function RedPointHeadquartersNewBuild:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointHeadquartersSwitch}, {"onAutoPushChange"})
end

function RedPointHeadquartersNewBuild:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_NEW_BUILD)
    return status and status > 0
end
