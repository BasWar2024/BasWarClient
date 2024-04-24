using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Settings;
using UnityEditor.AddressableAssets.Settings.GroupSchemas;
using UnityEngine;

public class AddressablesTools : EditorWindow
{
    public static string ResPath = "Assets/GameResources";
    public static AddressableAssetSettings setting;
    private static string DuplicateGroup = "Duplicate Asset Isolation";

    [MenuItem("Assets/""Addressable Group")]
    public static void AutoCreateGroup()
    {
        string path = "Assets/Prefabs";//GetSelectedAssetPath();
        //string scenePath = "Assets/Scenes";

        setting = AddressableAssetSettingsDefaultObject.Settings;

        BuildPrefabAndSceneGroup(path);
        //BuildPrefabAndSceneGroup(scenePath);

        Debug.Log("addr""");
    }

    public static void BuildPrefabAndSceneGroup(string path)
    {
        //""  
        if (Directory.Exists(path))
        {
            DirectoryInfo direction = new DirectoryInfo(path);
            FileInfo[] files = direction.GetFiles("*", SearchOption.AllDirectories);

            for (int i = 0; i < files.Length; i++)
            {
                string fileName = files[i].Name;
                if (fileName.EndsWith(".meta") || fileName.EndsWith(".asset") || fileName.EndsWith(".exr") || fileName.Contains("test"))
                {
                    continue;
                }

                string newDirectoryName = files[i].DirectoryName.Replace("\\", "/");
                var splits = newDirectoryName.Split(new string[] { "/Assets/" }, System.StringSplitOptions.RemoveEmptyEntries);

                if (splits.Length < 2)
                    Debug.LogError("DirectoryName""");

                var address = $"Assets/{splits[1]}";
                var groupSplits = splits[1].Split(new string[] { "/" }, System.StringSplitOptions.RemoveEmptyEntries);
                var groupName = $"{groupSplits[0]}-{groupSplits[1]}";
                var group = setting.FindGroup(groupName);
                //Debug.Log(groupName + "/" + files[i].Name);
                //Debug.Log(address);
                if (group == null)
                {
                    group = setting.CreateGroup(groupName, false, false, false, null);
                }

                string assetsPath = $"{address}/{files[i].Name}";
                var name = files[i].Name.Split('.');
                string newName = name[0];
                if (name.Length > 1)
                {
                    if (name[1] == "strings")
                    {
                        newName = name[0] + "." + name[1];
                    }
                }

                var entry = AddAssetEntry(group, assetsPath, newName);
                var label = address.Replace("/", "-");
                setting.AddLabel(label);
                entry.SetLabel(label, true);
                UpdateGroupSchema(group);
            }
        }
    }

    // ""
    private static AddressableAssetEntry AddAssetEntry(AddressableAssetGroup group, string assetPath, string address)
    {
        string guid = AssetDatabase.AssetPathToGUID(assetPath);
        AddressableAssetEntry entry = group.entries.FirstOrDefault(e => e.guid == guid);
        if (entry == null)
        {
            entry = setting.CreateOrMoveEntry(guid, group, false, false);

        }
        entry.address = address;

        return entry;
    }

    private static void UpdateGroupSchema(AddressableAssetGroup group)
    {
        ContentUpdateGroupSchema contentUpdate = null;
        if (group.GetSchema<ContentUpdateGroupSchema>())
        {
            contentUpdate = group.GetSchema<ContentUpdateGroupSchema>();
        }
        else
        {
            contentUpdate = group.AddSchema<ContentUpdateGroupSchema>();
        }

        BundledAssetGroupSchema bundledAsset = null;
        if (group.GetSchema<BundledAssetGroupSchema>())
        {
            bundledAsset = group.GetSchema<BundledAssetGroupSchema>();
        }
        else
        {
            bundledAsset = group.AddSchema<BundledAssetGroupSchema>();
        }

        bundledAsset.BundleMode = BundledAssetGroupSchema.BundlePackingMode.PackTogetherByLabel;
    }

    //[MenuItem("Assets/""")]
    public static void AutoCreateRelyResGroup()
    {
        setting = AddressableAssetSettingsDefaultObject.Settings;
        var group = setting.FindGroup(DuplicateGroup);

        if (group == null)
        {
            Debug.Log("""" + DuplicateGroup + """");
            return;
        }

        while (group.entries.Count > 0)
        {
            AddressableAssetEntry entrie = group.entries.First();
            var index = entrie.AssetPath.LastIndexOf('/');
            var groupName = entrie.AssetPath.Substring(0, index);
            groupName = groupName.Replace("/", "-");
            var newGroup = setting.FindGroup(groupName);

            if (newGroup == null)
            {
                newGroup = setting.CreateGroup(groupName, false, false, false, null);
            }

            AddAssetEntry(newGroup, entrie.AssetPath, entrie.AssetPath);
            UpdateGroupSchema(newGroup);
        }
    }

    //[MenuItem("Assets/""LabelPreload")]
    //public static void LabelPreload()
    //{
    //    var setting = AddressableAssetSettingsDefaultObject.Settings;
    //    foreach (var group in setting.groups)
    //    {
    //        foreach (var entry in group.entries)
    //        {
    //            //Debug.Log(entry.address);
    //            entry.SetLabel("preload", true, false, false);
    //        }
    //    }
    //}
}