Shader "WorldCommon/UnitBodyShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _Flash ("flash", Range(0, 1)) = 0
        _FlashColor ("flash Tint", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        LOD 100

        Pass
        {
            
            // Stencil
            // {
            //     Ref 2
            //     Comp Equal
            //     // Pass keep
            //     // ZFail keep
            // }
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _Color;
            half4 _FlashColor;

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(int, _Flash)
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

            fixed4 frag(v2f i): SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                float p = UNITY_ACCESS_INSTANCED_PROP(Props, _Flash);
                fixed4 c = fixed4(p, p, p, p) * _FlashColor;
                fixed4 col = tex2D(_MainTex, i.uv) * _Color + c;
                return col;
            }
            ENDCG

        }
    }
}
