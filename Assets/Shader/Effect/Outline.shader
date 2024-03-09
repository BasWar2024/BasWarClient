
Shader "Hidden/PostProcessing/Outline"
{
    Properties 
    {
        _MainTex("Base (RGB)", 2D) = "white" {}

        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineIntensity("Outline Intensity", Range(0, 10)) = 0.75
        _SampleRange("Sample Range", Range(0, 5)) = 0.3
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Cull Off ZWrite Off ZTest Always

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv[9] : TEXCOORD0;
            };

            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform half4 _MainTex_TexelSize;
            
            uniform float4 _OutlineColor;
            uniform float _OutlineIntensity;
            uniform float _SampleRange;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                half2 uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                //8UV
                o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, -1) * _SampleRange;
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, -1) * _SampleRange;
                o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, -1) * _SampleRange;
                o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0) * _SampleRange;
                o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0) * _SampleRange;
                o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0) * _SampleRange;
                o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, 1) * _SampleRange;
                o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0, 1) * _SampleRange;
                o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, 1) * _SampleRange;
            
                return o;
            }

            float luminance(float4 color)
            {
                return color.r * 0.2125 + color.g * 0.7154 + color.b * 0.0721;
            }

            half Sobel(v2f i)
            {
                const half Gx[9] = {-1,-2,-1, 0,0,0, 1,2,1};
                const half Gy[9] = {-1,0,1, -2,0,2, -1,0,1};
                
                half edgeX = 0;
                half edgeY = 0;

                for(int it = 0; it < 9; it ++)
                {
                    half texColor = luminance(tex2D(_MainTex, i.uv[it]));
                    edgeX += texColor * Gx[it];
                    edgeY += texColor * Gy[it];
                }

                half edge = 1 - abs(edgeX) - abs(edgeY);

                return edge;
            }

            float4 frag(v2f i) : SV_Target
            {
                half edge = Sobel(i);
                edge = pow(edge, _OutlineIntensity);

                float4 color = lerp(_OutlineColor, float4(1, 1, 1, 1), edge);
                color.a = 1;
                
                return color;
            }

        ENDCG
        }
    }

    FallBack OFF
}
