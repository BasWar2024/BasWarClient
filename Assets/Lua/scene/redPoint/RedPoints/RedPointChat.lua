RedPointChat = class("RedPointChat", ggclass.RedPointBase)

function RedPointChat:ctor()
    ggclass.RedPointBase.ctor(self, {}, {})
end

function RedPointChat:onCheck()
    return false
end

------------------------------------------------------------------

RedPointChatWorld = class("RedPointChatWorld", ggclass.RedPointBase)

function RedPointChatWorld:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointChat}, {"onAutoPushChange"})
end

function RedPointChatWorld:onCheck()
    return AutoPushData.autoPushStatus[constant.AUTOPUSH_CFGID_CAHT_WORLD_NEW] and AutoPushData.autoPushStatus[constant.AUTOPUSH_CFGID_CAHT_WORLD_NEW] > 0
end

------------------------------------------------------------------

RedPointChatUnion = class("RedPointChatUnion", ggclass.RedPointBase)

function RedPointChatUnion:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointChat}, {"onAutoPushChange"})
end

function RedPointChatUnion:onCheck()
    return AutoPushData.autoPushStatus[constant.AUTOPUSH_CFGID_CAHT_UNION_NEW] and AutoPushData.autoPushStatus[constant.AUTOPUSH_CFGID_CAHT_UNION_NEW] > 0
end