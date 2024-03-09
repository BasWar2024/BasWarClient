using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Build;
using UnityEditor.AddressableAssets.Settings;
using UnityEngine;
public class BuildingProjectProcessing {
    // [MenuItem ("Tools//1.APK")]
    // public static void BuildingProcessing () {
    //     if (Application.isPlaying) return;
    //     //
    //     string path = EditorPrefs.GetString ("BuildingFolderPath", "");
    //     path = EditorUtility.SaveFolderPanel ("BuildingFolderPath", path, "TrainArtsDEMO");
    //     if (path.Equals ("") || path == null) return;
    //     EditorPrefs.SetString ("BuildingFolderPath", path);

    //     //clean 
    //     AddressableAssetSettings.CleanPlayerContent (AddressableAssetSettingsDefaultObject.Settings.ActivePlayerDataBuilder);
    //     //addressable Group
    //     AddressableAssetSettings.BuildPlayerContent ();

    //     // // BuildScript
    //     // var res = AddressableAssetBuildResult.CreateResult<customBuilderRes> (null, 0, "errorString");
    //     // //apk
    //     BuildPipeline.BuildPlayer (new string[] { "Assets/Scenes/Launcher.unity" }, path, BuildTarget.Android, BuildOptions.None);

    //     // processCommand (path + "/AS_All_EN_Train_MoPub/build/outputs/apk/release", path, path + "/AS_All_EN_Train_MoPub/gradlew.bat", "assembleDebug");
    // }
    static void PerExp () {
        //clean 
        AddressableAssetSettings.CleanPlayerContent (AddressableAssetSettingsDefaultObject.Settings.ActivePlayerDataBuilder);
        //addressable Group
        AddressableAssetSettings.BuildPlayerContent ();
    }

    #region build
    [InitializeOnLoadMethod]
    private static void Initialize () {
        BuildPlayerWindow.RegisterBuildPlayerHandler (BuildPlayerHandler);
    }
    private static void BuildPlayerHandler (BuildPlayerOptions options) {
        if (EditorUtility.DisplayDialog ("Build with Addressables",
                "Do you want to build a clean addressables before export?",
                "Build with Addressables", "Skip")) {
            PerExp ();
        }
        BuildPlayerWindow.DefaultBuildMethods.BuildPlayer (options);
    }
    #endregion
}