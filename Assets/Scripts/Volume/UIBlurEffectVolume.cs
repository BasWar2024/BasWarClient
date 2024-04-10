using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class UIBlurEffectVolume : VolumeComponent, IPostProcessComponent
{
    [Range(0, 127)]
    public FloatParameter Blur_size = new FloatParameter(1); // ""
    [Range(1, 10)]
    public IntParameter Blur_iteration = new IntParameter(2); // ""
    public FloatParameter Blur_spread = new FloatParameter(1); // ""
    public IntParameter Blur_down_sample = new IntParameter(1); // ""
    public RenderTextureParameter Blur_rt = new RenderTextureParameter(null);
    public BoolParameter Render_blur_screenShot = new BoolParameter(false); // ""

    //""lua
    public Action<RenderTexture> Blur_callback;

    public bool IsActive()
    {
        return Render_blur_screenShot.value;
    }

    public bool IsTileCompatible()
    {
        return false;
    }
}
