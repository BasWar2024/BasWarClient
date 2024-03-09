Shader "Game/Unity/Legacy/Legacy-Diffuse-Vertex-Color" {
Properties {
    // Blend
    [HideInInspector] _BlendMode("BlendMode", Float) = 0.0
    [HideInInspector] _SrcBlend("__src", Float) = 5.0
    [HideInInspector] _DstBlend("__dst", Float) = 10.0
    // Cull
    [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0
    // ZTest
    [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", Float) = 4.0
    // ZWrite
    [Enum(Off, 0, On, 1)] _ZWrite("Z Write", Float) = 0
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _WeatherNoiseTex("WeatherNoise", 2D) = "white" {}
    [Toggle(OBJBlend)] OBJBlend("", Float) = 0
    _BlendHeight("",Float) = 0
    _BlendGradient("",Float) = 1
}

SubShader
{
    Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "LightMode" = "ForwardBase"}
    LOD 100


    Pass
    {
        Cull[_CullMode]
        ZWrite[_ZWrite]
        ZTest[_ZTest]
        Blend[_SrcBlend][_DstBlend]
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        // make fog work
        #pragma multi_compile_fog
        #pragma multi_compile_instancing
        #pragma shader_feature _ OBJBlend
        #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
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
            float4 color : COLOR;
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float3 normalDir : TEXCOORD0;
            float4 uv : TEXCOORD1;
            UNITY_FOG_COORDS(2)
            VERTEX_GI_COORDS(3)
            float4 color : TEXCOORD4;
        #if USE_WORLDPOS
            float3 worldPos : TEXCOORD5;
        #endif
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        uniform float4 _GlobalMultiCol;
        fixed4 _Color;
#if OBJBlend
        float _BlendHeight;
        float _BlendGradient;
#endif
        v2f vert(appdata v)
        {
            v2f o;
            UNITY_INITIALIZE_OUTPUT(v2f, o);
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_TRANSFER_INSTANCE_ID(v, o);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            o.color = v.color;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.normalDir.xyz = UnityObjectToWorldNormal(v.normal);
            o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
        #if LIGHTMAP_ON
            o.uv.zw = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        #endif
        #if USE_WORLDPOS
            o.worldPos.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
        #endif
#if OBJBlend
         //   o.worldPos.w = saturate((v.vertex.y + _BlendHeight) * _BlendGradient);
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
            fixed4 col = albedo * _Color * i.color;

        #if  SHADER_LOD_LEVEL < 2
            //lightmap
            CalculateLighMap(col,i.uv.zw);
            GT_BLEND_VERTEX_GI(col,i);
            GetCloudShadow(col, i);
        #endif
#if  OBJBlend
            fixed4 blendColor;
            GetObjBlendColor(blendColor, i.worldPos);
            col.rgb = lerp(blendColor.rgb, col.rgb, saturate((i.worldPos.y + _BlendHeight) * _BlendGradient));
          //  col.rgb = lerp(blendColor.rgb, col.rgb, saturate(i.color.a));
            col.a = 1;
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
    CustomEditor "GTEffectShaderGUI"
}
