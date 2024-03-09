// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Effect/Mask-Add" 
{
	Properties 
	{
		_TintColor ("Tint Color", Color) = (1, 1, 1, 1)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_Mask ("Mask ( R Channel )", 2D) = "white" {}
		
	}

	SubShader 
	{

		Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" "LightMode" = "ForwardBase"}
		Blend SrcAlpha One
		Cull Off Lighting Off ZWrite Off 

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _Mask;
			fixed4 _TintColor;
			
			struct appdata_t 
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				half4 texcoord : TEXCOORD0;
			};
			
			float4 _MainTex_ST;
			float4 _Mask_ST;

				

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _Mask);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 baseCol = tex2D(_MainTex, i.texcoord.xy);
				fixed4 maskCol = tex2D(_Mask, i.texcoord.zw);
				baseCol.a *= maskCol.r;
				return 2.0f * i.color * _TintColor * baseCol;
			}
			ENDCG 
		}
	}
	
	
}
