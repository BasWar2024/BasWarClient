-- cfgId                            int                              ID
-- name                             string                           ""
-- Contribute                       int                              ""
-- rewardRatio                      int                              ""
-- maxCound                         int                              ""
-- accessLevel                      int                              ""
-- isTransfer                       int                              ""(1-""；0-"")
-- isAppointed                      int                              ""(1-""；0-"")
-- isOutgoing                       int                              ""(1-""；0-"")
-- isKickOut                        int                              ""(1-""；0-"")
-- isRemove                         int                              ""(1-""；0-"")
-- isAttack                         int                              ""(1-""；0-"")
-- isTrainTroops                    int                              ""(1-""；0-"")
-- isBuildTowers                    int                              ""(1-""；0-"")
-- isResearch                       int                              ""(1-""；0-"")
-- isEdit                           int                              ""(1-""；0-"")
-- isPersonnel                      int                              ""(1-""；0-"")
-- isCollect                        int                              ""
-- canMoveStartGrid                 int                              ""

return {
	[1] = {
		cfgId = 1,
		name = "President",
		Contribute = 20,
		rewardRatio = 800,
		maxCound = 1,
		accessLevel = 9,
		isTransfer = 1,
		isAppointed = 1,
		isOutgoing = 0,
		isKickOut = 1,
		isRemove = 1,
		isAttack = 1,
		isTrainTroops = 1,
		isBuildTowers = 1,
		isResearch = 1,
		isEdit = 1,
		isPersonnel = 1,
		isCollect = 1,
		canMoveStartGrid = 1,
	},
	[2] = {
		cfgId = 2,
		name = "Vice President",
		Contribute = 10,
		rewardRatio = 400,
		maxCound = 1,
		accessLevel = 8,
		isTransfer = 0,
		isAppointed = 1,
		isOutgoing = 1,
		isKickOut = 1,
		isRemove = 1,
		isAttack = 1,
		isTrainTroops = 1,
		isBuildTowers = 1,
		isResearch = 1,
		isEdit = 1,
		isPersonnel = 1,
		isCollect = 1,
		canMoveStartGrid = 1,
	},
	[3] = {
		cfgId = 3,
		name = "Commander",
		Contribute = 10,
		rewardRatio = 400,
		maxCound = 2,
		accessLevel = 7,
		isTransfer = 0,
		isAppointed = 0,
		isOutgoing = 1,
		isKickOut = 0,
		isRemove = 0,
		isAttack = 1,
		isTrainTroops = 1,
		isBuildTowers = 1,
		isResearch = 0,
		isEdit = 0,
		isPersonnel = 0,
		isCollect = 1,
		canMoveStartGrid = 0,
	},
	[4] = {
		cfgId = 4,
		name = "Member",
		Contribute = 0,
		rewardRatio = 0,
		maxCound = -1,
		accessLevel = 0,
		isTransfer = 0,
		isAppointed = 0,
		isOutgoing = 0,
		isKickOut = 0,
		isRemove = 0,
		isAttack = 0,
		isTrainTroops = 0,
		isBuildTowers = 0,
		isResearch = 0,
		isEdit = 0,
		isPersonnel = 0,
		isCollect = 0,
		canMoveStartGrid = 0,
	},
}
