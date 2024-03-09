// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Game/Unity/Unlit/Transparent-FogOff" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}

    [Space(20)]
    // Cull
    [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0

    _Brightness("Brightness", Range(0, 10)) = 1

    [Space(20)][Header((DayNight))][Toggle(_DayNight)] _DayNight("_DayNight", Float) = 1
    [Toggle(ReceiveShadowMap)] ReceiveShadowMap("ReceiveShadowMap", Float) = 0
    [Toggle(UV2Tex)] UV2Tex("UseUV2", Float) = 0
}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "LightMode" = "ForwardBase"}
    LOD 100

    Cull[_CullMode]
    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha

    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #pragma shader_feature _ _DayNight
            #pragma multi_compile __ ReceiveShadowMap
            #pragma multi_compile __ UseShadowMap
            #pragma multi_compile __ UV2Tex

            #include "UnityCG.cginc"
            #include "Assets/Shader/Common/GTCommon.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
#if UV2Tex
                float4 texcoord : TEXCOORD0;
#else
                float2 texcoord : TEXCOORD0;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
#if UV2Tex
                float4 texcoord : TEXCOORD0;
#else
                float2 texcoord : TEXCOORD0;
#endif
#if defined(USE_WORLDPOS)
                float3 worldPos :TEXCOORD1;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            uniform fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            uniform float _Brightness;

        #if _DayNight
            uniform fixed4 _GlobalMultiCol;
        #endif

            v2f vert (appdata_t v)
            {
                v2f o;

                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
#if UV2Tex
                o.texcoord.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                o.texcoord.zw = TRANSFORM_TEX(v.texcoord.zw, _MainTex);
#else
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
#endif
#if defined(USE_WORLDPOS)
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
#endif
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
#if UV2Tex
                fixed4 col = tex2D(_MainTex, i.texcoord.xy);
             //   if (i.texcoord.z > 0 && i.texcoord.w>0)
              //  {
                    fixed4 col2 = tex2D(_MainTex, i.texcoord.zw);
                    col = float4(lerp(col.rgb, col2.rgb, col2.a), max(col2.a, col.a));
              //  }
#else
                fixed4 col = tex2D(_MainTex, i.texcoord);
#endif
                col.rgb *= _Brightness;
                col *= _Color;

            #if _DayNight
                fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                col.rgb *= gColor;
            #endif
            #if ReceiveShadowMap
                CalculateShadowMap(col, i);
            #endif
                return col;
            }
        ENDCG
    }
}

}
