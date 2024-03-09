Shader "Game/Proj/PlanarShadow"
{
    Properties
    {
        _ShadowColor ("PlanarShadowColor", Color) = (0, 0, 0, 0.5)
        _LightDir("LightDir",Vector)=(0.27,1.35,0.49,0)
        _ShadowFalloff("ShadowFalloff", Float) = 0
    }
    SubShader
    {
        //pass
        Pass
        {
        	Name "Shadow"
            Blend SrcAlpha OneMinusSrcAlpha
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

    //        #include "Assets/Shader/Common/GTCommon.cginc"
        	struct appdata
        	{
        	      float4 vertex : POSITION;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
        	};
        	struct v2f
        	{
        	      float4 pos : SV_POSITION;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
        	};

        	float4 _LightDir;
        	float4 _GlobalShadowColor;
        	float _ShadowFalloff;


        	v2f vert (appdata v)
        	{
        		v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                float3 shadowPos;
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                float3 lightDir = normalize(_LightDir.xyz);
                shadowPos.y = min(worldPos.y, _LightDir.w);
                shadowPos.xz = worldPos.xz - lightDir.xz * max(0, worldPos.y - _LightDir.w) / lightDir.y;
        		o.pos = UnityWorldToClipPos(shadowPos);
        //		float3 center = float3( unity_ObjectToWorld[0].w , _LightDir.w , unity_ObjectToWorld[2].w);
        // 		float falloff = 1 - saturate(distance(shadowPos , center) * _ShadowFalloff);
                return o;
        	}

        	fixed4 frag (v2f i) : SV_Target
        	{
                fixed4 col = _GlobalShadowColor;
                return col;
        	}
        	ENDCG
        }
    }
}
