
Shader "Game/Proj/ANI/UV-Ani" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MainColor ("Color", Color) = (1, 1, 1, 1)

        _MainSpeedU("Main Speed U", float) = 0
        _MainSpeedV("Main Speed V", float) = 0
    }

    SubShader {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
        LOD 100

        Pass {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord : TEXCOORD0;
                };

                struct v2f {
                    float4 vertex : SV_POSITION;
                    half2 texcoord : TEXCOORD0;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float4 _MainColor;

                float _MainSpeedU;
                float _MainSpeedV;

                uniform fixed4 _GlobalMultiCol;


                v2f vert (appdata_t v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                    float4 moveUv = _Time.g;
                    o.texcoord += moveUv.g * float2(_MainSpeedU, _MainSpeedV);

                    return o;
                }

                fixed4 frag (v2f i) : SV_Target
                {
                    fixed4 col = tex2D(_MainTex, i.texcoord);
                    col *= _MainColor;
                    UNITY_OPAQUE_ALPHA(col.a);

                    fixed3 gColor = lerp(fixed3(1, 1, 1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                    col.rgb *= gColor.rgb;
                    return col;
                }

            ENDCG
        }
    }
}
