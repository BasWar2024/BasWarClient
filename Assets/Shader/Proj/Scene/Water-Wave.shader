// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Game/Proj/Water/Water-Wave" {
    Properties{
        _Color("Color", Color) = (1, 1, 1, 1)

        _MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
        _NormalMap("Normal Tex", 2D) = "bump" {}

        [Header(Water Gradient)]
        _GradientMap("Base (RGB), RefStrength (A)", 2D) = "white" {}
        _ReflectColor("Reflect Color", Color) = (1,1,1,1)
        _ReflectIntensity("Reflect Intensity", Range(1, 5)) = 1

        [Header((Reflect Texture))][Toggle(_REFTEX)] _REFTEX("_REFTEX", Float) = 0
        _RefTex ("Reflect Texture", 2D) = "black" {}

        [Header(Wave Param)]
        _WaveTrans("Speed(xy) Scale(zw)", Vector) = (0, 0, 1, 1)
    }

    SubShader{
            Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType" = "Transparent" "LightMode" = "ForwardBase"}
            LOD 200

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            Pass {
                    Tags{ "LightMode" = "ForwardBase" }
                    CGPROGRAM

                    #pragma skip_variants LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE DYNAMICLIGHTMAP_ON DIRECTIONAL_COOKIE POINT_COOKIE SHADOWS_CUBE FOG_EXP FOG_EXP2 SPOT POINT EDITOR_VISUALIZATION

                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma shader_feature _ _REFTEX
                    #pragma multi_compile_fog

                    #include "UnityCG.cginc"

                    struct appdata_t
                    {
                        float4 vertex : POSITION;
                        float2 texcoord : TEXCOORD0;
                    };

                    struct v2f
                    {
                        float4 pos : SV_POSITION;
                        float2 uv : TEXCOORD0;
                        float2 uv2 : TEXCOORD1;
                        float3 viewDir : TEXCOORD2;
                    #if _REFTEX
                        float2 uv3 : TEXCOORD3;
                    #endif
                        UNITY_FOG_COORDS(4)
                    };

                    uniform float4 _MainTex_ST;
                    uniform float4 _NormalMap_ST;
                    uniform float4 _WaveTrans;
                #if _REFTEX
                    uniform float4 _RefTex_ST;
                #endif

                    v2f vert (appdata_t v)
                    {
                        v2f o;
                        o.pos = UnityObjectToClipPos(v.vertex);
                        o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                        o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                        float2 waveCoord = v.texcoord * _WaveTrans.zw + _Time.x * _WaveTrans.xy;
                        o.uv2 = TRANSFORM_TEX(waveCoord, _NormalMap);

                    #if _REFTEX
                        float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
                        o.uv3 = TRANSFORM_TEX(viewDir.xz, _RefTex);
                    #endif
                        UNITY_TRANSFER_FOG(o, o.pos);
                        return o;
                    }

                    uniform float4 _Color;
                    uniform sampler2D _MainTex;
                    uniform sampler2D _NormalMap;
                    uniform sampler2D _GradientMap;
                    uniform float4 _GradientMap_ST;
                    uniform float4 _ReflectColor;
                    uniform float _ReflectIntensity;
                    uniform sampler2D _RefTex;
                    uniform fixed4 _GlobalMultiCol;

                    float4 frag (v2f i) : COLOR
                    {
                        fixed3 white = fixed3(1,1,1);
                        float3 normal = UnpackNormal(tex2D(_NormalMap, i.uv2));

                        float reflContrib = dot(i.viewDir, normal);

                        float refl = 1 - saturate(reflContrib);
                        refl *= step(0, reflContrib);

                        float2 uv = float2(refl, refl);

                        float4 color = tex2D(_MainTex, i.uv);
                        float4 finalColor = tex2D(_GradientMap, uv);

                        finalColor.rgb = finalColor.rgb * (finalColor.a) + (1-finalColor.a) * _ReflectColor * _ReflectIntensity;

                    #if _REFTEX
                        float4 rtColor = tex2D(_RefTex, i.uv3);
                        finalColor.rgb += rtColor.rgb * rtColor.a;
                    #endif

                        finalColor *= _Color;
                        finalColor.a = color.a;

                        fixed3 gColor = lerp(white, _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                        finalColor.rgb *= gColor;
                        UNITY_APPLY_FOG(i.fogCoord, finalColor);
                        return finalColor;
                    }
                ENDCG
            }
        }

        //FallBack "Diffuse"
}
