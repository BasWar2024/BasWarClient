-- cfgId                            int                              ID
-- hyMin                            int                              ""
-- hyMax                            int                              ""
-- taxesPercentage                  int                              ""
-- taxesMin                         int                              ""

return {
	[1] = {
		cfgId = 1,
		hyMin = 0,
		hyMax = 5000000,
		taxesPercentage = 400000,
		taxesMin = 1000000,
	},
	[2] = {
		cfgId = 2,
		hyMin = 5000001,
		hyMax = 30000000,
		taxesPercentage = 200000,
		taxesMin = 1000000,
	},
	[3] = {
		cfgId = 3,
		hyMin = 30000001,
		hyMax = 100000000,
		taxesPercentage = 100000,
		taxesMin = 1000000,
	},
	[4] = {
		cfgId = 4,
		hyMin = 100000001,
		hyMax = 0,
		taxesPercentage = 10000,
		taxesMin = 1000000,
	},
}
