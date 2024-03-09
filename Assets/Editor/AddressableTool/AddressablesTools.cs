
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

    [MenuItem("Assets/Addressable Group")]
    public static void AutoCreateGroup()
    {
        string path = "Assets/Prefabs";//GetSelectedAssetPath();
        string scenePath = "Assets/Scenes";

        setting = AddressableAssetSettingsDefaultObject.Settings;

        BuildPrefabAndSceneGroup(path);
        BuildPrefabAndSceneGroup(scenePath);

        Debug.Log("addr");
    }

    public static void BuildPrefabAndSceneGroup(string path)
    {
        //  
        if (Directory.Exists(path))
        {
            DirectoryInfo direction = new DirectoryInfo(path);
            FileInfo[] files = direction.GetFiles("*", SearchOption.AllDirectories);

            for (int i = 0; i < files.Length; i++)
            {
                string fileName = files[i].Name;
                if (fileName.EndsWith(".meta") || fileName.EndsWith(".asset") || fileName.EndsWith(".exr"))
                {
                    continue;
                }

                string newDirectoryName = files[i].DirectoryName.Replace("\\", "/");
                var splits = newDirectoryName.Split(new string[] { "/Assets/" }, System.StringSplitOptions.RemoveEmptyEntries);

                if (splits.Length < 2)
                    Debug.LogError("DirectoryName");

                var address = $"Assets/{splits[1]}";
                var groupName = address.Replace("/", "-");
                var group = setting.FindGroup(groupName);

                if (group == null)
                {
                    group = setting.CreateGroup(groupName, false, false, false, null);
                }

                string assetsPath = $"{address}/{files[i].Name}";
                var name = files[i].Name.Split('.');
                AddAssetEntry(group, assetsPath, name[0]);
                UpdateGroupSchema(group);
            }
        }
    }

     // 
     private static AddressableAssetEntry AddAssetEntry(AddressableAssetGroup group, string assetPath, string address)
     {
         string guid = AssetDatabase.AssetPathToGUID(assetPath);
        
         AddressableAssetEntry entry = group.entries.FirstOrDefault(e => e.guid == guid);
         if (entry == null)
         {
             entry = setting.CreateOrMoveEntry(guid, group, false, false);
            
         }
         entry.address = address;
         
         //entry.SetLabel(group.Name, true, false, false);
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
    }

    //[MenuItem("Assets/")]
    //public void CreateVersion()
    //{
    //    var filePath = Application.dataPath + "/Lua/etc/Version.json";
    //    var gr = AddressableAssetSettingsDefaultObject.Settings.groups;
    //    var jobj = new JsonObject();

    //    foreach (var item in gr)
    //    {
    //        if (item.name.Equals("Default Local Group"))
    //        {

    //        }
    //    }
    //}
}
