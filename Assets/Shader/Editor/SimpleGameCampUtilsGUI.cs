using System;
using UnityEditor;
using UnityEditor.Rendering.Universal.ShaderGUI;
using UnityEngine;
using UnityEngine.Rendering;

public class SimpleGameCampUtilsGUI : SimpleGameUtilsGUI {
    public MaterialProperty campMaskMap;
    public MaterialProperty campColor;
    public MaterialProperty customEmissionColor;
    public MaterialProperty customEmissionMap;

    public MaterialProperty fresnelColor;
    public MaterialProperty totalFlashPower;
    public MaterialProperty fresnelBrightness;
    public override void FindProperties (MaterialProperty[] properties) {
        base.FindProperties (properties);
        campColor = BaseShaderGUI.FindProperty ("_CampColor", properties, false);
        customEmissionColor = BaseShaderGUI.FindProperty ("_CustomEmissionColor", properties, false);
        customEmissionMap = BaseShaderGUI.FindProperty ("_CustomEmissionMap", properties, false);

        fresnelColor = BaseShaderGUI.FindProperty ("_FresnelColor", properties, false);
        totalFlashPower = BaseShaderGUI.FindProperty ("_P_TotalFlashPower", properties, false);
        fresnelBrightness = BaseShaderGUI.FindProperty ("_P_FresnelBrightness", properties, false);

    }

    public override void DrawSurfaceInputs (Material material) {
        base.DrawSurfaceInputs (material);
        if (customEmissionMap != null) {
            materialEditor.TexturePropertySingleLine (new GUIContent (""""), customEmissionMap, customEmissionColor);
        }
        if (campColor != null) {
            materialEditor.ColorProperty (campColor, """ """);
        }
        if (fresnelColor != null) {
            materialEditor.ColorProperty (fresnelColor, """");
        }
        if (totalFlashPower != null) {
            materialEditor.RangeProperty (totalFlashPower, """");
        }
        if (fresnelBrightness != null) {
            materialEditor.RangeProperty (fresnelBrightness, """");
        }
    }
}