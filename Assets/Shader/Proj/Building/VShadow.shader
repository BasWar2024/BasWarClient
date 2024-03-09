// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Game/Building/VShadow"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _LightMap ("LightMap Tex", 2D) = "black" {}
        // Common
        [PowerSlider(3.0)] _Shininess ("Shininess", Range (0, 10)) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend Mode", Float) = 10
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
        _ColorMask("ColorMask", Float) = 15
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4
        // shadow
        _ShadowColor ("Shadow Color", Color) = (0, 0, 0, 0.5)
        _LightDir ("Light Dir", Vector) = (0.01, 0.1, 0.02, 0.02)
        // _ShadowFalloff ("Shadow Fall off", Float) = 1
    }
    SubShader
    {
        LOD 400
        Tags { "RenderType" = "Opaque" "Queue"="Transparent" }
        UsePass "Game/Building/Standard/BASE"
        Pass{
            Stencil
            {
                Ref 1
                Comp Greater
                Pass Replace
                ZFail Replace
            }
            //
            Blend SrcAlpha OneMinusSrcAlpha
            //
            ZWrite Off
            //
            Offset -1, 0
            CGPROGRAM
            #pragma vertex verts
            #pragma fragment frags

            #include "UnityCG.cginc"

            float4 _LightDir;
            float4 _ShadowColor;
            uniform fixed4 _GlobalMultiCol;
            // float4 _ShadowFalloff;
            struct a2vs
            {
                float4 vertex : POSITION;
            };
            struct v2fs {
                float4 pos : SV_POSITION;
            };
            //
            float3 ShadowProjectPos(float4 vertexPos){
                float3 shadowPos;
                //
                float3 worldPos = mul(unity_ObjectToWorld, vertexPos).xyz;
                //
                float3 lightDir = normalize(_LightDir.xyz);
                //()
                shadowPos.y = min(worldPos.y, _LightDir.w);
                shadowPos.xz = worldPos.xz - lightDir.xz * max(0, worldPos.y - _LightDir.w) / (lightDir.y - _LightDir.w);
                return shadowPos;
            }
            v2fs verts(a2vs v){
                v2fs o;
                //
                float3 shadowPos = ShadowProjectPos(v.vertex);
                //
                o.pos = UnityWorldToClipPos(shadowPos);
                // //
                // float3 center = float3(unity_ObjectToWorld[0].w, _LightDir.w, unity_ObjectToWorld[2].w);
                // //unity_ObjectToWorld
                // float falloff = 1 - saturate(distance(shadowPos, center) * _ShadowFalloff);
                // o.color.a *= falloff;
                return o;
            }
            fixed4 frags(v2fs i):SV_Target{
                fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                _ShadowColor.rgb *= gColor;

                return _ShadowColor;
            }
            ENDCG
        }
    }
    Fallback "Game/Building/Standard"
}
