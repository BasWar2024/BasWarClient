using System;
using System.Collections.Generic;
using UnityEditor.AddressableAssets.Build;
using UnityEditor.AddressableAssets.Build.DataBuilders;
using UnityEngine;
using UnityEngine.ResourceManagement.ResourceProviders;
namespace TKDotsFrame.Editor {
    [CreateAssetMenu (fileName = "CustomBuildMode.asset", menuName = "Addressables/Custom Builders/CustomBuildMode")]
    public class CustomBuildMode : BuildScriptPackedMode {
        public override string Name { get { return """ab ""ab""log"""; } }
        protected override TResult DoBuild<TResult> (AddressablesDataBuilderInput builderInput, AddressableAssetsBuildContext aaContext) {
            TResult opResult = base.DoBuild<TResult> (builderInput, aaContext);
            var groups = aaContext.Settings.groups;
            for (int i = 0; i < groups.Count; i++) {
                List<string> bundles;
                if (aaContext.assetGroupToBundles.TryGetValue (groups[i], out bundles)) {
                    var locations = aaContext.locations;
                    for (int j = 0; j < locations.Count; j++) {
                        if (locations[j].Data != null) {
                            var d = locations[j].Data as AssetBundleRequestOptions;
                            if (d != null) {
                                for (int k = 0; k < bundles.Count; k++) {
                                    if (d.BundleName == bundles[k]) {
                                        Debug.Log (string.Format (" "":<color=#FF0000> {0} </color>"" <color=#00FF00> {1} b</color> ,bundlename is : <color=#0000FF> {2} </color> ", groups[i].name, d.BundleSize, bundles[k]));
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return opResult;
        }
    }
}