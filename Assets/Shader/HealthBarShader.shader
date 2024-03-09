Shader "WorldCommon/HealthBarShader"
{
    Properties
    {
        //
        _MainTex ("Main", 2D) = "white" { }
        _MainColor ("Tint", Color) = (1, 1, 1, 1)
        // _ScendTex ("Scend", 2D) = "white" { }
        // _ScendColor ("Scend Tint", Color) = (1, 1, 1, 1)
        // 
        _Percent ("Percent", Range(0, 1)) = 0
    }
    SubShader
    {

        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "CanUseSpriteAtlas" = "True" }
        // LOD 100

        Cull Back
        Lighting Off
        ZTest Off

        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            struct appdata
            {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            // half4 _MainColor;

            // sampler2D _ScendTex;
            // float4 _ScendTex_ST;
            // half4 _ScendColor;

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float, _Percent)
            UNITY_DEFINE_INSTANCED_PROP(half4, _MainColor)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            half4 frag(v2f i): SV_Target
            {
                // sample the texture
                // half4 col1 = tex2D(_MainTex, i.uv) * _MainColor;
                // col1 *= col1.a;

                // half4 col2 = tex2D(_ScendTex, i.fillUv) * _ScendColor;
                // col2 *= col2.a;

                // return col2;
                UNITY_SETUP_INSTANCE_ID(i);

                float p = UNITY_ACCESS_INSTANCED_PROP(Props, _Percent);
                half4 c = UNITY_ACCESS_INSTANCED_PROP(Props, _MainColor);

                float y = step(p, i.uv.x);// step(p, i.uv.x);
                half4 bar = half4(y, y, y, y);
                half4 bar2 = (1 - bar);

                return saturate(bar * half4(c.rgb, 0.3) + bar2 * c);
                // return saturate(bar * _ScendColor + bar2 * _MainColor);

            }
            ENDCG

        }
    }
    Fallback "Diffuse"
}