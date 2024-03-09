using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.LowLevel;
using UnityEngine.PlayerLoop;

namespace GypsyMagic.FrameAnimation {
    class FrameAnimationSystem {
        private static readonly int RESERVED_MEMORY_SIZE = 64;

        private FrameAnimationTable _dataTable = new FrameAnimationTable (RESERVED_MEMORY_SIZE);
        private Dictionary<int, int> _uuidMap = new Dictionary<int, int> (RESERVED_MEMORY_SIZE);

        [RuntimeInitializeOnLoadMethod (RuntimeInitializeLoadType.SubsystemRegistration)]
        private static void RegisterSystem () {
            PlayerLoopSystem currentPlayerLoop = PlayerLoop.GetCurrentPlayerLoop ();
            if (AddFrameAnimationLoop (ref currentPlayerLoop)) {
                PlayerLoop.SetPlayerLoop (currentPlayerLoop);
            }
        }

        private static bool AddFrameAnimationLoop (ref PlayerLoopSystem playerLoop) {
            PlayerLoopSystem[] subSystems = playerLoop.subSystemList;
            if (playerLoop.type == typeof (PreLateUpdate)) {
                PlayerLoopSystem frameAnimationLoopSystem = new PlayerLoopSystem () {
                updateDelegate = Instance.CalculateClipFrame,
                type = typeof (FrameAnimationSystem)
                };
                if (subSystems != null) {
                    PlayerLoopSystem[] newSubSystems = new PlayerLoopSystem[subSystems.Length + 1];
                    newSubSystems[0] = frameAnimationLoopSystem;
                    Array.Copy (subSystems, 0, newSubSystems, 1, subSystems.Length);
                    playerLoop.subSystemList = newSubSystems;
                } else {
                    subSystems = new PlayerLoopSystem[] { frameAnimationLoopSystem };
                    playerLoop.subSystemList = subSystems;
                }
                return true;
            }
            if (subSystems != null) {
                for (int i = 0; i < subSystems.Length; ++i) {
                    if (AddFrameAnimationLoop (ref subSystems[i])) {
                        return true;
                    }
                }
            }
            return false;
        }

        private FrameAnimationSystem () { }

        private static FrameAnimationSystem _instance = null;

        public static FrameAnimationSystem Instance {
            get {
                if (_instance == null) {
                    _instance = new FrameAnimationSystem ();
                }
                return _instance;
            }
        }

        private void CalculateClipFrame () {
            float unscaledDeltaTime = Time.unscaledDeltaTime;
            float scaledDeltaTime = Time.deltaTime;
            for (int i = 0; i < _dataTable.data_size; ++i) {
                if (_dataTable.clips[i] == null || _dataTable.clips[i].Length <= _dataTable.clip_indices[i] || _dataTable.animation_states[i] != AnimationState.Play ||
                    (_dataTable.culling_types[i] == AnimationCullingType.BasedOnRenderers && !_dataTable.renderers[i].isVisible)) {
                    continue;
                }
                var scale_multiple = _dataTable.animation_scale_time[i];
                switch (_dataTable.clips[i][_dataTable.clip_indices[i]].WrapMode) {
                    case WrapMode.Default:
                    case WrapMode.Once:
                        {
                            CalculateOnceClipFrame (i, unscaledDeltaTime, scaledDeltaTime * scale_multiple);
                            break;
                        }
                    case WrapMode.ClampForever:
                        {
                            CalculateClampClipFrame (i, unscaledDeltaTime, scaledDeltaTime * scale_multiple);
                            break;
                        }
                    case WrapMode.Loop:
                        {
                            CalculateLoopClipFrame (i, unscaledDeltaTime, scaledDeltaTime * scale_multiple);
                            break;
                        }
                    case WrapMode.PingPong:
                        {
                            CalculatePingPongClipFrame (i, unscaledDeltaTime, scaledDeltaTime * scale_multiple);
                            break;
                        }
                }
            }
        }

        private void CalculateOnceClipFrame (int i, float unscaledDT, float scaledDT) {
            _dataTable.animation_times[i] += _dataTable.ignore_scale_times[i] ? unscaledDT : scaledDT;
            int index = (int) (_dataTable.animation_times[i] / (1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate));
            if (index >= _dataTable.clips[i][_dataTable.clip_indices[i]].Frames.Length) {
                _dataTable.animation_states[i] = AnimationState.Stop;
                _dataTable.frame_indices[i] = 0;
                _dataTable.animation_times[i] = 0f;
                _dataTable.renderers[i].sprite = _dataTable.clips[i][_dataTable.clip_indices[i]].Frames[0];
            } else if (index != _dataTable.frame_indices[i]) {
                _dataTable.frame_indices[i] = index;
                _dataTable.renderers[i].sprite = _dataTable.clips[i][_dataTable.clip_indices[i]].Frames[_dataTable.frame_indices[i]];
            }
        }

        private void CalculateClampClipFrame (int i, float unscaledDT, float scaledDT) {
            _dataTable.animation_times[i] += _dataTable.ignore_scale_times[i] ? unscaledDT : scaledDT;
            int index = (int) (_dataTable.animation_times[i] / (1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate));
            if (index >= _dataTable.clips[i][_dataTable.clip_indices[i]].Frames.Length) {
                _dataTable.animation_states[i] = AnimationState.Pause;
            } else if (index != _dataTable.frame_indices[i]) {
                _dataTable.frame_indices[i] = index;
                _dataTable.renderers[i].sprite = _dataTable.clips[i][_dataTable.clip_indices[i]].Frames[_dataTable.frame_indices[i]];
            }
        }

        private void CalculateLoopClipFrame (int i, float unscaledDT, float scaledDT) {
            _dataTable.animation_times[i] = (_dataTable.animation_times[i] + (_dataTable.ignore_scale_times[i] ? unscaledDT : scaledDT)) %
                (_dataTable.clips[i][_dataTable.clip_indices[i]].Frames.Length * (1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate));
            int index = (int) (_dataTable.animation_times[i] / (1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate));
            if (index != _dataTable.frame_indices[i]) {
                _dataTable.frame_indices[i] = index;
                _dataTable.renderers[i].sprite = _dataTable.clips[i][_dataTable.clip_indices[i]].Frames[_dataTable.frame_indices[i]];
            }
        }

        private void CalculatePingPongClipFrame (int i, float unscaledDT, float scaledDT) {
            if (_dataTable.backwards[i]) {
                _dataTable.animation_times[i] = Mathf.Max (0f, _dataTable.animation_times[i] - (_dataTable.ignore_scale_times[i] ? unscaledDT : scaledDT));
                if (_dataTable.animation_times[i] == 0f) {
                    _dataTable.backwards[i] = false;
                    _dataTable.animation_times[i] = 1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate;
                }
            } else {
                float maxAnimationTime = (1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate) * _dataTable.clips[i][_dataTable.clip_indices[i]].Frames.Length;
                _dataTable.animation_times[i] = Mathf.Min (maxAnimationTime, _dataTable.animation_times[i] + (_dataTable.ignore_scale_times[i] ? unscaledDT : scaledDT));
                if (_dataTable.animation_times[i] == maxAnimationTime) {
                    _dataTable.backwards[i] = true;
                    _dataTable.animation_times[i] = (_dataTable.clips[i][_dataTable.clip_indices[i]].Frames.Length - 1) * (1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate);
                }
            }
            int index = (int) (_dataTable.animation_times[i] / (1f / _dataTable.clips[i][_dataTable.clip_indices[i]].FrameRate));
            if (index != _dataTable.frame_indices[i]) {
                _dataTable.frame_indices[i] = index;
                _dataTable.renderers[i].sprite = _dataTable.clips[i][_dataTable.clip_indices[i]].Frames[_dataTable.frame_indices[i]];
            }
        }

        public bool AddData (int componentUuid, AnimationCullingType cullingType, bool ignoreScaleTime, SpriteRenderer renderer, FrameClip[] clips) {
            if (_uuidMap.ContainsKey (componentUuid)) {
                return false;
            }
            if (_dataTable.data_size == _dataTable.animation_times.Length) {
                Array.Resize (ref _dataTable.animation_states, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.culling_types, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.ignore_scale_times, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.backwards, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.component_uuids, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.frame_indices, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.clip_indices, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.animation_times, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.animation_scale_time, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.renderers, _dataTable.data_size + RESERVED_MEMORY_SIZE);
                Array.Resize (ref _dataTable.clips, _dataTable.data_size + RESERVED_MEMORY_SIZE);
            }
            _dataTable.animation_states[_dataTable.data_size] = AnimationState.Stop;
            _dataTable.culling_types[_dataTable.data_size] = cullingType;
            _dataTable.ignore_scale_times[_dataTable.data_size] = ignoreScaleTime;
            _dataTable.backwards[_dataTable.data_size] = false;
            _dataTable.component_uuids[_dataTable.data_size] = componentUuid;
            _dataTable.frame_indices[_dataTable.data_size] = 0;
            _dataTable.clip_indices[_dataTable.data_size] = 0;
            _dataTable.animation_times[_dataTable.data_size] = 0f;
            _dataTable.animation_scale_time[_dataTable.data_size] = 1f;
            _dataTable.renderers[_dataTable.data_size] = renderer;
            _dataTable.clips[_dataTable.data_size] = clips;
            _dataTable.data_size++;
            _uuidMap.Add (componentUuid, _dataTable.data_size - 1);
            return true;
        }

        public bool RemoveData (int componentUuid) {
            int indexToRemove;
            if (!_uuidMap.TryGetValue (componentUuid, out indexToRemove)) {
                return false;
            }
            int lastIndex = _dataTable.data_size - 1;
            if (indexToRemove != lastIndex) {
                _dataTable.animation_states[indexToRemove] = _dataTable.animation_states[lastIndex];
                _dataTable.culling_types[indexToRemove] = _dataTable.culling_types[lastIndex];
                _dataTable.ignore_scale_times[indexToRemove] = _dataTable.ignore_scale_times[lastIndex];
                _dataTable.backwards[indexToRemove] = _dataTable.backwards[lastIndex];
                _dataTable.component_uuids[indexToRemove] = _dataTable.component_uuids[lastIndex];
                _dataTable.frame_indices[indexToRemove] = _dataTable.frame_indices[lastIndex];
                _dataTable.clip_indices[indexToRemove] = _dataTable.clip_indices[lastIndex];
                _dataTable.animation_times[indexToRemove] = _dataTable.animation_times[lastIndex];
                _dataTable.animation_scale_time[indexToRemove] = _dataTable.animation_scale_time[lastIndex];
                _dataTable.renderers[indexToRemove] = _dataTable.renderers[lastIndex];
                _dataTable.clips[indexToRemove] = _dataTable.clips[lastIndex];
                _uuidMap[_dataTable.component_uuids[indexToRemove]] = indexToRemove;
            }
            _uuidMap.Remove (componentUuid);
            _dataTable.data_size--;
            if (_dataTable.data_size > 0 && (_dataTable.data_size + RESERVED_MEMORY_SIZE) == _dataTable.animation_times.Length) {
                Array.Resize (ref _dataTable.animation_states, _dataTable.data_size);
                Array.Resize (ref _dataTable.culling_types, _dataTable.data_size);
                Array.Resize (ref _dataTable.ignore_scale_times, _dataTable.data_size);
                Array.Resize (ref _dataTable.backwards, _dataTable.data_size);
                Array.Resize (ref _dataTable.component_uuids, _dataTable.data_size);
                Array.Resize (ref _dataTable.frame_indices, _dataTable.data_size);
                Array.Resize (ref _dataTable.clip_indices, _dataTable.data_size);
                Array.Resize (ref _dataTable.animation_times, _dataTable.data_size);
                Array.Resize (ref _dataTable.animation_scale_time, _dataTable.data_size);
                Array.Resize (ref _dataTable.renderers, _dataTable.data_size);
                Array.Resize (ref _dataTable.clips, _dataTable.data_size);
            }
            return true;
        }

        public bool Exists (int componentUuid) {
            return _uuidMap.ContainsKey (componentUuid);
        }

        public void SetAnimationState (int componentUuid, AnimationState animationState) {
            _dataTable.animation_states[_uuidMap[componentUuid]] = animationState;
        }

        public void SetCullingType (int componentUuid, AnimationCullingType cullingType) {
            _dataTable.culling_types[_uuidMap[componentUuid]] = cullingType;
        }

        public void SetIgnoreScaleTime (int componentUuid, bool ignoreScaleTime) {
            _dataTable.ignore_scale_times[_uuidMap[componentUuid]] = ignoreScaleTime;
        }
        public void SetScaleTimeMultiple (int componentUuid, float multiple) {
            _dataTable.animation_scale_time[_uuidMap[componentUuid]] = multiple;
        }

        public void SetFrameIndex (int componentUuid, int frameIndex) {
            _dataTable.frame_indices[_uuidMap[componentUuid]] = frameIndex;
        }

        public void SetClipIndex (int componentUuid, int clipIndex) {
            _dataTable.clip_indices[_uuidMap[componentUuid]] = clipIndex;
        }

        public void SetAnimationTime (int componentUuid, float animationTime) {
            _dataTable.animation_times[_uuidMap[componentUuid]] = animationTime;
        }

        public void SetSpriteRenderer (int componentUuid, SpriteRenderer renderer) {
            _dataTable.renderers[_uuidMap[componentUuid]] = renderer;
        }

        public void SetClips (int componentUuid, FrameClip[] clips) {
            _dataTable.clips[_uuidMap[componentUuid]] = clips;
        }

        public AnimationState GetAnimationState (int componentUuid) {
            return _dataTable.animation_states[_uuidMap[componentUuid]];
        }

        public AnimationCullingType GetCullingType (int componentUuid) {
            return _dataTable.culling_types[_uuidMap[componentUuid]];
        }

        public bool IsIgnoringScaleTime (int componentUuid) {
            return _dataTable.ignore_scale_times[_uuidMap[componentUuid]];
        }

        public bool IsBackward (int componentUuid) {
            return _dataTable.backwards[_uuidMap[componentUuid]];
        }

        public int GetFrameIndex (int componentUuid) {
            return _dataTable.frame_indices[_uuidMap[componentUuid]];
        }

        public int GetClipIndex (int componentUuid) {
            return _dataTable.clip_indices[_uuidMap[componentUuid]];
        }

        public float GetAnimationTime (int componentUuid) {
            return _dataTable.animation_times[_uuidMap[componentUuid]];
        }
    }
}