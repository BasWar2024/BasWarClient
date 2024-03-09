using UnityEngine;

namespace GypsyMagic.FrameAnimation {
    struct FrameAnimationTable {
        public int data_size;

        public AnimationState[] animation_states;
        public AnimationCullingType[] culling_types;
        public bool[] ignore_scale_times;
        public bool[] backwards;
        public int[] component_uuids;
        public int[] frame_indices;
        public int[] clip_indices;
        public float[] animation_times;
        public float[] animation_scale_time;
        public SpriteRenderer[] renderers;
        public FrameClip[][] clips;

        public FrameAnimationTable (int capacity) {
            data_size = 0;
            animation_states = new AnimationState[capacity];
            culling_types = new AnimationCullingType[capacity];
            ignore_scale_times = new bool[capacity];
            backwards = new bool[capacity];
            component_uuids = new int[capacity];
            frame_indices = new int[capacity];
            clip_indices = new int[capacity];
            animation_times = new float[capacity];
            animation_scale_time = new float[capacity];
            renderers = new SpriteRenderer[capacity];
            clips = new FrameClip[capacity][];
        }
    }
}