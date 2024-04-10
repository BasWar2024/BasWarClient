using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.UI;

public class UIBlurEffectRenderPassFeature : ScriptableRendererFeature
{
    private UIBlurEffectVolume EffectVolume;
    class CustomRenderPass : ScriptableRenderPass
    {
        public Shader Shader;
        public Material Material;

        private RenderTargetIdentifier m_Src;
        private RenderTargetHandle m_TempRT1;
        private RenderTargetHandle m_TempRT2;

        public string RenderTag = "UIBlurEffect";
        private UIBlurEffectVolume m_EffectVolume;

        private int m_Cur_iterate_num;

        public CustomRenderPass()
        {
            if (Material == null)
            {
                Shader = Shader.Find("Custom_URP/UIBlurEffect");
                if (Shader != null)
                {
                    Material = CoreUtils.CreateEngineMaterial(Shader);
                }
            }

            m_EffectVolume = VolumeManager.instance.stack.GetComponent<UIBlurEffectVolume>();
            m_TempRT1.Init("UIBlurEffectTempRt1");
            m_TempRT2.Init("UIBlurEffectTempRt2");
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

            if (m_EffectVolume.Blur_rt.value != null)
                RenderTexture.ReleaseTemporary(m_EffectVolume.Blur_rt.value);

            m_EffectVolume.Blur_rt.value = null;

            if (Material == null)
                return;

            int width = 160;//Screen.width / m_EffectVolume.Blur_down_sample.value;
            int height = 90;//Screen.height / m_EffectVolume.Blur_down_sample.value;
            m_Cur_iterate_num = 0;

            CommandBuffer cmd = CommandBufferPool.Get(RenderTag);
            RenderTextureDescriptor opaqueDesc = renderingData.cameraData.cameraTargetDescriptor;
            opaqueDesc.depthBufferBits = 0;


            cmd.GetTemporaryRT(m_TempRT1.id, opaqueDesc);
            cmd.Blit(m_Src, m_TempRT1.Identifier());

            while (m_Cur_iterate_num <= m_EffectVolume.Blur_iteration.value)
            {
                Material.SetFloat("_BlurSize", (1.0f + m_Cur_iterate_num * m_EffectVolume.Blur_spread.value) * m_EffectVolume.Blur_size.value);
                cmd.GetTemporaryRT(m_TempRT2.id, opaqueDesc);
                cmd.Blit(m_TempRT1.Identifier(), m_TempRT2.Identifier(), Material, 0);
                cmd.Blit(m_TempRT2.Identifier(), m_TempRT1.Identifier(), Material, 1);
                cmd.ReleaseTemporaryRT(m_TempRT2.id);
                m_Cur_iterate_num++;
            }

            var rt = RenderTexture.GetTemporary(width, height, 0);
            cmd.Blit(m_TempRT1.Identifier(), rt);
            cmd.ReleaseTemporaryRT(m_TempRT1.id);
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
            m_EffectVolume.Blur_rt = new RenderTextureParameter(rt);
            //GameObject.Find("UIRoot/NormalNode/PnlLogin/Bg").GetComponent<RawImage>().texture = m_EffectVolume.Blur_rt.value;
            m_EffectVolume.Render_blur_screenShot = new BoolParameter(false);
            m_EffectVolume.Blur_callback(rt);
        }

        /// Cleanup any allocated resources that were created during the execution of this render pass.
        public override void FrameCleanup(CommandBuffer cmd)
        {
            
        }

        internal void SetUp(RenderTargetIdentifier src)
        {
            m_Src = src;
        }
    }

    CustomRenderPass m_ScriptablePass;

    public override void Create()
    {
        EffectVolume = VolumeManager.instance.stack.GetComponent<UIBlurEffectVolume>();
        m_ScriptablePass = new CustomRenderPass();

        // Configures where the render pass should be injected.
        m_ScriptablePass.renderPassEvent = RenderPassEvent.BeforeRendering;
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


