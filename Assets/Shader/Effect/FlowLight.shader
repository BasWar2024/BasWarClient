

Shader "Game/Effect/FlowLight"
{
    Properties
    {
        // Cull
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0

        // ZTest
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", Float) = 4.0

        // ZWrite
        [Enum(Off, 0, On, 1)] _ZWrite("Z Write", Float) = 1.0


        // Blend
        [HideInInspector] _BlendMode("BlendMode", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 5.0
        [HideInInspector] _DstBlend("__dst", Float) = 10.0

        //To do Custom Thing
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Base (RGB)", 2D) = "white" {}
        _Strongth("Strongth", Range(0, 2)) = 1
        _MainSpeedU("Main Speed U", float) = 0
        _MainSpeedV("Main Speed V", float) = 0

        _LightTex("Light Texture(A)", 2D) = "black" {}
        _LightColor("LightColor", Color) = (1, 1, 1, 1)
        _Brightness("Brightness", Range(0, 5)) = 1
        _uSpeed("Light Speed U", float) = 0
        _vSpeed("Light Speed V", float) = 0

        _MaskTex("Mask Texture(A)", 2D) = "white" {}
        _MaskSpeedU("Mask Speed U", float) = 0
        _MaskSpeedV("Mask Speed V", float) = 0
    }
    SubShader
    {
        Tags{"LightMode" = "ForwardBase"}
        Cull[_CullMode]
        ZWrite[_ZWrite]
        ZTest[_ZTest]
        Blend[_SrcBlend][_DstBlend]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "../Common/GTCommon.cginc"

            float _BlendMode;

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Strongth;
            float _MainSpeedU;
            float _MainSpeedV;

            float4 _TimeEditor;

            sampler2D _LightTex;
            float4 _LightTex_ST;
            float4 _LightColor;
            float _Brightness;
            float _uSpeed;
            float _vSpeed;

            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float _MaskSpeedU;
            float _MaskSpeedV;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };


            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float4 moveUv = _Time.g;

                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.xy += moveUv.g * float2(_MainSpeedU, _MainSpeedV);

                o.uv.zw = TRANSFORM_TEX(v.uv, _LightTex);
                o.uv.zw += moveUv.g * float2(_uSpeed, _vSpeed);

                o.uv2 = TRANSFORM_TEX(v.uv, _MaskTex);
                o.uv2 += moveUv.g * float2(_MaskSpeedU, _MaskSpeedV);

                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv.xy);
                fixed4 lightC = tex2D(_LightTex, i.uv.zw) * _Brightness;
                fixed4 mask = tex2D(_MaskTex, i.uv2);

                fixed4 c = tex * _Color * _Strongth;
                c.rgb += lightC.rgb * _LightColor.rgb * mask.rgb * lightC.a;
                return c;
            }

            ENDCG
        }
    }

    CustomEditor "GTEffectShaderGUI"
}

