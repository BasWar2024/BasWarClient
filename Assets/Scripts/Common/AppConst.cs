using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using XLua;
using UnityEngine.SceneManagement;

[ReflectionUse]
public class Appconst : Singleton<Appconst>
{
    public const string bgMusicVolumeKey = "bgMusicVolumeKey";
    public const string audioVolumeKey = "audioVolumeKey";
    public const string systemVolumeKey = "systemVolumeKey";
    public const string loginAccountKey = "loginAccountKey";

    //
    public const string AppVersion = "1.1.1";
    //
    public const string BattleVersion = "1";
    public string RemoteVersion = "";

    public const string HotFixIP = "http://8.134.94.169/";

#if UNITY_ANDROID
    public const string HotFixAddress = HotFixIP + "clientpack/Android/";
#elif UNITY_IPHONE
    public const string HotFixAddress = HotFixIP + "clientpack/IPhone/";
#endif

    public void ExitGame()
    {
        Application.Quit();
    }
}
