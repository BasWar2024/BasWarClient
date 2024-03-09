using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEngine;
namespace UnityAddressableImporter.Helper.Internal {

    [CustomEditor (typeof (AddressableImportSettings), true), CanEditMultipleObjects]
    public class AddressableImportSettingsEditor : Editor {
        private List<MethodInfo> _methods;
        private AddressableImportSettings _target;

        private void OnEnable () {
            _target = target as AddressableImportSettings;
            if (_target == null) return;

            _methods = AddressableImporterMethodHandler.CollectValidMembers (_target.GetType ());

        }

        private void OnDisable () { }

        public override void OnInspectorGUI () {
            DrawBaseEditor ();

            if (_methods == null) return;
            AddressableImporterMethodHandler.OnInspectorGUI (_target, _methods);

            //
            serializedObject.ApplyModifiedProperties ();
        }

        private void DrawBaseEditor () {
            base.OnInspectorGUI ();
        }
    }
}