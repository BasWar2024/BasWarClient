
Shader "Game/Effect/Outline-DepthNormalsBased"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _DepthMap("DepthMap (RGBA)", 2D) = "white" {}

        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
        _SampleRange("Sample Range", Range(0, 5)) = 0.3

        _NormalDiffThreshold("Normal Differ Threshold", Range(0, 1)) = 1
        _DepthDiffThreshold("Depth Differ Threshold", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Cull Off
        ZWrite Off
        ZTest Always
        Lighting Off
        Fog { Mode Off }

        Pass
        {
            Tags { "LightMode" = "ForwardBase" "LightMode" = "ForwardBase"}

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
                half2 uv : TEXCOORD0;
                half2 samplerUV[4] : TEXCOORD1;
            };

            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float4 _MainTex_TexelSize;

            uniform sampler2D _DepthMap;

            uniform sampler2D _CameraDepthNormalsTexture;
            uniform float _NormalDiffThreshold;
            uniform float _DepthDiffThreshold;

            uniform float4 _OutlineColor;
            uniform float _SampleRange;

            float EdgeTest(fixed4 c1, fixed4 c2)
            {
                float2 normalDiff = abs(c1.xy - c2.xy);
                float normalEdgeVal = (normalDiff.x + normalDiff.y) < _NormalDiffThreshold;

                float c1Depth = DecodeFloatRG(c1.zw);
                float c2Depth = DecodeFloatRG(c2.zw);
                float depthEdgeVal = abs(c1Depth - c2Depth) < 0.1 * c1Depth * _DepthDiffThreshold;

                return depthEdgeVal * normalEdgeVal;
            }

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                half2 uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv = uv;

                o.samplerUV[0] = uv + _MainTex_TexelSize.xy * half2(-1, -1) * _SampleRange;
                o.samplerUV[1] = uv + _MainTex_TexelSize.xy * half2(1, -1) * _SampleRange;
                o.samplerUV[2] = uv + _MainTex_TexelSize.xy * half2(-1, 1) * _SampleRange;
                o.samplerUV[3] = uv + _MainTex_TexelSize.xy * half2(1, 1) * _SampleRange;

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 clr = tex2D(_MainTex, i.uv);

                float4 depthMap = tex2D(_DepthMap, i.uv);
                float depthValue = DecodeFloatRG(depthMap.zw);

                float4 dn = tex2D(_CameraDepthNormalsTexture, i.uv);
                float depth = DecodeFloatRG(dn.zw);

                float delta = depth - depthValue;


                if(depth >= depthValue)
                {
                    clr.rgb = fixed3(1, 1, 1);
                }
                else
                {
                    float4 c1 = tex2D(_CameraDepthNormalsTexture, i.samplerUV[0]);
                    float4 c2 = tex2D(_CameraDepthNormalsTexture, i.samplerUV[1]);
                    float4 c3 = tex2D(_CameraDepthNormalsTexture, i.samplerUV[2]);
                    float4 c4 = tex2D(_CameraDepthNormalsTexture, i.samplerUV[3]);

                    float edge = 1.0;
                    edge *= EdgeTest(c1, c4);
                    edge *= EdgeTest(c2, c3);

                    clr.rgb = lerp(_OutlineColor.rgb, fixed3(1, 1, 1), edge);
                }

                return clr;
            }

        ENDCG
        }
    }

    FallBack OFF
}
