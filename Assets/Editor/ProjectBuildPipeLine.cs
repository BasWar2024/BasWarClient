using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Build;
using UnityEditor.AddressableAssets.Settings;
using UnityEditor.AddressableAssets.Settings.GroupSchemas;
using UnityEngine;
public class ProjectBuildPipeLine {
    //""android ""
    public static void BuildAllAndroid () {
        var levels = new List<string> ();
        foreach (var scene in EditorBuildSettings.scenes) {
            if (!scene.enabled) continue;
            levels.Add (scene.path);
        }
        // EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.Android, BuildTarget.Android);

        //""lua""
        CustomBuildMode.CreateLuaScriptAssetKey ();
        //""
        SetAddressableLocalBuild ();
        //"" ""
        AddressableAssetSettings.CleanPlayerContent (AddressableAssetSettingsDefaultObject.Settings.ActivePlayerDataBuilder);
        //addressable ""
        AddressableAssetSettings.BuildPlayerContent ();

        var args = System.Environment.GetCommandLineArgs ();
        string outPath = ""; //""
        foreach (var s in args) {
            if (s.Contains ("-outputpath:")) {
                outPath = s.Split (':') [1];
                //Debug.LogError ("outputpath " + outPath);
            }
        }
        Directory.CreateDirectory (outPath);
        //""
        EditorUserBuildSettings.exportAsGoogleAndroidProject = true;
        //""android ""
        EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.Android, BuildTarget.Android);
        //""
        BuildPipeline.BuildPlayer (levels.ToArray (), outPath, BuildTarget.Android, BuildOptions.AcceptExternalModificationsToPlayer);
        //""apk test
        // BuildPipeline.BuildPlayer (levels.ToArray (), outPath, BuildTarget.Android, BuildOptions.None);
    }
    //""bundle""
    // [MenuItem ("Tools/""")]
    public static void BuildPatchAndroid () {

        var settings = AddressableAssetSettingsDefaultObject.Settings;
        var profileId = settings.profileSettings.GetProfileId ("Build");

        var args = System.Environment.GetCommandLineArgs ();
        var version = ""; //""
        var buildTarget = "Android";
        foreach (var s in args) {
            if (s.Contains ("-version:")) {
                version = s.Split (':') [1];
                //Debug.LogError ("outputpath " + outPath);
            }
            if (s.Contains ("-buildtarget:")) {
                buildTarget = s.Split (':') [1];
                //Debug.LogError ("outputpath " + outPath);
            }
        }

        //""
        syncAddressableRemoteBuild(settings,profileId,buildTarget);

        //addressable OnUpdateBuild
        var path = ContentUpdateScript.GetContentStateDataPath (false);
        Debug.LogError("path "+path);
        if (!string.IsNullOrEmpty (path))
            ContentUpdateScript.BuildContentUpdate (AddressableAssetSettingsDefaultObject.Settings, path);

    }
    static void SetAddressableLocalBuild (string buildTarget = "Android") {
        var settings = AddressableAssetSettingsDefaultObject.Settings;
        var profileId = settings.profileSettings.GetProfileId ("Build");

        //""
        var buildPath = "[UnityEngine.AddressableAssets.Addressables.BuildPath]/[BuildTarget]";
        var loadPath = "{UnityEngine.AddressableAssets.Addressables.RuntimePath}/[BuildTarget]";
        settings.profileSettings.SetValue (profileId, "LocalBuildPath", buildPath);
        settings.profileSettings.SetValue (profileId, "LocalLoadPath", loadPath);

        var remoteBuildPath = "../clientpack/" + buildTarget;
        var remoteLoadPath = "http://81.69.12.6:4030/clientpack/" + buildTarget;
        settings.profileSettings.SetValue (profileId, "RemoteBuildPath", remoteBuildPath);
        settings.profileSettings.SetValue (profileId, "RemoteLoadPath", remoteLoadPath);
    }
    //"" ""LocalBuildPath "" remoteBuildPath"" ""
    static void syncAddressableRemoteBuild(UnityEditor.AddressableAssets.Settings.AddressableAssetSettings settings,string profileId,string buildTarget = "Android"){
        var remoteBuildPath = "../clientpack/" + buildTarget;
        var remoteLoadPath = "http://81.69.12.6:4030/clientpack/" + buildTarget;
        settings.profileSettings.SetValue (profileId, "LocalBuildPath", remoteBuildPath);
        settings.profileSettings.SetValue (profileId, "LocalLoadPath", remoteLoadPath);
    }

}