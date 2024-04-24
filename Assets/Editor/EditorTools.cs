
# if UNITY_EDITOR
using Spine.Unity;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Xml;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.U2D;
using UnityEditor.Sprites;
using UnityEditor.U2D;
using System.Text;

public class EditorTools {
    public static string[] GetAllFile(List<string> matchList) {
        var extensions = matchList;
        var files = Directory.GetFiles(Application.dataPath, "*.*", SearchOption.AllDirectories).
            Where(s => extensions.Contains(Path.GetExtension(s)?.ToLower())).ToArray();
        return files;
    }

    static FileInfo[] SearchSelectDirectory(string extension) {
        // "" ""、"" GUID
        string[] guids = Selection.assetGUIDs;
        List<FileInfo> files = new List<FileInfo>();
        foreach (var guid in guids) {
            string assetPath = AssetDatabase.GUIDToAssetPath(guid);
            if (Directory.Exists(assetPath)) {
                FileInfo[] fileInfos = SearchDirectory(assetPath, extension);
                foreach (FileInfo fileInfo in fileInfos) {
                    files.Add(fileInfo);
                }
            }
            else {
                Regex regex = new Regex("@" + extension);
                if (regex.IsMatch(assetPath)) {
                    files.Add(new FileInfo(assetPath));
                }
            }
        }
        return files.ToArray();
    }

    static FileInfo[] SearchDirectory(string directory, string extension) {
        DirectoryInfo dInfo = new DirectoryInfo(directory);
        // "" ""  extension ""
        FileInfo[] fileInfoArr = dInfo.GetFiles(extension, SearchOption.AllDirectories);
        return fileInfoArr;
    }

    static string GetAssetPath(string fullPath) {
        Regex regex = new Regex(@"Assets.*");
        string path = regex.Match(fullPath).Value;
        path = path.Replace("\\", "/");
        return path;
    }

    //----------------------------------------------------------------------------------------------------------------------------------
    //[MenuItem("ReplaceTool/""Text")]
    public static void ReplaceAllText() {
        string[] files = GetAllFile(new List<string>() { ".prefab" });
        for (int i = 0; i < files.Length; i++) {
            string path = GetAssetPath(files[i]);
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            EditorUtility.DisplayProgressBar(obj.name, "replace text", (float)i / files.Length);
            ReplaceText(obj);
        }
        EditorUtility.ClearProgressBar();
    }

    [MenuItem("EditorTools/""text")]
    static void ReplaceSelectText() {
        FileInfo[] fileInfos = SearchSelectDirectory("*.prefab");
        for (int i = 0; i < fileInfos.Length; i++) {
            FileInfo fileInfo = fileInfos[i];
            Debug.Log(fileInfo.Name);
            string path = GetAssetPath(fileInfo.FullName);

            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            EditorUtility.DisplayProgressBar(obj.name, "replace text", (float)i / fileInfos.Length);

            ReplaceText(obj);
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        EditorUtility.ClearProgressBar();
    }

    public static void ReplaceText(GameObject go) {
        if (!go.TryGetComponent<TextYouYU>(out TextYouYU textYouYU) && go.TryGetComponent<Text>(out Text text)) {
            try {
                GameObject.DestroyImmediate(text, true);
                TextYouYU textYouYu = go.AddComponent<TextYouYU>();
                textYouYu.material = text.material;
                textYouYu.color = text.color;
                textYouYu.text = text.text;
                textYouYu.raycastTarget = text.raycastTarget;
                textYouYu.maskable = text.maskable;
                textYouYu.font = text.font;
                textYouYu.fontStyle = text.fontStyle;
                textYouYu.fontSize = text.fontSize;
                textYouYu.lineSpacing = text.lineSpacing;
                textYouYu.alignment = text.alignment;
                textYouYu.horizontalOverflow = text.horizontalOverflow;
                textYouYu.verticalOverflow = text.verticalOverflow;
                textYouYu.alignByGeometry = text.alignByGeometry;
                textYouYu.resizeTextForBestFit = text.resizeTextForBestFit;
            }
            catch {
                Debug.Log($"catch    {go.name}");
            }
        }

        foreach (Transform item in go.transform) {
            ReplaceText(item.gameObject);
        }
    }
    //----------------------------------------------------------------------------------------------------------------------------------
    [MenuItem("EditorTools/""TweenObjectsMove")]
    public static void OptimizeTweenObjectMove() {
        string[] files = GetAllFile(new List<string>() { ".prefab" });
        for (int i = 0; i < files.Length; i++) {
            string path = GetAssetPath(files[i]);
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);

            if (obj.TryGetComponent<TweenObjectsMove>(out TweenObjectsMove comp)) {
                if (comp.isTest) {
                    comp.isTest = false;
                    Debug.Log(obj.name);
                    PrefabUtility.SavePrefabAsset(obj);
                    EditorUtility.DisplayProgressBar(obj.name, """TweenObjectsMove", (float)i / files.Length);
                }
            }
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        EditorUtility.ClearProgressBar();
    }

    //----------------------------------------------------------------------------------------------------------------------------------
    [MenuItem("EditorTools/""Role2d")]
    public static void CheckRole2d() {
        var files = Directory.GetFiles(Application.dataPath + "/Prefabs/Role2D", "*.*", SearchOption.AllDirectories).
            Where(s => new List<string>() { ".prefab" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();


        for (int i = 0; i < files.Length; i++) {
            var file = files[i];
            string path = GetAssetPath(file);
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            EditorUtility.DisplayProgressBar(obj.name, "CheckBuilding2d", (float)i / files.Length);

            CheckHpStar(obj);
            CheckSpine(obj);
            CheckSpineAnim(obj, "birth");
            CheckSpineLayer(obj, 14);
        }
        EditorUtility.ClearProgressBar();
    }

    [MenuItem("EditorTools/""Building2d")]
    public static void CheckBuilding2d() {
        var files = Directory.GetFiles(Application.dataPath + "/Prefabs/Building2D", "*.*", SearchOption.AllDirectories).
            Where(s => new List<string>() { ".prefab" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();

        for (int i = 0; i < files.Length; i++) {
            var file = files[i];
            string path = GetAssetPath(file);
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);

            EditorUtility.DisplayProgressBar(obj.name, "CheckBuilding2d", (float)i / files.Length);
            CheckHpStar(obj);
            CheckSpine(obj);
            CheckSpineLayer(obj, 14);
            CheckOperPoint(obj);
        }
        EditorUtility.ClearProgressBar();
    }

    [MenuItem("EditorTools/""Effect")]
    public static void CheckEffect() {
        var files = Directory.GetFiles(Application.dataPath + "/Prefabs/Effect", "*.*", SearchOption.AllDirectories).
            Where(s => new List<string>() { ".prefab" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();

        for (int i = 0; i < files.Length; i++) {
            var file = files[i];
            string path = GetAssetPath(file);
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);

            EditorUtility.DisplayProgressBar(obj.name, "CheckEffect", (float)i / files.Length);
            CheckEffSpine(obj);
        }

        //AssetDatabase.SaveAssets();
        //AssetDatabase.Refresh();
        EditorUtility.ClearProgressBar();
    }

    public static void CheckEffSpine(GameObject obj) {
        Transform spine = obj.transform.Find("Spine");

        if (spine == null) {
            Debug.Log($"{obj.name}  ""spine");
            return;
        }

        SkeletonAnimation skeletonAnimation = spine.GetComponent<SkeletonAnimation>();

        if (skeletonAnimation == null) {
            Debug.Log($"{obj.name}  ""skeletonAnimation");
            return;
        }

        if (skeletonAnimation.AnimationName == "") {
            Debug.Log($"{obj.name}  """);

        }

        if (!skeletonAnimation.loop) {
            Debug.Log($"{obj.name}  loop == false");
            //Debug.Log($"gggggggggggggggggggggggg {obj.name}");
            //skeletonAnimation.loop = true;
            //AssetDatabase.SaveAssets();
            //AssetDatabase.Refresh();
        }
    }

    public static void CheckHpStar(GameObject obj) {
        Transform hp = obj.transform.Find("Hp");
        if (hp == null) {
            Debug.Log($"{obj.name}  ""hp");
            return;
        }
        if (hp.Find("Star") == null) {
            Debug.Log($"{obj.name}  ""star");
            return;
        }
    }

    public static void CheckSpineLayer(GameObject obj, int layer) {
        if (obj.layer != layer) {
            Debug.Log($"{obj.name}  layer""{layer}");
            return;
        }

        //Transform spine = obj.transform.Find("Spine");
        //if (spine == null)
        //{
        //    Debug.Log($"{obj.name}  ""spine");
        //    return;
        //}
        //SkeletonAnimation skeletonAnimation = spine.GetComponent<SkeletonAnimation>();
        //skeletonAnimation.sor
    }

    public static void CheckOperPoint(GameObject obj) {
        if (!obj.transform.Find("OperPoint")) {
            Debug.Log($"{obj.name}  ""OperPoint");
        }
    }

    public static void CheckSpine(GameObject obj) {
        Transform spine = obj.transform.Find("Spine");

        if (spine == null) {
            Debug.Log($"{obj.name}  ""spine");

            CheckTankSpine(obj, (body, gun) => {
                CheckSpine(body);
                CheckSpine(gun);
            });
            return;
        }

        if (spine.localRotation.eulerAngles != new Vector3(45, 45, 0)) {
            Debug.Log($"{obj.name}  """);
        }

        MeshRenderer mr = spine.GetComponent<MeshRenderer>();
        foreach (var mrrs in mr.sharedMaterials) {

            if (mrrs == null) {
                Debug.Log($"{obj.name}  mrrs = null");

            }

            else if (mrrs.shader == null) {
                Debug.Log($"{obj.name}  mrrs.shader = null");

            }

            else {
                if (mrrs.shader.name != "Universal Render Pipeline/Spine/Skeleton") {
                    Debug.Log($"{obj.name}  mrrs.shader.name""");
                }

                if (!mrrs.enableInstancing) {
                    Debug.Log($"{obj.name}  GPU instancing """);
                }
            }
        }
    }

    public static void CheckSpineAnim(GameObject obj, string animName) {
        Transform spine = obj.transform.Find("Spine");
        if (spine == null) {
            Debug.Log($"{obj.name}  CheckSpineAnim""spine");
            CheckTankSpine(obj, (body, gun) => {
                CheckSpineAnim(body, animName);
                CheckSpineAnim(gun, animName);
            });
            return;
        }
        var SpineAnim = spine.GetComponent<SkeletonAnimation>();

        if (SpineAnim.AnimationName != animName) {
            Debug.Log($"{obj.name}  ""AnimationName");
        }
    }

    public static void CheckTankSpine(GameObject obj, Action<GameObject, GameObject> callback) {
        Debug.Log($"{obj.name}  """);
        Transform body = obj.transform.Find("Body");
        Transform gun = obj.transform.Find("Gun");

        if (body == null || gun == null) {
            Debug.Log($"{obj.name}  """);
            return;
        }
        callback(body.gameObject, gun.gameObject);
    }

    //--------------------------------
    [MenuItem("EditorTools/""")]
    public static void CheckPicture() {
        string[] files = GetAllFile(new List<string>() { ".dds" });

        Debug.Log($""" {files.Length} """);

        foreach (string file in files) {
            Debug.Log(file);
        }
    }

    enum PlatformType {
        All,
        Android,
        iPhone,
        DefaultTexturePlatform,
    }

    //--------------------------------
    [MenuItem("EditorTools/""IOS""")]
    public static void OptimizeIOSPng() {
        var files = Directory.GetFiles(Application.dataPath + "/GameRes/Building2D", "*.*", SearchOption.AllDirectories).
             Where(s => new List<string>() { ".png" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();
        ForeachFiles(files, TextureImporterFormat.ETC2_RGBA8);

        var files1 = Directory.GetFiles(Application.dataPath + "/GameRes/Role2D", "*.*", SearchOption.AllDirectories).
            Where(s => new List<string>() { ".png" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();
        ForeachFiles(files1, TextureImporterFormat.ETC2_RGBA8);

        var files2 = Directory.GetFiles(Application.dataPath + "/GameRes/BuildingOther2D", "*.*", SearchOption.AllDirectories).
             Where(s => new List<string>() { ".png" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();
        ForeachFiles(files2, TextureImporterFormat.ETC2_RGBA8);
    }

    static void ForeachFiles(string[] files, TextureImporterFormat textureImporterFormat)
    {
        int i = 0;
        foreach (var file in files)
        {
            i++;
            SetPngPlatform(PlatformType.iPhone, textureImporterFormat, file, i, files.Length);
        }

        EditorUtility.ClearProgressBar();
    }



    static void SetPngPlatform(PlatformType platformType, TextureImporterFormat textureImporterFormat, string file, int i, int length)
    {
        var path = GetAssetPath(file);
        EditorUtility.DisplayProgressBar("""png""", path, i / length);
        TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
        TextureImporterPlatformSettings setting = textureImporter.GetPlatformTextureSettings(platformType.ToString());
        setting.overridden = true;
        setting.format = textureImporterFormat;
        textureImporter.SetPlatformTextureSettings(setting);
        AssetDatabase.ImportAsset(path);
    }

    //--------------------------------
    [MenuItem("EditorTools/""")]
    public static void OptimizeIOSAtlas()
    {
        var files1 = Directory.GetFiles(Application.dataPath + "/GameRes/UI/Atlas", "*.*", SearchOption.AllDirectories).
             Where(s => new List<string>() { ".spriteatlas" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();
        ForeachAtlasFiles(files1, TextureImporterFormat.PVRTC_RGBA4);
        var files2 = Directory.GetFiles(Application.dataPath + "/Prefabs/UI/Atlas", "*.*", SearchOption.AllDirectories).
             Where(s => new List<string>() { ".spriteatlas" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();
        ForeachAtlasFiles(files2, TextureImporterFormat.PVRTC_RGBA4);
    }

    static void ForeachAtlasFiles(string[] files, TextureImporterFormat textureImporterFormat)
    {
        int i = 0;
        foreach (var file in files)
        {
            i++;
            SetAtlasPlatform(PlatformType.iPhone, textureImporterFormat, file, i, files.Length);
        }
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        EditorUtility.ClearProgressBar();
    }



    static void SetAtlasPlatform(PlatformType platformType, TextureImporterFormat textureImporterFormat, string file, int i, int length)
    {
        var path = GetAssetPath(file);
        EditorUtility.DisplayProgressBar("""png""", path, i / length);
        /*
        AssetImporter assetImporter = AssetImporter.GetAtPath(path);      
        TextureImporterPlatformSettings setting = textureImporter.GetPlatformTextureSettings(platformType.ToString());
        setting.overridden = true;
        setting.format = textureImporterFormat;
        textureImporter.SetPlatformTextureSettings(setting);
        */
        SpriteAtlas atlas = AssetDatabase.LoadAssetAtPath(path, typeof(object)) as SpriteAtlas;
        TextureImporterPlatformSettings setting = atlas.GetPlatformSettings(platformType.ToString());
        setting.overridden = true;
        setting.format = textureImporterFormat;
        atlas.SetPlatformSettings(setting);
        AssetDatabase.ImportAsset(path);
    }


    ////[MenuItem("Assets/""png""")]
    ////[MenuItem("EditTool/""png""")]
    //static void UpdatePngAndroidPlatform()
    //{
    //    UpdatePngPlatform(PlatformType.Android, "*.png", TextureImporterFormat.ETC2_RGBA8);
    //}

    ////[MenuItem("Assets/""png""iphone""")]
    ////[MenuItem("EditTool/""png""")]
    //static void UpdatePngIphonePlatform()
    //{
    //    UpdatePngPlatform(PlatformType.iphone, "*.png", TextureImporterFormat.PVRTC_RGBA4);
    //}

    ////[MenuItem("Assets/""jpg""")]
    //static void UpdateJPGPlatform()
    //{
    //    UpdatePngPlatform(PlatformType.Android, "*.jpg", TextureImporterFormat.RGB16);
    //}

    //static void UpdatePngPlatform(PlatformType platformType, string extension, TextureImporterFormat textureImporterFormat) {
    //    FileInfo[] fileInfos = SearchSelectDirectory(extension);
    //    for (int i = 0; i < fileInfos.Length; i++) {
    //        FileInfo info = fileInfos[i];
    //        string path = GetAssetPath(info.FullName);
    //        //Texture2D texture2d = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
    //        TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
    //        EditorUtility.DisplayProgressBar($"""png""{platformType.ToString()}""", info.Name, (float)i / fileInfos.Length);
    //        TextureImporterPlatformSettings setting = textureImporter.GetPlatformTextureSettings(platformType.ToString());
    //        setting.overridden = true;
    //        setting.format = textureImporterFormat;
    //        textureImporter.SetPlatformTextureSettings(setting);
    //        AssetDatabase.ImportAsset(path);
    //    }
    //    EditorUtility.ClearProgressBar();
    //}


    //-------------------------------------------------------------------------------------------
    [MenuItem("EditorTools/""")]
    static void UpdatePngPlatform()
    {
        var files = GetAllFile(new List<string>() { ".spriteatlas" });

        for (int i = 0; i < files.Length; i++)
        {
            string path = GetAssetPath(files[i]);
            EditorUtility.DisplayProgressBar($"""atlas""{PlatformType.All.ToString()}""", path, (float)i / files.Length);
            SpriteAtlas atlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(path);


            Debug.Log(path);


            TextureImporterPlatformSettings iPhonePlatformSetting = atlas.GetPlatformSettings(PlatformType.iPhone.ToString());
            iPhonePlatformSetting.overridden = false;
            atlas.SetPlatformSettings(iPhonePlatformSetting);

            TextureImporterPlatformSettings androidPlatformSetting = atlas.GetPlatformSettings(PlatformType.Android.ToString());
            androidPlatformSetting.overridden = false;
            atlas.SetPlatformSettings(androidPlatformSetting);


            TextureImporterPlatformSettings defaultPlatformSetting = atlas.GetPlatformSettings(PlatformType.DefaultTexturePlatform.ToString());
            defaultPlatformSetting.crunchedCompression = true;
            defaultPlatformSetting.compressionQuality = 50;
            atlas.SetPlatformSettings(defaultPlatformSetting);

            AssetDatabase.ImportAsset(path);
        }
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        EditorUtility.ClearProgressBar();

    }

    //-------------------------------------------------------------------------

    class TextureUseInfo {
        public List<string> refrenceNames;
        public TextureUseInfo() {
            refrenceNames = new List<string>();
        }
    }

    static T[] GetComponentsInChildren<T>(GameObject go, List<T> list = null) {
        if (list == null) {
            list = new List<T>();
        }

        T comp = go.GetComponent<T>();

        if (comp != null) {
            list.Add(comp);
        }

        foreach (Transform item in go.transform)
        {
            GetComponentsInChildren(item.gameObject, list);
        }

        return list.ToArray();
    }

    [MenuItem("Assets/""")]
    static void FindTextureRefrence()
    {
        List<GameObject> gameObjectList = new List<GameObject>();
        string[] files = GetAllFile(new List<string>() { ".prefab" });
        for (int i = 0; i < files.Length; i++)
        {
            string path = GetAssetPath(files[i]);
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            gameObjectList.Add(obj);
        }

        //string[] endStr = 

        List<FileInfo> fileInfos = new List<FileInfo>();

        foreach (var item in SearchSelectDirectory("*.png"))
        {
            fileInfos.Add(item);
        }

        foreach (var item in SearchSelectDirectory("*.jpg"))
        {
            fileInfos.Add(item);
        }

        foreach (var item in SearchSelectDirectory("*.tga"))
        {
            fileInfos.Add(item);
        }

        Dictionary<string, TextureUseInfo> dictRefrence = new Dictionary<string, TextureUseInfo>();

        List<string> textureAssetPathList = new List<string>();
        for (int i = 0; i < fileInfos.Count; i++)
        {

            FileInfo fileInfo = fileInfos[i];
            string path = GetAssetPath(fileInfo.FullName);
            TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
            string textureAssetPath = AssetDatabase.GetAssetPath(textureImporter);
            textureAssetPathList.Add(textureAssetPath);

            dictRefrence.Add(textureAssetPath, new TextureUseInfo());
        }



        for (int j = 0; j < gameObjectList.Count; j++)
        {
            GameObject go = gameObjectList[j];
            string refPath = AssetDatabase.GetAssetPath(go);

            if (go == null) {
                continue;
            }

            EditorUtility.DisplayProgressBar($"""{go.name}""", refPath, (float)j / files.Length);

            //Image[] images = go.GetComponentsInChildren<Image>();
            Image[] images = GetComponentsInChildren<Image>(go);

            
            foreach (Image image in images)
            {
                if (image.mainTexture != null)
                {
                    string assetPath = AssetDatabase.GetAssetPath(image.mainTexture);

                    foreach (var item in textureAssetPathList)
                    {
                        if (item == assetPath) {
                            if (!dictRefrence[item].refrenceNames.Exists((prefabName) => prefabName == refPath))
                            {
                                dictRefrence[item].refrenceNames.Add(refPath);

                            }
                            //Debug.Log($"{item} "" {goPath} """);
                        }
                    }
                }
            }

            MeshRenderer[] MeshRenderers =  GetComponentsInChildren<MeshRenderer>(go);

            if (MeshRenderers.Length > 0)
            {
                foreach (MeshRenderer mesh in MeshRenderers)
                {
                    if (mesh != null && mesh.sharedMaterials.Length > 0)
                    {
                        foreach (var mat in mesh.sharedMaterials)
                        {
                            List<string> targetAssetPathList = new List<string>();
                            //Debug.Log(AssetDatabase.GetAssetPath(go));

                            //if (mat != null && mat.mainTexture != null)
                            //{
                            //    targetAssetPathList.Add(AssetDatabase.GetAssetPath(mat.mainTexture));
                            //}

                            //try
                            //{
                            //    //mat.texture
                            //    if (mat != null && mat.mainTexture != null)
                            //    {
                            //        targetAssetPathList.Add(AssetDatabase.GetAssetPath(mat.mainTexture));
                            //    }
                            //}
                            //catch(InvalidCastException e)
                            //{
                            //    Debug.LogWarning($"MeshRenderers warning { AssetDatabase.GetAssetPath(go) }");
                            //}



                            if (mat != null && mat.GetTexture("_MainTex") != null)
                            {
                                targetAssetPathList.Add(AssetDatabase.GetAssetPath(mat.GetTexture("_MainTex")));
                            }

                            foreach (var item in textureAssetPathList)
                            {
                                //Debug.Log("qqqqqqqqqqqqqqqqqqqqqqqqqqq");
                                //Debug.Log($"aaaaaaaaaaaaaaaa  {AssetDatabase.GetAssetPath(mat.GetTexture("_MainTex"))}  {refPath}  {item}  {item = }");
                                foreach (string assetPath in targetAssetPathList)
                                {
                                    //Debug.Log($"aaaaaaaaaaaaaaaa  {assetPath}  {item}  {item == assetPath}");

                                    if (item == assetPath)
                                    {
                                        if (!dictRefrence[item].refrenceNames.Exists((path) => path == refPath))
                                        {
                                            dictRefrence[item].refrenceNames.Add(refPath);
                                        }
                                        //Debug.Log($"{item} "" {refPath} """);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        foreach (var item in dictRefrence)
        {
            Debug.Log($"{ item.Key } ------------------------------------");

            if (item.Value.refrenceNames.Count > 0)
            {
                Dictionary<string, List<string>> refrenceDirMap = new Dictionary<string, List<string>>();

                foreach (var item2 in item.Value.refrenceNames)
                {
                    string[] split = item2.Split('/');
                    string prefabName = split[split.Length - 1];

                    string dirName = Regex.Split(item2, prefabName)[0];

                    if (!refrenceDirMap.ContainsKey(dirName)) {
                        refrenceDirMap.Add(dirName, new List<string>());
                    }
                    refrenceDirMap[dirName].Add(item2);

                    //Debug.Log($"{item2}");
                }

                if (refrenceDirMap.Count > 1) {
                    Debug.Log("""prefab====================================");
                }

                foreach (var kv in refrenceDirMap)
                {
                    Debug.Log($"""：{kv.Key}");
                    foreach (var item3 in kv.Value)
                    {
                        Debug.Log($"    {item3}");
                    }
                }
            }
            else {
                Debug.Log($"""");
            }
        }

        EditorUtility.ClearProgressBar();
    }

    //struct matInfo

        [MenuItem("Assets/""")]
    static void FindTextureRefrenceInMat() {

        List<Material> matList = new List<Material>();
        string[] files = GetAllFile(new List<string>() { ".mat" });
        for (int i = 0; i < files.Length; i++)
        {
            string path = GetAssetPath(files[i]);
            Material mat = AssetDatabase.LoadAssetAtPath<Material>(path);

            matList.Add(mat);
        }

        List<FileInfo> fileInfos = new List<FileInfo>();

        foreach (var item in SearchSelectDirectory("*.png"))
        {
            fileInfos.Add(item);
        }

        foreach (var item in SearchSelectDirectory("*.jpg"))
        {
            fileInfos.Add(item);
        }
        foreach (var item in SearchSelectDirectory("*.tga"))
        {
            fileInfos.Add(item);
        }
        
        Dictionary<string, TextureUseInfo> dictRefrence = new Dictionary<string, TextureUseInfo>();

        List<string> textureAssetPathList = new List<string>();
        for (int i = 0; i < fileInfos.Count; i++)
        {

            FileInfo fileInfo = fileInfos[i];
            string path = GetAssetPath(fileInfo.FullName);
            TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
            string textureAssetPath = AssetDatabase.GetAssetPath(textureImporter);
            textureAssetPathList.Add(textureAssetPath);

            dictRefrence.Add(textureAssetPath, new TextureUseInfo());
        }

        for (int j = 0; j < matList.Count; j++)
        {
            Material mat = matList[j];
            string refPath = AssetDatabase.GetAssetPath(mat);

            EditorUtility.DisplayProgressBar($"""{mat.name}""", refPath, (float)j / files.Length);

            List<string> targetAssetPathList = new List<string>();

            if (mat.mainTexture != null) {
                targetAssetPathList.Add(AssetDatabase.GetAssetPath(mat.mainTexture));
            }

            if (mat.GetTexture("_MainTex") != null)
            {
                //Debug.Log($"pppppppppppppppppppp  {AssetDatabase.GetAssetPath(mat.GetTexture("_MainTex"))}  {refPath}");

                targetAssetPathList.Add(AssetDatabase.GetAssetPath(mat.GetTexture("_MainTex")));
            }

            foreach (var item in textureAssetPathList)
            {
                //Debug.Log("qqqqqqqqqqqqqqqqqqqqqqqqqqq");

                //Debug.Log($"aaaaaaaaaaaaaaaa  {AssetDatabase.GetAssetPath(mat.GetTexture("_MainTex"))}  {refPath}  {item}  {item = }");
                foreach (string assetPath in targetAssetPathList)
                {
                    //Debug.Log($"aaaaaaaaaaaaaaaa  {assetPath}  {item}  {item == assetPath}");

                    if (item == assetPath)
                    {
                        if (!dictRefrence[item].refrenceNames.Exists((path) => path == refPath))
                        {
                            dictRefrence[item].refrenceNames.Add(refPath);
                        }
                        //Debug.Log($"{item} "" {refPath} """);
                    }
                }
            }
        }

        foreach (var item in dictRefrence)
        {
            Debug.Log($"{ item.Key } ------------------------------------");

            if (item.Value.refrenceNames.Count > 0)
            {
                Dictionary<string, List<string>> refrenceDirMap = new Dictionary<string, List<string>>();

                foreach (var item2 in item.Value.refrenceNames)
                {
                    string[] split = item2.Split('/');
                    string prefabName = split[split.Length - 1];

                    string dirName = Regex.Split(item2, prefabName)[0];

                    if (!refrenceDirMap.ContainsKey(dirName))
                    {
                        refrenceDirMap.Add(dirName, new List<string>());
                    }
                    refrenceDirMap[dirName].Add(item2);
                }

                //if (refrenceDirMap.Count > 1)
                //{
                //    Debug.Log("""====================================");
                //}

                foreach (var kv in refrenceDirMap)
                {
                    //Debug.Log($"""：{kv.Key}");
                    foreach (var item3 in kv.Value)
                    {
                        Debug.Log($"    {item3}");
                    }
                }
            }
            else
            {
                Debug.Log($"""");
            }
        }

        EditorUtility.ClearProgressBar();
    }

    [MenuItem("Assets/""")]
    static void FindMatRefrenceInPrefab()
    {
        List<GameObject> gameObjectList = new List<GameObject>();
        string[] files = GetAllFile(new List<string>() { ".prefab" });
        for (int i = 0; i < files.Length; i++)
        {
            string path = GetAssetPath(files[i]);
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            gameObjectList.Add(obj);
        }

        Dictionary<string, TextureUseInfo> dictRefrence = new Dictionary<string, TextureUseInfo>();
        foreach (var item in SearchSelectDirectory("*.mat"))
        {
            string path = GetAssetPath(item.FullName);

            Material mat = AssetDatabase.LoadAssetAtPath<Material>(path);
            string matPath = AssetDatabase.GetAssetPath(mat);
            dictRefrence.Add(matPath, new TextureUseInfo());
        }

        for (int i = 0; i < gameObjectList.Count; i++)
        {
            GameObject item = gameObjectList[i];

            string objPath = AssetDatabase.GetAssetPath(item);

            EditorUtility.DisplayProgressBar($"""{item.name}""", objPath, (float)i / files.Length);


            Renderer[] renderArr = GetComponentsInChildren<Renderer>(item);
            foreach (Renderer renderer in renderArr)
            {
                if (renderer != null && renderer.sharedMaterials != null && renderer.sharedMaterials.Length > 0)
                {

                    foreach (var mat in renderer.sharedMaterials)
                    {
                        string matPath = AssetDatabase.GetAssetPath(mat);

                        foreach (var kv in dictRefrence)
                        {
                            if (kv.Key == matPath)
                            {
                                kv.Value.refrenceNames.Add(objPath);
                            }
                        }
                    }
                }
            }
        }

        foreach (var kv in dictRefrence)
        {
            Debug.Log($"{kv.Key}==========================");

            if (kv.Value.refrenceNames.Count > 0)
            {
                foreach (var item in kv.Value.refrenceNames)
                {
                    Debug.Log(item);
                }
            }
            else
            {
                Debug.Log($"""");
            }
        }

        EditorUtility.ClearProgressBar();
    }

    [MenuItem("EditorTools/""shader""")]
    static void checkMatShader() {
        List<Material> matList = new List<Material>();
        string[] files = GetAllFile(new List<string>() { ".mat" });
        for (int i = 0; i < files.Length; i++)
        {
            string path = GetAssetPath(files[i]);
            Material mat = AssetDatabase.LoadAssetAtPath<Material>(path);
            matList.Add(mat);
        }

        Dictionary<string, List<string>> shaderRefMap = new Dictionary<string, List<string>>();

        foreach (Material mat in matList) {

            if (!shaderRefMap.TryGetValue(mat.shader.name, out List<string> refList)) {
                refList = new List<string>();
                shaderRefMap.Add(mat.shader.name, refList);
            }
            refList.Add(AssetDatabase.GetAssetPath(mat));
            //Debug.Log(mat.shader.name);
        }


        foreach (var kv in shaderRefMap) {
            Debug.Log($"{kv.Key} ""：-----------------------");

            string outPut = "";

            foreach (var item in kv.Value)
            {
                outPut += item + "\n";
            }
            Debug.Log(outPut);
        }
    }

    [MenuItem("Assets/""Battle Tag")]
    static void SetBattleTag()
    {
        List<FileInfo> fileInfos = new List<FileInfo>();

        foreach (var item in SearchSelectDirectory("*.prefab"))
        {
            fileInfos.Add(item);
        }

        for (int i = 0; i < fileInfos.Count; i++)
        {

            FileInfo fileInfo = fileInfos[i];
            string path = GetAssetPath(fileInfo.FullName);
            GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            if (go == null)
            {
                continue;
            }
            go.tag = "Battle";
            EditorUtility.DisplayProgressBar($"""{go.name}""", path, (float)i / fileInfos.Count);
        }

        EditorUtility.ClearProgressBar();
    }

    [MenuItem("EditorTools/""lua""")]
    static void OneKeyEncryption()
    {
        EditorUtility.DisplayProgressBar("""", """", 0);
        var files = Directory.GetFiles(Application.dataPath + "/Lua", "*.lua", SearchOption.AllDirectories).ToArray();
        for(int i = 0; i < files.Length; i++)
        {
            var item = files[i];
            if (item.Contains("language.lua"))
                continue;

            EditorUtility.DisplayProgressBar(item, "lua""", (float)i / files.Length);
            var data = File.ReadAllBytes(item);
            var newData = EncryptionTools.Encryption(data);

            FileInfo file = new FileInfo(item);
            // Delete the file if it exists.
            if (file.Exists)
            {
                file.Delete();
            }
            //Create the file.
            using (StreamWriter sw = new StreamWriter(item, false, new UTF8Encoding(false)))
            {
                sw.Write(Encoding.UTF8.GetString(newData));
            }
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }   

    [MenuItem("EditorTools/""lua""")]
    static void OneKeyDecryption()
    {
        EditorUtility.DisplayProgressBar("""", """", 0);
        var files = Directory.GetFiles(Application.dataPath + "/Lua", "*.lua", SearchOption.AllDirectories).ToArray();

        for (int i = 0; i < files.Length; i++)
        {
            var item = files[i];

            if (item.Contains("language.lua"))
                continue;

            EditorUtility.DisplayProgressBar(item, "lua""", (float)i / files.Length);
            var data = File.ReadAllBytes(item);
            var newData = EncryptionTools.Decryption(data);

            FileInfo file = new FileInfo(item);
            // Delete the file if it exists.
            if (file.Exists)
            {
                file.Delete();
            }
            //Create the file.
            using (StreamWriter sw = new StreamWriter(item, false, new UTF8Encoding(false)))
            {
                sw.Write(Encoding.UTF8.GetString(newData));
            }
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }

    [MenuItem("EditorTools/""lua""utf-8 ""Bom""")]
    static void OneKeyLuaToUtf8NoBom()
    {
        EditorUtility.DisplayProgressBar("""", """", 0);
        var files = Directory.GetFiles(Application.dataPath + "/Lua", "*.lua", SearchOption.AllDirectories).ToArray();

        for (int i = 0; i < files.Length; i++)
        {
            var item = files[i];
            EditorUtility.DisplayProgressBar(item, "lua""utf-8 ""Bom""", (float)i / files.Length);
            var data = File.ReadAllBytes(item);

            FileInfo file = new FileInfo(item);
            // Delete the file if it exists.
            if (file.Exists)
            {
                file.Delete();
            }
            //Create the file.
            using (StreamWriter sw = new StreamWriter(item, false, new UTF8Encoding(false)))
            {
                sw.Write(Encoding.UTF8.GetString(data));
            }
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }

}

#endif
