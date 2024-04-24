using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

namespace TKDotsFrame.Editor {

#if !UNITY_EDITOR_OSX
    /// <summary>
    /// ""
    /// </summary>
    public class GetScreenInfo {

        [DllImport ("GetScreenResolution")]
        public static extern int GetScreenWidth ();
        [DllImport ("GetScreenResolution")]
        public static extern int GetScreenHeight ();
    }
#endif
    public class AssetsCheckProcessingWindow : EditorWindow {
        static AssetsCheckProcessingWindow window;
        static Queue<string> AllUnIllegal = new Queue<string> ();
        static List<string> tempList = new List<string> ();
        private GUILayoutOption labelHeigh = GUILayout.Height (25);
        string newFileName = "";

        public static void CreateWindowOrProcessing (string sourcePath = null) {
            if (window == null) {

                window = ScriptableObject.CreateInstance (typeof (AssetsCheckProcessingWindow)) as AssetsCheckProcessingWindow;
#if !UNITY_EDITOR_OSX
                int width = 1200;
                int height = 500;
                window.position = new Rect (GetScreenInfo.GetScreenWidth () / 2 - width / 2, GetScreenInfo.GetScreenHeight () / 2 - height / 2, width, height);
#endif
                window.titleContent = new GUIContent ("""");
                //""
                window.ShowPopup ();
                //""F
                // AllUnIllegal = new Queue<string> ();
                // Debug.LogError ("""window");
            }
            if (string.IsNullOrEmpty (sourcePath)) {
                return;
            }
            AllUnIllegal.Enqueue (sourcePath);
        }
        void OnGUI () {
            GUILayout.Space (40);

            EditorGUILayout.LabelField (AssetsImporterSystemSetting.tipsStr, GUILayout.Height (120));

            GUILayout.Space (20);

            if (AllUnIllegal != null && AllUnIllegal.Count > 0) {
                //""
                var sourcePath = AllUnIllegal.Peek ();
                // Debug.LogError ("sourcePath " + sourcePath + " AllUnIllegal.length " + AllUnIllegal.Count);
                EditorGUILayout.LabelField (""": ", sourcePath, labelHeigh);
                newFileName = EditorGUILayout.TextField (""": ", newFileName, labelHeigh);
                var isFile = Path.GetExtension (sourcePath) != "";
                if (Regex.IsMatch (newFileName, AssetsImporterSystemSetting.pattern)) {
                    var curFileName = Path.GetFileNameWithoutExtension (sourcePath);
                    var newPath = sourcePath.Replace (curFileName, newFileName);

                    if (!AssetsImporterSystemSetting.isExistsFileOrFolder (newPath, isFile)) {
                        if (GUILayout.Button ("Next", labelHeigh)) {
                            Debug.Log ("sourcePath  : " + sourcePath + "/// newPath  : " + newPath);
                            AssetDatabase.RenameAsset (sourcePath, newFileName);
                            AssetDatabase.Refresh ();
                            AssetDatabase.SaveAssets ();
                            AllUnIllegal.Dequeue ();
                            // Debug.LogError ("work??? ");
                        }
                    } else {
                        EditorGUILayout.LabelField (" =============""============= ", labelHeigh);
                    }
                } else {
                    EditorGUILayout.LabelField (" =============""============= ", labelHeigh);
                }
            } else {

                if (GUILayout.Button ("Close", labelHeigh)) {
                    AllUnIllegal.Clear ();
                    Close ();
                }
            }

        }

        public static bool IsHasUnIllegalAssets () {
            if (AllUnIllegal == null) {
                AllUnIllegal = new Queue<string> ();
            }
            if (window == null && AllUnIllegal.Count > 0) {
                return true;
            }
            return false;
        }

        public static void AddToTempList (string path) {
            tempList.Add (path);
        }
        public static bool isTempListContains (string path) {
            return tempList.Contains (path);
        }

        void OnDisable () {
            // Debug.LogError ("OnDisable");
            AssetDatabase.SaveAssets ();
            AssetDatabase.Refresh ();
        }

#if !UNITY_EDITOR_OSX
        private void OnLostFocus () {
            Debug.LogError (""" """);
            Focus ();
        }
#endif

        void OnInspectorUpdate () {
            Repaint ();
        }
    }
}