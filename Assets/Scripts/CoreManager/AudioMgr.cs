using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

// wav ogg
// unity
// open settings : load in backGround,compressed in memory,
//  PCM ADPCM  
//


public enum AudioType
{
    BGMusic = 1,            //
    Battle = 2,             //
    Building = 3,           //
    UI = 4,                 //ui
}
public class AudioMgr : Singleton<AudioMgr>
{
    private Dictionary<AudioType, AudioSource> audioDic = new Dictionary<AudioType, AudioSource>();

    private AudioSource bgAudio;
    private uint fadeInTimer = 0;
    private uint fadeOutTimer = 0;

    public void Init()
    {
        Transform parent = GameObject.Find("global/AudioTemplate").transform;
        audioDic.Add(AudioType.BGMusic, parent.Find("Bg").GetComponent<AudioSource>());
        audioDic.Add(AudioType.Battle, parent.Find("Battle").GetComponent<AudioSource>());
        audioDic.Add(AudioType.UI, parent.Find("UI").GetComponent<AudioSource>());
        audioDic.Add(AudioType.Building, parent.Find("Building").GetComponent<AudioSource>());      
    }

    //
    public void SetSystemVolume(float volume)
    {
        PlayerPrefs.SetFloat(Appconst.systemVolumeKey, volume);
        AudioListener.volume = volume;
    }
    public float GetSystemVolume()
    {
        return PlayerPrefs.GetFloat(Appconst.systemVolumeKey, 1);
    }

    //
    public void SetBGVolume(float volume)
    {
        AudioSource source = audioDic[AudioType.BGMusic];
        source.volume = volume;
        PlayerPrefs.SetFloat(Appconst.bgMusicVolumeKey, volume);
    }
    public float GetBGVolume()
    {
        return PlayerPrefs.GetFloat(Appconst.bgMusicVolumeKey, 1);
    }

    //
    public void SetAudioVolume(float volume)
    {
        AudioSource source = audioDic[AudioType.Battle];
        source.volume = volume;
        source = audioDic[AudioType.Building];
        source.volume = volume;
        source = audioDic[AudioType.UI];
        source.volume = volume;
        PlayerPrefs.SetFloat(Appconst.audioVolumeKey, volume);
    }

    public float GetAudioVolume()
    {
        return PlayerPrefs.GetFloat(Appconst.audioVolumeKey, 1);
    }

    //
    public void PauseAudio(AudioType audioType, bool paused)
    {
        if (paused)
        {
            audioDic[audioType].Pause();
        }
        else
        {
            audioDic[audioType].UnPause();
        }
    }

    public void PlayBGAudio(string assetName)
    {
        PlayAudio(assetName, AudioType.BGMusic, Vector3.zero, 0f, true);
    }

    //ui2d
    //
    public void Play2DAudio(string assetName, float delay = 0, AudioType audioType = AudioType.UI, Action onPlayFinish = null)
    {
        if (delay == 0f)
        {
            PlayAudio(assetName, audioType, Vector3.zero, 0f, true);
        }
        else
        {
            TimerMgr.instance.StartTimer(delay, () => {
                PlayAudio(assetName, audioType, Vector3.zero, 0f, false, onPlayFinish);
            });

        }
    }

    //3d
    public void Play3DAudio(string assetName, Vector3 pos, float delay = 0, AudioType audioType = AudioType.Building, Action onPlayFinish = null)
    {
        if (delay == 0f)
        {
            PlayAudio(assetName, audioType, pos);
        }
        else
        {
            TimerMgr.instance.StartTimer(delay, () => {
                PlayAudio(assetName, audioType, pos, 0f, false, onPlayFinish);
            });
        }

    }

    //3d
    //audioComp
    public AudioSource Play3DFollowAudio(string assetName,Transform trans, float delay = 0,
        AudioType audioType = AudioType.Battle, Action onPlayFinish = null)
    {
        AudioSource source = trans.GetComponent<AudioSource>();
        if (source == null)
        {
            trans.gameObject.AddComponent<AudioSource>();
        }

        AudioSource template = audioDic[audioType];
        source.loop = false;
        source.priority = template.priority;
        source.volume = template.volume;
        source.pitch = template.pitch;
        source.panStereo = template.panStereo;
        source.spatialBlend = template.spatialBlend;
        source.reverbZoneMix = template.reverbZoneMix;
        source.dopplerLevel = template.dopplerLevel;
        source.spread = template.spread;
        source.rolloffMode = template.rolloffMode;
        source.minDistance = template.minDistance;
        source.maxDistance = template.maxDistance;

        GG.ResMgr.instance.LoadAudioClipAsync(assetName, (clip) => {
            source.clip = clip;
            source.PlayDelayed(delay);

            TimerMgr.instance.StartTimer(clip.length + delay, () => {
                source.clip = null;
                GG.ResMgr.instance.ReleaseAsset(clip);
            });
        });
        return source;
    }
    public void PlayAudio(string assetName, AudioType audioType, Vector3 pos, float delay = 0, bool loop = false, Action onPlayFinish = null)
    {
        GG.ResMgr.instance.LoadAudioClipAsync(assetName, (clip) => {
            AudioSource source = audioDic[audioType];

            if (audioType == AudioType.BGMusic)
            {
                //cross fade
                source.volume = 1f;
                TimerMgr.instance.RemoveTimer(fadeOutTimer);
                fadeOutTimer = TimerMgr.instance.StartLoopTimer(0.1f, 0.1f, BgMusicFadeOut);
                TimerMgr.instance.StartTimer(0.5f, () => {
                    source.Stop();
                    source.clip = clip;
                    source.Play();
                    source.volume = 0f;
                    fadeInTimer = TimerMgr.instance.StartLoopTimer(0.1f, 0.1f, BgMusicFadeIn);
                });

            }
            else
            {
                source.clip = clip;
                //3d
                if (audioType == AudioType.Battle || audioType == AudioType.Building)
                {
                    source.transform.position = pos;
                    source.PlayOneShot(clip);
                }
                else
                {
                    source.PlayOneShot(clip);
                }

                if (loop == false && onPlayFinish != null)
                {
                    TimerMgr.instance.StartTimer(clip.length, onPlayFinish);
                }
            }

        });
    }

    public void StopAudio(AudioType audioType)
    {
        audioDic[audioType].Stop();
    }

    //0.5
    private void BgMusicFadeIn()
    {
        if (audioDic[AudioType.BGMusic].volume <= 1)
        {
            audioDic[AudioType.BGMusic].volume += 0.1f;
        }
        else
        {
            audioDic[AudioType.BGMusic].volume = 1f;
            TimerMgr.instance.RemoveTimer(fadeInTimer);
        }
    }
    private void BgMusicFadeOut()
    {
        if (audioDic[AudioType.BGMusic].volume > 0)
        {
            audioDic[AudioType.BGMusic].volume -= 0.1f;
        }
        else
        {
            audioDic[AudioType.BGMusic].volume = 0f;
            TimerMgr.instance.RemoveTimer(fadeOutTimer);
        }
    }
}
