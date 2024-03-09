using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using static UnityEngine.RectTransform;

namespace UGUIWorkFlowEditor.Core {
    public static class UIEditorHelper {
        public static GameObject EditorNode;
        public static Camera EditorCamera;
        public static Canvas EditorCanvas;
        public static Transform CurLayer;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="assetPath"></param>
        /// <param name="image"></param>
        /// <param name="isNativeSize"></param>
        public static void SetImageByPath (string assetPath, Image image, bool isNativeSize = true) {
            Object newImg = UnityEditor.AssetDatabase.LoadAssetAtPath (assetPath, typeof (Sprite));
            Undo.RecordObject (image, "Change Image"); // ctrl+z
            image.sprite = newImg as Sprite;
            if (isNativeSize)
                image.SetNativeSize ();
            EditorUtility.SetDirty (image);
        }

        /// <summary>
        /// UI
        /// </summary>
        /// <returns></returns>
        public static GameObject GetUIEditorNode () {
            // EditorNode = GameObject.Find (UGUIEditorConfig.EditorNodePrefabName);
            // // Node
            // if (!EditorNode) {
            //     var prefab = AssetDatabase.LoadAssetAtPath (UGUIEditorConfig.EditorNodeAssetPath, typeof (GameObject));
            //     if (prefab == null) {
            //         ErrorEx (":  " + UGUIEditorConfig.EditorNodeAssetPath + " ");
            //     }
            //     EditorNode = GameObject.Instantiate (prefab, Vector3.zero, Quaternion.identity) as GameObject;
            //     EditorNode.name = UGUIEditorConfig.EditorNodePrefabName;
            // }

            // EditorCamera = EditorNode.transform.Find (UGUIEditorConfig.EditorCameraName).GetComponent<Camera> ();
            // EditorCanvas = EditorNode.transform.Find (UGUIEditorConfig.EditorCanvasName).GetComponent<Canvas> ();

            return EditorNode;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="isPrefba"></param>
        /// <returns></returns>
        public static Transform GetRootLayer (bool isPrefba = false) {
            if (EditorCanvas == null) {
                GetUIEditorNode ();
            }

            if (isPrefba) {
                return EditorCanvas.transform;
            } else {

                if (CurLayer == null) {
                    CurLayer = EditorCanvas.transform.Find ("Layer");

                    // PrefabLayer 
                    if (CurLayer == null) {
                        var layer = new GameObject ("Layer");
                        var canvasRect = EditorCanvas.transform.GetComponent<RectTransform> ();

                        layer.transform.SetParent (EditorCanvas.transform);
                        layer.transform.localPosition = Vector3.zero;
                        layer.transform.localScale = Vector3.one;
                        var layerRect = layer.AddComponent<RectTransform> ();
                        layerRect.anchorMin = Vector2.zero;
                        layerRect.anchorMax = Vector2.one;
                        layerRect.pivot = Vector2.one * 0.5f;
                        layerRect.offsetMax = Vector2.zero;
                        layerRect.offsetMin = Vector2.zero;

                        CurLayer = layer.transform;

                    }
                }
                return CurLayer;
            }
        }

        /// <summary>
        ///  ()
        /// </summary>
        public static void SavePanel () {
            SavePanel (null, false);
        }

        /// <summary>
        ///  ... ()
        /// </summary>
        public static void SaveAsPanel () {
            SavePanel (null, true);
        }

        /// <summary>
        /// 
        /// </summary>
        static void SavePanel (GameObject obj, bool isSaveAs) {
            var saveObject = obj == null ? FindSelectObjectRoot () : obj;
            if (saveObject == null) {
                return;
            }

            ErrorEx (": " + saveObject);

            var saveed = false;
            // 
            if (PrefabUtility.IsPartOfPrefabInstance (saveObject) && !isSaveAs) {
                var asset = PrefabUtility.GetCorrespondingObjectFromSource (saveObject);
                var assetPath = AssetDatabase.GetAssetPath (asset);
                if (string.IsNullOrEmpty (assetPath)) {
                    EditorUtility.DisplayDialog ("", ",", "");
                    return;
                }
                // 
                PrefabUtility.SaveAsPrefabAsset (saveObject, assetPath, out saveed);
            } else {
                var savePath = EditorUtility.SaveFilePanel ("", "", "PrefabName", "prefab");
                savePath = FileUtil.GetProjectRelativePath (savePath);
                if (string.IsNullOrEmpty (savePath)) {
                    EditorUtility.DisplayDialog ("", "", "");
                    return;
                }
                var fileName = System.IO.Path.GetFileNameWithoutExtension (savePath);
                saveObject.name = fileName;

                // 
                PrefabUtility.SaveAsPrefabAssetAndConnect (saveObject, savePath, InteractionMode.AutomatedAction);

                saveed = true;
            }

            // 
            AssetDatabase.Refresh ();

            EditorUtility.DisplayDialog ("", saveed? "": "", "");
        }

        /// <summary>
        /// 
        /// </summary>
        public static void CreateNewPanel () {
            Selection.activeGameObject = GetRootLayer ().gameObject;
        }

        /// <summary>
        /// 
        /// </summary>
        public static void OpenPrefabPanel () {
            string select_path = EditorUtility.OpenFilePanel ("", "", "prefab");

            // Asset
            string asset_relate_path = select_path;
            if (!select_path.StartsWith ("Assets/"))
                asset_relate_path = FileUtil.GetProjectRelativePath (select_path);

            if (asset_relate_path.Length > 0) {
                var prefab = AssetDatabase.LoadAssetAtPath (asset_relate_path, typeof (GameObject));
                if (prefab == null) {
                    ErrorEx (": " + select_path + "  ");
                    return;
                }

                var loadPanel = GetAssetPathPrefabInstance (asset_relate_path);
                if (loadPanel != null) {
                    ReLoadPrefabsInstance (loadPanel);
                } else {
                    CreatePrefabInstance (prefab, true);
                }
            }
        }

        /// <summary>
        /// PanelObject
        /// </summary>
        /// <param name="assetPath"></param>
        /// <returns></returns>
        public static GameObject GetAssetPathPrefabInstance (string assetPath) {
            if (EditorCanvas == null || EditorCanvas.transform.childCount == 0) {
                return null;
            } else {
                for (int i = 0; i < EditorCanvas.transform.childCount; i++) {
                    var child = EditorCanvas.transform.GetChild (i).gameObject;

                    if (PrefabUtility.IsPartOfPrefabInstance (child)) {
                        var path = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot (child);
                        if (path.Length > 0 && path == assetPath) {
                            return child;
                        }
                    }
                }
            }
            return null;
        }

        /// <summary>
        ///  
        /// </summary>
        /// <param name="prefab"></param>
        public static void CreatePrefabInstance (Object prefab, bool isPrefabAsset = false) {
            var prefabInstance = PrefabUtility.InstantiatePrefab (prefab, UIEditorHelper.GetRootLayer (isPrefabAsset)) as GameObject;

            // 
            Undo.RegisterCreatedObjectUndo (prefabInstance, "create PrefabInstance");

            // 
            prefabInstance.transform.localPosition = Vector3.zero;
            prefabInstance.name = prefab.name;

            // Layer
            if (isPrefabAsset)
                UIEditorHelper.CurLayer = prefabInstance.transform;

            // 
            Selection.activeGameObject = prefabInstance;
        }

        /// <summary>
        ///  ()
        /// </summary>
        public static void ReLoadPanel () {
            ReLoadPrefabsInstance (null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="prefabInstance"></param>
        public static void ReLoadPrefabsInstance (GameObject prefabInstance) {
            var obj = prefabInstance == null ? FindSelectObjectRoot () : prefabInstance;
            if (obj == null || !PrefabUtility.IsPartOfPrefabInstance (obj)) {
                return;
            }

            var isReload = EditorUtility.DisplayDialog ("", ",", "", "");
            if (isReload) {
                var path = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot (obj);
                if (!string.IsNullOrEmpty (path)) {
                    Undo.DestroyObjectImmediate (obj);

                    var prefab = AssetDatabase.LoadAssetAtPath (path, typeof (Object));
                    CreatePrefabInstance (prefab, true);
                } else {
                    ErrorEx ("");
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public static void DeleteObject () {
            var selectObjs = Selection.gameObjects;
            if (selectObjs == null || selectObjs.Length == 0) {
                return;
            }

            // var isDeleteObj = EditorUtility.DisplayDialog ("", "", "", "");
            // if (isDeleteObj) {
            for (int i = 0; i < selectObjs.Length; i++) {
                var obj = selectObjs[i];

                // Unity  
                var isPrefabInstance = PrefabUtility.IsPartOfPrefabInstance (obj);
                if (isPrefabInstance) {
                    EditorUtility.DisplayDialog ("", "", "");
                    return;
                }

                Undo.DestroyObjectImmediate (obj);
            }
            // }
        }

        /// <summary>
        /// Layer
        /// </summary>
        public static void DeleteCurrentLayer () {
            if (CurLayer == null) {
                EditorUtility.DisplayDialog ("", "UI", "");
            } else {
                var isDeleteLayer = EditorUtility.DisplayDialog ("", "", "", "");
                if (isDeleteLayer) {
                    var selectLayer = UIEditorHelper.FindSelectObjectRoot ();
                    if (selectLayer == null) {
                        selectLayer = CurLayer.gameObject;
                    }

                    Undo.DestroyObjectImmediate (selectLayer.gameObject);

                    // 
                    if (CurLayer == null) {
                        if (EditorNode != null && EditorCanvas.transform.childCount > 0) {
                            CurLayer = EditorCanvas.transform.GetChild (EditorCanvas.transform.childCount - 1);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public static void DeleteNode () {
            if (EditorNode == null) {
                EditorUtility.DisplayDialog ("", "UI", "");
            } else {
                var isDeleteNode = EditorUtility.DisplayDialog ("", "", "", "");
                if (isDeleteNode) {
                    Undo.DestroyObjectImmediate (EditorNode);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static bool IsNodeCanDivide (GameObject obj) {
            if (obj == null)
                return false;
            return obj.transform != null && obj.transform != EditorCanvas && obj.transform.parent != EditorCanvas && obj.transform.childCount > 0 && obj.transform.parent != null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static Transform GetContainerUnderMouse (Vector3 mouse_abs_pos, GameObject ignore_obj = null) {
            if (CurLayer == null) {
                return null;
            } else {
                if (ignore_obj != CurLayer.gameObject) {
                    Vector3[] corners = new Vector3[4];
                    RectTransform rect = CurLayer.transform as RectTransform;
                    if (rect != null) {
                        // 
                        rect.GetWorldCorners (corners);
                        if (mouse_abs_pos.x >= corners[0].x && mouse_abs_pos.y <= corners[1].y && mouse_abs_pos.x <= corners[2].x && mouse_abs_pos.y >= corners[3].y) {
                            return CurLayer;
                        }
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static GameObject FindSelectObjectRoot () {
            if (Selection.gameObjects == null || Selection.gameObjects.Length == 0) return null;

            var parents = Selection.activeGameObject.transform.GetComponentsInParent<Transform> ();
            for (int i = 0; i < parents.Length; i++) {
                var parent = parents[i];
                if (parent.parent == EditorCanvas.transform) {
                    return parent.gameObject;
                }
            }
            return null;
        }

        /// <summary>
        ///  ()
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static Bounds GetBounds (GameObject obj) {
            var bounds = default (Bounds);
            RectTransform[] rectTrans = obj.GetComponentsInChildren<RectTransform> ();
            for (int i = 0; i < rectTrans.Length; i++) {
                var corner = new Vector3[4];
                rectTrans[i].GetWorldCorners (corner);
                for (int j = 0; j < corner.Length; j++) {
                    bounds.Encapsulate (corner[j]);
                }
            }
            return bounds;
        }

        /// <summary>
        /// 
        /// </summary>
        public static void LockWidget () {
            var selectionObjs = Selection.gameObjects;
            if (selectionObjs != null && selectionObjs.Length > 0) {
                for (int i = 0; i < selectionObjs.Length; i++) {
                    selectionObjs[0].hideFlags = HideFlags.NotEditable;
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public static void UnLockWidget () {
            var selectionObjs = Selection.gameObjects;
            if (selectionObjs != null && selectionObjs.Length > 0) {
                for (int i = 0; i < selectionObjs.Length; i++) {
                    selectionObjs[0].hideFlags = HideFlags.None;
                }
            }
        }

        /// <summary>
        ///  
        /// </summary>
        public static void CreateEmpty () {
            if (Selection.activeGameObject == null) return;

            var selectObject = Selection.activeGameObject;

            var go = new GameObject (CommonHelper.GenerateUniqueName (Selection.activeGameObject, "GameObject"));
            go.transform.SetParent (selectObject.transform);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            go.AddComponent<RectTransform> ();

            Selection.activeGameObject = go;
        }

        /// <summary>
        ///  Image 
        /// </summary>
        public static void CreateImage () {
            if (Selection.activeGameObject == null) return;

            var selectObject = Selection.activeGameObject;

            var go = new GameObject (CommonHelper.GenerateUniqueName (Selection.activeGameObject, "Image"));
            go.transform.SetParent (selectObject.transform);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            var component = go.AddComponent<Image> ();
            component.raycastTarget = false;
            component.SetNativeSize ();

            Selection.activeGameObject = go;
        }

        /// <summary>
        ///  Button 
        /// </summary>
        public static void CreateButton () {
            if (Selection.activeGameObject == null) return;

            var selectObject = Selection.activeGameObject;

            bool isOk = EditorApplication.ExecuteMenuItem ("GameObject/UI/Button");
            if (isOk) {
                var createObject = Selection.activeGameObject;
                createObject.name = CommonHelper.GenerateUniqueName (createObject, "Button");
                createObject.transform.SetParent (selectObject.transform, false);
                var textComponent = createObject.transform.Find ("Text").GetComponent<Text> ();
                textComponent.raycastTarget = false;
            }
        }

        /// <summary>
        ///  Text 
        /// </summary>
        public static void CreateText () {
            if (Selection.activeGameObject == null) return;

            var selectObject = Selection.activeGameObject;

            var go = new GameObject (CommonHelper.GenerateUniqueName (Selection.activeGameObject, "Text"));
            go.transform.SetParent (selectObject.transform);
            go.transform.localPosition = Vector3.zero;
            go.transform.localScale = Vector3.one;
            var component = go.AddComponent<Text> ();
            component.raycastTarget = false;
            component.SetNativeSize ();

            Selection.activeGameObject = go;
        }

        /// <summary>
        /// Layout
        /// </summary>
        public static void AddGridLayoutGroupComponent () {
            if (Selection.activeGameObject == null)
                return;
            Selection.activeGameObject.AddComponent<GridLayoutGroup> ();
        }

        /// <summary>
        /// Image
        /// </summary>
        public static void AddImageComponent () {
            if (Selection.activeGameObject == null)
                return;
            Selection.activeGameObject.AddComponent<Image> ();
        }

        /// <summary>
        /// 
        /// </summary>
        public static void CreateHorizontalScroll () {
            if (Selection.activeGameObject == null) return;

            var selectObject = Selection.activeGameObject;

            bool isOk = EditorApplication.ExecuteMenuItem ("GameObject/UI/Scroll View");
            if (isOk) {
                var createObject = Selection.activeGameObject;
                createObject.name = CommonHelper.GenerateUniqueName (createObject, "HorizontalScrollView");
                createObject.transform.SetParent (selectObject.transform, false);
                InitScrollView (true);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public static void CreateVerticalScroll () {
            if (Selection.activeGameObject == null) return;

            var selectObject = Selection.activeGameObject;

            bool isOk = EditorApplication.ExecuteMenuItem ("GameObject/UI/Scroll View");
            if (isOk) {
                var createObject = Selection.activeGameObject;
                createObject.name = CommonHelper.GenerateUniqueName (createObject, "VerticalScrollView");
                createObject.transform.SetParent (selectObject.transform, false);
                InitScrollView (true);
            }
        }

        /// <summary>
        ///  ScrollView 
        /// </summary>
        /// <param name="isHorizontal"></param>
        static void InitScrollView (bool isHorizontal) {
            ScrollRect scroll = Selection.activeTransform.GetComponent<ScrollRect> ();
            if (scroll == null)
                return;
            Image img = Selection.activeTransform.GetComponent<Image> ();
            if (img != null)
                Object.DestroyImmediate (img);
            scroll.horizontal = isHorizontal;
            scroll.vertical = !isHorizontal;
            scroll.horizontalScrollbar = null;
            scroll.verticalScrollbar = null;
            Transform horizontalObj = Selection.activeTransform.Find ("Scrollbar Horizontal");
            if (horizontalObj != null)
                GameObject.DestroyImmediate (horizontalObj.gameObject);
            Transform verticalObj = Selection.activeTransform.Find ("Scrollbar Vertical");
            if (verticalObj != null)
                GameObject.DestroyImmediate (verticalObj.gameObject);
            RectTransform viewPort = Selection.activeTransform.Find ("Viewport") as RectTransform;
            if (viewPort != null) {
                viewPort.offsetMin = new Vector2 (0, 0);
                viewPort.offsetMax = new Vector2 (0, 0);
            }
        }

        // ========================================PrefabWin========================================

        static public string ObjectToGUID (UnityEngine.Object obj) {
            string path = AssetDatabase.GetAssetPath (obj);
            return (!string.IsNullOrEmpty (path)) ? AssetDatabase.AssetPathToGUID (path) : null;
        }

        static MethodInfo s_GetInstanceIDFromGUID;
        static public UnityEngine.Object GUIDToObject (string guid) {
            if (string.IsNullOrEmpty (guid)) return null;

            if (s_GetInstanceIDFromGUID == null)
                s_GetInstanceIDFromGUID = typeof (AssetDatabase).GetMethod ("GetInstanceIDFromGUID", BindingFlags.Static | BindingFlags.NonPublic);

            if (s_GetInstanceIDFromGUID == null) return null;

            int id = (int) s_GetInstanceIDFromGUID.Invoke (guid, new object[] { guid });
            if (id != 0) return EditorUtility.InstanceIDToObject (id);
            string path = AssetDatabase.GUIDToAssetPath (guid);
            if (string.IsNullOrEmpty (path)) return null;
            return AssetDatabase.LoadAssetAtPath (path, typeof (UnityEngine.Object));
        }

        static public T GUIDToObject<T> (string guid) where T : UnityEngine.Object {
            UnityEngine.Object obj = GUIDToObject (guid);
            if (obj == null) return null;

            System.Type objType = obj.GetType ();
            if (objType == typeof (T) || objType.IsSubclassOf (typeof (T))) return obj as T;

            if (objType == typeof (GameObject) && typeof (T).IsSubclassOf (typeof (Component))) {
                GameObject go = obj as GameObject;
                return go.GetComponent (typeof (T)) as T;
            }
            return null;
        }

        public static Texture2D LoadTextureInLocal (string file_path) {
            //
            FileStream fileStream = new FileStream (file_path, FileMode.Open, FileAccess.Read);
            fileStream.Seek (0, SeekOrigin.Begin);
            //
            byte[] bytes = new byte[fileStream.Length];
            //
            fileStream.Read (bytes, 0, (int) fileStream.Length);
            //
            fileStream.Close ();
            fileStream.Dispose ();
            fileStream = null;

            //Texture
            int width = 300;
            int height = 372;
            Texture2D texture = new Texture2D (width, height);
            texture.LoadImage (bytes);
            return texture;
        }

        public static Texture GetAssetPreview (GameObject obj) {
            GameObject canvas_obj = null;
            GameObject clone = GameObject.Instantiate (obj);
            Transform cloneTransform = clone.transform;
            bool isUINode = false;
            if (cloneTransform is RectTransform) {
                //UGUICanvas
                canvas_obj = new GameObject ("render canvas", typeof (Canvas));
                Canvas canvas = canvas_obj.GetComponent<Canvas> ();
                cloneTransform.SetParent (canvas_obj.transform);
                cloneTransform.localPosition = Vector3.zero;

                canvas_obj.transform.position = new Vector3 (-1000, -1000, -1000);
                canvas_obj.layer = 21; //21
                isUINode = true;
            } else
                cloneTransform.position = new Vector3 (-1000, -1000, -1000);

            Transform[] all = clone.GetComponentsInChildren<Transform> ();
            foreach (Transform trans in all) {
                trans.gameObject.layer = 21;
            }

            Bounds bounds = GetBounds (clone);
            Vector3 Min = bounds.min;
            Vector3 Max = bounds.max;
            GameObject cameraObj = new GameObject ("render camera");

            Camera renderCamera = cameraObj.AddComponent<Camera> ();
            renderCamera.backgroundColor = new Color (0.8f, 0.8f, 0.8f, 1f);
            renderCamera.clearFlags = CameraClearFlags.Color;
            renderCamera.cameraType = CameraType.Preview;
            renderCamera.cullingMask = 1 << 21;
            if (isUINode) {
                cameraObj.transform.position = new Vector3 ((Max.x + Min.x) / 2f, (Max.y + Min.y) / 2f, cloneTransform.position.z - 100);
                Vector3 center = new Vector3 (cloneTransform.position.x + 0.01f, (Max.y + Min.y) / 2f, cloneTransform.position.z); //+0.01fUnity0
                cameraObj.transform.LookAt (center);

                renderCamera.orthographic = true;
                float width = Max.x - Min.x;
                float height = Max.y - Min.y;
                float max_camera_size = width > height ? width : height;
                renderCamera.orthographicSize = max_camera_size / 2; //
            } else {
                cameraObj.transform.position = new Vector3 ((Max.x + Min.x) / 2f, (Max.y + Min.y) / 2f, Max.z + (Max.z - Min.z));
                Vector3 center = new Vector3 (cloneTransform.position.x + 0.01f, (Max.y + Min.y) / 2f, cloneTransform.position.z);
                cameraObj.transform.LookAt (center);

                int angle = (int) (Mathf.Atan2 ((Max.y - Min.y) / 2, (Max.z - Min.z)) * 180 / 3.1415f * 2);
                renderCamera.fieldOfView = angle;
            }
            RenderTexture texture = new RenderTexture (128, 128, 0, RenderTextureFormat.Default);
            renderCamera.targetTexture = texture;

            Undo.DestroyObjectImmediate (cameraObj);
            Undo.PerformUndo (); //UndoRenderUI3DCanvas
            renderCamera.RenderDontRestore ();
            RenderTexture tex = new RenderTexture (128, 128, 0, RenderTextureFormat.Default);
            Graphics.Blit (texture, tex);

            Object.DestroyImmediate (canvas_obj);
            Object.DestroyImmediate (cameraObj);
            return tex;
        }

        public static bool SaveTextureToPNG (Texture inputTex, string save_file_name) {
            RenderTexture temp = RenderTexture.GetTemporary (inputTex.width, inputTex.height, 0, RenderTextureFormat.ARGB32);
            Graphics.Blit (inputTex, temp);
            bool ret = SaveRenderTextureToPNG (temp, save_file_name);
            RenderTexture.ReleaseTemporary (temp);
            return ret;
        }

        /// <summary>
        /// RenderTexturepng
        /// </summary>
        /// <param name="rt"></param>
        /// <param name="save_file_name"></param>
        /// <returns></returns>  
        public static bool SaveRenderTextureToPNG (RenderTexture rt, string save_file_name) {
            RenderTexture prev = RenderTexture.active;
            RenderTexture.active = rt;
            Texture2D png = new Texture2D (rt.width, rt.height, TextureFormat.ARGB32, false);
            png.ReadPixels (new Rect (0, 0, rt.width, rt.height), 0, 0);
            byte[] bytes = png.EncodeToPNG ();
            string directory = Path.GetDirectoryName (save_file_name);
            if (!Directory.Exists (directory))
                Directory.CreateDirectory (directory);
            FileStream file = File.Open (save_file_name, FileMode.Create);
            BinaryWriter writer = new BinaryWriter (file);
            writer.Write (bytes);
            file.Close ();
            Texture2D.DestroyImmediate (png);
            png = null;
            RenderTexture.active = prev;
            return true;
        }

        static Texture2D mBackdropTex;
        static public Texture2D backdropTexture {
            get {
                if (mBackdropTex == null) mBackdropTex = CreateCheckerTex (
                    new Color (0.1f, 0.1f, 0.1f, 0.5f),
                    new Color (0.2f, 0.2f, 0.2f, 0.5f));
                return mBackdropTex;
            }
        }

        static Texture2D CreateCheckerTex (Color c0, Color c1) {
            Texture2D tex = new Texture2D (16, 16);
            tex.name = "[Generated] Checker Texture";
            tex.hideFlags = HideFlags.DontSave;

            for (int y = 0; y < 8; ++y)
                for (int x = 0; x < 8; ++x) tex.SetPixel (x, y, c1);
            for (int y = 8; y < 16; ++y)
                for (int x = 0; x < 8; ++x) tex.SetPixel (x, y, c0);
            for (int y = 0; y < 8; ++y)
                for (int x = 8; x < 16; ++x) tex.SetPixel (x, y, c0);
            for (int y = 8; y < 16; ++y)
                for (int x = 8; x < 16; ++x) tex.SetPixel (x, y, c1);

            tex.Apply ();
            tex.filterMode = FilterMode.Point;
            return tex;
        }

        static public void DrawTiledTexture (Rect rect, Texture tex) {
            GUI.BeginGroup (rect); {
                int width = Mathf.RoundToInt (rect.width);
                int height = Mathf.RoundToInt (rect.height);

                for (int y = 0; y < height; y += tex.height) {
                    for (int x = 0; x < width; x += tex.width) {
                        GUI.DrawTexture (new Rect (x, y, tex.width, tex.height), tex);
                    }
                }
            }
            GUI.EndGroup ();
        }

        public static void LogEX (string log) {
            // if (UGUIEditorConfig.EnableDebug && SceneEditorConfigContorller.config.EnableDebug)
            Debug.Log (log);
        }

        public static void ErrorEx (string error) {
            // if (UGUIEditorConfig.EnableDebug && SceneEditorConfigContorller.config.EnableDebug)
            Debug.LogError (error);
        }
    }
}