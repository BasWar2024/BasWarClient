using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEditor.UI;
using UnityEngine;
using Object = UnityEngine.Object;


public class NoReferenceWindow : EditorWindow {
    private enum AssetType {
        None,
        Prefab,
        Material,
        Scene,
        Asset,
        Lua,
        Image,
        FBX,
        Controller,
        Animation,
    }

    private class FileInfo {
        public string path;
        public AssetType assetType;
        public Object asset;
    }

    private static string[] ASSET_FILE_ROOT = { "Assets/GameRes/UI", "Assets/Prefabs" , "Assets/Scenes" };
    // ""
    private static string[] FilterDirectory = { "Assets/GameRes/UI/Icon", "Assets/GameRes/RemoteBg", "Assets/GameRes/GameLogo", "Assets/Prefabs/UI/Icon" };

    private Dictionary<string, FileInfo> allFileDic = null;
    // key:luaPath,value:luaContent
    private Dictionary<string, string> luaFileContentDic = null;
    private List<FileInfo> assetDependsList = null;
    // ""
    private Dictionary<AssetType, List<FileInfo>> noReferenceAssetDic = null;
    private Vector2 ve2;
    private bool initComplete = false;
    // "" 
    private List<string> siftPathList = new List<string>();
    // ""
    private Dictionary<AssetType, List<FileInfo>> noReferenceSiftAssetDic = null;

    private bool isAll = true;

    private void Awake() {
        siftPathList.Add("Assets/GameRes");
    }

    // ""
    private void OnGUI() {
        EditorGUILayout.Space();

        if (initComplete == false) {
            return;
        }

        if (noReferenceAssetDic == null) {
            InitAllFileDic();
            return;
        }


        DrawSift();
        ve2 = EditorGUILayout.BeginScrollView(ve2);

        var tmpNoRefernceDic = noReferenceAssetDic;
        if (!isAll) {
            tmpNoRefernceDic = noReferenceSiftAssetDic;
        }

        foreach (var assetType in tmpNoRefernceDic.Keys) {
            List<FileInfo> infos = tmpNoRefernceDic[assetType];
            if (infos.Count == 0) continue;
            EditorGUILayout.LabelField(assetType.ToString(), EditorStyles.boldLabel);
            for (int i = 0; i < infos.Count; i++) {
                CreateNpReferenceItem(infos[i]);
            }

            if (GUILayout.Button("""", GUILayout.Height(30))) {
                DeleteAllAsset(assetType);
            }
            EditorGUILayout.Space();
        }

        EditorGUILayout.EndScrollView();
        EditorGUILayout.Space();
    }

    [MenuItem("Tools/Find no-Ref Assets", false, 10)]
    private static void OpenNoReferenceWindow() {
        NoReferenceWindow window = (NoReferenceWindow)EditorWindow.GetWindow(typeof(NoReferenceWindow), true, """");
        window.InitAllFileDic();
    }

    public void RefreshInfo() {
        InitAssetDependDic();
        InitLuaFileContentDic();
        InitNoReferenceAssetDic();

        initComplete = true;
    }

    private bool IsInFilterDirectory(string assetPath) {
        for (int i = 0; i < FilterDirectory.Length; i++) {
            if (assetPath.Contains(FilterDirectory[i])) {
                return true;
            }
        }
        return false;
    }

    /// <summary>
    /// ""
    /// </summary>
    private void InitAllFileDic() {
        Debug.Log("""");
        long t = System.DateTime.Now.Ticks;

        allFileDic = new Dictionary<string, FileInfo>();
        string[] guids = AssetDatabase.FindAssets("", ASSET_FILE_ROOT);

        for (int i = 0; i < guids.Length; i++) {
            try {
                string path = AssetDatabase.GUIDToAssetPath(guids[i]);

                if (EditorUtility.DisplayCancelableProgressBar($""":({i}/{guids.Length})", path,
                    (float)i / (float)guids.Length)) {
                    EditorUtility.ClearProgressBar();
                    Close();
                    return;
                }

                if (IsInFilterDirectory(path)) continue;

                AssetType assetType = GetAssetTypeByPath(path);
                if (assetType == AssetType.None) continue;
                FileInfo info = new FileInfo();
                info.path = path;
                info.assetType = assetType;
                info.asset = AssetDatabase.LoadAssetAtPath<Object>(path);
                allFileDic.Add(path, info);
            }
            catch {

            }
            
        }

        EditorUtility.ClearProgressBar();
        Debug.Log("""");
        RefreshInfo();

        Debug.Log($"""：{(System.DateTime.Now.Ticks - t) / 10000} """);
    }

    /// <summary>
    /// ""，""
    /// </summary>
    private void InitAssetDependDic() {
        assetDependsList = new List<FileInfo>();
        List<FileInfo> infos = new List<FileInfo>(allFileDic.Values);
        if (infos.Count == 0) return;
        for (int i = 0; i < infos.Count; i++) {
            FileInfo info = infos[i];

            if (info.assetType == AssetType.Lua || info.assetType == AssetType.Image) continue;

            if (EditorUtility.DisplayCancelableProgressBar("""...", $"({i}/{infos.Count})\n path:{info.path}",
                (float)i / (float)infos.Count)) {
                EditorUtility.ClearProgressBar();
                Close();
                return;
            }
            string[] depends = AssetDatabase.GetDependencies(info.path, false);

            for (int j = 0; j < depends.Length; j++) {
                string dependPath = depends[j];

                FileInfo dependInfo = FindFileInfo(dependPath);

                // ""
                if (dependInfo == null || dependInfo == info) continue;
                if (!assetDependsList.Contains(dependInfo)) {
                    assetDependsList.Add(dependInfo);
                }
            }
        }

        Debug.Log("""");
        EditorUtility.ClearProgressBar();
    }

    /// <summary>
    /// ""lua""，""（""lua""，""lua""，""lua""）
    /// </summary>
    private void InitLuaFileContentDic() {
        luaFileContentDic = new Dictionary<string, string>();

        foreach (var info in allFileDic.Values) {
            if (info.assetType == AssetType.Lua) {
                luaFileContentDic.Add(info.path, File.ReadAllText(info.path));
            }
        }
    }

    // ""
    private void InitNoReferenceAssetDic() {
        noReferenceAssetDic = new Dictionary<AssetType, List<FileInfo>>();

        foreach (var info in allFileDic.Values) {
            if (info.assetType == AssetType.Lua) continue;

            // ""（"",lua""）
            // ""
            if (CheckOtherAssetReference(info.path)) continue;
            // ""lua""
            if (CheckLuaReference(info.path)) continue;

            AddNoReferenceAsset(info);
        }

        Debug.Log("""");
    }

    private FileInfo FindFileInfo(string assetPath) {
        if (!allFileDic.ContainsKey(assetPath)) return null;
        return allFileDic[assetPath];
    }

    private void AddNoReferenceAsset(FileInfo info) {
        List<FileInfo> list = null;
        if (!noReferenceAssetDic.TryGetValue(info.assetType, out list)) {
            list = new List<FileInfo>();
            noReferenceAssetDic.Add(info.assetType, list);
        }
        list.Add(info);
    }

    private void RemoveNoReferenceAsset(Dictionary<AssetType, List<FileInfo>> noReferenceAsset, string path) {
        FileInfo info = FindFileInfo(path);
        if (info == null) return;

        List<FileInfo> list = null;
        if (noReferenceAsset.TryGetValue(info.assetType, out list)) {
            list.Remove(info);
        }
    }

    private AssetType GetAssetTypeByPath(string assetPath) {
        string extension = Path.GetExtension(assetPath);
        switch (extension.ToLower()) {
            case ".prefab": return AssetType.Prefab;
            case ".mat": return AssetType.Material;
            case ".unity": return AssetType.Scene;
            case ".asset": return AssetType.Asset;
            case ".lua": return AssetType.Lua;
            case ".png": return AssetType.Image;
            case ".jpg": return AssetType.Image;
            case ".fbx": return AssetType.FBX;
            case ".controller": return AssetType.Controller;
            case ".anim": return AssetType.Animation;
        }
        return AssetType.None;
    }

    /// <summary>
    /// ""
    /// </summary>
    /// <param name="assetPath"></param>
    /// <returns></returns>
    private bool CheckOtherAssetReference(string assetPath) {
        if (string.IsNullOrEmpty(assetPath)) {
            Debug.LogError("CheckOtherAssetReference error: assetPath is null");
            return false;
        }

        FileInfo info = FindFileInfo(assetPath);
        if (info == null) return false;

        if (info.assetType == AssetType.Scene) {
            return EditorSceneManager.GetActiveScene().name.Equals(Path.GetFileNameWithoutExtension(assetPath));
        }

        foreach (var dependInfo in assetDependsList) {
            if (dependInfo == info) {
                return true;
            }
        }
        return false;
    }

    // ""lua""
    private bool CheckLuaReference(string assetPath) {
        string fileName = Path.GetFileNameWithoutExtension(assetPath);

        if (string.IsNullOrEmpty(fileName)) {
            return false;
        }

        foreach (var content in luaFileContentDic.Values) {
            if (Regex.IsMatch(content, fileName + "\"") || Regex.IsMatch(content, fileName + "\'")) {
                return true;
            }
        }

        return false;
    }

    private void DeleteAsset(FileInfo info, bool refresh = false) {
        RemoveDepends(info);
        RemoveNoReferenceAsset(noReferenceAssetDic, info.path);
        if (!isAll && noReferenceSiftAssetDic != null) RemoveNoReferenceAsset(noReferenceSiftAssetDic, info.path);
        allFileDic.Remove(info.path);
        AssetDatabase.DeleteAsset(info.path);
        if (refresh)
            AssetDatabase.Refresh();
    }

    // ""
    private void DeleteAllAsset(AssetType assetType) {
        List<FileInfo> infos = noReferenceAssetDic[assetType];
        for (int i = infos.Count - 1; i >= 0; i--) {
            DeleteAsset(infos[i]);
        }
        AssetDatabase.Refresh();
    }

    // ""
    private void RemoveDepends(FileInfo info) {
        if (assetDependsList.Contains(info)) {
            assetDependsList.Remove(info);
        }
    }

    // ""
    private void RefreshNoReferenceSiltAssetDic() {
        noReferenceSiftAssetDic = new Dictionary<AssetType, List<FileInfo>>();

        foreach (var info in allFileDic.Values) {
            if (info.assetType == AssetType.Lua) continue;

            if (!CheckInSiltDirectory(info.path)) continue;

            // ""（"",lua""）
            // ""
            if (CheckOtherAssetReference(info.path)) continue;
            // ""lua""
            if (CheckLuaReference(info.path)) continue;

            AddNoReferenceSiltAsset(info);
        }
    }

    private bool CheckInSiltDirectory(string assetPath) {
        for (int i = 0; i < siftPathList.Count; i++) {
            string path = siftPathList[i];
            if (string.IsNullOrEmpty(path)) continue;
            if (!Directory.Exists(path)) continue;
            if (Regex.IsMatch(assetPath, path)) {
                return true;
            }
        }

        return false;
    }

    private void AddNoReferenceSiltAsset(FileInfo info) {
        List<FileInfo> list = null;
        if (!noReferenceSiftAssetDic.TryGetValue(info.assetType, out list)) {
            list = new List<FileInfo>();
            noReferenceSiftAssetDic.Add(info.assetType, list);
        }
        list.Add(info);
    }


    #region // ---------------------- "" ------------------------- //
    private void CreateNpReferenceItem(FileInfo info) {
        GUILayout.BeginHorizontal();
        // var obj = AssetDatabase.LoadAssetAtPath<Object>(info.path);
        EditorGUILayout.ObjectField(info.asset, typeof(UnityEngine.Object));
        // string assetName = Path.GetFileNameWithoutExtension(info.path);
        // EditorGUILayout.DelayedTextField(assetName);
        // if (GUILayout.Button("""",GUILayout.Width(70)))
        // {
        //     var obj = AssetDatabase.LoadAssetAtPath<Object>(info.path);
        //     if(obj != null)
        //         EditorGUIUtility.PingObject(obj);
        // }

        if (GUILayout.Button("""", GUILayout.Width(70))) {
            DeleteAsset(info, true);
        }
        GUILayout.EndHorizontal();
    }

    private void DrawSift() {
        EditorGUILayout.LabelField("""", EditorStyles.boldLabel, GUILayout.Height(30));
        for (int i = 0; i < siftPathList.Count; i++) {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Path:", GUILayout.Width(50));
            siftPathList[i] = EditorGUILayout.TextField(siftPathList[i]);
            if (GUILayout.Button("x", GUILayout.Width(20))) {
                siftPathList.RemoveAt(i);
            }
            EditorGUILayout.EndHorizontal();
        }

        if (GUILayout.Button("+", GUILayout.Height(20))) {
            siftPathList.Add(string.Empty);
        }

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("""", GUILayout.Height(40))) {
            string noExistDirectoryStr = "";

            for (int i = 0; i < siftPathList.Count; i++) {
                string path = siftPathList[i];
                if (string.IsNullOrEmpty(path)) continue;
                if (!Directory.Exists(path)) {
                    noExistDirectoryStr = noExistDirectoryStr + path + "\r\n";
                    continue;
                }
            }

            if (noExistDirectoryStr != "") {
                EditorUtility.DisplayDialog("""", """:\r\n" + noExistDirectoryStr, "ok");
            }

            RefreshNoReferenceSiltAssetDic();
            isAll = false;
        }

        if (GUILayout.Button("""", GUILayout.Height(40))) {
            isAll = true;
        }

        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();
        EditorGUILayout.Space();
    }

    #endregion // ---------------------- "" ------------------------- //
}