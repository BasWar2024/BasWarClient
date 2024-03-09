Shader "Game/Proj/TreePlanarShadow"
{
    Properties
    {
        _ShadowColor ("PlanarShadowColor", Color) = (0, 0, 0, 0.5)
        _LightDir("LightDir",Vector)=(0.27,1.35,0.49,0)
        _ShadowFalloff("ShadowFalloff", Float) = 0
        _MainTex("Main Texture", 2D) = "white" {}
        _Amplitude("", Float) = 1
        _Direction("Direction", Vector) = (0,0,0,0)
        _Frequency("", Float) = 1
        _BaseLineY("BaseLine Y", Float) = 1
        _Rigidness("",Float) = 1
        _UseWind("",Range(0,1)) = 0
    }
    SubShader
    {
        //pass
        Pass
        {
        	Name "Shadow"
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
        	Stencil
        	{
        		Ref 0
        		Comp equal
        		Pass incrWrap
        		Fail keep
        		ZFail keep
        	}
            ZWrite On
        	CGPROGRAM
        	#pragma vertex vert
        	#pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

        	struct appdata
        	{
        	      float4 vertex : POSITION;
                  float2 texcoord0 : TEXCOORD0;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
        	};
        	struct v2f
        	{
        	      float4 pos : SV_POSITION;
                  fixed2 texcoord0 : TEXCOORD0;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
        	};

        	float4 _LightDir;
        	float4 _GlobalShadowColor;
        	float _ShadowFalloff;
            uniform sampler2D _MainTex;
            uniform fixed4 _MainTex_ST;
            uniform float _Amplitude, _Rigidness;
            uniform float4 _Direction;
            uniform float _Frequency;
            uniform float _BaseLineY;
            uniform float _GlobalWind, _UseWind;
            inline float3 CalVertexPosition(float3 pos, float3 wPos)
            {
                float offset = step(_BaseLineY, pos.y) * (pos.y - _BaseLineY);
                float amp = _Amplitude * offset;
                float3 newPos = pos;
                float frequency = _Frequency * _Time.y;
                frequency = lerp(frequency, frequency * _GlobalWind, _UseWind);
                newPos += amp * sin(wPos.zyx * _Rigidness + frequency) * _Direction.xyz;
                return newPos;
            }

        	v2f vert (appdata v)
        	{
        		v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                float3 shadowPos;
                float3 lightDir = normalize(_LightDir.xyz);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                v.vertex.xyz = CalVertexPosition(v.vertex.xyz, worldPos);
                worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                shadowPos.y = min(worldPos.y, _LightDir.w);
                shadowPos.xz = worldPos.xz - lightDir.xz * max(0, worldPos.y - _LightDir.w) / lightDir.y;
        		o.pos = UnityWorldToClipPos(shadowPos);
                //o.pos = UnityWorldToClipPos(v.vertex);
                o.texcoord0.xy = TRANSFORM_TEX(v.texcoord0, _MainTex);
                return o;
        	}

        	fixed4 frag (v2f i) : SV_Target
        	{
               UNITY_SETUP_INSTANCE_ID(i);
                fixed alpha = tex2D(_MainTex, i.texcoord0.xy).a;
                fixed4 col = _GlobalShadowColor;
                clip(alpha-0.5);
                return col;
        	}
        	ENDCG
        }
    }
}
