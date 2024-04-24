using UnityEditor;
 
class AssetsMenu
{
    [MenuItem("Assets/""Unity""", true)]
    static bool ExportPackageValidation()
    {
        for (var i = 0; i < Selection.objects.Length; i++)
        {
            if (AssetDatabase.GetAssetPath(Selection.objects[i]) != "")
                return true;
        }
 
        return false;
    }
 
    [MenuItem("Assets/""Unity""")]
    static void ExportPackage()
    {
        var path = EditorUtility.SaveFilePanel("Save unitypackage", "", "", "unitypackage");
        if (path == "")
            return;
 
        var assetPathNames = new string[Selection.objects.Length];
        for (var i = 0; i < assetPathNames.Length; i++)
        {
            assetPathNames[i] = AssetDatabase.GetAssetPath(Selection.objects[i]);
        }
 
        assetPathNames = AssetDatabase.GetDependencies(assetPathNames);
 
        AssetDatabase.ExportPackage(assetPathNames, path, ExportPackageOptions.Interactive | ExportPackageOptions.Recurse | ExportPackageOptions.IncludeDependencies);
    }
}