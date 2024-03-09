using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;

namespace TKDotsFrame.Editor {

    public class AssetsImporterSystemSetting {
        public const string configPath = "Assets/Editor/AddressableTool/AssetsCheckWhenChangeConfig.asset";
        // public const string pattern = @"^([A-Za-z0-9]+|[A-Za-z]+|[A-Za-z]+_[A-Za-z]+|[A-Za-z]+_[0-9]+|[A-Za-z]+_[A-Za-z]+_[0-9]+|[A-Za-z]+_[A-Za-z]+_[A-Za-z]+|[A-Za-z]+_[A-Za-z]+_[A-Za-z]+_[0-9]+|[A-Za-z]+_[A-Za-z]+_[A-Za-z]+_[A-Za-z]+)$";
        public const string pattern = @"^\w{3,50}$";
        // public const string tipsStr = "{0} \n A \n A_ \n A_A \n A_A_ \n A_A_A \n A_A_A_ \n  : {1}";
        public const string tipsStr = " ";
        static string[] configtempDetectionPaths;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="path"></param>
        /// <param name="isfile"></param>
        /// <returns></returns>
        public static bool isExistsFileOrFolder (string path, bool isHasExtension) {
            if (isHasExtension) {
                return File.Exists (path);
            } else {
                return Directory.Exists (path);
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        public static bool IsTargetCheckFile (string filePath) {
            //
            bool isInCheckList = false;
            var config = GetAssetConfig ();
            if (config != null) {
                for (int i = 0; i < config.Length; i++) {
                    if (filePath.Contains (config[i])) {
                        isInCheckList = true;
                        break;
                    }
                }
            }
            return isInCheckList;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string[] GetAssetConfig () {
            if (configtempDetectionPaths == null) {

                var config = AssetDatabase.LoadAssetAtPath<AssetsCheckWhenChangeConfig> (AssetsImporterSystemSetting.configPath);
                if (config != null) {
                    configtempDetectionPaths = config.DetectionPaths;
                } else {
                    Debug.LogWarning ("not find AssetsCheckWhenChangeConfig");
                }
            }
            return configtempDetectionPaths;
        }
    }

    /// <summary>
    /// 1./,
    /// 2.addressable 
    /// 3.addressable 
    /// </summary>
    public class AssetsCheckWhenChange : AssetPostprocessor {
        public static bool isDirty = true; //
        public static List<string> DirtyList = new List<string> ();
        static AssetsCheckWhenChange () {
            // Debug.LogError ("");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="importedAssets">//</param>
        /// <param name="deletedAssets"></param>
        /// 
        /// 
        ///     importedAssets   movedAssets
        ///                  
        ///                  
        ///                    
        ///                   
        /// 
        /// <param name="movedAssets"></param>
        /// <param name="movedFromAssetPaths"></param>
        static void OnPostprocessAllAssets (string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths) {

            foreach (string importedAssetPath in importedAssets) {
                CheckProcessing (importedAssetPath);
            }
            // Debug.LogError ("importedAssets " + importedAssets.Length);
            foreach (var movedAssetPath in movedAssets) {
                //
                if (Path.GetExtension (movedAssetPath) == "") continue;
                CheckProcessing (movedAssetPath);
            }
            // Debug.LogError ("movedAssets " + movedAssets.Length);
        }
        static void CheckProcessing (string assetpath) {

            if (AssetsImporterSystemSetting.IsTargetCheckFile (assetpath) && !AssetsCheckProcessingWindow.isTempListContains (assetpath)) {

                //
                string fileName = Path.GetFileNameWithoutExtension (assetpath);
                string fileExtension = Path.GetExtension (assetpath);

                if (Regex.IsMatch (fileName, AssetsImporterSystemSetting.pattern)) {
                    //
                    Debug.Log ("<color=#9AFF7C>" + fileName + fileExtension + "   </color>");
                } else {
                    //
                    Debug.Log ("<color=#FF0000>" + fileName + fileExtension + "  </color>  ");
                    AssetsCheckProcessingWindow.AddToTempList (assetpath);
                    AssetsCheckProcessingWindow.CreateWindowOrProcessing (assetpath);
                }
            }
        }

        static void ProcessingFile (string[] pathStrs, bool isMoveAsset = false) {
            if (pathStrs.Length <= 0) return;
            // if (inProcessing) return;

            // Debug.LogError (" pathStrs.length " + pathStrs.Length + " isMoveAsset " + isMoveAsset);

            int startIndex = 0;
            //
            EditorApplication.update = () => {
                string assetpath = pathStrs[startIndex];
                EditorUtility.DisplayProgressBar (": ", assetpath, (float) startIndex / (float) pathStrs.Length);

                CheckProcessing (assetpath);

                startIndex++;
                if (startIndex >= pathStrs.Length) {
                    EditorUtility.ClearProgressBar ();
                    EditorApplication.update = null;
                    startIndex = 0;
                    AssetDatabase.Refresh ();
                    // Debug.Log ("");
                }
            };
        }

    }
}