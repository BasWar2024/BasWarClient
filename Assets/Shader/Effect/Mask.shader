
Shader "Game/Effect/Mask"
{
    Properties
    {
        // Cull
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0

        // ZTest
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", Float) = 4.0

        // ZWrite
        [Enum(Off, 0, On, 1)] _ZWrite("Z Write", Float) = 1.0


        // Blend
        [HideInInspector] _BlendMode("BlendMode", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 5.0
        [HideInInspector] _DstBlend("__dst", Float) = 10.0

        //To do Custom Thing
        _TintColor("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex("Particle Texture", 2D) = "white" {}
        _EmissionGain("Emission Gain", Range(0, 10)) = 2
        _MoveSpeedX ("Move Speed", Range(-10, 10)) = 0
        _MoveSpeedY("Move Speed", Range(-10, 10)) = 0

        [Space(20)]
        [Header(Mask Texture)]
        _Mask("Mask ( R Channel )", 2D) = "white" {}
        _MaskSpeedX ("Mask Speed X", Range(-10, 10)) = 0
        _MaskSpeedY("Mask Speed Y", Range(-10, 10)) = 0

		[Space(20)][Header((MultiColor))][Toggle(_MultiColor)] _MultiColor("_MultiColor", Float) = 0
         [Space(20)][Header((UseCurve))][Toggle(UseCurve)] UseCurve("", Float) = 0
        //Stencil
		[HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
        [HideInInspector]_Stencil ("Stencil ID", Float) = 0
        [HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255
		[HideInInspector]_ColorMask ("Color Mask", Float) = 15
    }
    SubShader
    {
   		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" "LightMode" = "ForwardBase"}
	    Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }
		ColorMask [_ColorMask]
		Cull[_CullMode]
		ZWrite[_ZWrite]
		ZTest[_ZTest]
		Blend[_SrcBlend][_DstBlend]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ _MultiColor
            #pragma multi_compile __ UseCurve

            #include "../Common/GTCommon.cginc"
            #include "UnityUI.cginc"

            float _BlendMode;

            //To do Custom Thing
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _TintColor;
            float _EmissionGain;
            float _MoveSpeedX;
            float _MoveSpeedY;

            sampler2D _Mask;
            float4 _Mask_ST;
            float4 _ClipRect;
            float _MaskSpeedX;
            float _MaskSpeedY;
		    #if _MultiColor
                    uniform fixed4 _GlobalMultiCol;
            #endif

            struct VertexInput
            {
                float4 vertex : POSITION;
#if UseCurve
                float4 uv : TEXCOORD0;
#else
                float2 uv : TEXCOORD0;

#endif
                fixed4 color : COLOR;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                fixed4 color : COLOR;
            #ifdef UNITY_UI_CLIP_RECT
				float4 worldPosition : TEXCOORD1;
			#endif
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
#if UseCurve
                o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex) + v.uv.z * float2(_MoveSpeedX, _MoveSpeedY);
                o.uv.zw = TRANSFORM_TEX(v.uv.xy, _Mask) + v.uv.w * float2(_MaskSpeedX, _MaskSpeedY);

#else
                o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex) + _Time.yy * float2(_MoveSpeedX, _MoveSpeedY);
                o.uv.zw = TRANSFORM_TEX(v.uv.xy, _Mask) + _Time.yy * float2(_MaskSpeedX, _MaskSpeedY);
#endif
            #ifdef UNITY_UI_CLIP_RECT
				o.worldPosition = v.vertex;
			#endif
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
                fixed4 baseCol = tex2D(_MainTex, i.uv.xy);
                fixed4 maskCol = tex2D(_Mask, i.uv.zw);
                #if _MultiColor
                    BlendGlobalColor(i.color);
                #endif
                baseCol.a *= maskCol.r;
            #ifdef UNITY_UI_CLIP_RECT
                i.color.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
            #endif
				return i.color * _TintColor * baseCol * _EmissionGain;
            }

            ENDCG
        }
    }

    CustomEditor "GTEffectShaderGUI"
}
