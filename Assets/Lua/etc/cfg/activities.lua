-- cfgId                            int                              ""ID
-- name                             string                           ""
-- languageName                     string                           ""
-- actType                          int                              ""
-- actClass                         string                           ""
-- startTime                        string                           ""
-- endTime                          string                           ""
-- interval                         int                              ""("")
-- duration                         int                              ""("")
-- rankTopN                         int                              ""
-- status                           int                              ""(0-"" 1-"")
-- rewardCfgId                      int                              ""Id

return {
	[1] = {
		cfgId = 1,
		name = "PVP""",
		languageName = "hyRank_Left_PvpRankingSprint",
		actType = 1,
		actClass = "ActPVPRank",
		startTime = "2023-03-17 10:00:00",
		endTime = "2023-03-28 15:59:59",
		interval = nil,
		duration = nil,
		rankTopN = 100,
		status = 0,
		rewardCfgId = 13001,
	},
	[2] = {
		cfgId = 2,
		name = """",
		languageName = "hyRank_Left_DaoCompetition",
		actType = 1,
		actClass = "ActStarmapUnion",
		startTime = "2023-03-17 10:00:00",
		endTime = "2023-03-28 15:59:59",
		interval = nil,
		duration = nil,
		rankTopN = 20,
		status = 0,
		rewardCfgId = 13002,
	},
	[3] = {
		cfgId = 3,
		name = """",
		languageName = "hyRank_Left_OccupyPlotSprint",
		actType = 1,
		actClass = "ActStarmapFirstGet",
		startTime = "2023-03-17 10:00:00",
		endTime = "2023-03-28 15:59:59",
		interval = nil,
		duration = nil,
		rankTopN = 200,
		status = 0,
		rewardCfgId = 13003,
	},
}
