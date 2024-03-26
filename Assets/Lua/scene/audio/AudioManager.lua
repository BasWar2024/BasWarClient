AudioManager = class("AudioManager")

function AudioManager:ctor()
    self:initVolume()
    self.playingBgm = nil
end

AudioManager.BG_VOLUME_KEY = "bgVolume"
AudioManager.EFFECT_VOLUME_KEY = "effectVolume"

function AudioManager:setVolume(key, volume)
    if key == AudioManager.BG_VOLUME_KEY then
        AudioFmodMgr:SetBGVolume(volume)
    elseif key == AudioManager.EFFECT_VOLUME_KEY then
        AudioFmodMgr:SetAudioVolume(volume)
    end
end

function AudioManager:getVolume(key)
    if key == AudioManager.BG_VOLUME_KEY then
        return AudioFmodMgr:GetBGVolume()
    elseif key == AudioManager.EFFECT_VOLUME_KEY then
        return AudioFmodMgr:GetAudioVolume()
    end
end

AudioManager.SCENE_2_BGM = {
    [constant.SCENE_LOGIN] = constant.AUDIO_BGM_LOGIN,
    -- [constant.SCENE_BATTLE] = constant.AUDIO_BGM_BATTLE,
    [constant.SCENE_PLANET] = constant.AUDIO_BGM_PLANNET,
    [constant.SCENE_BASE] = constant.AUDIO_BGM_BASE,
    [constant.SCENE_GALAXY] = constant.AUDIO_BGM_BASE,
    -- [constant.SCENE_STELLARSYSTEM] = constant.AUDIO_BGM_BASE,
    -- [constant.SCENE_STELLAR] = constant.AUDIO_BGM_BASE,
}

function AudioManager:onShowingSceneChange()
    local assetName = AudioManager.SCENE_2_BGM[gg.sceneManager.showingScene]
    if assetName then
        self:playBgAudio(assetName)
    end
end

function AudioManager:playBgAudio(assetName, isFadeBg)
    if self.playingBgm == assetName then
        return
    end
    self.playingBgm = assetName
    if isFadeBg or isFadeBg == nil then
        isFadeBg = true
    else
        isFadeBg = false
    end

    --AudioFmodMgr:PlayBGM("event:/Bgm/bgm_login", "bgm_login")
    AudioFmodMgr:PlayBGM(assetName.event, assetName.bank)
    -- AudioFmodMgr:PlayBGM("event:/Bgm/bgm_battle", "bgm_battle")
end

function AudioManager:initVolume()
    gg.event:addListener("onShowingSceneChange", self)

    AudioFmodMgr.ActionPlayBattleAudio = gg.bind(self.playBattleAudio, self)
    AudioFmodMgr.ActionPlaySkillAudio = gg.bind(self.playSkillAudio, self)
end

function AudioManager:playBattleAudio(cfgId, audio, transform)
    if audio == nil or audio == "" then
        return
    end
    
    -- if transform == nil then
    --     return
    -- end

    local audioCfg = cfg.battleaudio[cfgId]
    if audioCfg == nil then
        return
    end

    local audioName = audioCfg[audio]
    if audioName == nil or audioName == "" then
        return
    end
    AudioFmodMgr:PlayBattleAudio(audioName, audioCfg.bank, transform, nil)
end

function AudioManager:playSkillAudio(cfgId, audio, transform, callBack)
    if audio == nil or audio == "" then
        return
    end
    -- if transform == nil then
    --     return
    -- end

    local audioCfg = cfg.skillAudio[cfgId]
    if audioCfg == nil then
        return
    end

    local audioName = audioCfg[audio]
    if audioName == nil or audioName == "" then
        return
    end

    AudioFmodMgr:PlayBattleAudio(audioName, audioCfg.bank, transform, callBack)
end

function AudioManager:preLoadAudioByBattleAudioCfgId(preBattleAudioCfgIDList)
    local preLoadAudioList = {}

    for key, value in pairs(preBattleAudioCfgIDList) do
        local battleAudioCfg = cfg.battleaudio[value]
        if battleAudioCfg then
            for k, assetName in pairs(battleAudioCfg) do
                if k ~= "cfgId" and assetName and assetName ~= "" then
                    table.insert(preLoadAudioList, assetName)
                end
            end
        end
    end

    table.insert(preLoadAudioList, constant.AUDIO_BGM_BATTLE)
    table.insert(preLoadAudioList, constant.AUDIO_BGM_PLANNET)

    AudioFmodMgr:PreLoadBattleBank()
end

function AudioManager:preloadBattleAudio(battleInfo)

end

-- function AudioManager:playResultAudio(isWin, view)
--     -- self.battleMono:OpenMessageView()
--     local audioInfo
--     if isWin == 1 then
--         audioInfo = constant.AUDIO_BATTLE_WIN
--     else
--         audioInfo = constant.AUDIO_BATTLE_LOSE
--     end

--     AudioFmodMgr:LoadAudioInstance(audioInfo.event, audioInfo.bank, function (instance)
--         self.audioInstence = instance
--         if view and not view:isShow() then
--             self.audioInstence:release()
--             self.audioInstence = nil
--         else
--             self.audioInstence:start()
--             -- AudioFmodMgr:SetInstanceCallback(self.audioInstence, function (type)
--             --     print(type)
--             -- end)
            
--             -- //instance.setCallback((type, _event, parameters) =>
--             -- //{
--             -- //    UnityEngine.Debug.Log($"audioCB {eventName} {type} {_event}");
--             -- //    return RESULT.OK;
--             -- //});
--         end
--     end)
--     AudioFmodMgr:PauseBgm(true)
-- end

-- function AudioManager:stopResultAudio()

--     if self.audioInstence then
        
--     end

-- end
