using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityAddressableImporter.Helper;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEngine;

namespace UnityAddressableImporter {

    [CreateAssetMenu (fileName = "AddressableImportSettings", menuName = "Addressable Assets/Import Settings", order = 50)]
    public class AddressableImportSettings : ScriptableObject {
        public const string kDefaultConfigObjectName = "addressableimportsettings";
        public const string kDefaultPath = "Assets/Editor/AddressableImportSettings.asset";

        [Tooltip ("")]
        public bool allowGroupCreation = false;

        public List<AddressableImportRule> rules;

        [ButtonMethod]
        public void Save () {
            AssetDatabase.SaveAssets ();
        }

        [ButtonMethod]
        public void CleanEmptyGroup () {
            var settings = AddressableAssetSettingsDefaultObject.Settings;
            if (settings == null) {
                return;
            }
            var dirty = false;
            var emptyGroups = settings.groups.Where (x => x.entries.Count == 0 && !x.IsDefaultGroup ()).ToArray (); //
            for (var i = 0; i < emptyGroups.Length; i++) {
                dirty = true;
                settings.RemoveGroup (emptyGroups[i]);
            }
            if (dirty) {
                AssetDatabase.SaveAssets ();
            }
        }

        public static AddressableImportSettings Instance {
            get {
                AddressableImportSettings so;
                // Try to locate settings via EditorBuildSettings.
                if (!EditorBuildSettings.TryGetConfigObject (kDefaultConfigObjectName, out so)) //
                {
                    //
                    AssetDatabase.CreateAsset (new AddressableImportSettings (), kDefaultPath);
                }
                // Try to locate settings via path.
                so = AssetDatabase.LoadAssetAtPath<AddressableImportSettings> (kDefaultPath); //
                if (so != null) {
                    EditorBuildSettings.AddConfigObject (kDefaultConfigObjectName, so, true);
                } else {
                    Debug.LogWarning ("\n: " + kDefaultPath);
                }

                return so;
            }
        }
    }
}