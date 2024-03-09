// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Game/Unity/Unlit/Unlit-Transparent" {
Properties {
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    // ZWrite
	[Enum(Off, 0, On, 1)] _ZW("", Float) = 0
}

SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "LightMode" = "ForwardBase"}
    LOD 100

    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha
    Pass {
            ZWrite [_ZW]
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma multi_compile __ SHADER_LOD_LOW
            #pragma shader_feature _ RAIN
            #pragma skip_variants FOG_EXP FOG_EXP2

            #include "UnityCG.cginc"
            #include "Assets/Shader/Common/GTCommon.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                half2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
#if defined(USE_WORLDPOS)
               float3 worldPos :TEXCOORD2;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            uniform fixed4 _GlobalMultiCol;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
#if defined(USE_WORLDPOS)
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
#endif
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                fixed4 col = tex2D(_MainTex, i.texcoord);
                BlendGlobalColor(col);
                RAIN_SHADING(col, i);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
    }
}

}
