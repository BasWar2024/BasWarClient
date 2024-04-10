

using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class BuildData
{
    public Vector3 pos = Vector3.zero;
    public float size = 0;
}

public class FloorTextureVolume : VolumeComponent, IPostProcessComponent
{
    public TextureParameter BaseFloorTexture = new TextureParameter(null); //""
    public TextureParameter MineralFloorTexture = new TextureParameter(null); //""
    public RenderTextureParameter MixRt = new RenderTextureParameter(null); //""
    public RenderTextureParameter TempRt = new RenderTextureParameter(null); //""
    public BoolParameter Active = new BoolParameter(false); //""
    public FloatParameter LengthCoe = new FloatParameter(1f);
    public Action<RenderTexture> CallBack;
    public BuildData[] BuildDataList;

    //lua""MixRt""null,""
    public bool IsMixRtNull()
    {
        if (MixRt.value == null)
            return true;
        else
            return false;
    }

    public bool IsActive()
    {
        return Active.value;
    }

    public bool IsTileCompatible()
    {
        return false;
    }
}
