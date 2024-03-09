// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Game/Building/MoveGrid" {
    Properties {
        _Valid ("Valid", Float) = 1
        _RedTex ("Red Tex", 2D) = "white" {}
        _GreenTex ("Green Tex", 2D) = "white" {}
    }
    SubShader {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType" = "Transparent" }
        LOD 200

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

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
                float4 texcoord : TEXCOORD0;
            };
            uniform fixed _Valid;
            uniform sampler2D _RedTex; uniform float4 _RedTex_ST;
            uniform sampler2D _GreenTex; uniform float4 _GreenTex_ST;
            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _GreenTex);
                o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _RedTex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 green = tex2D(_GreenTex, i.texcoord.xy);
                fixed4 red = tex2D(_RedTex, i.texcoord.zw);
                fixed4 col = lerp(red, green, _Valid);
                return col;
            }
            ENDCG
        }
    }
}
