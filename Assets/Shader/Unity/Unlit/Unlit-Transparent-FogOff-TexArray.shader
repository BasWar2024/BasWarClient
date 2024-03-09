// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Game/Unity/Unlit/Transparent-FogOff-TexArray" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    [NoScaleOffset]_MainTexArray("MainTexArray", 2DArray) = "white" {}

    [Space(20)]
    // Cull
    [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0
    _Brightness("Brightness", Range(0, 10)) = 1

    [Space(20)][Header((DayNight))][Toggle(_DayNight)] _DayNight("_DayNight", Float) = 1
    [Toggle(ReceiveShadowMap)] ReceiveShadowMap("ReceiveShadowMap", Float) = 0
}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    LOD 100

    Cull[_CullMode]
    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha

    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #pragma multi_compile __ UseShadowMap
            #pragma multi_compile __ ReceiveShadowMap
            #define _DayNight 1
            #include "UnityCG.cginc"
            #include "Assets/Shader/Common/GTCommon.cginc"
            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
#if defined(USE_WORLDPOS)
                float3 worldPos :TEXCOORD4;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            uniform fixed4 _Color;
            uniform float _Brightness;
            UNITY_DECLARE_TEX2DARRAY(_MainTexArray);
            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(fixed4, _InstanceProp0)
            UNITY_INSTANCING_BUFFER_END(Props)
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
                o.texcoord = v.texcoord;

            #if defined(USE_WORLDPOS)
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
            #endif
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                float4 instanceProp = UNITY_ACCESS_INSTANCED_PROP(Props, _InstanceProp0);
                fixed4 col = UNITY_SAMPLE_TEX2DARRAY(_MainTexArray, float3(i.texcoord, instanceProp.x));// tex2D(_MainTex, i.texcoord);
                col.rgb *= instanceProp.yzw;
                col.rgb *= _Brightness;
                col *= _Color;
#if _DayNight
                BlendGlobalColor(col);
#endif
               // return float4(i.texcoord.y, i.texcoord.y, i.texcoord.y, 1);
#if ReceiveShadowMap
                CalculateShadowMap(col, i);
#endif
                RAIN_SHADING(col, i);


                return col;
            }
        ENDCG
    }
}

}
