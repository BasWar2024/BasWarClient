Shader "Game/Unity/Legacy/Legacy-Diffuse" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _WeatherNoiseTex("WeatherNoise", 2D) = "white" {}
    [Toggle(GT_REFLECTION)] gt_Reflection("Reflection?", Float) = 0
    gt_ReflectionIntensity("Reflection Intensity", Range(0, 1)) = 0.5
    gt_ReflectionMask("Reflection Mask", 2D) = "white" {}
    [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0
    //[PerRendererData]gt_ReflectionTex("Reflection Tex", 2D) = "white" {}
}
//SubShader {
//    Tags { "RenderType"="Opaque" }
//    LOD 200
//    Cull[_CullMode]
//
//CGPROGRAM
//#pragma skip_variants SHADOWS_CUBE POINT_COOKIE FOG_EXP FOG_EXP2 DYNAMICLIGHTMAP_ON DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
//#include "../../Common/GTSceneShaderUtilities.cginc"
//#pragma surface surf GTLambert vertex:SurfaceShaderHeightFogVertex finalcolor:SurfaceShaderHeightFogColor
//#pragma multi_compile_fog
//#pragma multi_compile _ GT_WEATHER
//#pragma multi_compile _ GT_DYNAMIC_SHADOW
//#pragma multi_compile _ GT_REFLECTION
//
//sampler2D _MainTex;
//fixed4 _Color;
//uniform fixed4 _GlobalMultiCol;
//
//struct Input {
//    float2 uv_MainTex;
//    float2 uvgt_ReflectionMask;
//    SURFACE_INPUT_WEATHER
//    SURFACE_INPUT_FOG
//    SURFACE_INPUT_SHADOW_PROJECTOR_COORD
//    SURFACE_INPUT_REFLECTION_COORD
//};
//
//void SurfaceShaderHeightFogVertex(inout appdata_full v, out Input data) {
//    UNITY_INITIALIZE_OUTPUT(Input, data);
//    GT_TRANSFER_WEATHER(data, v);
//    GT_TRANSFER_FOG_SURF(data, v);
//    GT_TRANSFER_SHADOW_PROJECTOR_COORD(data, v);
//}
//
//void SurfaceShaderHeightFogColor(Input IN, SurfaceOutput o, inout fixed4 color) {
//    GT_APPLY_FOG(IN, color);
//}
//
//void surf (Input IN, inout SurfaceOutput o) {
//    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
//    c.rgb = SHADOW_ALBEDO(c, IN);
//    o.Albedo = WEATHER_ALBEDO(c, IN);
//    o.Emission = GT_REFLECTION_COLOR(IN, IN.uvgt_ReflectionMask);
//    o.Alpha = c.a;
//
//    fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
//    o.Albedo *= gColor;
//}
//ENDCG
//}

//Fallback "Game/Unity/Legacy/Legacy-VertexLit"
}
