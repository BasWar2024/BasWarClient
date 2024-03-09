using UnityEditor;
using UnityEngine;

namespace GypsyMagic.FrameAnimation {
    [CustomEditor (typeof (FrameClip))]
    public class FrameClipEditor : Editor {
        private FrameClip _frameClip;
        private LoopClipPlayer _player;
        private double _timestamp;

        private void OnEnable () {
            _frameClip = target as FrameClip;
            _player = new LoopClipPlayer (_frameClip);
            _timestamp = EditorApplication.timeSinceStartup;
            EditorApplication.update += EditorUpdate;
        }

        private void OnDisable () {
            EditorApplication.update -= EditorUpdate;
        }

        private void EditorUpdate () {
            float deltaTime = (float) (EditorApplication.timeSinceStartup - _timestamp);
            _player.UpdateFrame (deltaTime);
            _timestamp = EditorApplication.timeSinceStartup;
        }

        public override void OnInspectorGUI () {
            serializedObject.Update ();
            float time = 0f;
            if (_frameClip.Frames != null) {
                time = 1f / _frameClip.FrameRate * _frameClip.Frames.Length;
            }
            GUI.enabled = false;
            EditorGUILayout.LabelField ($"Length: {time:0.###} sec.");
            GUI.enabled = true;
            EditorGUI.BeginChangeCheck ();
            EditorGUILayout.PropertyField (serializedObject.FindProperty ("FrameRate"));
            EditorGUILayout.PropertyField (serializedObject.FindProperty ("WrapMode"));
            EditorGUILayout.PropertyField (serializedObject.FindProperty ("Frames"));
            if (EditorGUI.EndChangeCheck ()) {
                _player.Stop ();
            }
            serializedObject.ApplyModifiedProperties ();
        }

        public override bool HasPreviewGUI () {
            return true;
        }

        public override bool RequiresConstantRepaint () {
            return _player == null ? false : _player.IsPlaying;
        }

        public override void OnPreviewGUI (Rect r, GUIStyle background) {
            if (_frameClip.Frames != null && _frameClip.Frames.Length > _player.CurrentFrameIndex) {
                if (_frameClip.Frames[_player.CurrentFrameIndex] != null) {
                    EditorGUILayout.LabelField ($"({_player.CurrentFrameIndex + 1}/{_frameClip.Frames.Length}) {_frameClip.Frames[_player.CurrentFrameIndex]?.name}", EditorStyles.boldLabel);
                    GUI.DrawTexture (r, AssetPreview.GetAssetPreview (_frameClip.Frames[_player.CurrentFrameIndex]), ScaleMode.ScaleToFit, true);
                } else {
                    EditorGUILayout.LabelField ($"({_player.CurrentFrameIndex + 1}/{_frameClip.Frames.Length}) null", EditorStyles.boldLabel);
                }
            }
        }

        public override void OnPreviewSettings () {
            GUI.enabled = (_frameClip.Frames != null && _frameClip.Frames.Length > 0);
            if (_player == null) {
                return;
            }
            if (GUILayout.Button (EditorGUIUtility.IconContent ("Animation.FirstKey"), EditorStyles.miniButtonLeft)) {
                _player.Rewind (0);
            }
            if (GUILayout.Button (EditorGUIUtility.IconContent ("Animation.PrevKey"), EditorStyles.miniButtonMid)) {
                _player.Rewind (Mathf.Max (0, _player.CurrentFrameIndex - 1));
            }
            if (!_player.IsPlaying) {
                if (GUILayout.Button (EditorGUIUtility.IconContent ("Animation.Play"), EditorStyles.miniButtonMid)) {
                    _player.Play ();
                }
            } else {
                if (GUILayout.Button (EditorGUIUtility.IconContent ("PauseButton"), EditorStyles.miniButtonMid)) {
                    _player.Pause ();
                }
            }
            if (GUILayout.Button (EditorGUIUtility.IconContent ("Animation.NextKey"), EditorStyles.miniButtonMid)) {
                _player.Rewind (Mathf.Min (_player.CurrentFrameIndex + 1, _frameClip.Frames.Length - 1));
            }
            if (GUILayout.Button (EditorGUIUtility.IconContent ("Animation.LastKey"), EditorStyles.miniButtonRight)) {
                _player.Rewind (_frameClip.Frames.Length - 1);
            }
            GUI.enabled = true;
        }
    }
}