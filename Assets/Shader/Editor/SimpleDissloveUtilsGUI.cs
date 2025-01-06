using System;
using UnityEditor;
using UnityEditor.Rendering.Universal.ShaderGUI;
using UnityEngine;
using UnityEngine.Rendering;
public class SimpleDissloveUtilsGUI : ParticlesUnlitShaderGUI
{
    public MaterialProperty DissolveTex;
    public MaterialProperty RampText;
    public MaterialProperty Clip;

    public override void FindProperties(MaterialProperty[] properties)
    {
        base.FindProperties(properties);
        DissolveTex = BaseShaderGUI.FindProperty("_DissolveTex", properties, false);
        RampText = BaseShaderGUI.FindProperty("_RampText", properties, false);
        Clip = BaseShaderGUI.FindProperty("_Clip", properties, false);

    }

    public override void DrawSurfaceInputs(Material material)
    {
        base.DrawSurfaceInputs(material);
        materialEditor.TexturePropertySingleLine(new GUIContent(""""), DissolveTex);
        materialEditor.TexturePropertySingleLine(new GUIContent(""""),RampText);
        materialEditor.RangeProperty (Clip, "Clip");
    }
}