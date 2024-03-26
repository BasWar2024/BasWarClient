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
    public const string bgMusicMuteKey = "bgMusicMuteKey";
    public const string audioVolumeKey = "audioVolumeKey";
    public const string audioMuteKey = "audioMuteKey";
    public const string systemVolumeKey = "systemVolumeKey";
    public const string loginAccountKey = "loginAccountKey";

    public const string baseDetailStatusKey = "DetailStatus";

    public const string languageKey = "languageKey";
    public const string secretKey = "youyugb";

    //【""】：【""】：【""】：【""】
    //【""】:  1=alpha, 2=beta 3=release 4=local,
    //【""】
    //""：galaxyblitz_androidGB_1.6.4.50        galaxyblitz_iosGB_1.6.4.50
    public const string BattleVersion = "6";
    public const string AppVersion = "1.11.3.1000"; //""r
    public string LocalVersion = "1.11.3.1000"; //""
    public string RemoteVersion = "1.11.3.1000"; //""
    public const string branch = "local";
    //"" local("") androidGB(""android) iosGB(""ios)  androidGooglePlay(""googleplay)  iosAppstore(ios"")
    //androidFB(facebook android) iosFB(facebook ios) androidTT(tiktok android) iosTT(tiktok ios)
    public const string platform = "local"; 
    public const string sdk = "sdk";
    public string loginServerUrl = "http://war.galaxyblitz.space:4000";
    //public string loginServerUrl = "http://www.galaxyblitz.space:4000";//""
    //public string loginServerUrl = "http://beta.galaxyblitz.space:4000";//""beta""
    //public string loginServerUrl = "http://login.alphastar.me:4000";//""alpha""
    //public string loginServerUrl = "http://10.168.1.2:4000";//""（""）
    //public string loginServerUrl = "http://10.168.1.93:4000";//""
    //public string loginServerUrl = "http://10.168.1.97:4000";//jj""
    //public string loginServerUrl = "http://10.168.1.109:4000";//""
    public string loginServerTestUrl = "http://test.galaxyblitz.space:4000";//""

    public string GameVersionUrl = $"http://www.galaxyblitz.org/{branch}/{platform}/{AppVersion}/GameVersion/GameVersion.json";
    public string GameVersionTestUrl = $"http://test.galaxyblitz.org/{branch}/{platform}/{AppVersion}/GameVersion/GameVersion.json";
    public static string RemoteLoadPath = $"http://www.galaxyblitz.org/{branch}/{platform}/{AppVersion}/AA";
    //public string RemoteLoadPath = "http://www.galaxyblitz.org/alpha/androidGB/1.5.1.40/AA";

    public void ExitGame()
    {
        Application.Quit();
    }
}
