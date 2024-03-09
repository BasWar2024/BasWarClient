Shader "Game/Unity/Legacy/Legacy-Transparent-Diffuse" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    _WeatherNoiseTex("WeatherNoise", 2D) = "white" {}
}

SubShader
{
    Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase"}
    LOD 100

    Pass
    {
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        // make fog work
        #pragma multi_compile_fog
        #pragma multi_compile_instancing
        #pragma multi_compile __ GTCloudShadow
        #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
        #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON LIGHTMAP_INS
        #pragma skip_variants FOG_EXP FOG_EXP2

    #include "../../Common/Lod_Macro.cginc"
    #include "../../Common/GTCommon.cginc"

    struct appdata
    {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
        float2 uv : TEXCOORD0;
        float2 uv1 : TEXCOORD1;
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    struct v2f
    {
        float4 vertex : SV_POSITION;
        float3 normalDir : TEXCOORD0;
        float4 uv : TEXCOORD1;
        UNITY_FOG_COORDS(2)
        VERTEX_GI_COORDS(3)
    #if USE_WORLDPOS
        float3 worldPos : TEXCOORD4;
    #endif
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    sampler2D _MainTex;
    float4 _MainTex_ST;
    uniform float4 _GlobalMultiCol;
    fixed4 _Color;
#if LIGHTMAP_INS
    UNITY_INSTANCING_BUFFER_START(Props)
    UNITY_DEFINE_INSTANCED_PROP(fixed4, _LightmapST)
    UNITY_INSTANCING_BUFFER_END(Props)
#endif
    v2f vert(appdata v)
    {
        v2f o;
        UNITY_INITIALIZE_OUTPUT(v2f, o);
        UNITY_SETUP_INSTANCE_ID(v);
        UNITY_TRANSFER_INSTANCE_ID(v, o);
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.normalDir.xyz = UnityObjectToWorldNormal(v.normal);
        o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
    #if LIGHTMAP_ON
        o.uv.zw = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    #elif LIGHTMAP_INS
        fixed4 lightmapUvOffset = UNITY_ACCESS_INSTANCED_PROP(Props, _LightmapST);
        o.uv.zw = v.uv1.xy * lightmapUvOffset.xy + lightmapUvOffset.zw;
    #endif
    #if USE_WORLDPOS
        o.worldPos.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
    #endif
        GT_VERTEX_GI(o,o.normalDir,v.vertex);
        UNITY_TRANSFER_FOG(o,o.vertex);
        return o;
    }

    fixed4 frag(v2f i) : SV_Target
    {
        UNITY_SETUP_INSTANCE_ID(i);
        //albedo
        fixed4 albedo = tex2D(_MainTex, i.uv);
        fixed4 col = albedo * _Color;
#if  SHADER_LOD_LEVEL < 2
        //deffuse
        i.normalDir.xyz = normalize(i.normalDir.xyz);
        //lightmap
        CalculateLighMap(col,i.uv.zw);
        GT_BLEND_VERTEX_GI(col,i);
        GetCloudShadow(col, i);
        CalculateShadowMap(col, i);
#endif
        BlendGlobalColor(col);
        GT_COLOR_GRADATION(col);
        // apply fog
        UNITY_APPLY_FOG(i.fogCoord, col);
        CalculateVerticalFog(col,i.worldPos.y);
        return col;
     }
     ENDCG
    }
}
/*
SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 200

CGPROGRAM
#pragma skip_variants SHADOWS_CUBE POINT_COOKIE FOG_EXP FOG_EXP2 DYNAMICLIGHTMAP_ON DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
#include "../../Common/GTSceneShaderUtilities.cginc"
#pragma surface surf GTLambert alpha:blend vertex:SurfaceShaderHeightFogVertex finalcolor:SurfaceShaderHeightFogColor
#pragma multi_compile_fog
#pragma multi_compile __ GT_WEATHER

sampler2D _MainTex;
fixed4 _Color;
uniform fixed4 _GlobalMultiCol;

struct Input {
    float2 uv_MainTex;
    SURFACE_INPUT_WEATHER
    SURFACE_INPUT_FOG
};

void SurfaceShaderHeightFogVertex(inout appdata_full v, out Input data) {
    UNITY_INITIALIZE_OUTPUT(Input, data);
    GT_TRANSFER_WEATHER(data, v);
    GT_TRANSFER_FOG_SURF(data, v);
}

void SurfaceShaderHeightFogColor(Input IN, SurfaceOutput o, inout fixed4 color) {
    GT_APPLY_FOG(IN, color);
}

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
    o.Albedo = WEATHER_ALBEDO(c, IN);
    o.Alpha = c.a;

    fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
    o.Albedo *= gColor;
}
ENDCG
}
*/
//Fallback "Game/Unity/Legacy/Legacy-Transparent-VertexLit"
}
