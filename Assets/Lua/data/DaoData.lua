DaoData = {}

DaoData.myDaoInfo = nil
DaoData.myDaoMemberMap = {}

DaoData.joinableDaoList = {}
DaoData.applyList = nil
DaoData.DaoTaxData = nil
DaoData.DaoVoteData = nil
DaoData.daoSettleData = nil

-- ""dao
function DaoData.C2S_Player_CreateDao(name, icon, notice, joinType, minJoinScore, score)
    gg.client.gameServer:send("C2S_Player_CreateDao", {
        name = name,
        icon = icon,
        notice = notice,
        joinType = joinType,
        minJoinScore = minJoinScore,
    })
end

-- ""dao
function DaoData.C2S_Player_JoinDao(daoId)
    gg.client.gameServer:send("C2S_Player_JoinDao", {
        daoId = daoId,
    })
end

-- ""dao
function DaoData.C2S_Player_SearchDao(daoNameOrId)
    gg.client.gameServer:send("C2S_Player_SearchDao", {
        daoNameOrId = daoNameOrId,
    })
end

-- ""
function DaoData.C2S_Player_TransferPresident(playerId)
    gg.client.gameServer:send("C2S_Player_TransferPresident", {
        playerId = playerId,
    })
end

-- ""
function DaoData.C2S_Player_TickOutDao(playerId)
    gg.client.gameServer:send("C2S_Player_TickOutDao", {
        playerId = playerId,
    })
end

--""
function DaoData.C2S_Player_QuitDao()
    gg.client.gameServer:send("C2S_Player_QuitDao", {
    })
end

--""
function DaoData.C2S_Player_QueryDaoDetail(daoId)
    gg.client.gameServer:send("C2S_Player_QueryDaoDetail", {
        daoId = daoId
    })
end

function DaoData.C2S_Player_QuitDao()
    gg.client.gameServer:send("C2S_Player_QuitDao", {
    })
end

-- ""dao""
function DaoData.C2S_Player_ModifyDaoInfo(icon, notice, joinType, minJoinScore)
    gg.client.gameServer:send("C2S_Player_ModifyDaoInfo", {
        icon = icon,
        notice = notice,
        joinType = joinType,
        minJoinScore = minJoinScore,
    })
end

-- ""
function DaoData.C2S_Player_DaoAppointJob(playerId, job)
    gg.client.gameServer:send("C2S_Player_DaoAppointJob", {
        playerId = playerId,
        job = job,
    })
end

-- ""
function DaoData.C2S_Player_TransferPresident(playerId)
    gg.client.gameServer:send("C2S_Player_TransferPresident", {
        playerId = playerId,
    })
end

-- ""
function DaoData.C2S_Player_TickOutDao(playerId)
    gg.client.gameServer:send("C2S_Player_TickOutDao", {
        playerId = playerId,
    })
end

-- "" 1-"" 2-""
function DaoData.C2S_Player_AnwserJoinDaoApply(answer, playerId)
    gg.client.gameServer:send("C2S_Player_AnwserJoinDaoApply", {
        answer = answer,
        playerId = playerId,
    })
end

-- ""
function DaoData.C2S_Player_UnionClearAllApply()
    gg.client.gameServer:send("C2S_Player_UnionClearAllApply", { 
    })
end

function DaoData.C2S_Player_QueryMyDaoInfo()
    gg.client.gameServer:send("C2S_Player_QueryMyDaoInfo", {
    })
end

--!
-- ""
function DaoData.C2S_Player_QueryDaoTaxData()
    gg.client.gameServer:send("C2S_Player_QueryDaoTaxData", {
    })
end

-- ""
function DaoData.C2S_Player_QueryDaoTaxSettleData()
    gg.client.gameServer:send("C2S_Player_QueryDaoTaxSettleData", {
    })
end

-- ""
function DaoData.C2S_Player_DrawDaoTaxAwards()
    gg.client.gameServer:send("C2S_Player_DrawDaoTaxAwards", {
    })
end

-- ""
function DaoData.C2S_Player_DaoOpenVote()
    gg.client.gameServer:send("C2S_Player_DaoOpenVote", {
    })
end

-- "" //"" 1-"" 2-"" 3-""
function DaoData.C2S_Player_DaoVote(distribution)
    gg.client.gameServer:send("C2S_Player_DaoVote", {
        distribution = distribution
    })
end

-- ""
function DaoData.C2S_Player_QueryDaoVoteData()
    gg.client.gameServer:send("C2S_Player_QueryDaoVoteData", {
    })
end

-- ""
function DaoData.C2S_Player_DaoInvite(playerId)
    gg.client.gameServer:send("C2S_Player_DaoInvite", {
        playerId = playerId
    })
end

-- ""
function DaoData.C2S_Player_AcceptDaoInvite(daoId)
    gg.client.gameServer:send("C2S_Player_AcceptDaoInvite", {
        daoId = daoId
    })
end
-------------------------------------------------------------------------
--""("")
function DaoData.S2C_Player_MyDaoInfo(myDaoInfo)
    local daoJoin = false
    if DaoData.myDaoInfo == nil then
        daoJoin = true
    end
    DaoData.myDaoInfo = myDaoInfo

    DaoData.myDaoMemberMap = {}
    for key, value in pairs(DaoData.myDaoInfo.members) do
        value.job = DaoUtil.getDaoJob(value.playerId, myDaoInfo)
        DaoData.myDaoMemberMap[value.playerId] = value
    end
    table.sort(DaoData.myDaoInfo.members, function (a, b)
        if a.job ~= b.job then
            return a.job > b.job
        end
        return a.playerScore > b.playerScore
    end)
    gg.event:dispatchEvent("onMyDaoInfoChange")

    if daoJoin then
        gg.event:dispatchEvent("onDaoJoinOrQuit")
    end
end

DaoData.MEMBER_UPDATE_TYPE_ADD = 1
DaoData.MEMBER_UPDATE_TYPE_DEL = 2
DaoData.MEMBER_UPDATE_TYPE_UPDATE = 3
-- ""
function DaoData.DaoMemberUpdate(playerId, type, member)
    if DaoData.myDaoInfo and next(DaoData.myDaoInfo) then
        if type == DaoData.MEMBER_UPDATE_TYPE_ADD then
            table.insert(DaoData.myDaoInfo.members, member)

        elseif type == DaoData.MEMBER_UPDATE_TYPE_DEL and playerId == gg.playerMgr.localPlayer:getPid() then
            DaoData.myDaoInfo = nil
            gg.event:dispatchEvent("onMyDaoInfoChange")
            gg.event:dispatchEvent("onDaoJoinOrQuit")
            return
        else
            for key, value in pairs(DaoData.myDaoInfo.members) do
                if value.playerId == playerId then
                    if type == DaoData.MEMBER_UPDATE_TYPE_DEL then
                        table.remove(DaoData.myDaoInfo.members, key)
                    elseif type == DaoData.MEMBER_UPDATE_TYPE_UPDATE then
                        DaoData.myDaoInfo.members[key] = member
                    end
                    break
                end
            end
        end
        DaoData.S2C_Player_MyDaoInfo(DaoData.myDaoInfo)
    end
end

-- ""
function DaoData.S2C_Player_DaoAppointJob(args)
    if DaoData.myDaoInfo and next(DaoData.myDaoInfo) then
        for key, value in pairs(DaoData.myDaoInfo.vicePresidentPids) do
            if value == args.playerId then
                table.remove(DaoData.myDaoInfo.vicePresidentPids, key)
            end
        end
        for key, value in pairs(DaoData.myDaoInfo.elitePids) do
            if value == args.playerId then
                table.remove(DaoData.myDaoInfo.elitePids, key)
            end
        end
        if args.job == constant.DAO_DUTY_PRESIDENT then
            DaoData.myDaoInfo.presidentPid = args.playerId

        elseif args.job == constant.DAO_DUTY_VICEPRESIDENT then
            table.insert(DaoData.myDaoInfo.vicePresidentPids, args.playerId)

        elseif args.job == constant.DAO_DUTY_ELITE then
            table.insert(DaoData.myDaoInfo.elitePids, args.playerId)
        end
        DaoData.S2C_Player_MyDaoInfo(DaoData.myDaoInfo)
    end
end

-- ""
function DaoData.S2C_Player_DaoTransferPresident(args)
    if DaoData.myDaoInfo and next(DaoData.myDaoInfo) then
        DaoData.myDaoInfo.presidentPid = args.presidentPid
        DaoData.myDaoInfo.vicePresidentPids = args.vicePresidentPids
        DaoData.S2C_Player_MyDaoInfo(DaoData.myDaoInfo)
    end
end

-- ""
function DaoData.S2C_Player_JoinableDaoList(args)
    DaoData.joinableDaoList = args.daoList
    gg.event:dispatchEvent("onDaoJoinableRefresh")
end

-- ""
function DaoData.S2C_Player_SearchDaoResult(args)
    gg.event:dispatchEvent("onDaoSearch", args.daoInfoList)
end

-- dao""
function DaoData.S2C_Player_QueryDaoDetail(daoInfo)

    for key, value in pairs(daoInfo.members) do
        value.job = DaoUtil.getDaoJob(value.playerId, daoInfo)
    end
    table.sort(daoInfo.members, function (a, b)
        if a.job ~= b.job then
            return a.job > b.job
        end
        return a.playerScore > b.playerScore
    end)

    gg.event:dispatchEvent("onQueryDaoDetail", daoInfo)
end

-- ""
function DaoData.S2C_Player_DaoPlayerApplyList(applyList)
    DaoData.applyList = applyList
    gg.event:dispatchEvent("onDaoApplyChange")
end

-- -- ""
-- function DaoData.S2C_Player_DaoPlayerApplyAdd(apply)
--     DaoData.applyList = DaoData.applyList or {}
--     -- for index, value in ipairs(DaoData.applyList) do
--     --     if value.playerId == apply.playerId then
--     --         DaoData.applyList[index] = apply
--     --     end
--     -- end
--     table.insert(DaoData.applyList, apply)
--     gg.event:dispatchEvent("onDaoApplyChange")
-- end

-- ""(isAgree == 1"")
function DaoData.S2C_Player_DaoPlayerApplyUpdate(apply)
    DaoData.applyList = DaoData.applyList or {}
    local isUpdate = false
    for index, value in ipairs(DaoData.applyList) do
        if value.playerId == apply.playerId then
            isUpdate = true
            DaoData.applyList[index] = apply
            break
        end
    end

    if not isUpdate then
        table.insert(DaoData.applyList, apply)
    end

--""dao""
    if apply.isAgree == 1 and DaoData.myDaoInfo and next(DaoData.myDaoInfo) then
        table.insert(DaoData.myDaoInfo.members, apply)
        DaoData.S2C_Player_MyDaoInfo(DaoData.myDaoInfo)
    end
    gg.event:dispatchEvent("onDaoApplyChange")
end

-- ""
function DaoData.S2C_Player_AnswerJoinDaoApply(args)
    if args.answer == 1 then
        gg.uiManager:showTip(string.format("%s agree your apply", args.daoId))
    elseif args.answer == 2 then
        gg.uiManager:showTip(string.format("%s refuse your apply", args.daoId))
    end
end

-- ""
function DaoData.S2C_Player_DaoTaxData(args)
    DaoData.DaoTaxData = args
    if DaoData.myDaoMemberMap and next(DaoData.myDaoMemberMap) then
        for key, value in pairs(DaoData.DaoTaxData.memberTaxInfos) do
            value.member = DaoData.myDaoMemberMap[value.playerId]
        end
    end

    gg.event:dispatchEvent("onDaoTaxDataReturn")
end
--!
function DaoData.S2C_Player_QueryDaoVoteData(args)
    DaoData.DaoVoteData = args
    args.endLessTime = args.lessTime + os.time()
    gg.event:dispatchEvent("onDaoDaoVoteChange")
end

function DaoData.S2C_Player_DaoTaxSettleData(args)
    DaoData.daoSettleData = args
    args.endLessDrawTime = args.lessDrawTime + os.time()
    gg.event:dispatchEvent("onDaoDaoSettleChange")
end

function DaoData.S2C_Player_DaoInvite(args)
    local callbackYes = function (isOn)
        DaoData.C2S_Player_AcceptDaoInvite(args.daoId)
    end
    local txt = string.format("%s invite u 2 join dao %s", args.playerName, args.daoName)
    gg.uiManager:openWindow("PnlAlert", {callbackYes = callbackYes, txt = txt, closeLessTick = 30})
end
