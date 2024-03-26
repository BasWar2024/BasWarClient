-- cfgId                            int                              ID
-- name                             string                           ""
-- desc                             string                           ""
-- president                        float                            ""
-- vicepresident                    float                            ""
-- member                           float                            ""("")

return {
	[1] = {
		cfgId = 1,
		name = "democraticy",
		desc = "democraticy",
		president = 0,
		vicepresident = 0,
		member = 1,
	},
	[2] = {
		cfgId = 2,
		name = "autarchy",
		desc = "autarchy",
		president = 1,
		vicepresident = 0,
		member = 0,
	},
	[3] = {
		cfgId = 3,
		name = "oligarchy",
		desc = "oligarchy",
		president = 0.3,
		vicepresident = 0.2,
		member = 0.5,
	},
}
