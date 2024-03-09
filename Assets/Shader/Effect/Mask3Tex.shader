Shader "Game/Effect/Mask3Tex"
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
        _TintColor("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex("Particle Texture", 2D) = "white" {}
        _EmissionGain("Emission Gain", Range(0, 10)) = 2
        _MoveSpeedX ("Move Speed", Range(-10, 10)) = 0
        _MoveSpeedY("Move Speed", Range(-10, 10)) = 0

        [Space(20)]
        [Header(Mask Texture)]
        _Mask("Mask ( R Channel )", 2D) = "white" {}
        _MaskSpeedX ("Mask Speed X", Range(-10, 10)) = 0
        _MaskSpeedY("Mask Speed Y", Range(-10, 10)) = 0

         [Space(20)]
        [Header(Mask Texture)]
        _Mask2("Mask2 ( R Channel )", 2D) = "white" {}
        _Mask2SpeedX("Mask2 Speed X", Range(-10, 10)) = 0
        _Mask2SpeedY("Mask2 Speed Y", Range(-10, 10)) = 0

		[Space(20)][Header((MultiColor))][Toggle(_MultiColor)] _MultiColor("_MultiColor", Float) = 0
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
            #pragma multi_compile __ _MultiColor

            #include "../Common/GTCommon.cginc"

            float _BlendMode;

            //To do Custom Thing
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _TintColor;
            float _EmissionGain;
            float _MoveSpeedX;
            float _MoveSpeedY;

            sampler2D _Mask;
            float4 _Mask_ST;
            float _MaskSpeedX;
            float _MaskSpeedY;

            sampler2D _Mask2;
            float4 _Mask2_ST;
            float _Mask2SpeedX;
            float _Mask2SpeedY;
    #if _MultiColor
            uniform fixed4 _GlobalMultiCol;
    #endif

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                fixed4 color : COLOR;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex) + _Time.yy * float2(_MoveSpeedX, _MoveSpeedY);
                o.uv.zw = TRANSFORM_TEX(v.uv, _Mask) + _Time.yy * float2(_MaskSpeedX, _MaskSpeedY);
                o.uv2.xy = TRANSFORM_TEX(v.uv, _Mask2) + _Time.yy * float2(_Mask2SpeedX, _Mask2SpeedY);
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
                fixed4 baseCol = tex2D(_MainTex, i.uv.xy);
                fixed4 maskCol = tex2D(_Mask, i.uv.zw);
                fixed4 mask2Col = tex2D(_Mask2, i.uv2.xy);
                baseCol.a *= maskCol.r * mask2Col.r;

				#if _MultiColor
					fixed3 gColor = lerp(fixed3(1, 1, 1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
					_TintColor.rgb *= gColor;
					return i.color * _TintColor * baseCol * _EmissionGain;
                #endif
				return i.color * _TintColor * baseCol * _EmissionGain;
            }

            ENDCG
        }
    }

    CustomEditor "GTEffectShaderGUI"
}
