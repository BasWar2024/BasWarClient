using System;
using System.Collections.Generic;
using System.IO;
using SimpleJson;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Build;
using UnityEditor.AddressableAssets.Settings;
using UnityEditor.Experimental.AssetImporters;
using UnityEngine;

[ScriptedImporter (1, "lua")]
public class LuaImporter : ScriptedImporter {
    public override void OnImportAsset (AssetImportContext ctx) {
        var luaTxt = File.ReadAllText (ctx.assetPath);
        Debug.Log ("LuaPostprocessor lua  " + ctx.assetPath);
        var assetsText = new TextAsset (luaTxt);
        ctx.AddObjectToAsset ("main obj", assetsText);
        ctx.SetMainObject (assetsText);
    }
}

public class LuaPostprocessor : AssetPostprocessor {
    static void OnPostprocessAllAssets (string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths) {
        foreach (var str in importedAssets) {
            if (str.EndsWith (".lua")) {
                // Debug.Log ("LuaPostprocessor " + str);

                var lua_obj = AssetDatabase.LoadAssetAtPath<UnityEngine.Object> (str);

                AssetDatabase.SetLabels (lua_obj, new string[] { "lua" });

            }
        }

        foreach (var item in deletedAssets) {
            if (item.EndsWith (".lua")) {

            }
        }

        foreach (var item in movedAssets) {
            if (item.EndsWith (".lua")) {

            }
        }
        foreach (var item in movedFromAssetPaths) {
            if (item.EndsWith (".lua")) {

            }
        }

    }

    // [MenuItem ("Assets/LuaPostprocessor: Check Folder(s)")]
    // private static void CheckFoldersFromSelection () {
    //     List<string> assetPaths = new List<string> ();
    //     // Folders comes up as Object.
    //     foreach (UnityEngine.Object obj in Selection.GetFiltered (typeof (UnityEngine.Object), SelectionMode.Assets)) {
    //         var assetPath = AssetDatabase.GetAssetPath (obj);
    //         // Other assets may appear as Object, so a Directory Check filters directories from folders.
    //         if (Directory.Exists (assetPath)) {
    //             assetPaths.Add (assetPath);
    //         }
    //     }

    //     foreach (var item in assetPaths) {
    //         var lua_obj = AssetDatabase.LoadAssetAtPath<Object> (item);

    //         AssetDatabase.SetLabels (lua_obj, new string[] { "lua" });
    //         Debug.LogError ("work??? " + item);
    //     }
    // }
}