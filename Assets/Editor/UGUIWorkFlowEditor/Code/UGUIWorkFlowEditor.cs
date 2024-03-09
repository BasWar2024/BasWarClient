using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Experimental.SceneManagement;
using UnityEngine;
using UnityEngine.UIElements;
using Button = UnityEngine.UIElements.Button;

namespace UGUIWorkFlowEditor.Core {
    public static class CommonString {
        // public const string UIBuilderExprotPath = "Packages/TKDotsFrame/Editor/UGUIWorkFlowEditor/Res/UIBuilderExprot/";
        public const string UIBuilderExprotPath = "Assets/Editor/UGUIWorkFlowEditor/Res/UIBuilderExprot/";
    }

    public class UGUIObjBrowser : EditorWindow {
        static UGUIObjBrowser _win;
        [MenuItem ("Tools/TK_UI_VIEWER")]
        public static void ShowWindow () {
            if (_win == null) {
                _win = GetWindow<UGUIObjBrowser> ("TK_UI_VIEWER");
                _win.maxSize = _win.minSize = new Vector2 (600, 400);
            } else {
                OnReflashWindow ();
            }
        }
        /// <summary>
        /// 
        /// </summary>
        static void OnReflashWindow () { }
        CustomScrollView cScroller; //
        void OnValidate () {
            // OnEnable ();
        }
        // void OnGUI () {
        //     var obj = EditorGUI.ObjectField (new Rect (0, 0, 100, 50), new GUIContent (), null, typeof (object));
        //     if (obj != null) {

        //         Debug.LogError ("CommonString.UIBuilderExprotPath " + AssetDatabase.GetAssetPath (obj));
        //     }
        // }
        public void OnEnable () {

            var asset = AssetDatabase.LoadAssetAtPath<StyleSheet> (CommonString.UIBuilderExprotPath + "UGUIObjBrowser.uss");
            rootVisualElement.styleSheets.Add (asset);
            var tree = AssetDatabase.LoadAssetAtPath<VisualTreeAsset> (CommonString.UIBuilderExprotPath + "UGUIObjBrowser.uxml");
            tree.CloneTree (rootVisualElement);

            // Find Button (with name "#test-button" assigned in UIBuilder)
            var CreatePanel = rootVisualElement.Q<Button> (name: "CreatePanel");
            var CreateItem = rootVisualElement.Q<Button> (name: "CreateItem");
            var ShowUIPanel = rootVisualElement.Q<Button> (name: "ShowUIPanel");
            var ShowUIItem = rootVisualElement.Q<Button> (name: "ShowUIItem");

            var ObjsView = rootVisualElement.Q<VisualElement> (name: "ObjsView");
            var ObjsItemTree = AssetDatabase.LoadAssetAtPath<VisualTreeAsset> (CommonString.UIBuilderExprotPath + "UGUIBrowserItem.uxml");

            //panel
            CreatePanel.clickable.clicked += () => {
                Debug.Log ("CreatePanel button clicked!");
            };

            //Item
            CreateItem.clickable.clicked += () => {
                Debug.Log ("CreateItem button clicked!");
            };

            //UIPanel
            ShowUIPanel.clickable.clicked += () => { };

            //UIItem
            ShowUIItem.clickable.clicked += () => { };

            //
            cScroller = new CustomScrollView (ObjsItemTree);
            ObjsView.Add (cScroller);
            ObjsView.style.flexDirection = FlexDirection.Row;

        }
    }
    class CustomScrollView : ScrollView {
        public CustomScrollView (VisualTreeAsset childAsset) : base (ScrollViewMode.Vertical) {
            style.flexGrow = new StyleFloat (1f);
            for (int i = 0; i < 400; i++) {
                var ObjsItemVE = new VisualElement ();
                childAsset.CloneTree (ObjsItemVE);
                base.contentContainer.Add (ObjsItemVE);
            }
        }
    }
    /// <summary>
    /// UI 
    /// </summary>
    public class UGUIEditorModeWin : EditorWindow {
        static UGUIEditorModeWin _win;
        static ScrollView L_Scroll, R_Scroll;
        static List<GameObject> isLegalSelestionObjs;
        static List<UIAnchorComp> allUIAnchorComps;
        // [MenuItem ("Window/PrefabWindow")]
        /// <summary>
        ///  
        /// </summary>
        public static void ShowWindow () {
            if (_win == null) {
                _win = GetWindow<UGUIEditorModeWin> ("UGUIEditorModeWin");
                _win.maxSize = _win.minSize = new Vector2 (600, 400);
                Selection.selectionChanged += OnSelectChange;
                isLegalSelestionObjs = new List<GameObject> ();
                allUIAnchorComps = new List<UIAnchorComp> ();
                // UIEditorHelper.ErrorEx ("ShowWindow");
                ReflashAllUIAnchorComps ();
            } else {
                OnReflashWindow ();
            }
        }
        /// <summary>
        /// 
        /// </summary>
        static void OnReflashWindow () {
            ReflashAllUIAnchorComps ();
        }
        public static void Clear () {
            if (L_Scroll != null) {
                L_Scroll.ClearClassList ();
                L_Scroll.Clear ();
            }
            if (R_Scroll != null) {
                R_Scroll.ClearClassList ();
                R_Scroll.Clear ();
            }
        }

        void OnDestroy () {
            Selection.selectionChanged -= OnSelectChange;
            // UIEditorHelper.ErrorEx ("OnDestroy");
        }

        /// <summary>
        /// 
        /// </summary>
        static void OnSelectChange () {
            if (!UGUIWorkFlowSceneEditor.IsInUIEditorMode) return;

            // UIEditorHelper.ErrorEx ("OnSelectChange");
            OnReflashWindow ();

            ReflashAllScroll ();
        }
        /// <summary>
        /// 
        /// </summary>
        static void ReflashAllScroll () {
            Clear ();
            Reflash_L_Scroll (Selection.gameObjects);
            Reflash_R_Scroll ();
        }
        static void Reflash_R_Scroll () {
            foreach (var item in allUIAnchorComps) {

                var root = new VisualElement ();
                var btnElement = new VisualElement ();
                var space = new VisualElement ();
                space.style.minHeight = 3; //
                root.Add (space);
                root.Add (btnElement);

                btnElement.style.minHeight = 30;
                btnElement.style.flexDirection = FlexDirection.Row; //
                btnElement.style.backgroundColor = new StyleColor (new Color (0.17f, 0.17f, 0.17f));

                var label = new Label {
                    text = item.name + " | "
                };
                label.style.alignSelf = Align.Center; //
                var btn = new Button {
                    text = "[Remove] UIAnchorComp"
                };

                btn.clickable.clicked += () => {
                    RemoveComponentProess (item);
                    //
                    ReflashAllScroll ();
                };

                var textField = new TextField ();
                textField.value = item.AnchorID;

                btnElement.Add (label);
                btnElement.Add (btn);
                btnElement.Add (textField);

                R_Scroll.contentContainer.Add (root);
            }
        }
        static void Reflash_L_Scroll (GameObject[] golist) {
            isLegalSelestionObjs.Clear ();

            foreach (var item in golist) {
                if (item.hideFlags != HideFlags.None) continue;
                var comp = item.GetComponent<UIAnchorComp> ();
                if (item.hideFlags != HideFlags.None || comp != null) continue;

                isLegalSelestionObjs.Add (item);

                var root = new VisualElement ();
                var btnElement = new VisualElement ();
                var space = new VisualElement ();
                space.style.minHeight = 3; //
                root.Add (space);
                root.Add (btnElement);

                btnElement.style.minHeight = 30;
                btnElement.style.flexDirection = FlexDirection.Row; //
                btnElement.style.backgroundColor = new StyleColor (new Color (0.17f, 0.17f, 0.17f));

                var label = new Label {
                    text = item.name + " | "
                };
                label.style.alignSelf = Align.Center; //
                var btn = new Button {
                    text = "[Add] UIAnchorComp"
                };

                btn.clickable.clicked += () => {
                    AddComponentProcess (item);
                    //
                    ReflashAllScroll ();
                };

                btnElement.Add (label);
                btnElement.Add (btn);

                L_Scroll.contentContainer.Add (root);
            }
        }

        public void OnEnable () {

            // UIEditorHelper.ErrorEx ("OnEnable");

            var asset = AssetDatabase.LoadAssetAtPath<StyleSheet> (CommonString.UIBuilderExprotPath + "Prefabs_WinUss.uss");
            rootVisualElement.styleSheets.Add (asset);
            var tree = AssetDatabase.LoadAssetAtPath<VisualTreeAsset> (CommonString.UIBuilderExprotPath + "PrefabWindow.uxml");
            tree.CloneTree (rootVisualElement);

            var L_ScrollRoot = rootVisualElement.Q<VisualElement> (name: "L_ScrollRoot");
            var R_ScrollRoot = rootVisualElement.Q<VisualElement> (name: "R_ScrollRoot");

            L_Scroll = new ScrollView (ScrollViewMode.Vertical);
            L_ScrollRoot.Add (L_Scroll);

            R_Scroll = new ScrollView (ScrollViewMode.Vertical);
            R_ScrollRoot.Add (R_Scroll);

            // 
            var addAllSelectionsBtn = rootVisualElement.Q<Button> (name: "addAllSelections");

            addAllSelectionsBtn.clickable.clicked += () => {
                foreach (var item in isLegalSelestionObjs) {
                    AddComponentProcess (item);
                }
                //
                ReflashAllScroll ();
            };

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="comp"></param>
        static void RemoveComponentProess (UIAnchorComp comp) {
            allUIAnchorComps.Remove (comp);
            comp.hideFlags = HideFlags.None; //
            var go = comp.gameObject;
            DestroyImmediate (comp);
            EditorUtility.SetDirty (go); //
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="item"></param>
        static void AddComponentProcess (GameObject item) {
            item.AddComponent<UIAnchorComp> ().AnchorID = item.name; //
            EditorUtility.SetDirty (item); //
        }
        /// <summary>
        /// 
        /// </summary>
        public static void ReflashAllUIAnchorComps () {
            if (UGUIWorkFlowSceneEditor.InEditorPerfabsRoot) {
                allUIAnchorComps.Clear ();
                var comps = UGUIWorkFlowSceneEditor.InEditorPerfabsRoot.GetComponentsInChildren<UIAnchorComp> ();
                foreach (var item in comps) {
                    allUIAnchorComps.Add (item);
                }
                //
                ReflashAllScroll ();
            }
        }
    }
    /// <summary>
    /// feature
    /// 1. 
    /// 2. 
    /// 
    /// 3. 
    /// 4. 
    /// 
    /// 5.    perfabs 
    /// 6.  ,
    /// 
    /// </summary>
    public static class UGUIWorkFlowSceneEditor {
        public static bool IsInUIEditorMode;
        public static GameObject InEditorPerfabsRoot; //
        /// <summary>
        /// 
        /// </summary>
        [InitializeOnLoadMethod]
        static void Init () {
            PrefabStage.prefabStageOpened += PrefabModeReactive;
            PrefabStage.prefabStageClosing += PrefabModeClose;
        }
        /// <summary>
        /// 
        /// </summary>
        public static bool CheckContainUIEditorKey (PrefabStage stage) {
            return false;//stage.prefabContentsRoot.name.Contains ("Panel") ||
                //stage.prefabContentsRoot.name.Contains ("Item");
        }
        /// <summary>
        /// 
        /// </summary>
        private static void PrefabModeClose (PrefabStage stage) {
            if (CheckContainUIEditorKey (stage)) {
                UIEditorHelper.ErrorEx (" UI ");
                SceneView.duringSceneGui -= OnSceneGUI;

                //
                stage.prefabContentsRoot.hideFlags = HideFlags.None;
                // Selection.selectionChanged -= OnSelectChange;
                IsInUIEditorMode = false;
                UGUIEditorModeWin.Clear ();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        static void PrefabModeReactive (PrefabStage stage) {
            if (CheckContainUIEditorKey (stage)) {
                UIEditorHelper.ErrorEx (" UI ");
                SceneView.duringSceneGui += OnSceneGUI;

                InEditorPerfabsRoot = stage.prefabContentsRoot;
                //
                InEditorPerfabsRoot.hideFlags = HideFlags.NotEditable;

                SetAllCompsNotEditable<UIAnchorComp> (InEditorPerfabsRoot);
                // Selection.selectionChanged += OnSelectChange;
                IsInUIEditorMode = true;
                UGUIEditorModeWin.Clear ();
                // UGUIEditorModeWin.ShowWindow ();
            }
        }
        /// <summary>
        /// 
        /// </summary>
        public static void SetAllCompsNotEditable<T> (GameObject root) where T : MonoBehaviour {
            var allUIAnchorComps = root.GetComponentsInChildren<T> ();
            foreach (var item in allUIAnchorComps) {
                item.hideFlags = HideFlags.NotEditable;
            }
        }

        /// <summary>
        /// scene 
        /// </summary>
        static void OnSceneGUI (SceneView sceneView) {
            Event e = Event.current;
            //do something

            //
            if (e != null && e.button == 1 && e.type == EventType.MouseUp) {
                var selectObjs = Selection.gameObjects;
                if (selectObjs == null || selectObjs.Length == 0 || selectObjs[0].transform is RectTransform) {
                    UIEditorHelper.ErrorEx ("");
                    ContextMenu.AddCommonItems (selectObjs);
                    ContextMenu.Show ();
                }
            }

            //
            ShieldSecneEvent (e);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="e"></param>
        static void ShieldSecneEvent (Event e) {

            if (e.IsRightMouseButton () || e.IsMiddleMouseButton ()) {
                e.Use ();
            }

            if (e.isKey) {
                // 
                if (e.keyCode == KeyCode.DownArrow || e.keyCode == KeyCode.LeftArrow || e.keyCode == KeyCode.RightArrow || e.keyCode == KeyCode.UpArrow) {
                    e.Use ();
                }
            }

        }
    }
    /// <summary>
    /// 
    /// </summary>
    public static class EventExtension {
        //
        public static bool IsLeftMouseButton (this Event e) {
            return e.isMouse && e.button == 0;
        }
        //
        public static bool IsRightMouseButton (this Event e) {
            return e.isMouse && e.button == 1;
        }
        //
        public static bool IsMiddleMouseButton (this Event e) {
            return e.isMouse && e.button == 2;
        }
    }
}