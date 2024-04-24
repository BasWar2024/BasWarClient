using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using SimpleJson;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Build;
using UnityEditor.AddressableAssets.Build.DataBuilders;
using UnityEditor.AddressableAssets.Settings;
using UnityEditor.AddressableAssets.Settings.GroupSchemas;
using UnityEngine;
using UnityEngine.ResourceManagement.ResourceProviders;

[CreateAssetMenu (fileName = "CustomBuildMode.asset", menuName = "Addressables/Custom Builders/CustomBuildMode")]
public class CustomBuildMode : BuildScriptPackedMode {
    public override string Name { get { return """ab ""ab""log"""; } }
    protected override TResult DoBuild<TResult> (AddressablesDataBuilderInput builderInput, AddressableAssetsBuildContext aaContext) {
        TResult opResult = base.DoBuild<TResult> (builderInput, aaContext);
        var groups = aaContext.Settings.groups;
        for (int i = 0; i < groups.Count; i++) {
            List<string> bundles;
            if (aaContext.assetGroupToBundles.TryGetValue (groups[i], out bundles)) {
                var locations = aaContext.locations;
                for (int j = 0; j < locations.Count; j++) {
                    if (locations[j].Data != null) {
                        var d = locations[j].Data as AssetBundleRequestOptions;
                        if (d != null) {
                            for (int k = 0; k < bundles.Count; k++) {
                                if (d.BundleName == bundles[k]) {
                                    Debug.Log (string.Format (" "":<color=#FF0000> {0} </color>"" <color=#00FF00> {1} b</color> ,bundlename is : <color=#0000FF> {2} </color> ", groups[i].name, d.BundleSize, bundles[k]));
                                }
                            }
                        }
                    }
                }
            }
        }

        CreateLuaScriptAssetKey ();

        return opResult;
    }


    [MenuItem ("Assets/""lua """)]
    public static void CreateLuaScriptAssetKey ()
    {

        string luaPath = "Assets/Lua";
        BuildLuaGroup(luaPath);

        var filePath = Application.dataPath + "/Lua/etc/LuaScriptConfig.json";
        var gr = AddressableAssetSettingsDefaultObject.Settings.groups;
        var jobj = new JsonObject ();
        foreach (var item in gr) {
            if (!item.name.Equals ("Built In Data") && !item.name.Contains ("Duplicate Asset Isolation") && item != null) {
                if (item.entries.Count > 0 && item.name == "LuaScript") {
                    foreach (AddressableAssetEntry obj in item.entries) {
                        // Debug.LogError (obj.address);
                        jobj.Add (obj.address, "");
                    }
                }
            }
        }
        var JsonOut = new JsonObject ();
        JsonOut.Add ("Version", DateTime.Now.Year + "_" + DateTime.Now.Month + "_" + DateTime.Now.Day + "_" + DateTime.Now.Hour + "_" + DateTime.Now.Minute);
        JsonOut.Add ("Content", jobj);
        // Debug.LogError (JsonOut);

        System.IO.FileInfo file = new System.IO.FileInfo (filePath);
        System.IO.StreamWriter sw = file.CreateText ();
        sw.WriteLine (JsonOut);
        sw.Close ();
        sw.Dispose ();

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh ();
    }

    public static void BuildLuaGroup(string path)
    {
        //""  
        if (Directory.Exists(path))
        {
            var setting = AddressableAssetSettingsDefaultObject.Settings;

            DirectoryInfo direction = new DirectoryInfo(path);
            FileInfo[] files = direction.GetFiles("*", SearchOption.AllDirectories);

            for (int i = 0; i < files.Length; i++)
            {
                string fileName = files[i].Name;

                if (!fileName.EndsWith(".lua"))
                {
                    continue;
                }

                string fullName = files[i].FullName.Replace("\\", "/");
                var splits = fullName.Split(new string[] { "/Assets/" }, System.StringSplitOptions.RemoveEmptyEntries);

                if (splits.Length < 2)
                    Debug.LogError("DirectoryName""");

                var address = $"Assets/{splits[1]}";
                var group = setting.FindGroup("LuaScript");

                AddAssetEntry(group, address, address);
            }

            Debug.Log("""Lua""LuaScript""");
        }
    }

    static AddressableAssetEntry AddAssetEntry(AddressableAssetGroup group, string assetPath, string address)
    {
        string guid = AssetDatabase.AssetPathToGUID(assetPath);

        AddressableAssetEntry entry = group.entries.FirstOrDefault(e => e.guid == guid);
        if (entry == null)
        {
            entry = AddressableAssetSettingsDefaultObject.Settings.CreateOrMoveEntry(guid, group, false, false);

        }
        entry.address = address;

        entry.SetLabel("LuaScript", true, false, false);
        return entry;
    }
}