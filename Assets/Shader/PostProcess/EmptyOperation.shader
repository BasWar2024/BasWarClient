Shader "Game/TA/EmptyOperation"
{

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            ColorMask 0
	        ZTest Never
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

        	float2 TransformTriangleVertexToUV(float2 vertex)
			{
			    float2 uv = (vertex + 1.0) * 0.5;
			    return uv;
			}

            v2f vert (appdata v)
            {
                v2f o;
               o.vertex = float4(v.vertex.xy, 0.0, 1.0);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return 0;
            }
            ENDCG
        }
    }
}
