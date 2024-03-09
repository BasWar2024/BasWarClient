// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Game/Proj/UI/UI-Custom" {
Properties {
    [PerRendererData] _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}

    // 
    [Space(20)][Header((Gray))][Toggle(_GRAY)] _GRAY("_GRAY", Float) = 0
    _FactorR ("Gray Factor R", Range(0, 1)) = 0.299
    _FactorG ("Gray Factor G", Range(0, 1)) = 0.587
    _FactorB ("Gray Factor B", Range(0, 1)) = 0.114

    [Space(20)]
    _StencilComp ("Stencil Comparison", Float) = 8
    _Stencil ("Stencil ID", Float) = 0
    _StencilOp ("Stencil Operation", Float) = 0
    _StencilWriteMask ("Stencil Write Mask", Float) = 255
    _StencilReadMask ("Stencil Read Mask", Float) = 255

    _ColorMask ("Color Mask", Float) = 15

    [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
}

SubShader {
    Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

    Stencil
    {
        Ref [_Stencil]
        Comp [_StencilComp]
        Pass [_StencilOp]
        ReadMask [_StencilReadMask]
        WriteMask [_StencilWriteMask]
    }

    LOD 100
    Cull Off
    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha
    ZTest [unity_GUIZTestMode]
    ColorMask [_ColorMask]

    Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP
            #pragma multi_compile __ _GRAY

            struct appdata_t {
                float4 vertex : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // 
            #if _GRAY
                fixed _FactorR, _FactorG, _FactorB;
            #endif

            float4 _ClipRect;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.worldPosition = v.vertex;
                o.vertex = UnityObjectToClipPos(o.worldPosition);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.texcoord);

                // 
                #if _GRAY
                    fixed gray = dot(col.rgb, fixed3(_FactorR, _FactorG, _FactorB));
                    col.rgb = fixed3(gray, gray, gray);
                #endif

                #ifdef UNITY_UI_CLIP_RECT
                    col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                    clip(col.a - 0.001);
                #endif

                return col;
            }
            ENDCG
        }
    }
}
