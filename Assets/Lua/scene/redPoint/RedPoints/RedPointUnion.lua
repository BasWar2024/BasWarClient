RedPointUnion = class("RedPointUnion", ggclass.RedPointBase)

function RedPointUnion:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointMainMenu}, {})
end

function RedPointUnion:onCheck()
    return false
end

------------------------------------------------

RedPointUnionInvite = class("RedPointUnionInvite", ggclass.RedPointBase)

function RedPointUnionInvite:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointUnion}, {"onAutoPushChange"})
end

function RedPointUnionInvite:onCheck()
    return AutoPushData.autoPushStatus[constant.AUTOPUSH_CFGID_UNION_NEW_INVITE] and AutoPushData.autoPushStatus[constant.AUTOPUSH_CFGID_UNION_NEW_INVITE] > 0
end

------------------------------------------------

RedPointUnionMember = class("RedPointUnionMember", ggclass.RedPointBase)

function RedPointUnionMember:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointUnion}, {})
end

function RedPointUnionMember:onCheck()
    return false
end

------------------------------------------------

RedPointUnionApply = class("RedPointUnionApply", ggclass.RedPointBase)

function RedPointUnionApply:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointUnionMember}, {"onAutoPushChange"})
end

function RedPointUnionApply:onCheck()
    if UnionData.myUnionJod == constant.DAO_DUTY_PRESIDENT or UnionData.myUnionJod == constant.DAO_DUTY_VICEPRESIDENT then
        local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_UNION_NEW_APPLY)
        return status and status > 0
    end

    return false
end

------------------------------------------------

RedPointUnionMint = class("RedPointUnionMint", ggclass.RedPointBase)

function RedPointUnionMint:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointUnion}, {"onAutoPushChange"})
end

function RedPointUnionMint:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_MINT_NEW)
    return status and status > 0
    -- return true
end