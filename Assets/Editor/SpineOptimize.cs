#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Spine.Unity;


namespace SpineOptimize {
    public class SpineOptimize {

        [MenuItem("EditorTools/""Spine")]
        static void OptimizeSpine() {
            SetSkeletonAnimationToBirth();
            ExchangeShard();
            SetEffectAnimName_Loop();

            InvertSelectMinMap();
            GameResRoleTx1024();
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            Debug.Log("""！");
        }

        static void SetEffectAnimName_Loop()
        {
            var files = Directory.GetFiles(Application.dataPath + "/Prefabs/Effect", "*.*", SearchOption.AllDirectories).
            Where(s => new List<string>() { ".prefab" }.Contains(Path.GetExtension(s)?.ToLower())).ToArray();

            for (int i = 0; i < files.Length; i++)
            {
                var file = files[i];
                string path = GetAssetPath(file);
                GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);

                EditorUtility.DisplayProgressBar(obj.name, "CheckEffect", (float)i / files.Length);

                Transform spine = obj.transform.Find("Spine");
                if (spine != null)
                {
                    SkeletonAnimation skeletonAnimation = spine.GetComponent<SkeletonAnimation>();

                    if (!skeletonAnimation.loop)
                    {
                        skeletonAnimation.loop = true;
                        PrefabUtility.SavePrefabAsset(obj);
                    }
                }
                //CheckEffSpine(obj);
            }

            //AssetDatabase.SaveAssets();
            //AssetDatabase.Refresh();
            EditorUtility.ClearProgressBar();
        }

        static void SetSkeletonAnimationToBirth() {
            var files = GetAllFiles("Role2D");

            foreach (var file in files) {
                string path = GetAssetPath(file);
                GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                var skeletonAnimation = GetSkeletonAnimation(obj);
                if (skeletonAnimation != null) {
                    var anim = skeletonAnimation.skeletonDataAsset.GetAnimationStateData().SkeletonData.FindAnimation("birth");
                    if (anim != null) {
                        if(skeletonAnimation.AnimationName != "birth") {
                            skeletonAnimation.AnimationName = "birth";
                            PrefabUtility.SavePrefabAsset(obj);
                        }
                    }
                    else {
                        Debug.LogError(path + """birth""");
                    }
                }
            }

            
        }

        static void ExchangeShard() {
            var files = GetAllFiles();

            foreach (var file in files) {
                string path = GetAssetPath(file);
                GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                var skeletonAnimation = GetSkeletonAnimation(obj);
                if (skeletonAnimation != null) {
                    try {
                        var atlasAssets = skeletonAnimation.SkeletonDataAsset.atlasAssets;
                        foreach (var atlas in atlasAssets) {
                            var materials = atlas.Materials;
                            foreach (var value in materials) {
                                if (value != null) {
                                    if (value.shader != Shader.Find("Universal Render Pipeline/Spine/Skeleton")) {
                                        value.shader = Shader.Find("Universal Render Pipeline/Spine/Skeleton");           
                                    }
                                    if(value.enableInstancing == true) {
                                        value.enableInstancing = false;
                                    }                                   
                                    string texturePath = AssetDatabase.GetAssetPath(value.mainTexture);
                                    TextureImporter texture = AssetImporter.GetAtPath(texturePath) as TextureImporter;
                                    if(texture.textureCompression != TextureImporterCompression.Compressed) {
                                        texture.textureCompression = TextureImporterCompression.Compressed;
                                    }
                                    if(texture.mipmapEnabled != false) {
                                        texture.mipmapEnabled = false;
                                    }                                   
                                }
                                else {
                                    Debug.LogError(path + """share""");
                                }

                            }
                        }
                    }
                    catch {
                        Debug.LogError(path + """skeletonAnimation");
                    }
                }
            }
        }

        static void InvertSelectMinMap()
        {

            var gameResFile = Directory.GetFiles(Application.dataPath + "/GameRes", "*.*", SearchOption.AllDirectories).Where(s => s.EndsWith(".png") || s.EndsWith(".jpg"));
            var prefabsFile = Directory.GetFiles(Application.dataPath + "/Prefabs", "*.*", SearchOption.AllDirectories).Where(s => s.EndsWith(".png") || s.EndsWith(".jpg"));

            foreach (var file in gameResFile)
            {
                var path = GetAssetPath(file);
                var textureImporter = TextureImporter.GetAtPath(path) as TextureImporter;
                if (textureImporter.mipmapEnabled)
                {
                    textureImporter.mipmapEnabled = false;
                    AssetDatabase.ImportAsset(path);
                }
            }

            foreach (var file in prefabsFile)
            {
                var path = GetAssetPath(file);
                var textureImporter = TextureImporter.GetAtPath(path) as TextureImporter;
                if (textureImporter.mipmapEnabled)
                {
                    textureImporter.mipmapEnabled = false;
                    AssetDatabase.ImportAsset(path);
                }
            }
        }

        //""3D""1024
        static void GameResRoleTx1024()
        {
            var files = Directory.GetFiles(Application.dataPath + "/GameRes/Role", "*.*", SearchOption.AllDirectories).Where(s => s.EndsWith(".png") || s.EndsWith(".jpg"));

            foreach (var file in files)
            {
                var path = GetAssetPath(file);
                var textureImporter = TextureImporter.GetAtPath(path) as TextureImporter;
                if (textureImporter.maxTextureSize != 1024)
                {
                    textureImporter.maxTextureSize = 1024;
                    AssetDatabase.ImportAsset(path);
                }
            }
        }

        static string[] GetAllFiles(string fileName = "") {
            if (fileName != "") {
                fileName = "/" + fileName;
            }

            var files = Directory.GetFiles(Application.dataPath + "/Prefabs" + fileName, "*.prefab", SearchOption.AllDirectories);

            return files;
        }

        static string GetAssetPath(string fullPath) {
            Regex regex = new Regex(@"Assets.*");
            string path = regex.Match(fullPath).Value;
            path = path.Replace("\\", "/");
            return path;
        }

        static SkeletonAnimation GetSkeletonAnimation(GameObject obj) {
            SkeletonAnimation skeletonAnimation;
            obj.transform.TryGetComponent<SkeletonAnimation>(out skeletonAnimation);
            if (skeletonAnimation == null) {
                var spineObj = obj.transform.Find("Spine");
                if (spineObj == null) {
                    return null;
                }
                skeletonAnimation = spineObj.GetComponent<SkeletonAnimation>();
            }
            return skeletonAnimation;
        }

        [MenuItem("Assets/""JSON")]
        static void CheckHaveJson() {
            var path = AssetDatabase.GetAssetPath(Selection.activeObject);

            var files = Directory.GetFiles(path, "*.json", SearchOption.AllDirectories);

            foreach(var file in files) {
                Debug.Log(file + """json""");
            }
        }
    }
}

#endif