using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using static UnityEngine.Experimental.Rendering.Universal.RenderObjects;

public class BloomRenderPassFeature : ScriptableRendererFeature {
    [System.Serializable]
    public class BloomSettings {
        public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing - 2;
        public FilterSettings filterSettings = new FilterSettings ();
        [Range (0f, 16f)]
        public int maxIterations = 1;

        [Min (1f)]
        public int downscaleLimit = 2;

        public bool bicubicUpsampling = true;

        [Min (0f)]
        public float threshold = 0.2f;

        [Range (0f, 1f)]
        public float thresholdKnee = 0.5f;

        [Min (0f)]
        public float intensity = 0.5f;

        [System.NonSerialized]
        Material material;

        [SerializeField]
        Shader shader = default;
        public Material Material {
            get {
                if (material == null && shader != null) {
                    material = new Material (shader);
                    material.hideFlags = HideFlags.HideAndDontSave;
                }
                return material;
            }
        }
        public int overrideMaterialPassIndex = 0;
    }

    [SerializeField]
    BloomSettings setting = default;

    public BloomSettings BloomSetting => setting;

    BloomRenderPass bloomRenderPass;

    public override void Create () {
        bloomRenderPass = new BloomRenderPass ("BloomPostEffectRender", BloomSetting.renderPassEvent, BloomSetting.filterSettings.PassNames, BloomSetting.filterSettings.RenderQueueType, BloomSetting.filterSettings.LayerMask);

    }

    public override void AddRenderPasses (ScriptableRenderer renderer, ref RenderingData renderingData) {

        if (renderingData.cameraData.postProcessEnabled && Application.isPlaying) {
            var src = renderer.cameraColorTarget;

            if (BloomSetting.Material == null) {
                Debug.LogWarningFormat ("""blit""");
                return;
            }

            bloomRenderPass.Setup (renderingData.cameraData.camera, setting, src);
            renderer.EnqueuePass (bloomRenderPass);
        }
    }
}