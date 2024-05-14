-- cfgId                            int                              ""ID
-- gm                               int                              ""GM(1-"", 2-PVE"")
-- robotid                          int                              ""ID
-- mailPrefix                       string                           ""
-- mail                             string                           ""
-- password                         string                           ""
-- roleNamePrefix                   string                           ""
-- headIcon                         string                           ""
-- initGameServer                   string                           ""
-- starCoin                         long                             ""
-- ice                              long                             ""
-- titanium                         long                             ""
-- gas                              long                             ""
-- carboxyl                         long                             ""
-- buildLayoutId                    int                              ""
-- initData                         json                             ""

return {
	[1] = {
		cfgId = 1,
		gm = 1,
		robotid = 0,
		mailPrefix = "yuntest",
		mail = "@qq.com",
		password = "a123456",
		roleNamePrefix = "yuntest",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 10000000,
		ice = 10000000,
		titanium = 10000000,
		gas = 10000000,
		carboxyl = 10000000,
		buildLayoutId = 0,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
					},
					iceGuideDrawed = false,
					starCoinGuideDrawed = false,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm5@qq.com",
			},
		},
	},
	[2] = {
		cfgId = 2,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_2",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 1,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm6@qq.com",
			},
		},
	},
	[3] = {
		cfgId = 3,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_3",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 2,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm7@qq.com",
			},
		},
	},
	[4] = {
		cfgId = 4,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_4",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 3,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm8@qq.com",
			},
		},
	},
	[5] = {
		cfgId = 5,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_5",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 4,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm9@qq.com",
			},
		},
	},
	[6] = {
		cfgId = 6,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_6",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 5,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm10@qq.com",
			},
		},
	},
	[7] = {
		cfgId = 7,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 6,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm11@qq.com",
			},
		},
	},
	[8] = {
		cfgId = 8,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_2",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 7,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm12@qq.com",
			},
		},
	},
	[9] = {
		cfgId = 9,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_3",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 8,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm13@qq.com",
			},
		},
	},
	[10] = {
		cfgId = 10,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_4",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 9,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm14@qq.com",
			},
		},
	},
	[11] = {
		cfgId = 11,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_5",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 10,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm15@qq.com",
			},
		},
	},
	[12] = {
		cfgId = 12,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_6",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 11,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm16@qq.com",
			},
		},
	},
	[13] = {
		cfgId = 13,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 12,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm17@qq.com",
			},
		},
	},
	[14] = {
		cfgId = 14,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_2",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 13,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm18@qq.com",
			},
		},
	},
	[15] = {
		cfgId = 15,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_3",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 14,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm19@qq.com",
			},
		},
	},
	[16] = {
		cfgId = 16,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_4",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 15,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm20@qq.com",
			},
		},
	},
	[17] = {
		cfgId = 17,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_5",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 16,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm21@qq.com",
			},
		},
	},
	[18] = {
		cfgId = 18,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_6",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 17,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm22@qq.com",
			},
		},
	},
	[19] = {
		cfgId = 19,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_3",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 18,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm23@qq.com",
			},
		},
	},
	[20] = {
		cfgId = 20,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_4",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 19,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm24@qq.com",
			},
		},
	},
	[21] = {
		cfgId = 21,
		gm = 1,
		robotid = 0,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_5",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 20,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm25@qq.com",
			},
		},
	},
	[22] = {
		cfgId = 22,
		gm = 2,
		robotid = 1,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 1,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm26@qq.com",
			},
		},
	},
	[23] = {
		cfgId = 23,
		gm = 2,
		robotid = 2,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_2",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 2,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm27@qq.com",
			},
		},
	},
	[24] = {
		cfgId = 24,
		gm = 2,
		robotid = 3,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_3",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 3,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm28@qq.com",
			},
		},
	},
	[25] = {
		cfgId = 25,
		gm = 2,
		robotid = 4,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_4",
		initGameServer = "game1",
		starCoin = 10000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 4,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm29@qq.com",
			},
		},
	},
	[26] = {
		cfgId = 26,
		gm = 2,
		robotid = 5,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_5",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 5,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm30@qq.com",
			},
		},
	},
	[27] = {
		cfgId = 27,
		gm = 2,
		robotid = 6,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_6",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 6,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm31@qq.com",
			},
		},
	},
	[28] = {
		cfgId = 28,
		gm = 2,
		robotid = 7,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 7,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm32@qq.com",
			},
		},
	},
	[29] = {
		cfgId = 29,
		gm = 2,
		robotid = 8,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_2",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 8,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm33@qq.com",
			},
		},
	},
	[30] = {
		cfgId = 30,
		gm = 2,
		robotid = 9,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_3",
		initGameServer = "game1",
		starCoin = 100000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 9,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm34@qq.com",
			},
		},
	},
	[31] = {
		cfgId = 31,
		gm = 2,
		robotid = 10,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_4",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 10,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm35@qq.com",
			},
		},
	},
	[32] = {
		cfgId = 32,
		gm = 2,
		robotid = 11,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_5",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 11,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm36@qq.com",
			},
		},
	},
	[33] = {
		cfgId = 33,
		gm = 2,
		robotid = 12,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_6",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 12,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm37@qq.com",
			},
		},
	},
	[34] = {
		cfgId = 34,
		gm = 2,
		robotid = 13,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 13,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm38@qq.com",
			},
		},
	},
	[35] = {
		cfgId = 35,
		gm = 2,
		robotid = 14,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_2",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 14,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm39@qq.com",
			},
		},
	},
	[36] = {
		cfgId = 36,
		gm = 2,
		robotid = 15,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_3",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 15,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm40@qq.com",
			},
		},
	},
	[37] = {
		cfgId = 37,
		gm = 2,
		robotid = 16,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_4",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 16,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm41@qq.com",
			},
		},
	},
	[38] = {
		cfgId = 38,
		gm = 2,
		robotid = 17,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_5",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 17,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm42@qq.com",
			},
		},
	},
	[39] = {
		cfgId = 39,
		gm = 2,
		robotid = 18,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_6",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 18,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm43@qq.com",
			},
		},
	},
	[40] = {
		cfgId = 40,
		gm = 2,
		robotid = 19,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 19,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm44@qq.com",
			},
		},
	},
	[41] = {
		cfgId = 41,
		gm = 2,
		robotid = 20,
		mailPrefix = "zzobot",
		mail = "@qq.com",
		password = "z123456",
		roleNamePrefix = "Enemy",
		headIcon = "Head_Icon_2",
		initGameServer = "game1",
		starCoin = 100000000,
		ice = 1000000,
		titanium = 0,
		gas = 0,
		carboxyl = 1000000,
		buildLayoutId = 20,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
						[1] = {
							guideId = 1000,
						},
						[2] = {
							guideId = 1001,
						},
						[3] = {
							guideId = 1002,
						},
						[4] = {
							guideId = 1003,
						},
						[5] = {
							guideId = 1004,
						},
						[6] = {
							guideId = 1005,
						},
						[7] = {
							guideId = 1006,
						},
						[8] = {
							guideId = 1007,
						},
						[9] = {
							guideId = 1008,
						},
						[10] = {
							guideId = 1009,
						},
						[11] = {
							guideId = 1010,
						},
					},
					iceGuideDrawed = true,
					starCoinGuideDrawed = true,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm45@qq.com",
			},
		},
	},
	[42] = {
		cfgId = 42,
		gm = 20,
		robotid = 0,
		mailPrefix = "king",
		mail = "@qq.com",
		password = "a123456",
		roleNamePrefix = "king",
		headIcon = "Head_Icon_1",
		initGameServer = "game1",
		starCoin = 10000000,
		ice = 10000000,
		titanium = 10000000,
		gas = 10000000,
		carboxyl = 1000000000,
		buildLayoutId = 0,
		initData = {
			account_roles = {
				account = "mm5@qq.com",
				appid = "sw",
				roles = {
					[1] = 1000004,
				},
			},
			brief = {
				pid = 1000004,
				logoutTime = 0,
				race = 1,
				loginTime = 1657543787,
				disconnectTime = 0,
				node = "game1",
				vip = 0,
				id = 6952242537587281927,
				onlineState = 1,
				address = 8,
				runId = "77568.1657543744983",
				name = "Commander1000004",
				createTime = 1657543787,
				currentServerId = "game1",
				level = 1,
				lang = "zh_CN",
				account = "mm5@qq.com",
			},
			role = {
				account = "mm5@qq.com",
				createServerId = "game1",
				level = 1,
				race = 1,
				onlineState = 1,
				createTime = 1657543787,
				roleid = 1000004,
				appid = "sw",
				name = "Commander1000004",
				headIcon = "Head_Icon_6",
				currentServerId = "game1",
				rmb = 0,
				gold = 0,
				vip = 0,
			},
			player = {
				heroBag = {
					heros = {
						[1] = {
							selectSkill = 1,
							nextTick = 0,
							skillLevel2 = 0,
							race = 0,
							chain = 0,
							skill1 = 5116016,
							level = 1,
							quality = 0,
							repairTick = 0,
							cfgId = 5000001,
							fightTick = 0,
							curLife = 49,
							skill3 = 0,
							skillUpNextTick = 0,
							life = 50,
							style = 0,
							skillUp = 0,
							skillLevel3 = 0,
							id = 6952242537520173061,
							skillLevel1 = 1,
							skill2 = 0,
						},
					},
					useId = 6952242537520173061,
				},
				mailBag = {
					mailsDict = {
						[1] = {
							mailType = 1,
							id = 100,
							duration = 720,
							sendName = "Galaxy Blitz Team",
							sendTime = 1657543787,
							title = "Welcome to Galaxy Blitz",
							sendPid = 0,
							read = false,
							content = "Congratulations on your hardship to finally land here.We all look forward to having you as a part of our galactic ecosystem,and we now officially assign you a role as Commander.Begin your journey to lead the descendants of humanity to forge a new empire now!\nWelcome to the Galaxy Blitz Beta Testing!",
							get = false,
						},
					},
				},
				guideBag = {
					guides = {
					},
					iceGuideDrawed = false,
					starCoinGuideDrawed = false,
				},
				chainBridgeBag = {
					withdrawToken = {
					},
					launchBridgeRecords = {
					},
					rechargeToken = {
					},
					rechargeNFT = {
					},
				},
				data = {
				},
				unionBag = {
					applys = {
					},
					invites = {
					},
				},
				repairBag = {
				},
				time = {
					thisweek = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					thisweek2 = {
						objs = {
						},
						data = {
						},
						dayno = 412,
					},
					today = {
						objs = {
						},
						data = {
						},
						dayno = 2878,
					},
					thistemp = {
						data = {
						},
						time = {
						},
					},
					thismonth = {
						objs = {
						},
						data = {
						},
						dayno = 95,
					},
				},
				chatBag = {
					banTick = 0,
					isBan = false,
				},
				resBag = {
					costMit = 0,
					resources = {
					},
				},
				achievementBag = {
				},
				warShipBag = {
					warShips = {
						[1] = {
							skillLevel5 = 0,
							nextTick = 0,
							skillLevel2 = 1,
							race = 0,
							chain = 0,
							skill1 = 5116017,
							level = 1,
							quality = 0,
							skillLevel4 = 0,
							repairTick = 0,
							skillUpNextTick = 0,
							cfgId = 4000001,
							skillUp = 0,
							curLife = 88,
							skill3 = 5111001,
							skillLevel3 = 1,
							life = 89,
							style = 0,
							skill5 = 0,
							id = 6952242537520173062,
							skill4 = 0,
							skillLevel1 = 1,
							skill2 = 5106001,
						},
					},
					useId = 6952242537520173062,
				},
				vipBag = {
					cdTick = 0,
					mit = 0,
					vipLevel = 0,
				},
				foundationBag = {
					attackedTick = 0,
					foundationWars = {
					},
					protectTick = 0,
				},
				fightReportBag = {
					starmapReports = {
					},
					pvpReports = {
					},
				},
				property = {
					halfHourVersion = 138138,
					openId = "mm5",
					logoutTime = 0,
					monthVersion = 95,
					race = 1,
					loginTime = 1657543787,
					level = 1,
					vip = 0,
					dayVersion = 2878,
					createTime = 1657543787,
					fiveMinuteVersion = 828827,
					sundayVersion = 412,
					hourVersion = 69069,
					minuteVersion = 4144132,
					banGame = false,
					disconnectTime = 0,
					mondayVersion = 412,
					name = "Commander1000004",
					headIcon = "Head_Icon_6",
					createServerId = "game1",
					gm = 0,
					lang = "zh_CN",
					account = "mm5@qq.com",
				},
				playerInfoBag = {
					totalGameTime = 0,
					canInvite = true,
					canVisit = true,
					text = "Enter Text...",
					modifyNameNum = 0,
					loginCount = 1,
				},
				taskBag = {
					tasks = {
					},
					resetTick = 1657555200000,
					playerLevel = 0,
				},
				buildBag = {
					buildMaxQueueCount = 1,
					mineLevels = {
					},
					builds = {
						[1] = {
							nextTick = 0,
							ownerPid = 0,
							trainTick = 0,
							repairTick = 0,
							fightTick = 0,
							race = 0,
							chain = 0,
							soliderCount = 0,
							curCarboxyl = 0,
							level = 2,
							curStarCoin = 0,
							quality = 0,
							lastMakeTick = 0,
							type = 2,
							curGas = 0,
							subType = 0,
							cfgId = 6010001,
							trainCount = 0,
							curLife = 50,
							soliderCfgId = 0,
							curTitanium = 0,
							x = 26,
							style = 0,
							z = 26,
							life = 50,
							id = 6952242537515978755,
							curIce = 0,
							trainCfgId = 0,
						},
					},
					soliderForgeLevels = {
						[1] = {
							cfgId = 7100001,
							level = 0,
						},
						[2] = {
							cfgId = 7100002,
							level = 0,
						},
						[3] = {
							cfgId = 7100003,
							level = 0,
						},
						[4] = {
							cfgId = 7100004,
							level = 0,
						},
						[5] = {
							cfgId = 7100005,
							level = 0,
						},
					},
					soliderLevels = {
						[1] = {
							cfgId = 7100004,
							level = 1,
							nextTick = 0,
						},
						[2] = {
							cfgId = 7400001,
							level = 1,
							nextTick = 0,
						},
						[3] = {
							cfgId = 7100011,
							level = 1,
							nextTick = 0,
						},
						[4] = {
							cfgId = 7100010,
							level = 1,
							nextTick = 0,
						},
						[5] = {
							cfgId = 7100009,
							level = 1,
							nextTick = 0,
						},
						[6] = {
							cfgId = 7100008,
							level = 1,
							nextTick = 0,
						},
						[7] = {
							cfgId = 7200002,
							level = 1,
							nextTick = 0,
						},
						[8] = {
							cfgId = 7100003,
							level = 1,
							nextTick = 0,
						},
						[9] = {
							cfgId = 7200001,
							level = 1,
							nextTick = 0,
						},
						[10] = {
							cfgId = 7100002,
							level = 1,
							nextTick = 0,
						},
						[11] = {
							cfgId = 7100007,
							level = 1,
							nextTick = 0,
						},
						[12] = {
							cfgId = 7100006,
							level = 1,
							nextTick = 0,
						},
						[13] = {
							cfgId = 7100005,
							level = 1,
							nextTick = 0,
						},
						[14] = {
							cfgId = 7100001,
							level = 1,
							nextTick = 0,
						},
					},
					researchMaxQueueCount = 1,
				},
				starmapBag = {
					battleGridIds = {
					},
					favoriteGridIds = {
					},
					myRewardInfo = {
						matchRewards = {
						},
						unionCarboxyl = 0,
						gridMit = 0,
						gridRewards = {
						},
						unionMit = 0,
						gridCarboxyl = 0,
					},
				},
				treasureBag = {
					treasures = {
					},
				},
				itemBag = {
					items = {
					},
					expandSpace = 99999999,
					maxSpace = 50,
				},
				pvpBag = {
					armyPlayers = {
					},
					index = 1,
					refreshCount = 10,
					battleNumPurchased = 0,
					refreshTotal = 10,
					pveWinIds = {
					},
					rewardsTips = {
					},
					banBattleTick = 0,
					matchRecords = {
					},
					banBattleCount = 0,
					battleNum = 5,
					resetTick = 1657555200000,
					pveScore = 0,
				},
			},
			account = {
				platform = "local",
				sdk = "local",
				passwd = "8ce410eed41e6a83",
				createTime = 1657543780,
				device = {
					registerLoginType = 1,
					wifiName = "wifiName",
					deviceCode = "deviceCode",
					os = "windows",
					deviceType = 3,
					deviceModel = "deviceModel",
					channelId = 0,
					lang = "zh_CN",
					network = "WIFI",
				},
				verifyCode = "660088",
				openid = "mm5@qq.com",
				account = "mm5@qq.com",
			},
		},
	},
}
