// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Game/Effect/Chromatic" {
	Properties{
		[Enum(Off, 0, On, 1)] _ZW("ZWrite", Float) = 0
		_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Particle Texture", 2D) = "white" {}
		_EmissionGain("Emission Gain", Range(0, 20)) = 1
		_ChromaticIntensity("ChromaticIntensity",Float) = 1
		_DittherIntensity("DittherIntensity",Float) = 1
		_Speed("Speed",Float) = 1
		_OffsetMap("_OffsetMap",2D) = "black"{}
		_OffsetMapIntensity("_OffsetMapIntensity",Float) = 1
		_OffsetSpeed("_OffsetSpeed",FLoat) = 1
	}

	Category{
		Tags{
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "LightMode" = "ForwardBase"
        }
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask RGBA
		Cull Off
		Lighting Off
		ZWrite[_ZW]

		SubShader{
			Pass{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
            #pragma skip_variants FOG_EXP FOG_EXP2

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _TintColor;

			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				half2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			float4 _MainTex_ST;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			float _EmissionGain;
			float _ChromaticIntensity;
			float _DittherIntensity;
			float _Speed;
			sampler2D _OffsetMap;
			float4 _OffsetMap_ST;
			float _OffsetMapIntensity;
			float _OffsetSpeed;

			fixed4 frag(v2f i) : SV_Target
			{
				float2 uv = i.texcoord;
				float t = _Time.y * 6 * _Speed;
				float offsetNoise = (1.0 + sin(_Time.y * _OffsetSpeed)) * 0.5;
				float4 offset = tex2D(_OffsetMap,TRANSFORM_TEX(uv, _OffsetMap) + float2(offsetNoise, offsetNoise)) * _OffsetMapIntensity;

				float d = length(uv - float2(0.5,0.5));
				float blur = 0.0;
				blur = (1.0 + sin(t)) * 0.5;
				blur *= 1.0 + sin(t * 2) * 0.5;
				blur = pow(blur, 3.0);
				blur *= 0.05;
				blur *= d + offset.r;

				half4 col = half4(1,1,1,0);

				float dittherUVFactor1 = sign(offsetNoise) * blur;
				float dittherUVFactor2 = sign(sin(t * 2)) * blur;

				float4 Main = tex2D(_MainTex,float2(uv.x + dittherUVFactor1 * _DittherIntensity,uv.y));
				float4 Main2 = tex2D(_MainTex, float2(uv.x - dittherUVFactor2 * _DittherIntensity, uv.y));
				Main = max(Main, Main2);
				col = Main;
				//col.g = Main.g;
				col.a = max(col.a, Main.a);

				half4 rChannel = tex2D(_MainTex, float2(uv.x + dittherUVFactor1 * _ChromaticIntensity, uv.y));
				col.r = lerp(col.r,rChannel.r, _ChromaticIntensity);
				col.a = max(col.a, rChannel.a);
				half4 bChannel = tex2D(_MainTex, float2(uv.x - dittherUVFactor2 * _ChromaticIntensity, uv.y));
				col.b = lerp(col.b, bChannel.b, _ChromaticIntensity);
				col.a = max(col.a, bChannel.a);

				col -= offset.g * blur;

				//col *= 1.0 - d * 0.5;
				col *= 2.0f * _EmissionGain * i.color * _TintColor;

				col.a = saturate(col.a);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
			}
		}
	}
}
