Shader "Game/Unity/Legacy/Legacy-Transparent-Cutout-Diffuse" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    _WeatherNoiseTex("WeatherNoise", 2D) = "white" {}
}

SubShader {
    Tags {"Queue"="AlphaTest" "RenderType"="TransparentCutout"}
    LOD 200

CGPROGRAM

#include "../../Common/GTSceneShaderUtilities.cginc"
#pragma surface surf GTLambert alphatest:_Cutoff vertex:SurfaceShaderHeightFogVertex finalcolor:SurfaceShaderHeightFogColor
#pragma multi_compile_fog
#pragma skip_variants SHADOWS_CUBE POINT_COOKIE FOG_EXP FOG_EXP2 DYNAMICLIGHTMAP_ON DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE SPOT POINT DIRECTIONAL_COOKIE POINT_COOKIE LIGHTMAP_SHADOW_MIXING

sampler2D _MainTex;
fixed4 _Color;
uniform fixed4 _GlobalMultiCol;

struct Input {
    float2 uv_MainTex;
    SURFACE_INPUT_WEATHER
    SURFACE_INPUT_FOG
    SURFACE_INPUT_SHADOW_PROJECTOR_COORD
};

void SurfaceShaderHeightFogVertex(inout appdata_full v, out Input data) {
    UNITY_INITIALIZE_OUTPUT(Input, data);
    GT_TRANSFER_WEATHER(data, v);
    GT_TRANSFER_FOG_SURF(data, v);
    GT_TRANSFER_SHADOW_PROJECTOR_COORD(data, v);
}

void SurfaceShaderHeightFogColor(Input IN, SurfaceOutput o, inout fixed4 color) {
    GT_APPLY_FOG(IN, color);
}

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
    c.rgb = SHADOW_ALBEDO(c, IN);
    o.Albedo = WEATHER_ALBEDO(c, IN);
    o.Alpha = c.a;

    fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
    o.Albedo *= gColor;
}
ENDCG
}

//Fallback "Game/Unity/Legacy/Legacy-Transparent-Cutout-VertexLit"
}
