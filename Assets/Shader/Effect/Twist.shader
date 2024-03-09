
Shader "Game/Effect/Twist"
{
	Properties
	{
		//To do Custom Thing
		_AlphaTex("", 2D) = "while" {}
		_NoiseTex("", 2D) = "black" {}
		_Speed("(xy)&(z)",vector) = (1,1,1,0)// 
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", Float) = 8.0
	}
		SubShader
		{
			Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" "LightMode" = "ForwardBase"}
			ZTest[_ZTest]
			ZWrite Off
		//	GrabPass{"_GTGrab"}
			Blend SrcAlpha OneMinusSrcAlpha
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "../Common/GTCommon.cginc"

				float4 _Speed;
				sampler2D _NoiseTex, _AlphaTex;
				float4 _NoiseTex_ST, _MainTex_ST, _AlphaTex_ST;
				sampler2D _GTGrab;
				sampler2D _GTGrabAfterForwardAlpha;
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
				#ifdef UNITY_UI_CLIP_RECT
					float4 worldPosition : TEXCOORD1;
				#endif
					float4 grabPos : TEXCOORD2;

				};


				VertexOutput vert (VertexInput v)
				{
					VertexOutput o;
					UNITY_INITIALIZE_OUTPUT(VertexOutput, o);
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv.xy = TRANSFORM_TEX(v.uv.xy, _NoiseTex);
					o.uv.zw = TRANSFORM_TEX(v.uv.xy, _AlphaTex);
					o.color = v.color;
					o.grabPos = ComputeGrabScreenPos(o.pos);
					return o;
				}

				fixed4 frag(VertexOutput i) : SV_Target
				{
					float2 noiseOffset = tex2D(_NoiseTex,i.uv.xy + _Speed.xy * _Time.y ).rr;
					noiseOffset *= tex2D(_AlphaTex, i.uv.zw).r * _Speed.z;;
					fixed4 color = tex2Dproj(_GTGrabAfterForwardAlpha, i.grabPos + float4(noiseOffset.xy,0,0));
					color.a = i.color.a;
					return color;
				}
				ENDCG
			}
	}
}
