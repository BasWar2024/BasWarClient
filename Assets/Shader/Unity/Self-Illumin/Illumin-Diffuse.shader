
Shader "Game/Unity/Self-Illumin/Diffuse" {
    Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, 1)
        _MainTex("Base (RGB) Trans (A)", 2D) = "white" {}

        _Illum ("Illumin (A)", 2D) = "white" {}
        _Emission ("Emission (Lightmapper)", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            //#pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma exclude_renderers gles xbox360 ps3
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            #ifdef LIGHTMAP_ON
                float2 texcoord1 : TEXCOORD1;
            #endif
            };

            struct v2f
            {
                float4 worldPos : SV_POSITION;
                float3 normal : NORMAL;

            #ifdef LIGHTMAP_ON
                half4 texcoord : TEXCOORD0;
            #else
                half2 texcoord : TEXCOORD0;
            #endif

                half2 uvIllum : TEXCOORD1;

                //UNITY_SHADOW_COORDS(3)
                //UNITY_FOG_COORDS(4)
            };

            uniform fixed4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;

            uniform sampler2D _Illum;
            uniform float4 _Illum_ST;
            uniform fixed _Emission;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.worldPos = UnityObjectToClipPos(v.vertex);
                o.normal = normalize(UnityObjectToWorldNormal(v.normal));
                o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

            #ifdef LIGHTMAP_ON
                o.texcoord.zw = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
            #endif

                o.uvIllum = TRANSFORM_TEX(v.texcoord, _Illum);

                //UNITY_TRANSFER_SHADOW(o,v.texcoord1.xy);
                //UNITY_TRANSFER_FOG(o, o.worldPos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 clr = tex2D(_MainTex, i.texcoord.xy);
                clr *= _Color;

                fixed4 finalColor = clr;

                // Lambert lighting
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed diff = max(0, dot (i.normal, lightDir));
                finalColor.rgb = clr.rgb * _LightColor0.rgb * diff;

            #ifdef LIGHTMAP_ON
                half4 bakedColorTex = UNITY_SAMPLE_TEX2D(unity_Lightmap, i.texcoord.zw);
                half3 bakedColor = DecodeLightmap(bakedColorTex);
                finalColor.rgb += clr.rgb * bakedColor;
            #endif

                // self illumin
                fixed4 illumClr = tex2D(_Illum, i.uvIllum);
                fixed3 emission = clr.rgb * illumClr.a;
            #if defined (UNITY_PASS_META)
                emission *= _Emission.rrr;
            #endif

                finalColor.rgb += emission;

                //UNITY_APPLY_FOG(i.fogCoord, finalColor);
                UNITY_OPAQUE_ALPHA(finalColor.a);

                return finalColor;
            }

            ENDCG
        }
    }

    //FallBack "Diffuse"
    CustomEditor "LegacyIlluminShaderGUI"
}
