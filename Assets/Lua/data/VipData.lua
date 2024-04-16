VipData = {}

VipData.vipData = {}

function VipData.S2C_Player_VipData(args)
    VipData.vipData = args
    gg.event:dispatchEvent("onVipPledgeChange")
end

return VipData