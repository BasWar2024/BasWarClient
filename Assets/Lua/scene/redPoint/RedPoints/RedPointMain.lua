RedPointMainMenu = class("RedPointMainMenu", ggclass.RedPointBase)

-- "":RedPointDrawCard
function RedPointMainMenu:ctor()
    ggclass.RedPointBase.ctor(self, {}, {})
end

function RedPointMainMenu:onCheck()
    return false
end
