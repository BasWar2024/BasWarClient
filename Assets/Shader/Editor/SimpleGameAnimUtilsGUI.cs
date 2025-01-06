using System;
using UnityEditor;
using UnityEditor.Rendering.Universal.ShaderGUI;
using UnityEngine;
using UnityEngine.Rendering;
public class SimpleGameAnimUtilsGUI : SimpleGameCampUtilsGUI {
    //_AnimTex
    public MaterialProperty animTex;


    public override void FindProperties (MaterialProperty[] properties) {
        base.FindProperties (properties);
        animTex = BaseShaderGUI.FindProperty ("_AnimTex", properties, false);
    }

    public override void DrawSurfaceInputs (Material material) {
        base.DrawSurfaceInputs (material);
        materialEditor.TexturePropertySingleLine (new GUIContent (""""), animTex, null);
    }
}