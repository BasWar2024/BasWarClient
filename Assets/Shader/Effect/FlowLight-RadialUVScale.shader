Shader "Hidden/Effect/FlowLight-RadialUVScale" {
	Properties {
		// Cull
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 0.0

		// ZTest
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", Float) = 4.0

		// ZWrite
		[Enum(Off, 0, On, 1)] _ZWrite("Z Write", Float) = 0.0


		// Blend
		[HideInInspector] _BlendMode("BlendMode", Float) = 1.0
		[HideInInspector] _SrcBlend("__src", Float) = 5.0
		[HideInInspector] _DstBlend("__dst", Float) = 10.0

		_MainTex ("MainTex", 2D) = "white" {}
		_EmissTex ("EmissTex", 2D) = "white" {}
		_EmissOffset("Emiss RadialUVScale Offset",Range(0,1)) = 0
		//_EmissColor("Emiss Color",Color) = (0.3,0.59,0.11,1)
		_EmissGain ("EmissGain", Float ) = 5
		_TintColor ("Tint Color",Color) = (1,1,1,1)
		_Mask("Mask Tex(R Channel)",2D) = "white"{}
	}
	SubShader {
		Tags {
			"IgnoreProjector"="True"
			"Queue"="Transparent"
			"RenderType"="Transparent"
            "LightMode" = "ForwardBase"
		}
		Pass {
			Cull[_CullMode]
			ZWrite[_ZWrite]
			ZTest[_ZTest]
			Blend[_SrcBlend][_DstBlend]

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu
            #include "UnityCG.cginc"

			uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
			uniform sampler2D _EmissTex; uniform half4 _EmissTex_ST;
			uniform sampler2D _Mask; uniform half4 _Mask_ST;
			uniform float _EmissGain;
			uniform float _EmissOffset;
			float4 _TintColor;
			//uniform float4 _EmissColor;
			struct VertexInput {
				float4 vertex : POSITION;
				float2 texcoord0 : TEXCOORD0;
				half4 vertexColor : COLOR;
			};
			struct VertexOutput {
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				half4 vertexColor : COLOR;
			};
			VertexOutput vert (VertexInput v) {
				VertexOutput o = (VertexOutput)0;
				o.uv0 = v.texcoord0;
				o.vertexColor = v.vertexColor;
				o.pos = UnityObjectToClipPos( v.vertex );
				return o;
			}
			half4 frag(VertexOutput i) : COLOR {
				float2 uvCenter = float2(0.5,0.5);
				float2 uvOffset = i.uv0 + (i.uv0 - uvCenter)/_EmissOffset;
				float2 uv = saturate(lerp(uvOffset,uvCenter,_EmissOffset));
				half4 _EmissTex_var = tex2D(_EmissTex,TRANSFORM_TEX(uv, _EmissTex));
				half4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
				half mask = tex2D(_Mask, TRANSFORM_TEX(i.uv0, _Mask));
				half3 emissive = i.vertexColor.rgb* _EmissGain * _EmissTex_var.rgb * _EmissTex_var.a * _MainTex_var.rgb * _TintColor.rgb;
				half3 finalColor = emissive;
				return half4(finalColor,i.vertexColor.a * mask);
			}
			ENDCG
		}
	}
	CustomEditor "GTEffectShaderGUI"
}
