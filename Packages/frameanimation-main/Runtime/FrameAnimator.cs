using UnityEngine;

namespace GypsyMagic.FrameAnimation {
    public class FrameAnimator : MonoBehaviour {
        [SerializeField] private SpriteRenderer _renderer = default;
        [SerializeField] private FrameClip[] _clips = default;
        [SerializeField] private bool _playAutomatically = true;
        [SerializeField] private bool _ignoreScaleTime = false;
        [SerializeField] private float _scaleTimeMultiple = 1;
        [SerializeField] private AnimationCullingType _cullingType = AnimationCullingType.AlwaysAnimate;

        public SpriteRenderer Renderer => _renderer;
        public FrameClip[] Clips => _clips;
        public bool PlayAutomatically => _playAutomatically;

        private int _uuid = -1;

        public int GetUuid () {
            if (_uuid == -1) {
                _uuid = GetInstanceID ();
            }
            return _uuid;
        }

        public bool GetAnimationState (ref AnimationState animationState) {
            if (!FrameAnimationSystem.Instance.Exists (_uuid)) {
                return false;
            }
            animationState = FrameAnimationSystem.Instance.GetAnimationState (_uuid);
            return true;
        }

        public bool GetFrameIndex (ref int frameIndex) {
            if (!FrameAnimationSystem.Instance.Exists (_uuid)) {
                return false;
            }
            frameIndex = FrameAnimationSystem.Instance.GetFrameIndex (_uuid);
            return true;
        }

        public bool IsIgnoringScaleTime (ref bool ignoreScaleTime) {
            if (!FrameAnimationSystem.Instance.Exists (_uuid)) {
                return false;
            }
            ignoreScaleTime = FrameAnimationSystem.Instance.IsIgnoringScaleTime (_uuid);
            return true;
        }

        public bool GetCullingType (ref AnimationCullingType cullingType) {
            if (!FrameAnimationSystem.Instance.Exists (_uuid)) {
                return false;
            }
            cullingType = FrameAnimationSystem.Instance.GetCullingType (_uuid);
            return true;
        }

        public bool GetClipIndex (ref int clipIndex) {
            if (!FrameAnimationSystem.Instance.Exists (_uuid)) {
                return false;
            }
            clipIndex = FrameAnimationSystem.Instance.GetClipIndex (_uuid);
            return true;
        }

#if UNITY_EDITOR
        private void OnValidate () {
            if (FrameAnimationSystem.Instance.Exists (_uuid)) {
                FrameAnimationSystem.Instance.SetSpriteRenderer (_uuid, _renderer);
                FrameAnimationSystem.Instance.SetClips (_uuid, _clips);
                FrameAnimationSystem.Instance.SetIgnoreScaleTime (_uuid, _ignoreScaleTime);
                FrameAnimationSystem.Instance.SetScaleTimeMultiple (_uuid, _scaleTimeMultiple);
                FrameAnimationSystem.Instance.SetCullingType (_uuid, _cullingType);
            }
        }

        public void SetClipsInEditor (FrameClip[] fc) {
            _clips = fc;
        }
        public void SetRenderInEditor (SpriteRenderer re) {
            _renderer = re;
        }
#endif

        private void OnEnable () {
            FrameAnimationSystem.Instance.AddData (GetUuid (), _cullingType, _ignoreScaleTime, _renderer, _clips);
            if (_playAutomatically) {
                Play (0);
            }
        }

        private void OnDisable () {
            FrameAnimationSystem.Instance.RemoveData (_uuid);
        }

        private void Start () {
            if (_playAutomatically) {
                Play (0);
            }
        }

        public bool Play () {
            if (FrameAnimationSystem.Instance.Exists (_uuid)) {
                FrameAnimationSystem.Instance.SetAnimationState (_uuid, AnimationState.Play);
                return true;
            }
            return false;
        }

        public bool Play (string clipName) {
            for (int i = 0; i < _clips.Length; ++i) {
                if (_clips[i].name == clipName) {
                    return Play (i);
                }
            }
            return false;
        }

        public bool Play (int clipIndex) {
            if (_clips.Length > clipIndex && FrameAnimationSystem.Instance.Exists (_uuid)) {
                FrameAnimationSystem.Instance.SetClipIndex (_uuid, clipIndex);
                FrameAnimationSystem.Instance.SetFrameIndex (_uuid, 0);
                FrameAnimationSystem.Instance.SetAnimationTime (_uuid, 0f);
                FrameAnimationSystem.Instance.SetAnimationState (_uuid, AnimationState.Play);
                return true;
            }
            return false;
        }

        public bool SetClipIndex (int clipIndex) {
            if (_clips.Length > clipIndex && FrameAnimationSystem.Instance.Exists (_uuid)) {
                FrameAnimationSystem.Instance.SetClipIndex (_uuid, clipIndex);
                return Stop ();
            }
            return false;
        }

        public bool Pause () {
            if (FrameAnimationSystem.Instance.Exists (_uuid)) {
                FrameAnimationSystem.Instance.SetAnimationState (_uuid, AnimationState.Pause);
                return true;
            }
            return false;
        }

        public bool Stop () {
            if (FrameAnimationSystem.Instance.Exists (_uuid)) {
                FrameAnimationSystem.Instance.SetFrameIndex (_uuid, 0);
                FrameAnimationSystem.Instance.SetAnimationTime (_uuid, 0f);
                FrameAnimationSystem.Instance.SetAnimationState (_uuid, AnimationState.Stop);
                return true;
            }
            return false;
        }

        public bool SetFrameIndex (int frameIndex) {
            if (FrameAnimationSystem.Instance.Exists (_uuid) && _clips[FrameAnimationSystem.Instance.GetClipIndex (_uuid)].Frames.Length > frameIndex) {
                FrameAnimationSystem.Instance.SetFrameIndex (_uuid, frameIndex);
                int currentClip = FrameAnimationSystem.Instance.GetClipIndex (_uuid);
                FrameAnimationSystem.Instance.SetAnimationTime (_uuid, 1f / _clips[currentClip].FrameRate);
                _renderer.sprite = _clips[currentClip].Frames[frameIndex];
                return true;
            }
            return false;
        }

        public bool SetIgnoreScaleTime (bool ignoreScaleTime) {
            if (FrameAnimationSystem.Instance.Exists (_uuid)) {
#if UNITY_EDITOR
                _ignoreScaleTime = ignoreScaleTime;
#endif
                FrameAnimationSystem.Instance.SetIgnoreScaleTime (_uuid, ignoreScaleTime);
                return true;
            }
            return false;
        }

        public bool SetScaleTimeMultiple (float multiple) {
            if (FrameAnimationSystem.Instance.Exists (_uuid) && multiple >= 0) {
#if UNITY_EDITOR
                _scaleTimeMultiple = multiple;
#endif
                FrameAnimationSystem.Instance.SetScaleTimeMultiple (_uuid, multiple);
                return true;
            }
            return false;
        }

        public bool SetCullingType (AnimationCullingType cullingType) {
            if (FrameAnimationSystem.Instance.Exists (_uuid)) {
#if UNITY_EDITOR
                _cullingType = cullingType;
#endif
                FrameAnimationSystem.Instance.SetCullingType (_uuid, cullingType);
                return true;
            }
            return false;
        }
    }
}