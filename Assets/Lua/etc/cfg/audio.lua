-- name                             string                           ""
-- event                            string                           ""
-- bank                             string                           bank""

return {
	["gameStart"] = {
		name = "gameStart",
		event = "event:/game_begin",
		bank = "se_UI",
	},
	["buttonClickDefault"] = {
		name = "buttonClickDefault",
		event = "event:/UI_button_click",
		bank = "se_UI",
	},
	["windowOpen"] = {
		name = "windowOpen",
		event = "event:/SFX/sfx_UI_OpenWnd",
		bank = "SFX",
	},
	["buildingClick"] = {
		name = "buildingClick",
		event = "event:/Build_common_click",
		bank = "se_UI",
	},
	["buildingMove"] = {
		name = "buildingMove",
		event = "event:/Build_Move",
		bank = "se_UI",
	},
	["buildingUpgradeComplete"] = {
		name = "buildingUpgradeComplete",
		event = "event:/Build_finish",
		bank = "se_UI",
	},
	["battleWin"] = {
		name = "battleWin",
		event = "event:/BGM/bgm_battle_win",
		bank = "bgm_battle_win",
	},
	["battleLose"] = {
		name = "battleLose",
		event = "event:/BGM/bgm_battle_lose",
		bank = "bgm_battle_lose",
	},
	["starCoinCollect"] = {
		name = "starCoinCollect",
		event = "event:/Starcoin_collect_click",
		bank = "se_UI",
	},
	["gasCollect"] = {
		name = "gasCollect",
		event = "event:/gas_collect_click",
		bank = "se_UI",
	},
	["hydroxylCollect"] = {
		name = "hydroxylCollect",
		event = "event:/hydroxyl_collect_click",
		bank = "se_UI",
	},
	["iceCollect"] = {
		name = "iceCollect",
		event = "event:/ice_collect_click",
		bank = "se_UI",
	},
	["titaniumCollect"] = {
		name = "titaniumCollect",
		event = "event:/Titanium_collect_click",
		bank = "se_UI",
	},
	["loginBGM"] = {
		name = "loginBGM",
		event = "event:/BGM/bgm_main_bg",
		bank = "bgm_main_bg",
	},
	["baseBGM"] = {
		name = "baseBGM",
		event = "event:/BGM/bgm_main",
		bank = "bgm_main",
	},
	["battleBGM"] = {
		name = "battleBGM",
		event = "event:/BGM/bgm_battle_2",
		bank = "bgm_battle",
	},
	["battleReadyBGM"] = {
		name = "battleReadyBGM",
		event = "event:/BGM/bgm_battle_1",
		bank = "bgm_battle",
	},
	["planningBGM"] = {
		name = "planningBGM",
		event = "event:/BGM/bgm_planning",
		bank = "bgm_planning",
	},
	["starBGM"] = {
		name = "starBGM",
		event = "event:/BGM/bgm_star",
		bank = "bgm_star",
	},
}
