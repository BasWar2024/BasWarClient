--""
constant.RES_MIN = 101

constant.RES_MIT = 101           --MIT
constant.RES_STARCOIN = 102      --""
constant.RES_ICE = 103           --""
constant.RES_CARBOXYL = 104      --""
constant.RES_TITANIUM = 105      --""
constant.RES_GAS = 106           --""
constant.RES_TESSERACT = 107     --""

constant.RES_ITEM = 200          --""

constant.RES_BADGE = 110         --""

constant.RES_MAX = 110

constant.INSTANCE_COST_RES = constant.RES_TESSERACT

constant.RES_2_CFG_KEY = {
    [constant.RES_MIT] = {
        key = "RES_MIT",
        name = "MIT",
        languageKey = "res_MIT",
        iconNameHead = "icon_mit_",
        icon = "ResIcon_200_Atlas[icon_mit_200]",
        iconBig = "ResIcon_200_Atlas[icon_mit_200]",
        levelUpKey = "levelUpNeedMit",
        exchangeFrom = 0,
        exchangeKey = "",
        storeKey = "",
        perMakeKey = "",
        vipKey = "",
        protoGetResKey = "",
        BuildDataCurResKey = "",
        makeResBuild = nil,
        storeResBuild = nil,
    },

    [constant.RES_STARCOIN] = {
        key = "RES_STARCOIN",
        name = "Star coin",
        languageKey = "res_Star",
        iconNameHead = "icon_starcoin_",
        icon = "ResIcon_200_Atlas[icon_starcoin_200]",
        iconBig = "ResIcon_200_Atlas[icon_starcoin_200]",
        levelUpKey = "levelUpNeedStarCoin",
        exchangeFrom = constant.RES_TESSERACT,
        exchangeKey = "starCoin",
        storeKey = "storeStarCoin",
        perMakeKey = "perMakeStarCoin",
        vipKey = "starCoinRatio",
        protoGetResKey = "getStarCoin",
        BuildDataCurResKey = "curStarCoin",
        makeResBuild = 6010008,
        storeResBuild = 6010009,
    },

    [constant.RES_ICE] = {
        key = "RES_ICE",
        name = "Ice",
        languageKey = "res_Ice",
        iconNameHead = "icon_ice_",
        icon = "ResIcon_200_Atlas[icon_ice_200]",
        iconBig = "ResIcon_200_Atlas[icon_ice_200]",
        levelUpKey = "levelUpNeedIce",
        exchangeFrom = constant.RES_TESSERACT,
        exchangeKey = "ice",
        storeKey = "storeIce",
        perMakeKey = "perMakeIce",
        vipKey = "iceRatio",
        protoGetResKey = "getIce",
        BuildDataCurResKey = "curIce",
        makeResBuild = 6010002,
        storeResBuild = 6010003,
    },

    [constant.RES_CARBOXYL] = {
        key = "RES_CARBOXYL",
        name = "Hydroxyl",
        languageKey = "res_Hydroxyl",
        iconNameHead = "icon_hydroxyl_",
        icon = "ResIcon_200_Atlas[icon_hydroxyl_200]",
        iconBig = "ResIcon_200_Atlas[icon_hydroxyl_200]",
        levelUpKey = "levelUpNeedCarboxyl",
        exchangeFrom = constant.RES_TESSERACT,
        exchangeKey = "carboxyl",
        storeKey = "storeCarboxyl",
        perMakeKey = "perMakeCarboxyl",
        vipKey = "carboxylRatio",
        protoGetResKey = "getCarboxyl",
        BuildDataCurResKey = "curCarboxyl",
        makeResBuild = nil,
        storeResBuild = nil,
    },

    [constant.RES_TITANIUM] = {
        key = "RES_TITANIUM",
        name = "Titanium",
        languageKey = "res_Titanium",
        iconNameHead = "icon_titanium_",
        icon = "ResIcon_200_Atlas[icon_titanium_200]",
        iconBig = "ResIcon_200_Atlas[icon_titanium_200]",
        levelUpKey = "levelUpNeedTitanium",
        exchangeFrom = constant.RES_TESSERACT,
        exchangeKey = "titanium",
        storeKey = "storeTitanium",
        perMakeKey = "perMakeTitanium",
        vipKey = "titaniumRatio",
        protoGetResKey = "getTitanium",
        BuildDataCurResKey = "curTitanium",
        makeResBuild = 6010004,
        storeResBuild = 6010005,
    },

    [constant.RES_GAS] = {
        key = "RES_GAS",
        name = "Gas",
        languageKey = "res_Gas",
        iconNameHead = "icon_gas_",
        icon = "ResIcon_200_Atlas[icon_gas_200]",
        iconBig = "ResIcon_200_Atlas[icon_gas_200]",
        levelUpKey = "levelUpNeedGas",
        exchangeFrom = constant.RES_TESSERACT,
        exchangeKey = "gas",
        storeKey = "storeGas",
        perMakeKey = "perMakeGas",
        vipKey = "gasRatio",
        protoGetResKey = "getGas",
        BuildDataCurResKey = "curGas",
        makeResBuild = 6010006,
        storeResBuild = 6010007,
    },

    [constant.RES_TESSERACT] = {
        key = "RES_TESSERACT",
        name = "Tesseract",
        languageKey = "res_Tesseract",
        iconNameHead = "icon_Tesseract_",
        icon = "ResIcon_200_Atlas[icon_tesseract_200]",
        iconBig = "ResIcon_200_Atlas[icon_tesseract_200]",
        levelUpKey = "levelUpNeedTesseract",
        exchangeFrom = constant.RES_CARBOXYL,
        exchangeKey = "tesseract",
        storeKey = "",
        perMakeKey = "",
        vipKey = "",
        protoGetResKey = "",
        BuildDataCurResKey = "",
        makeResBuild = nil,
        storeResBuild = nil,
    },
}
