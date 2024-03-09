
Shader "Game/Unity/Mobile/ParticlesColorGradation"
{
	Properties
	{
		//To do Custom Thing
		_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Particle Texture", 2D) = "white" {}
		_EmissionGain("Emission Gain", Range(0, 20)) = 1
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
	}
	SubShader
	{
        Tags{ "LightMode" = "ForwardBase" }
		Cull[_CullMode]
		ZWrite[_ZWrite]
		ZTest[_ZTest]
		Blend[_SrcBlend][_DstBlend]

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#pragma multi_compile __ GTColorGradation

			#include "../../Common/GTCommon.cginc"
			float _BlendMode;

			//To do Custom Thing
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _TintColor;
			float _EmissionGain;
			float4 _ClipRect;
			struct VertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
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
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag (VertexOutput i) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 col = 2.0f * _EmissionGain * i.color * _TintColor * tex2D(_MainTex, i.uv);
				// HDRAlpha1
				col.a = saturate(col.a);
				GT_COLOR_GRADATION(col);
				return col;
			}
			ENDCG
		}
	}
	CustomEditor "GTEffectShaderGUI"
}
