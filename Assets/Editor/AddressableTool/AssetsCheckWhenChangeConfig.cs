using System;
using UnityEditor;
using UnityEngine;

namespace TKDotsFrame.Editor {
    /// <summary>
    /// ""
    /// </summary>
    public class AssetsCheckWhenChangeConfig : ScriptableObject {
        //""
        public string[] DetectionPaths;
        [MenuItem ("Tools/PackageTool/""")]
        private static void Create () {
            ScriptableObjectUtility.CreateAsset<AssetsCheckWhenChangeConfig> ("AssetsCheckWhenChangeConfig.asset");
        }
    }
}