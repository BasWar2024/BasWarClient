
Shader "Game/Effect/GTDissolve"
{
	Properties
	{
		// Cull
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0
		// ZTest
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", Float) = 4.0
		// Blend
		[HideInInspector] _BlendMode("BlendMode", Float) = 0.0
		[HideInInspector] _SrcBlend("__src", Float) = 5.0
		[HideInInspector] _DstBlend("__dst", Float) = 10.0
		// ZWrite
		[Enum(Off, 0, On, 1)] _ZWrite("Z Write", Float) = 0
		//To do Custom Thing
		_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Particle Texture", 2D) = "white" {}
		_EmissionGain("Emission Gain", Range(0, 20)) = 1
		[Space(20)]
		[HDR]_DisolveColor("", Color) = (0.5,0.5,0.5,0.5)
		_DisolveTex("", 2D) = "white" {}
		_Dissolve("", Range(0.0, 1.0)) = 0
		_DissolveEdge("", Range(0.0, 10)) = 4
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
			#pragma multi_compile_particles
			#pragma multi_compile_instancing
			#pragma multi_compile __ UNITY_UI_CLIP_RECT

			#include "../Common/GTCommon.cginc"
			#include "UnityUI.cginc"

			float _BlendMode;
			fixed _Dissolve;
			float4 _DisolveColor;

			sampler2D _DisolveTex;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _TintColor;
			float _EmissionGain;
			float4 _ClipRect;
			float _DissolveEdge;
			struct VertexInput
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				fixed4 color : COLOR;
			#ifdef UNITY_UI_CLIP_RECT
				float4 worldPosition : TEXCOORD1;
			#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};


			VertexOutput vert (VertexInput v)
			{
				VertexOutput o;
				UNITY_INITIALIZE_OUTPUT(VertexOutput, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
			#ifdef UNITY_UI_CLIP_RECT
				o.worldPosition = v.vertex;
			#endif
				o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
				//ParticleSystem Custom Data
				o.uv.zw = v.uv.zw;
				return o;
			}

			fixed4 frag (VertexOutput i) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);

				fixed4 col = 2.0f * _EmissionGain * i.color * _TintColor * tex2D(_MainTex, i.uv);
				float customDissovle = saturate(_Dissolve+i.uv.z);
				float dissolve = 1 - customDissovle;
				float clipVale =  ( dissolve  * 1.2 -0.6 ) + tex2D( _DisolveTex, i.uv).r ;
				float edge = 1 - saturate ( clipVale * 8 - _DissolveEdge);
				col.rgb += edge * _DisolveColor.rgb * customDissovle;
				clip( clipVale - 0.5 );
				// HDRAlpha1
				col.a = saturate(col.a);
			#ifdef UNITY_UI_CLIP_RECT
                col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
            #endif
				return col;
			}
			ENDCG
		}
	}
	CustomEditor "GTEffectShaderGUI"
}
