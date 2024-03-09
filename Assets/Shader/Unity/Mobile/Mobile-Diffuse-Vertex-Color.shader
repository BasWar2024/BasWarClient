// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "Game/Unity/Mobile/Mobile-Diffuse-Vertex-Color" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _WeatherNoiseTex("WeatherNoise", 2D) = "white" {}
    //_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}

SubShader
{
    Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase"}
    LOD 100

    Pass
    {
        Blend SrcAlpha OneMinusSrcAlpha
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        // make fog work
        #pragma multi_compile_fog
        #pragma multi_compile_instancing
        #pragma shader_feature _ GTCloudShadow
        #pragma multi_compile __ SHADER_LOD_MID// SHADER_LOD_LOW
        #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
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
    #if UseVerticalFog || GTCloudShadow
        float3 worldPos : TEXCOORD4;
    #endif
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    sampler2D _MainTex;
    float4 _MainTex_ST;
    uniform float4 _GlobalMultiCol;
    fixed4 _Color;
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
    #endif
    #if UseVerticalFog || GTCloudShadow
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
#endif
            GetCloudShadow(col, i);
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

Fallback "Game/Unity/Mobile/Mobile-VertexLit"
}
