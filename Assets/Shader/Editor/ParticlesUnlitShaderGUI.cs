using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Rendering.Universal.ShaderGUI;
using UnityEngine;
using static UnityEditor.Rendering.Universal.ShaderGUI.ParticleGUI;

public class ParticlesUnlitShaderGUI : BaseShaderGUI {
    public MaterialProperty emissionGain;
    public override void MaterialChanged (Material material) {
        if (material == null)
            throw new ArgumentNullException ("material");

        SetMaterialKeywords (material, null, SetMaterialKeywords);
    }

    public override void FindProperties (MaterialProperty[] properties) {
        base.FindProperties (properties);
        emissionGain = BaseShaderGUI.FindProperty ("_EmissionGain", properties, false);
    }

    public override void DrawSurfaceOptions (Material material) {
        // Detect any changes to the material
        EditorGUI.BeginChangeCheck (); {
            base.DrawSurfaceOptions (material);
        }
        if (EditorGUI.EndChangeCheck ()) {
            foreach (var obj in blendModeProp.targets)
                MaterialChanged ((Material) obj);
        }
    }

    public override void DrawSurfaceInputs (Material material) {
        base.DrawSurfaceInputs (material);
        materialEditor.RangeProperty (emissionGain, "emissionGain");
    }

    //""
    public void SetMaterialKeywords (Material material) {

    }

}