
Shader "Game/Proj/ANI/2UV-Ani" {
    Properties {
        _MainColor ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MainTex2UV ("Base (RGB)", 2D) = "white" {}//2UV
        _MainSpeedU("Main Speed U", float) = 0
        _MainSpeedV("Main Speed V", float) = 0
        _MainSpeed2U("Main Speed 2U", float) = 0//2U
        _MainSpeed2V("Main Speed 2V", float) = 0//2V
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
                    float2 texcoord1 : TEXCOORD1;//2UV
                };

                struct v2f {
                    float4 vertex : SV_POSITION;
                    half4 texcoord : TEXCOORD0;
                };

                sampler2D _MainTex;
                sampler2D _MainTex2UV;
                float4 _MainTex_ST;
                float4 _MainTex2UV_ST;//2UV
                float4 _MainColor;
                float _MainSpeedU;
                float _MainSpeedV;
                float _MainSpeed2U;//2U
                float _MainSpeed2V;//2V
                uniform fixed4 _GlobalMultiCol;


                v2f vert (appdata_t v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                    o.texcoord.zw = TRANSFORM_TEX(v.texcoord1, _MainTex2UV);//2UV
                    o.texcoord.xy += _Time.g * float2(_MainSpeedU, _MainSpeedV);
                    o.texcoord.zw += _Time.g * float2(_MainSpeed2U, _MainSpeed2V);//2U
                    return o;
                }

                fixed4 frag (v2f i) : SV_Target
                {
                    fixed4 col = tex2D(_MainTex, i.texcoord.xy);
                    fixed4 col2 = tex2D(_MainTex2UV, i.texcoord.zw);//2U
                    col.rgb = lerp(col.rgb, col2.rgb, col2.a);

                    //col *= _MainColor;
                    //UNITY_OPAQUE_ALPHA(col.a);

                    fixed3 gColor = lerp(fixed3(1, 1, 1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                    col.rgb *= gColor.rgb;
                    return col;
                }

            ENDCG
        }
    }
}
