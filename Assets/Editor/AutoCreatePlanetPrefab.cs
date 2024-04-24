using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using XLua;
using System;

class posJson {
    public float x;
    public float y;
    public float z;
}

class galaxy {
    public int cfgId;
    public string name;
    public int statue;
    public posJson pos;
    public int minIndex;
    public int maxIndex;
}

class resPlanet {
    public int index;
    public posJson pos;
}

public class AutoCreatePlanetPrefab : EditorWindow {
    //[MenuItem("Assets/""")]
    public static void CreatePlanetPrefab() {
        //TextAsset text = AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/Lua/etc/cfg/galaxy.lua");

        //Debug.Log(text);

        LuaEnv luaEnv = new LuaEnv();
        luaEnv.AddLoader(CustomLoader);
        luaEnv.DoString(@"require('cfg')");
        Action action = luaEnv.Global.Get<Action>("loadTable");
        action();
        Dictionary<int, galaxy> galaxyTable = luaEnv.Global.Get<Dictionary<int, galaxy>>("galaxyTable");
        Dictionary<int, resPlanet> resPlanetTable = luaEnv.Global.Get<Dictionary<int, resPlanet>>("resPlanetTable");

        foreach (galaxy g in galaxyTable.Values) {
            string path = "Assets/Prefabs/ResPlanet/" + g.name + ".Prefab";

            GameObject newGameObject = new GameObject();
            newGameObject.name = g.name;

            List<resPlanet> res = new List<resPlanet>();
            foreach(resPlanet r in resPlanetTable.Values) {
                if(r.index >= g.minIndex && r.index <= g.maxIndex){
                    GameObject planet = AssetDatabase.LoadAssetAtPath("Assets/Prefabs/ResPlanet/ResPlanet.Prefab", typeof(GameObject)) as GameObject;
                    GameObject star = GameObject.Instantiate(planet);
                    star.name = r.index.ToString();
                    star.transform.SetParent(newGameObject.transform, false);
                    star.transform.localPosition = new Vector3(r.pos.x, r.pos.y, r.pos.z);
                }
            }
            
            PrefabUtility.SaveAsPrefabAsset(newGameObject, path);
            GameObject.DestroyImmediate(newGameObject);
        }


        //""
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    private static byte[] CustomLoader(ref string filePath) {
        filePath = filePath.Replace(".", "/") + ".lua";
        string luaPath = Application.dataPath + "/Lua/" + filePath;
        string luaCode = File.ReadAllText(luaPath);
        return System.Text.Encoding.UTF8.GetBytes(luaCode);
    }

}
