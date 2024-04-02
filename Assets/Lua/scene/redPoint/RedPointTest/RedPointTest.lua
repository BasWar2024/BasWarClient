RedPointHeroUpgrade = class("RedPointHeroUpgrade", ggclass.RedPointBase)

--hero
function RedPointHeroUpgrade:ctor()
    ggclass.RedPointBase.ctor(self, {}, {})
end

function RedPointHeroUpgrade:onCheck()
    -- return HeroUtil.checkIsEnoughtUpgrade()
end
------------------------------------------------------

RedPointTest2 = class("RedPointTest2", ggclass.RedPointBase)

function RedPointTest2:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointHeroUpgrade}, {"onHeroChange"})
end

function RedPointTest2:onCheck()
    return HeroUtil.checkIsEnoughtUpgrade()
end
---------------------------------------------------------

RedPointTest3 = class("RedPointTest3", ggclass.RedPointBase)

function RedPointTest3:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointHeroUpgrade}, {"onHeroChange"})
end

function RedPointTest3:onCheck()
    return HeroUtil.checkIsEnoughtSkillUpgrade(2)
end
