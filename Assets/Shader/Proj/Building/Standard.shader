// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Game/Building/Standard"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _LightMap ("LightMap Tex", 2D) = "white" {}

        [Header((DayNight))][Toggle(_DayNight)] _DayNight("_DayNight", Float) = 1
        [Space(20)]

        // Common
        [PowerSlider(3.0)] _Shininess ("Shininess", Range (0, 10)) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend Mode", Float) = 10
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
        _ColorMask("ColorMask", Float) = 15
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4

        [NoScaleOffset] _LightArray("LightArray", 2DArray) = "white" {}
        [Toggle(LIGHTMAPARR)] LIGHTMAPARR("", Float) = 0
        [Toggle(HightSkinQuality)] HightSkinQuality("", Float) = 0
    }

    SubShader
    {
        LOD 200
        Tags { "RenderType" = "Opaque" }
        Pass
        {
            Tags{ "Queue" = "Background+500" "RenderType" = "Opaque" "LightMode" = "ForwardBase" }
            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            ZTest [_ZTest]
            ColorMask [_ColorMask]

            CGPROGRAM
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
            #pragma shader_feature _ LIGHTMAPARR
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma shader_feature NO_SKIN ROOTOFF_BLENDOFF ROOTOFF_BLENDOFF_KEEPUV2
            #pragma shader_feature _ _DayNight
            #pragma shader_feature _ HightSkinQuality
            #pragma skip_variants FOG_EXP FOG_EXP2

            #pragma vertex vert_tex_base
            #pragma fragment frag_tex_base

            #include "Assets/Shader/Common/Lod_Macro.cginc"
            #include "Assets/Shader/Common/GTCommon.cginc"
            #include "Assets/Shader/Common/GPUSkinningInclude.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
#if USE_SKIN
                float4 uv3 : TEXCOORD2;
#endif
#if SKIN_KEEP_UV2
                float4 uv4 : TEXCOORD3;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
            #if USE_WORLDPOS
                float3 worldPos : TEXCOORD2;
            #endif
                //SHADOW_COORDS(4)
                UNITY_FOG_COORDS(5)

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


            uniform sampler2D _MainTex;
            uniform fixed4 _MainTex_ST;
            uniform sampler2D _LightMap;
            uniform fixed4 _LightMap_ST;

            //uniform fixed4 _Color;
            uniform fixed _Shininess;

        #if _DayNight
            uniform fixed4 _GlobalMultiCol;
        #endif

#if LIGHTMAPARR
            UNITY_DECLARE_TEX2DARRAY(_LightArray);
#endif
            UNITY_INSTANCING_BUFFER_START(Props)
#if LIGHTMAPARR
            UNITY_DEFINE_INSTANCED_PROP(fixed, _LightmapIndex)
#endif
            UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert_tex_base (appdata v)
            {
                v2f o;

                UNITY_INITIALIZE_OUTPUT(v2f, o);

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
#if SKIN_KEEP_UV2
                #if HightSkinQuality
                    v.vertex = skin4(v.vertex, v.uv4, v.uv3);
                #else
                    v.vertex = skin2(v.vertex, v.uv4, v.uv3);
                #endif
#elif USE_SKIN
                #if HightSkinQuality
                    v.vertex = skin4(v.vertex, v.uv2, v.uv3);
                #else
                    v.vertex = skin2(v.vertex, v.uv2, v.uv3);
                #endif
#endif
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord0.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.texcoord0.zw = TRANSFORM_TEX(v.uv2.xy, _LightMap);
            #if USE_WORLDPOS
                o.worldPos.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
            #endif
                //TRANSFER_SHADOW(o);
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            fixed4 frag_tex_base (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                fixed4 col = tex2D(_MainTex, i.texcoord0.xy) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
#if LIGHTMAPARR
                //lightmap 41
                fixed lmIndex = UNITY_ACCESS_INSTANCED_PROP(Props, _LightmapIndex);
                fixed4 dirlm = UNITY_SAMPLE_TEX2DARRAY(_LightArray, fixed3(i.texcoord0.zw, lmIndex));
                //Lightmap,RGBM,M=4.6
               // col.rgb *= DecodeLightmap(dirlm);
                col.rgb *= dirlm.rgb * 4.6;
#else
                //PCRGBA HalfRGBA/ETC2 * 4.6
                col.rgb *= DecodeLightmap(tex2D(_LightMap, i.texcoord0.zw));
#endif
                col *= _Shininess;
            #if SHADER_LOD_LEVEL < 2
                GetCloudShadow(col, i);
                CalculateBakeShadow(col, i);
                CalculateShadowMap(col, i);
            #endif

                //col.rgb *= SHADOW_ATTENUATION(i);
            #if _DayNight
                BlendGlobalColor(col)
            #endif
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }

            ENDCG
        }
     //   UsePass "Game/CommonDepthPass/Depth"
    }
    Fallback "Game/Base/ShadowCaster"
}
