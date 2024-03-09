

Shader "Game/Effect/Rim"
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
		_MainTex ("Texture", 2D) = "white" {}

		_RimColor("Rim Color", Color) = (0.5,0.5,0.5,0.5)
		_InnerColor("Inner Color", Color) = (0.5,0.5,0.5,0.5)
		_InnerColorPower("Inner Color Power", Range(0.0,1.0)) = 0.5
		_RimPower("Rim Power", Range(0.0,5.0)) = 2.5
		_AlphaPower("Alpha Rim Power", Range(0.0,8.0)) = 4.0
		_AllPower("All Power", Range(0.0, 10.0)) = 1.0
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

			#include "../Common/GTCommon.cginc"

			float _BlendMode;

			//To do Custom Thing
			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _RimColor;
			float _RimPower;
			float _AlphaPower;
			float _AlphaMin;
			float _InnerColorPower;
			float _AllPower;
			float4 _InnerColor;

			struct VertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct VertexOutput {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				half3 viewDir : TEXCOORD1;
				half3 normal : TEXCOORD2;
			};


			VertexOutput vert (VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				return o;
			}

			fixed4 frag (VertexOutput i) : SV_Target
			{
				fixed4 mainCol = tex2D(_MainTex, i.uv);
				fixed rim = 1.0 - saturate(dot(i.viewDir, i.normal));
				fixed4 col = mainCol * fixed4(pow(rim, _RimPower) * _AllPower * _RimColor.rgb + (2 * _InnerColorPower * _InnerColor.rgb), pow(rim, _AlphaPower) * _AllPower);
				return col;
			}
			ENDCG
		}
	}
	CustomEditor "GTEffectShaderGUI"
}

