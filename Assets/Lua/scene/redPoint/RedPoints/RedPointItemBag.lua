RedPointItemBag = class("RedPointItemBag", ggclass.RedPointBase)

function RedPointItemBag:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointMainMenu}, {})
end

function RedPointItemBag:onCheck()
    return false
end

----------------------------------------------------

RedPointItemBagNft = class("RedPointItemBagNft", ggclass.RedPointBase)

function RedPointItemBagNft:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointItemBag}, {"onAutoPushChange"})
end

function RedPointItemBagNft:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_NEW_ITEM_13)
    return status and status > 0
end

-------------------------------------------------------

RedPointItemBagDao = class("RedPointItemBagDao", ggclass.RedPointBase)

function RedPointItemBagDao:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointItemBag}, {"onAutoPushChange"})
end

function RedPointItemBagDao:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_NEW_ITEM_14)
    return status and status > 0
end

-------------------------------------------------------

RedPointItemBagItem = class("RedPointItemBagItem", ggclass.RedPointBase)

function RedPointItemBagItem:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointItemBag}, {"onAutoPushChange"})
end

function RedPointItemBagItem:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_NEW_ITEM_15)
    return status and status > 0
end

-------------------------------------------------------

RedPointItemBagSkillCard = class("RedPointItemBagSkillCard", ggclass.RedPointBase)

function RedPointItemBagSkillCard:ctor()
    ggclass.RedPointBase.ctor(self, {RedPointItemBag}, {"onAutoPushChange"})
end

function RedPointItemBagSkillCard:onCheck()
    local status = AutoPushData.getAutoPushStatus(constant.AUTOPUSH_CFGID_NEW_ITEM_16)
    return status and status > 0
end