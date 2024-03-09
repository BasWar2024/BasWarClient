-- cfgId                            int                              id
-- name                             string                           
-- intValue                         int                              
-- floatValue                       float                            
-- tableValue                       json                             table
-- stringValue                      string                           string
-- nameStr                          string                           1
-- age                              int                              2
-- arrayValue                       array[int:2]                     array
--    [1]                           int                              1
--    [2]                           int                              2

return {
	[1001] = {
		cfgId = 1001,
		name = "test",
		intValue = 1,
		floatValue = 1,
		tableValue = {
			[1] = 1,
		},
		stringValue = "string",
		nameStr = "name",
		age = 18,
		arrayValue = {
			[1] = 1,
			[2] = 2,
		},
	},
	[1002] = {
		cfgId = 1002,
		name = "test02",
		intValue = 1,
		floatValue = 1,
		tableValue = {
			[1] = 1,
		},
		stringValue = "string",
		nameStr = "name",
		age = 18,
		arrayValue = {
			[1] = 1,
			[2] = 2,
		},
	},
}
