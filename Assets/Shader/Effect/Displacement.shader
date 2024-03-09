Shader "Game/Effect/Displacement"
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


        _TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
        _NoiseTex("Distort Texture (RG)", 2D) = "white" {}
        _MainTex("Alpha (A)", 2D) = "white" {}
        _MaskTex("Mask Tex", 2D) = "white" {}
        _HeatTime("Heat Time", range(-1,1)) = 0
        _ForceX("Strength X", range(0,1)) = 0.1
        _ForceY("Strength Y", range(0,1)) = 0.1
        _EmissionGain("Emission Gain", Range(0, 20)) = 1
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

            //To do Custom Thing
            fixed4 _TintColor;
            fixed _ForceX;
            fixed _ForceY;
            fixed _HeatTime;
            float4 _MainTex_ST;
            float4 _NoiseTex_ST;
            sampler2D _NoiseTex;
            sampler2D _MainTex;
            float _EmissionGain;
            sampler2D _MaskTex;
            float4 _MaskTex_ST;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct VertexOutput {
                float4 pos : SV_POSITION;
                fixed4 color : COLOR;
                float2 uvmain : TEXCOORD0;
                float2 uvmask : TEXCOORD1;
                float2 uvNoise : TEXCOORD2;
            };


            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uvmain = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvmask = TRANSFORM_TEX(v.uv, _MaskTex);
                o.uvNoise = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;

            }

            fixed4 frag (VertexOutput i) : SV_Target
            {

                fixed4 maskCol = tex2D(_MaskTex, i.uvmask);
                //noise effect
                fixed4 offsetColor1 = tex2D(_NoiseTex, i.uvNoise + _Time.xz*_HeatTime);
                fixed4 offsetColor2 = tex2D(_NoiseTex, i.uvNoise + _Time.yx*_HeatTime);
                i.uvmain.x += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceX;
                i.uvmain.y += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceY;
                fixed4 resCol = 2.0f * _EmissionGain * i.color * _TintColor * tex2D(_MainTex, i.uvmain);
                resCol.a *= maskCol.r;
                return resCol;
            }
            ENDCG
        }
    }
    CustomEditor "GTEffectShaderGUI"
}