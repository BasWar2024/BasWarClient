
constant.TASK_TYPE_PVE = 611
constant.TASK_TYPE_PVP_COUNT = 601
constant.TASK_TYPE_PVP_SCORE = 602
constant.TASK_TYPE_PVP_BUILD_BUILDING = 301

-- ""x""
constant.TASK_COLLECT_RES = 701

-- ""x""y""
constant.TASK_COLLECT_X_RES_Y = 702

-- ""x""
constant.TASK_COST_RES = 711

-- ""x""y""
constant.TASK_COST_X_RES_Y = 712

constant.TASK_TYPE_MESSAGE = {
    [constant.TASK_TYPE_PVE] = {
        jumpView = "PnlPveNew",
    },
    [constant.TASK_TYPE_PVP_COUNT] = {
        jumpView = "PnlPvp",
    },
    [constant.TASK_TYPE_PVP_SCORE] = {
        jumpView = "PnlPvp",
    },

    [constant.TASK_TYPE_PVP_BUILD_BUILDING] = {
        type = "BUILD_BUILDING",
        -- jumpView = "PnlBuild",
    },
}

constant.SHOW_RES_PROGRESS = {
    -- [constant.TASK_COLLECT_RES] = true,
    [constant.TASK_COLLECT_X_RES_Y] = true,
    [constant.TASK_COST_RES] = true,
    [constant.TASK_COST_X_RES_Y] = true,
}

-- Administrator:
-- 101	""x""
-- 102	""x""
-- 201	""x""
-- 202	""x""
-- 203	""
-- 301	""X""Y""Z""
-- 401	""x""y"" 
-- 403 	""
-- 601	Pvp""x
-- 602	Pvp""x
-- 611	PVE""x""
-- 621	""x""y""
-- 624	""x""y""
-- 701	""x""
-- 702	""x""y""
-- 711	""x""
-- 712	""x""y""
-- 801	""
-- 901	""
-- 902	""x""
-- 903	""
-- 904	""x""
-- 905	""
