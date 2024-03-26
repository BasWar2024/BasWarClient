DaoUtil = DaoUtil or {}

function DaoUtil.getDaoJob(pId, daoInfo)
    pId = pId or gg.playerMgr.localPlayer:getPid()
    daoInfo = daoInfo or DaoData.myDaoInfo
    if not daoInfo then
        return constant.DAO_DUTY_NONE
    end

    daoInfo = daoInfo or DaoData.myDaoInfo
    if pId == daoInfo.presidentPid then
        return constant.DAO_DUTY_PRESIDENT
    end
    for key, value in pairs(daoInfo.vicePresidentPids) do
        if value == pId then
            return constant.DAO_DUTY_VICEPRESIDENT
        end
    end
    for key, value in pairs(daoInfo.elitePids) do
        if value == pId then
            return constant.DAO_DUTY_ELITE
        end
    end
    for key, value in pairs(daoInfo.members) do
        if value.playerId == pId then
            return constant.DAO_DUTY_NORMAL
        end
    end
    return constant.DAO_DUTY_NONE
end