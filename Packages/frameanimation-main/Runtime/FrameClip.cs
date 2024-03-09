using UnityEngine;

namespace GypsyMagic.FrameAnimation {
    [CreateAssetMenu (menuName = "Frame Animation Clip", order = 350)]
    public class FrameClip : ScriptableObject {
        [Min (0.001f)] public float FrameRate = 12;
        public WrapMode WrapMode;
        public Sprite[] Frames;
    }
}