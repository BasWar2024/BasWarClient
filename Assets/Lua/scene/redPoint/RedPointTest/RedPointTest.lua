RedPointHeroUpgrade = class("RedPointHeroUpgrade", ggclass.RedPointBase)

--hero
function RedPointHeroUpgrade:ctor()
    ggclass.RedPointBase.ctor(self)
    self.id = RedPointManager.HERO_UPGRADE
    self.parentList = {}
end

function RedPointHeroUpgrade:onCheck()
    return HeroUtil:checkIsEnoughtUpgrade()
end
------------------------------------------------------
RedPointTest2 = class("RedPointTest2", ggclass.RedPointBase)

function RedPointTest2:ctor()
    ggclass.RedPointBase.ctor(self)
    self.id = RedPointManager.TEST2

    self.parentList = {RedPointManager.HERO_UPGRADE}
    self:setEventList({"onHeroChange"})
end

function RedPointTest2:onCheck()
    return HeroUtil:checkIsEnoughtUpgrade()
end
---------------------------------------------------------

RedPointTest3 = class("RedPointTest3", ggclass.RedPointBase)

function RedPointTest3:ctor()
    ggclass.RedPointBase.ctor(self)
    self.id = RedPointManager.TEST3

    self.parentList = {RedPointManager.HERO_UPGRADE}
    self:setEventList({"onHeroChange"})
end

function RedPointTest3:onCheck()
    return HeroUtil:checkIsEnoughtSkillUpgrade(2)
end
