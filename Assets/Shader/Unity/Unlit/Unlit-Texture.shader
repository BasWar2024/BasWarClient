// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Game/Unity/Unlit/Unlit-Texture" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _MainColor ("Color", Color) = (1, 1, 1, 1)
}

SubShader {
    Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
    LOD 100

    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile __ GTCloudShadow
            #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
            #pragma skip_variants FOG_EXP FOG_EXP2

            #include "../../Common/Lod_Macro.cginc"
            #include "../../Common/GTCommon.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                half2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            #if (UseVerticalFog || (GTCloudShadow && SHADER_LOD_LEVEL<2))
                float3 worldPos : TEXCOORD2;
            #endif
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;
            uniform fixed4 _GlobalMultiCol;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
            #if (UseVerticalFog || (GTCloudShadow && SHADER_LOD_LEVEL<2))
                o.worldPos.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
            #endif
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.texcoord);
                col *= _MainColor;
                UNITY_OPAQUE_ALPHA(col.a);
#if  SHADER_LOD_LEVEL < 2
                GetCloudShadow(col, i);
#endif
                fixed3 gColor = lerp(fixed3(1, 1, 1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                col.rgb *= gColor.rgb;

                UNITY_APPLY_FOG(i.fogCoord, col);

                return col;
            }
        ENDCG
    }
}

}
