Shader "Unlit/GTfullScreen"
{

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            Cull Off
            ZTest Always
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 TransformTriangleVertexToUV(float2 vertex)
            {
                float2 uv = (vertex + 1.0) * 0.5;
                return uv;
            }
            v2f vert (appdata v)
            {
                v2f o;
               o.vertex = float4(v.vertex.xy, 0.0, 1.0);
               o.uv = TransformTriangleVertexToUV(v.vertex.xy);

#if UNITY_UV_STARTS_AT_TOP
               o.uv = o.uv * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                 fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
