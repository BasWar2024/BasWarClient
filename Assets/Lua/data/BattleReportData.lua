BattleReportData = {}

BattleReportData.battleReport = {}

-- ""
function BattleReportData.C2S_Player_QueryFightReports(battleType)
    gg.client.gameServer:send("C2S_Player_QueryFightReports", {
        battleType = battleType,
    })
end

function BattleReportData.S2C_Player_FightReports(reports, battleType)
    BattleReportData.battleReport[battleType] = {}
    for k, v in pairs(reports) do
        table.insert(BattleReportData.battleReport[battleType], 1, v)
    end
    gg.event:dispatchEvent("onLoadBattleReport", battleType)

end

-- function BattleReportData.S2C_Player_FightReportAdd(report)
--     if BattleReportData.battleReport then
--         --print("aaaaa",table.dump(BattleReportData.battleReport))

--         table.insert(BattleReportData.battleReport, 1, report)

--         --print("bbbbb",table.dump(BattleReportData.battleReport))

--         if #BattleReportData.battleReport > 30 then
--             for k = 31, #BattleReportData.battleReport do
--                 print(table.dump(BattleReportData.battleReport[k]))
--                 BattleReportData.battleReport[k] = nil
--             end
--         end
--         --print("ccccc",table.dump(BattleReportData.battleReport))

--     end

-- end

return BattleReportData
