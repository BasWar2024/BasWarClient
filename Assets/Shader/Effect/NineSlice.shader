/*
	 sclaebounding
	scale  0-0.3  0-0.5 
	minScale  minValue ,maxScale  maxValue
*/
Shader "Game/Effect/Nine-Slice"
{
	Properties
	{
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
		//Stencil
		[HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
        [HideInInspector]_Stencil ("Stencil ID", Float) = 0
        [HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255
		[HideInInspector]_ColorMask ("Color Mask", Float) = 15

		_Bounding ("Bounding (xMin,xMax & yMin,yMax)", vector) = (0.2,0.8,0.2,0.8)
		_Scale ("Scale(xMin,xMax & yMin, yMax)", vector) = (0.35,0.65,0.35,0.65)
		_ObjectScale ("ObjectScale", Float) = 1
		_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Particle Texture", 2D) = "white" {}
		_EmissionGain("Emission Gain", Range(0, 20)) = 1
		[Toggle(_DEBUG)] _DEBUG("DEBUG", Float) = 0
	}
	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
			"PreviewType"="Plane"
            "LightMode" = "ForwardBase"
		}

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
			#pragma shader_feature _DEBUG

			#include "UnityCG.cginc"

			float _BlendMode,_ObjectScale;
			fixed4 _TintColor;
			float _EmissionGain;
			float4 _ClipRect;
			sampler2D _MainTex;
			float4 _MainTex_ST,_Bounding,_Scale;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
			#ifdef UNITY_UI_CLIP_RECT
				float4 worldPosition : TEXCOORD1;
			#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};



			v2f vert (appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.color = v.color;
			#ifdef UNITY_UI_CLIP_RECT
				o.worldPosition = v.vertex;
			#endif
				return o;
			}
			//
			inline float map(float value, float originalMin, float originalMax, float newMin, float newMax)
			{
				 return (value - originalMin) / (originalMax - originalMin) * (newMax - newMin) + newMin;
			}

			inline float processAxis(float coord, float2 bounding ,float2 scale)
			{
				fixed minBlock = step(coord, bounding.x);
 				fixed maxBlock = step(bounding.y, coord);
				fixed centerBlock = 1 - (minBlock + maxBlock);
				fixed minGradient = max(0, map(minBlock * coord, 0, bounding.x, 0, scale.x) * minBlock);
				fixed maxGradient = max(0, map(maxBlock * coord, bounding.y, 1, scale.y, 1) * maxBlock);
				fixed centerGradient = map(centerBlock * coord, bounding.x, bounding.y, scale.x, scale.y) * centerBlock;
				#if defined(_DEBUG)
					centerGradient = 0;
				#endif
				return minGradient + maxGradient + centerGradient;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				float2 newUV = float2(processAxis(i.uv.x,_Bounding.xy, _Scale.xy),processAxis(i.uv.y, _Bounding.zw, _Scale.zw));
				fixed4 col = tex2D(_MainTex, newUV);
				col *= 2.0f * _EmissionGain * i.color * _TintColor;
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
