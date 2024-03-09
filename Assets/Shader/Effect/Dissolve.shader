// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Game/Effect/Dissolve"
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
		_MainTex("Base (RGB)", 2D) = "white" {}
		_DissolveTex("Dissolve Texture", 2D) = "white" {}
		_LimitValue("Percent", Range(0.0, 1.0)) = 0.0
		_BrightFactor("Bright Factor", Range(0.0, 4.0)) = 1.0
		_Color("Color", Color) = (1, 1, 1, 1)
		_EdgeColor("EdgeColor", Color) = (1, 1, 1, 1)
		_EdgeWidth("EdgeWidth", Range(0.0, 1.0)) = 0.5
		_EdgeBright("EdgePower", Range(1, 10)) = 1
	}
	SubShader
	{
        Tags{"LightMode" = "ForwardBase"}
		Cull[_CullMode]
		ZWrite[_ZWrite]
		ZTest[_ZTest]
		Blend[_SrcBlend][_DstBlend]

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "../Common/GTCommon.cginc"

			float _BlendMode;

			//To do Custom Thing
			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			sampler2D _DissolveTex;
			fixed4 _DissolveTex_ST;
			float _LimitValue;
			float _BrightFactor;
			float4 _Color;

			// edge
			float4 _EdgeColor;
			float _EdgeWidth;
			float _EmissionGain;
			float _EdgeBright;

			struct VertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct VertexOutput {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};


			VertexOutput vert (VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _DissolveTex);
				o.color = v.color;
				return o;
			}

			fixed4 frag (VertexOutput i) : SV_Target
			{
				half4 texColor = tex2D(_MainTex,i.uv.xy);
				clip(texColor.a - 0.01);
				half maskValue = tex2D(_DissolveTex,i.uv.zw).r;
				_LimitValue *= i.color.a;
				// _LimitValue
				half dist = _LimitValue - maskValue - 0.001;
				texColor *= _Color * i.color;
				texColor.rgb *= _BrightFactor;
				float blendFactor = lerp(1, saturate(dist / _EdgeWidth), _EdgeWidth > 0);
				half3 resCol = lerp(_EdgeColor.rgb * _EdgeBright, texColor.rgb,  blendFactor);
				return half4(resCol, texColor.a * ceil(dist)); //clip alpha
			}
			ENDCG
		}
	}
	CustomEditor "GTEffectShaderGUI"
}
