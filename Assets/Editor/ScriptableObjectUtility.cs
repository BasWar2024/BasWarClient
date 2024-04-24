using System.IO;
using UnityEditor;
using UnityEngine;
#if UNITY_EDITOR
public static class ScriptableObjectUtility {
	//This makes it easy to create, name and place unique new ScriptableObject asset files.
	//Taken from here: http://wiki.unity3d.com/index.php?title=CreateScriptableObjectAsset
	public static T CreateAsset<T> (string assetName = "") where T : ScriptableObject {
		T asset = ScriptableObject.CreateInstance<T> ();

		string path = AssetDatabase.GetAssetPath (Selection.activeObject);
		if (path == "") {
			path = "Assets";
		} else if (Path.GetExtension (path) != "") {
			path = path.Replace (Path.GetFileName (AssetDatabase.GetAssetPath (Selection.activeObject)), "");
		}
		assetName = assetName ?? "New " + typeof (T).ToString () + ".asset";
		string assetPathAndName = AssetDatabase.GenerateUniqueAssetPath (path + "/" + assetName);

		AssetDatabase.CreateAsset (asset, assetPathAndName);

		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
		EditorUtility.FocusProjectWindow ();
		Selection.activeObject = asset;
		return asset;
	}
	public static Object CreateAsset (System.Type type) {
		Object asset = ScriptableObject.CreateInstance (type);

		string path = AssetDatabase.GetAssetPath (Selection.activeObject);
		if (path == "") {
			path = "Assets";
		} else if (Path.GetExtension (path) != "") {
			path = path.Replace (Path.GetFileName (AssetDatabase.GetAssetPath (Selection.activeObject)), "");
		}

		string assetPathAndName = AssetDatabase.GenerateUniqueAssetPath (path + "/ New " + type.ToString () + ".asset");

		AssetDatabase.CreateAsset (asset, assetPathAndName);

		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
		EditorUtility.FocusProjectWindow ();
		Selection.activeObject = asset;
		return asset;
	}
	public static T Clone<T> (this T scriptableObject) where T : ScriptableObject {
		if (scriptableObject) {
			return (T) ScriptableObject.CreateInstance (typeof (T));
		}
		T instance = UnityEngine.Object.Instantiate (scriptableObject);
		instance.name = scriptableObject.name;

		return instance;
	}
}
#endif