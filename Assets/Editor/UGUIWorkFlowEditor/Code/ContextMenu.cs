#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace UGUIWorkFlowEditor.Core {
    static public class ContextMenu {
        static List<string> mEntries = new List<string> ();
        static GenericMenu mMenu;

        static public void AddItem (string item, bool isChecked, GenericMenu.MenuFunction callback) {
            if (callback != null) {
                if (mMenu == null) mMenu = new GenericMenu ();
                int count = 0;

                for (int i = 0; i < mEntries.Count; ++i) {
                    string str = mEntries[i];
                    if (str == item) ++count;
                }
                mEntries.Add (item);

                if (count > 0) item += " [" + count + "]";
                mMenu.AddItem (new GUIContent (item), isChecked, callback);
            } else AddDisabledItem (item);
        }

        static public void AddItemWithArge (string item, bool isChecked, GenericMenu.MenuFunction2 callback, object arge) {
            if (callback != null) {
                if (mMenu == null) mMenu = new GenericMenu ();
                int count = 0;

                for (int i = 0; i < mEntries.Count; ++i) {
                    string str = mEntries[i];
                    if (str == item) ++count;
                }
                mEntries.Add (item);

                if (count > 0) item += " [" + count + "]";
                mMenu.AddItem (new GUIContent (item), isChecked, callback, arge);
            } else AddDisabledItem (item);
        }

        static public void Show () {
            if (mMenu != null) {
                mMenu.ShowAsContext ();
                mMenu = null;
                mEntries.Clear ();
            }
        }

        //
        static public void AddAlignMenu () {
            AddItem ("/ ", false, AlignTool.AlignInHorziontalLeft);
            AddItem ("/ ", false, AlignTool.AlignInHorziontalRight);
            AddItem ("/ ", false, AlignTool.AlignInVerticalUp);
            AddItem ("/ ", false, AlignTool.AlignInVerticalDown);
            AddItem ("/ |||", false, AlignTool.UniformDistributionInHorziontal);
            AddItem ("/ ", false, AlignTool.UniformDistributionInVertical);
            AddItem ("/ ", false, AlignTool.ResizeMax);
            AddItem ("/ ", false, AlignTool.ResizeMin);
        }

        //
        static public void AddPriorityMenu () {
            AddItem ("/ ", false, PriorityTool.MoveToTopWidget);
            AddItem ("/ ", false, PriorityTool.MoveToBottomWidget);
            AddItem ("/ ", false, PriorityTool.MoveUpWidget);
            AddItem ("/ ", false, PriorityTool.MoveDownWidget);
        }

        //UI
        static public void AddUIMenu () {
            AddItem ("/Empty", false, UIEditorHelper.CreateEmpty);
            AddItem ("/Image", false, UIEditorHelper.CreateImage);
            AddItem ("/Button", false, UIEditorHelper.CreateButton);
            AddItem ("/Text", false, UIEditorHelper.CreateText);
            AddItem ("/HorizontalScroll", false, UIEditorHelper.CreateHorizontalScroll);
            AddItem ("/VerticalScroll", false, UIEditorHelper.CreateVerticalScroll);
        }

        //UI
        static public void AddUIComponentMenu () {
            AddItem ("/GridLayout", false, UIEditorHelper.AddGridLayoutGroupComponent);
            AddItem ("/Image", false, UIEditorHelper.AddImageComponent);
        }

        //
        static public void AddShowOrHideMenu () {
            bool hasHideWidget = false;
            foreach (var item in Selection.gameObjects) {
                if (!item.activeSelf) {
                    hasHideWidget = true;
                    break;
                }
            }
            if (hasHideWidget)
                AddItem ("", false, UILayoutTool.ShowAllSelectedWidgets);
            else
                AddItem ("", false, UILayoutTool.HideAllSelectedWidgets);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="targets"></param>
        static public void AddCommonItems (GameObject[] targets) {

            // AddItem ("", false, UIEditorHelper.SavePanel);
            // AddItem ("", false, UIEditorHelper.ReLoadPanel);
            AddItem ("", false, UIEditorHelper.SaveAsPanel);

            AddSeparator ("///");

            // Debug.LogError ("targets ?? " + targets.Length);
            // 
            if (targets.Length == 1) {
                AddUIMenu ();
                AddUIComponentMenu ();
                AddPriorityMenu ();

                if (UIEditorHelper.IsNodeCanDivide (targets[0]))
                    AddItem ("", false, UILayoutTool.UnGroup);
            }

            // 
            if (targets.Length > 1) {
                AddAlignMenu ();
                AddItem ("", false, UILayoutTool.MakeGroup);
            }

            if (targets.Length > 0) {
                AddItem ("", false, UIEditorHelper.DeleteNode);
                AddItem ("", false, UIEditorHelper.DeleteObject);
                if (HasLockObject (targets)) {
                    AddItem ("", false, UIEditorHelper.UnLockWidget);
                } else {
                    AddItem ("", false, UIEditorHelper.LockWidget);
                }
                AddShowOrHideMenu ();
            }

            // AddSeparator ("///");
            // AddItem ("", false, UIEditorHelper.DeleteCurrentLayer);

        }

        static public void AddSeparator (string path) {
            if (mMenu == null) mMenu = new GenericMenu ();

            if (Application.platform != RuntimePlatform.OSXEditor)
                mMenu.AddSeparator (path);
        }

        static public void AddDisabledItem (string item) {
            if (mMenu == null) mMenu = new GenericMenu ();
            mMenu.AddDisabledItem (new GUIContent (item));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objects"></param>
        /// <returns></returns>
        static bool HasLockObject (GameObject[] objects) {
            for (int i = 0; i < objects.Length; i++) {
                if (objects[i].hideFlags == HideFlags.NotEditable) {
                    return true;
                }
            }
            return false;
        }
    }
}
#endif