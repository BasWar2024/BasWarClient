// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;
// using UnityEditor;
// using XLua;
// using System;

// public class EditorMenu : MonoBehaviour
// {
//     #if UNITY_EDITOR
//     //[MenuItem("GameObject/ChangeControlEntity")]
//     [MenuItem("CONTEXT/WorldObjMono/ChangeControlEntity")]
//     static public void ChangeControlEntity() {
//         GameObject go = Selection.activeObject as GameObject;
//         string temp = go.name.Split('_')[1];
//         Int64 id = Convert.ToInt64(temp);
//         Lua lua = GameObject.Find("global").GetComponent<Lua>();
//         LuaTable args = lua.luaEnv.NewTable();
//         args.Set("id",id);
//         lua.sendToSceneServer("C2S_Scene_ChangeControlEntity",args);
//         args.Dispose();
//     }
//     #endif
// }
