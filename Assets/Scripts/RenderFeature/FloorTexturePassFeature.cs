using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.UI;

public class FloorTexturePassFeature : ScriptableRendererFeature
{
    private FloorTextureVolume EffectVolume;
    class CustomRenderPass : ScriptableRenderPass
    {
        public Shader Shader;
        public Material Material;

        private RenderTargetHandle m_TempRT1;
        private RenderTargetHandle m_TempRT2;

        public string RenderTag = "FloorTexture";
        private FloorTextureVolume m_EffectVolume;

        public CustomRenderPass()
        {
            if (Material == null)
            {
                Shader = Shader.Find("Custom/FloorTexture");
                if (Shader != null)
                {
                    Material = CoreUtils.CreateEngineMaterial(Shader);
                }
            }

            m_EffectVolume = VolumeManager.instance.stack.GetComponent<FloorTextureVolume>();
            m_TempRT1.Init("FloorTextureTempRt1");
            m_TempRT2.Init("FloorTextureTempRt2");
        }

        // This method is called before executing the render pass.
        // It can be used to configure render targets and their clear state. Also to create temporary render target textures.
        // When empty this render pass will render to the active camera render target.
        // You should never call CommandBuffer.SetRenderTarget. Instead call <c>ConfigureTarget</c> and <c>ConfigureClear</c>.
        // The render pipeline will ensure target setup and clearing happens in an performance manner.
        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {

        }

        // Here you can implement the rendering logic.
        // Use <c>ScriptableRenderContext</c> to issue drawing commands or execute command buffers
        // https://docs.unity3d.com/ScriptReference/Rendering.ScriptableRenderContext.html
        // You don't have to call ScriptableRenderContext.submit, the render pipeline will call it at specific points in the pipeline.
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            if (renderingData.cameraData.isSceneViewCamera)
                return;

            if (Material == null)
                return;

            if (m_EffectVolume.MixRt.value != null)
                RenderTexture.ReleaseTemporary(m_EffectVolume.MixRt.value);

            if (m_EffectVolume.TempRt.value != null)
                RenderTexture.ReleaseTemporary(m_EffectVolume.TempRt.value);

            m_EffectVolume.MixRt.value = null;
            m_EffectVolume.TempRt.value = null;

            int width = m_EffectVolume.BaseFloorTexture.value.width;
            int height = m_EffectVolume.BaseFloorTexture.value.height;

            CommandBuffer cmd = CommandBufferPool.Get(RenderTag);

            cmd.GetTemporaryRT(m_TempRT1.id, width, height);

            float lengthCoe = m_EffectVolume.LengthCoe.value;
            //Material.SetFloat("_OutRectLength", m_EffectVolume.OutRectLength.value);

            for (int i = 0; i < m_EffectVolume.BuildDataList.Length; i++)
            {
                var bulidData= m_EffectVolume.BuildDataList[i];
                cmd.SetGlobalFloat("_X", bulidData.pos.x);
                cmd.SetGlobalFloat("_Z", bulidData.pos.z);
                cmd.SetGlobalFloat("_OutRectLength", bulidData.size * lengthCoe);
                cmd.GetTemporaryRT(m_TempRT2.id, width, height);
                cmd.Blit(m_TempRT1.Identifier(), m_TempRT2.Identifier(), Material, 0);
                cmd.Blit(m_TempRT2.Identifier(), m_TempRT1.Identifier());
                cmd.ReleaseTemporaryRT(m_TempRT2.id);
            }

            var rt1 = RenderTexture.GetTemporary(32, 32, 0);
            cmd.Blit(m_TempRT1.Identifier(), rt1);

            cmd.SetGlobalTexture("_RtTexture", rt1);
            cmd.SetGlobalTexture("_MineralFloorTexture", m_EffectVolume.MineralFloorTexture.value);

            cmd.Blit(m_EffectVolume.BaseFloorTexture.value, m_TempRT1.Identifier(), Material, 1);

            var rt = RenderTexture.GetTemporary(width, height, 0);
            cmd.Blit(m_TempRT1.Identifier(), rt);
            cmd.ReleaseTemporaryRT(m_TempRT1.id);
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
            m_EffectVolume.MixRt = new RenderTextureParameter(rt);
            m_EffectVolume.TempRt = new RenderTextureParameter(rt1);
            m_EffectVolume.Active = new BoolParameter(false);
            m_EffectVolume.CallBack(rt);
        }

        /// Cleanup any allocated resources that were created during the execution of this render pass.
        public override void FrameCleanup(CommandBuffer cmd)
        {

        }

        internal void SetUp(RenderTargetIdentifier src)
        {
            
        }
    }

    CustomRenderPass m_ScriptablePass;

    public override void Create()
    {
        EffectVolume = VolumeManager.instance.stack.GetComponent<FloorTextureVolume>();
        m_ScriptablePass = new CustomRenderPass();

        // Configures where the render pass should be injected.
        m_ScriptablePass.renderPassEvent = RenderPassEvent.AfterRendering;
    }

    // Here you can inject one or multiple render passes in the renderer.
    // This method is called when setting up the renderer once per-camera.
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (!EffectVolume.IsActive())
            return;

        m_ScriptablePass.SetUp(renderer.cameraColorTarget);
        renderer.EnqueuePass(m_ScriptablePass);
    }
}


