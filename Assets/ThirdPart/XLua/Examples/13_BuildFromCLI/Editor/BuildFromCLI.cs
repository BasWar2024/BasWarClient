using System;
using UnityEditor;
using UnityEngine;
using CSObjectWrapEditor;
using XLua;

namespace XLuaTest
{
    public static class BuildFromCLI
    {
        /// <summary>
        /// Unity
        /// </summary>
        [MenuItem("XLua/Examples/13_BuildFromCLI")]
        public static void BuildFromUnityMenu()
        {
            var outputDir = Application.dataPath.Substring(0, Application.dataPath.Length - "/Assets".Length) + "/output";
            var packageName = "xLuaGame.exe";
            build(outputDir, packageName);
        }

        /// <summary>
        /// 
        /// </summary>
        public static void Build()
        {
            var outputDir = Application.dataPath.Substring(0, Application.dataPath.Length - "/Assets".Length) + "/output";
            var packageName = "xLuaGame.exe";
            build(outputDir, packageName);
        }

        private static void build(string outputDir, string packageName)
        {
            Debug.Log(" " + outputDir);
            DelegateBridge.Gen_Flag = true;
            Generator.ClearAll();
            Generator.GenAll();

            var levels = new string[0];
            var locationPathName = string.Format("{0}/{1}", outputDir, packageName);
            var target = BuildTarget.StandaloneWindows64;
            var options = BuildOptions.None;
            BuildPipeline.BuildPlayer(levels, locationPathName, target, options);
            Debug.Log("");
        }
    }
}
