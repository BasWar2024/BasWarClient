Shader "Unlit/BakeShadowmap"
{
	Properties{
		   _MainTex("Main Texture", 2D) = "white" {}
	_Cutoff("", Range(0,1)) = 0.5

	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100
		Cull back
	//	Cull Front
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_instancing
			 #pragma multi_compile __ UseAlphaClip
			#include "UnityCG.cginc"
			uniform float _ShadowBias;
			struct VertexInput
			{
				float4 vertex : POSITION;
#if UseAlphaClip
				float2 texcoord0 : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float2 depth  : TEXCOORD0;
				float4 vertex : SV_POSITION;
#if UseAlphaClip
				fixed2 texcoord0 : TEXCOORD2;
#endif
				UNITY_VERTEX_OUTPUT_STEREO
			};
#if UseAlphaClip
			uniform sampler2D _MainTex;
			uniform fixed _Cutoff;
#endif
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
#if defined (UNITY_REVERSED_Z)
				o.vertex.z += _ShadowBias;   //(1, 0)-->(0, 1)
#else
				o.vertex.z -= _ShadowBias * 2;
#endif
#if UseAlphaClip
				o.texcoord0 = v.texcoord0;
#endif
				o.depth = o.vertex.zw;
				return o;			 	
			}						 	
									 	
			fixed4 frag(VertexOutput i) : SV_Target
			{
#if UseAlphaClip
	     	   fixed4 col = tex2D(_MainTex, i.texcoord0.xy);
			   clip(col.a - _Cutoff);
#endif
				float depth = i.depth.x / i.depth.y;
			#if defined (UNITY_REVERSED_Z)
				depth = 1 - depth;       //(1, 0)-->(0, 1)
			#else
				depth = depth * 0.5 + 0.5;
			#endif
				return depth;
			}						 

			ENDCG					 	
		}
	}				
		SubShader
			{
				Tags { "RenderType" = "TransparentCutout" }
				LOD 100

				Cull back

				Pass
				{
					CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma target 3.0
					#pragma multi_compile_instancing
					#include "UnityCG.cginc"
					uniform float _ShadowBias;
					uniform sampler2D _MainTex;
					uniform fixed4 _MainTex_ST;
					uniform float _Cutoff;
					struct VertexInput
					{
						float4 vertex : POSITION;
						float2 texcoord0 : TEXCOORD0;
						UNITY_VERTEX_INPUT_INSTANCE_ID
					};

					struct VertexOutput
					{
						float2 depth  : TEXCOORD0;
						float4 vertex : SV_POSITION;
						float2 texcoord0 : TEXCOORD1;
						UNITY_VERTEX_OUTPUT_STEREO
					};

					VertexOutput vert(VertexInput v)
					{
						VertexOutput o;
						UNITY_SETUP_INSTANCE_ID(v);
						UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
						o.vertex = UnityObjectToClipPos(v.vertex);
						o.texcoord0.xy = TRANSFORM_TEX(v.texcoord0, _MainTex);
						o.vertex.z += _ShadowBias;

						o.depth = o.vertex.zw;
						return o;
					}

					fixed4 frag(VertexOutput i) : SV_Target
					{
							fixed4 clr = tex2D(_MainTex, i.texcoord0.xy);
							clip(clr.a - _Cutoff);
							float depth = i.depth.x / i.depth.y;
#if defined (UNITY_REVERSED_Z)
							depth = 1 - depth;       //(1, 0)-->(0, 1)
#else
							depth = depth * 0.5 + 0.5;
#endif
							return depth;
					}

					ENDCG
				}
			}
	
}									 	
									 	
									 	
									 	

									 	
									 	
									 	
									 	
									 	
									 	
									 	

									 	
									 	
									 	
									 	
									 	
									 	
									 	