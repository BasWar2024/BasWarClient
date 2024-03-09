// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Game/Building/Standard-Clip"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _LightMap ("LightMap Tex", 2D) = "white" {}
        _NoiseClip("NoiseClip Tex", 2D) = "black" {}
        [Space(20)]
        // Common
        [PowerSlider(3.0)] _Shininess ("Shininess", Range (0, 10)) = 1
         _ClipHeight("", Range(-30, 30)) = 30
         _ClipEdge("", Range(0, 100)) = 4
         _ClipTexEdge("", Range(0, 100)) = 1
         [MaterialToggle]_ClipDir("", Range(0,1)) = 0
     /*   [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend Mode", Float) = 10
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
        _ColorMask("ColorMask", Float) = 15
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4*/
    }

    SubShader
    {
        LOD 200
        Tags { "RenderType" = "Opaque" }
        Pass
        {

          Tags{ "Queue" = "Background+500" "RenderType" = "Opaque" "LightMode" = "ForwardBase" }
        //    Blend SrcAlpha OneMinusSrcAlpha
        //    ZWrite Off
         //   Cull Front
         //   ColorMask [_ColorMask]

            CGPROGRAM
            #pragma multi_compile_instancing
            #define _DayNight 1
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
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 worldPos : TEXCOORD2;
                //SHADOW_COORDS(4)
                UNITY_FOG_COORDS(5)

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


            uniform sampler2D _MainTex,_NoiseClip;
            uniform fixed4 _MainTex_ST,_NoiseClip_ST;
            uniform sampler2D _LightMap;
            uniform fixed4 _LightMap_ST;
            uniform float _ClipHeight, _ClipEdge;
            //uniform fixed4 _Color;
            uniform fixed _Shininess;
            uniform fixed _ClipDir, _ClipTexEdge;
        #if _DayNight
            uniform fixed4 _GlobalMultiCol;
        #endif

            UNITY_INSTANCING_BUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert_tex_base (appdata v)
            {
                v2f o;

                UNITY_INITIALIZE_OUTPUT(v2f, o);

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
#if SKIN_KEEP_UV2
                v.vertex = skin2(v.vertex, v.uv4, v.uv3);
#elif USE_SKIN
                v.vertex = skin2(v.vertex, v.uv2, v.uv3);
#endif
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord0 = TRANSFORM_TEX(v.uv, _MainTex);
                o.texcoord1 = TRANSFORM_TEX(v.uv2.xy, _LightMap);
                o.worldPos.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
                //
                o.worldPos.w = v.vertex.y;
                //TRANSFER_SHADOW(o);
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            fixed4 frag_tex_base (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                fixed4 col = tex2D(_MainTex, i.texcoord0.xy) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
                col.rgb *= DecodeLightmap(tex2D(_LightMap, i.texcoord1));
                float clipPos = (i.worldPos.w - _ClipHeight) * _ClipEdge + tex2D(_NoiseClip, TRANSFORM_TEX(i.worldPos.xz,_NoiseClip)).r * _ClipTexEdge;
                clipPos = saturate(clipPos);
                clipPos = lerp(clipPos, 1 - clipPos, _ClipDir);
                col *= _Shininess;
            #if SHADER_LOD_LEVEL < 2
                GetCloudShadow(col, i);
                CalculateBakeShadow(col, i);
                CalculateShadowMap(col, i);
            #endif

                //col.rgb *= SHADOW_ATTENUATION(i);
            #if _DayNight
                fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                col.rgb *= gColor;
            #endif
                UNITY_APPLY_FOG(i.fogCoord, col);
              //  col.a = clipPos;
                clip(clipPos-0.5);
                return col;
            }

            ENDCG
        }
     //   UsePass "Game/CommonDepthPass/Depth"
    }
    Fallback "Game/Base/ShadowCaster"
}
