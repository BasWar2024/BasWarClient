PvpUtil = PvpUtil or {}

function PvpUtil.init()
    PvpUtil.pvpStageMap = {}
    local stageParam = -1
    local starParam = -1

    for key, value in ipairs(cfg.pvpStage) do
        if value.stage ~= stageParam  then
            PvpUtil.pvpStageMap[value.stage] = {}
            stageParam = value.stage
            starParam = value.star
        end

        value.showStar = value.star - starParam
        PvpUtil.pvpStageMap[stageParam][value.showStar + 1] = value
    end
end

function PvpUtil.bladge2StageCfg(bladge)
    for key, value in ipairs(cfg.pvpStage) do
        if value.startBladge > bladge then
            return cfg.pvpStage[value.star - 1], cfg.pvpStage[value.star]
        end
    end
    return cfg.pvpStage[#cfg.pvpStage]
end

function PvpUtil.getStageMap()
    if not PvpUtil.pvpStageMap then
        PvpUtil.init()
    end
    return PvpUtil.pvpStageMap
end
