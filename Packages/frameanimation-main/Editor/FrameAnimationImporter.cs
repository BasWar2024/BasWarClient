using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.U2D;
using UnityEngine;
using UnityEngine.U2D;

namespace GypsyMagic.FrameAnimation {
    /// <summary>
    /// Clip 
    /// </summary>
    public class FrameAnimationImporter {
        public static string[] AnimationClipName = new string[3] { "idle", "attack", "run" };

        [MenuItem ("Assets/BuildAnimationClips()")]
        public static void BuildAnimationClips () {

            List<string> assetPaths = new List<string> ();

            foreach (UnityEngine.Object obj in Selection.GetFiltered (typeof (UnityEngine.Object), SelectionMode.Assets)) {
                var assetPath = AssetDatabase.GetAssetPath (obj);
                if (Directory.Exists (assetPath)) {
                    assetPaths.Add (assetPath);
                }
            }

            for (int j = 0; j < assetPaths.Count; j++) {

                var fileName = Path.GetFileName (assetPaths[j]);
                var folder = assetPaths[j].Replace (fileName, "");
                var clipFolder = folder + fileName + "_AnimClips/";
                var FrameClips = new List<FrameClip> ();

                //
                CreateAtlasForSelectedSprite (folder, fileName, assetPaths[j]);

                // 
                for (int k = 0; k < AnimationClipName.Length; k++) {
                    var aName = AnimationClipName[k];

                    for (int i = 0; i < 5; i++) { //
                        var dirIndex = i + 1;

                        //
                        List<Sprite> spritePaths = new List<Sprite> ();
                        var splist = AssetDatabase.FindAssets ("t:Sprite " + aName + dirIndex, new string[] { assetPaths[j] });
                        foreach (var item in splist) {
                            var path = AssetDatabase.GUIDToAssetPath (item);

                            spritePaths.Add (AssetDatabase.LoadAssetAtPath<Sprite> (path));
                        }

                        if (spritePaths.Count <= 0)
                            continue;

                        var clip = ScriptableObject.CreateInstance<FrameClip> ();
                        clip.WrapMode = WrapMode.Loop;
                        clip.Frames = spritePaths.ToArray ();
                        FrameClips.Add (clip);

                        Directory.CreateDirectory (clipFolder);

                        AssetDatabase.CreateAsset (clip, clipFolder + fileName + "_" + aName + "_" + dirIndex + "_Clip.asset");
                        AssetDatabase.SaveAssets ();

                    }

                }

                //
                CreateFramePrefab (folder, fileName, FrameClips);

            }

            AssetDatabase.Refresh ();

            // Debug.LogError ("folder " + folder);

        }
        public static void CreateFramePrefab (string path, string fileName, List<FrameClip> clips) {
            if (clips.Count <= 0)
                return;

            var go = new GameObject ();
            go.name = fileName + "_Body";
            var render = go.AddComponent<SpriteRenderer> ();
            var frameA = go.AddComponent<FrameAnimator> ();
            frameA.SetRenderInEditor (render);
            frameA.SetClipsInEditor (clips.ToArray ());
            render.sprite = frameA.Clips[0].Frames[0];

            PrefabUtility.SaveAsPrefabAssetAndConnect (go, path + go.name + ".prefab", InteractionMode.UserAction);
        }
        // 
        public static void CreateAtlasForSelectedSprite (string path, string fileName, string searchPath) {
            var sa = new SpriteAtlas ();

            var splist = AssetDatabase.FindAssets ("t:Sprite ", new string[] { searchPath });
            var objs = new List<Object> ();
            foreach (var item in splist) {
                var spPath = AssetDatabase.GUIDToAssetPath (item);
                var o = AssetDatabase.LoadAssetAtPath<Sprite> (spPath);
                objs.Add (o);
            }

            if (objs.Count <= 0)
                return;

            SpriteAtlasExtensions.Add (sa, objs.ToArray ());

            AssetDatabase.CreateAsset (sa, path + fileName + ".spriteatlas");
            AssetDatabase.SaveAssets ();
            AssetDatabase.Refresh ();
        }

        // item 
        [MenuItem ("Assets/BuildAnimationClips()", true)]
        private static bool CheckRebuildAllExcel () {
            foreach (UnityEngine.Object obj in Selection.GetFiltered (typeof (UnityEngine.Object), SelectionMode.Assets)) {
                if (Directory.Exists (AssetDatabase.GetAssetPath (obj))) {
                    return true;
                }
            }
            return false;
        }
    }
}