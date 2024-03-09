using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using GG;
using SimpleJson;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.Networking;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.UI;
using XLua;

public class Lua : MonoBehaviour {
    static Lua instance;
    public static Lua getInstance() {
        return instance;
    }
    public delegate void SendToServerDelegate(string cmd, LuaTable args);
    public delegate bool DoGmDelegate(string cmdline);
    public delegate void ChangeScene(string oldName, string newName);

    public SendToServerDelegate sendToGameServer;
    public SendToServerDelegate sendToSceneServer;
    public DoGmDelegate doGm;

    public LuaEnv luaEnv = new LuaEnv();

    ManagerLauncher managerLauncher; //C# 
    InputMgr inputMgr; //C# 

    internal static float lastGCTime = 0;
    internal const float GCInterval = 1; //1 second

    private Action luaAwake;
    private Action luaStart;
    private Action luaUpdate;
    private Action luaFixedUpdate;
    private Action luaOnDestroy;
    private Action luaAfterUpdate;

    public GameObject pnlaunch;
    private Text launchText;
    private Slider launchSlider;
    private Text launchTxtProgress;
    private GameObject ExitTheGameImg;
    private Button BtnExit;

    void Awake() {
        instance = this;
        InitPnlLaunch();

        DontDestroyOnLoad(gameObject);

        StartCoroutine(DoUpdateAddressable(() => {

            LuaScriptDic = new Dictionary<string, byte[]>();
            LoadTextAsset("LuaScriptConfig", textAsset => {
                var jsonObj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(textAsset.text);
                var jsonContent = jsonObj.GetJsonObject("Content");
                var keys = new string[jsonContent.Count];
                int index = 0;
                foreach (var item in jsonContent) {
                    keys[index] = item.Key;
                    ++index;
                    // Debug.LogError ("item.Key " + item.Key);
                }
                //lua 
                ResMgr.instance.LoadAssetsAsync<TextAsset>(keys, allLuaCode => {
                    for (int i = 0; i < keys.Length; i++) {
                        LuaScriptDic.Add(keys[i], allLuaCode[i].bytes);
                    }
                    Init();
                });

            });

        }));
        Debug.Log(System.DateTime.Now);
    }
    Dictionary<string, byte[]> LuaScriptDic;

    private IEnumerator DoUpdateAddressable(Callback finish)
    {
        //
        float startTime = Time.realtimeSinceStartup;
        var initHandle = Addressables.InitializeAsync();
        launchText.text = "..";
        Debug.Log("--------InitializeAsync---------!"); 
        yield return initHandle;
        var checkHandle = Addressables.CheckForCatalogUpdates(false);
        // checkHandle.
        launchText.text = "..";
        Debug.Log("===============CheckForCatalogUpdates=============!");
        yield return checkHandle;
        Debug.Log("checkHandle.Result.Count ==== " + checkHandle.Result.Count);

        if (checkHandle.Result.Count > 0)
        {
            var updateHandle = Addressables.UpdateCatalogs(checkHandle.Result, false);
            yield return updateHandle;
            var locators = updateHandle.Result;

            int done = 0;
            foreach (var locator in locators)
            {
                launchText.text = $".. ({done}/{locators.Count})";
                var keys = locator.Keys;
                var sizeHandle = Addressables.GetDownloadSizeAsync(keys);
                yield return sizeHandle;
                long totalDownloadSize = sizeHandle.Result;
                Debug.Log("download size" + totalDownloadSize);
                if (totalDownloadSize > 0)
                {
                    //
                    var downloadHandle = Addressables.DownloadDependenciesAsync(keys, Addressables.MergeMode.Union);
                    while (!downloadHandle.IsDone)
                    {
                        float percentage = downloadHandle.PercentComplete;
                        launchSlider.value = percentage;
                        launchTxtProgress.text = Math.Round(percentage, 2) * 100 + "%";
                        Debug.Log("doing (" + percentage + ")");
                        yield return null;
                    }
                    Debug.Log("Done!");

                    float endTime = Time.realtimeSinceStartup - startTime;

                    //if (finish != null) {
                    //    finish ();
                    //}
                    Addressables.Release(downloadHandle);
                }

                done++;
            }

            //if (finish != null)
            //{
            //    finish();
            //}
            Addressables.Release(updateHandle);
        }
        //else
        //{
        //    ////
        //    //if (finish != null)
        //    //{
        //    //    finish();
        //    //}
        //}

        var gameVerHandle = ResMgr.instance.LoadTextAssetAsync("GameVersion", null);

        while (!gameVerHandle.IsDone)
        {
            yield return gameVerHandle;
        }

        var text = gameVerHandle.Result as TextAsset;
        var jsonObj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(text.text);
        var res = jsonObj.GetString("Res");
        var resVerList = res.Split('.');
        var appVerList = Appconst.AppVersion.Split('.');

        Addressables.Release(checkHandle);

        if (resVerList[0] != appVerList[0] || resVerList[1] != appVerList[1])
        {
            Debug.Log("");
            ExitTheGameImg.SetActive(true);
            yield return 0;
        }
        else
        {
            Appconst.instance.RemoteVersion = res;
            Debug.Log(Appconst.instance.RemoteVersion);
            pnlaunch.SetActive(false);

            if (finish != null)
            {
                finish();
            }
        }
    }

    private void InitPnlLaunch()
    {
        launchText = pnlaunch.transform.Find("Text").GetComponent<Text>();
        launchSlider = pnlaunch.transform.Find("SliderProgress").GetComponent<Slider>();
        launchTxtProgress = pnlaunch.transform.Find("SliderProgress/TxtProgress").GetComponent<Text>();
        ExitTheGameImg = pnlaunch.transform.Find("ExitTheGameImg").gameObject;
        BtnExit = ExitTheGameImg.transform.Find("BtnExit").GetComponent<Button>();
        launchSlider.value = 0;
        ExitTheGameImg.SetActive(false);

        BtnExit.onClick.AddListener(() => { Appconst.instance.ExitGame(); });
    }

    void Init () {
        luaEnv.AddBuildin ("crypt.core", XLua.LuaDLL.Lua.LoadCryptCore);
        luaEnv.AddBuildin ("cjson", XLua.LuaDLL.Lua.LoadCjson);
        luaEnv.AddBuildin ("sproto.core", XLua.LuaDLL.Lua.LoadSprotoCore);
        luaEnv.AddBuildin ("pb", XLua.LuaDLL.Lua.LoadPb);
        luaEnv.AddBuildin ("lkcp", XLua.LuaDLL.Lua.LoadLkcp);
        // luaEnv.AddBuildin ("ffi", XLua.LuaDLL.Lua.LoadFfi);
        luaEnv.AddBuildin ("lpeg", XLua.LuaDLL.Lua.LoadLpeg);
        luaEnv.AddBuildin ("timer.core", XLua.LuaDLL.Lua.LoadTimerCore);
        // luaEnv.AddBuildin ("lfs", XLua.LuaDLL.Lua.LoadLfs);
        luaEnv.AddBuildin ("map.core", XLua.LuaDLL.Lua.LoadMapCore);
        luaEnv.AddBuildin ("i18n.core", XLua.LuaDLL.Lua.LoadI18nCore);
        luaEnv.AddBuildin ("traceback", XLua.LuaDLL.Lua.LoadTraceback);
        luaEnv.AddBuildin ("random", XLua.LuaDLL.Lua.LoadRandom);
        luaEnv.AddBuildin ("lutil", XLua.LuaDLL.Lua.LoadLutil);

        luaEnv.AddLoader (this.CustomLoader);
        Debug.Log (string.Format ("Application.dataPath={0}", Application.dataPath));
        luaEnv.DoString (@"require('main')");

        luaAwake = luaEnv.Global.Get<Action> ("Awake");
        luaStart = luaEnv.Global.Get<Action> ("Start");
        luaUpdate = luaEnv.Global.Get<Action> ("Update");
        luaFixedUpdate = luaEnv.Global.Get<Action> ("FixedUpdate");
        luaOnDestroy = luaEnv.Global.Get<Action> ("OnDestroy");
        luaAfterUpdate = luaEnv.Global.Get<Action> ("AfterUpdate");
        sendToGameServer = luaEnv.Global.Get<SendToServerDelegate> ("sendToGameServer");
        sendToSceneServer = luaEnv.Global.Get<SendToServerDelegate> ("sendToSceneServer");
        doGm = luaEnv.Global.Get<DoGmDelegate> ("doGm");

        managerLauncher = new ManagerLauncher ();
        InputMgr.instance.Init();
        
        if (luaAwake != null) {
            luaAwake ();
        }

        if (luaStart != null) {
            luaStart ();
        }
        // TODO: check updater
        this.AfterUpdate ();
    }

    void Start () { }

    // Update is called once per frame
    void Update () {
        if (luaUpdate != null) {
            luaUpdate ();
        }
        if (Time.time - Lua.lastGCTime > GCInterval) {
            luaEnv.Tick ();
            Lua.lastGCTime = Time.time;
        }
    }

    void FixedUpdate () {
        if (luaFixedUpdate != null) {
            luaFixedUpdate ();
        }
    }

    void OnDestroy () {
        if (luaOnDestroy != null) {
            luaOnDestroy ();
        }
        luaOnDestroy = null;
        luaUpdate = null;
        luaFixedUpdate = null;
        luaStart = null;
    }

    /// <summary>
    /// 
    /// </summary>
    private void AfterUpdate () {
        if (luaAfterUpdate != null) {
            luaAfterUpdate ();
        }
    }

    private byte[] CustomLoader (ref string filePath) {
        //lua 
#if UNITY_EDITOR
        filePath = filePath.Replace (".", "/") + ".lua";
        string luaPath = Application.dataPath + "/Lua/" + filePath;
        string luaCode = File.ReadAllText (luaPath);
        return System.Text.Encoding.UTF8.GetBytes (luaCode);
#else
        filePath = "Assets/Lua/" + filePath.Replace (".", "/") + ".lua";
        if (LuaScriptDic.ContainsKey (filePath)) {
            var luaCode = LuaScriptDic[filePath];
            return luaCode;
        } else {
            Debug.LogError ("lua " + filePath);
            return null;
        }
#endif

    }

    //ID
    public static string GetDeviceUniqueIdentifier () {
        return SystemInfo.deviceUniqueIdentifier;
    }
    private IEnumerator LoadLuaCode (string[] keys, Callback<IList<TextAsset>> onLoaded) {

        var handle = Addressables.LoadAssetsAsync<TextAsset> (keys, null);
        while (!handle.IsDone) {
            yield return handle;
        }
        if (onLoaded != null && handle.Status == AsyncOperationStatus.Succeeded) {
            onLoaded (handle.Result);
        }
        ResMgr.instance.ReleaseAsset (handle);
    }

    public void LoadTextAsset (string assetName, Callback<TextAsset> onLoaded) {
        StartCoroutine (CoLoadTextAsset (assetName, onLoaded));
    }

    private IEnumerator CoLoadTextAsset (string assetName, Callback<TextAsset> onLoaded) {
        AsyncOperationHandle handle = ResMgr.instance.LoadTextAssetAsync (assetName, null);
        while (!handle.IsDone) {
            yield return handle;
        }
        if (onLoaded != null && handle.Status == AsyncOperationStatus.Succeeded) {
            onLoaded (handle.Result as TextAsset);
        }
        ResMgr.instance.ReleaseAsset (handle);
    }
}