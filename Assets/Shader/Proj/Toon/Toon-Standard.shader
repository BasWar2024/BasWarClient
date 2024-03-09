// Upgrade NOTE: replaced 'defined _DIFFUSEFALLOFF' with 'defined (_DIFFUSEFALLOFF)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Game/Proj/Toon/Standard" {
    Properties{
        _MainTex("Alpha", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)

        [Space(20)][Header((MultiColor))][Toggle(_MultiColor)] _MultiColor("_MultiColor", Float) = 1

        /*
        [Space(20)][Header((NormalMap))][Toggle(_NORMALMAPON)] _NORMALMAPON("_NORMALMAPON", Float) = 0
        _NormalMap("Normal Map(RG),diffuseFalloff(B),RimFallOff(A)", 2D) = "bump" {}
        _NormalIntensity("Normal Intensity", Float) = 1
        */

        [Space(20)][Header((DiffuseFalloff))][Toggle(_DIFFUSEFALLOFF)] _DIFFUSEFALLOFF("_DIFFUSEFALLOFF", Float) = 0
        [NoScaleOffset]_DiffuseLightRamp("Ramp",2D) = "white"{}
        _DiffuseIntensity("",Range(0,1)) = 0.5
        _DiffuseAttenDir("",vector) = (-1,-1,1,1)

        /*
        [Space(20)][Header((Specular))][Toggle(_SPECULARFALLOFF)] _SPECULARFALLOFF("_SPECULARFALLOFF", Float) = 0
        [NoScaleOffset]_SpecularMask("Specular(RGB)",2D) = "white"{}
        _SpecularPower("Specular",Float) = 20

        [Space(20)][Header((RefletionMatcap))][Toggle(_REFLECTMATCAP)] _REFLECTMATCAP("_REFLECTMATCAP", Float) = 0
        _MatCap("Matcap",2D) = "white"{}
        _MatCapIntensity("",Float) = 2


        [Space(20)][Header((SHADOWFALLOFF))][Toggle(_SHADOWFALLOFF)] _SHADOWFALLOFF("_SHADOWFALLOFF", Float) = 0
        _ShadowColor("",Color) = (1,1,1,1)
        */

        [Space(20)][Header((RimLight))][Toggle(_RIMLIGHT)] _RIMLIGHT("_RIMLIGHT", Float) = 0
        [NoScaleOffset]_RimLightRamp("Ramp",2D) = "white"{}
        _RimPower("",Range(0.0,2.0)) = 1
        _Rim_BloomRange("",Range(0.0,1.0)) = 0
        _AttenDir("",vector) = (1,-1,1,1)
    }

    SubShader{
            Tags { "RenderType" = "Opaque" }
            LOD 200

            Pass {
                    Tags{ "LightMode" = "ForwardBase" }
                    CGPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma shader_feature _ _DIFFUSEFALLOFF
                    //#pragma shader_feature _ _SPECULARFALLOFF
                    #pragma shader_feature _ _RIMLIGHT
                    //#pragma shader_feature _ _REFLECTMATCAP
                    //#pragma shader_feature _ _SHADOWFALLOFF
                    //#pragma shader_feature _ _NORMALMAPON
                    #pragma shader_feature _ _MultiColor
                    #pragma shader_feature _ UseShadowMap

                    #include "UnityCG.cginc"
                    #include "AutoLight.cginc"
                    #include "Assets/Shader/Common/GTCommon.cginc"

                    struct appdata_t {
                        float4 vertex : POSITION;
                        float2 texcoord : TEXCOORD0;
                        float3 normal : NORMAL;
            #if _NORMALMAPON
                        float4 tangent : TANGENT;
            #endif
                    };

                    struct v2f {
                        float4 pos : SV_POSITION;
                        half4 uv : TEXCOORD0;
                        float3 vertexLighting : TEXCOORD1;
                        float3 normal : TEXCOORD2;
                        float3 viewDir : TEXCOORD3;
            #if _NORMALMAPON
                        float3 tangentDir : TEXCOORD4;
                        float3 bitangentDir : TEXCOORD5;
            #endif
            #if _SHADOWFALLOFF
                        LIGHTING_COORDS(6, 7)
            #endif
            #if defined(USE_WORLDPOS)
                         float3 worldPos :TEXCOORD8;
            #endif
                    };

                    inline half3 GetOverlayColor(half3 inUpper, half3 inLower)
                    {
                        half3 oneMinusLower = half3(1.0, 1.0, 1.0) - inLower;
                        half3 valUnit = 2.0 * oneMinusLower;
                        half3 minValue = 2.0 * inLower - half3(1.0, 1.0, 1.0);
                        half3 greaterResult = inUpper * valUnit + minValue;

                        half3 lowerResult = 2.0 * inLower * inUpper;

                        half3 lerpVals = round(inLower);
                        return lerp(lowerResult, greaterResult, lerpVals);
                    }

                    sampler2D _MainTex;
                    float4 _MainTex_ST;
                    float4 _Color;
                    float4 _ShadowColor;
                    uniform float4 _AttenDir;
                    uniform float4 _DiffuseAttenDir;
                    uniform sampler2D _NormalMap;
                    uniform float4 _NormalMap_ST;
                    uniform float _NormalIntensity;
            #if _MultiColor
                    uniform fixed4 _GlobalMultiCol;
            #endif
                    v2f vert(appdata_t v)
                    {
                        v2f o = (v2f)0;
                        o.pos = UnityObjectToClipPos(v.vertex);
                        o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

                        float3 posW = mul(unity_ObjectToWorld, v.vertex).xyz;
            #if defined(USE_WORLDPOS)
                        o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            #endif
                        float3 worldNorm = normalize(unity_WorldToObject[0].xyz * v.normal.x + unity_WorldToObject[1].xyz * v.normal.y + unity_WorldToObject[2].xyz * v.normal.z);
                        o.normal = worldNorm;
                        o.viewDir = _WorldSpaceCameraPos.xyz - posW.xyz;
                        o.vertexLighting = float3(0.0, 0.0, 0.0);
            #if _NORMALMAPON
                        o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
                        o.bitangentDir = normalize(cross(o.normal, o.tangentDir) * v.tangent.w);
            #endif

            #ifdef VERTEXLIGHT_ON
                        for (int index = 0; index < 4; index++)
                        {
                            float4 lightPosition = float4(unity_4LightPosX0[index],
                                unity_4LightPosY0[index],
                                unity_4LightPosZ0[index], 1.0);
                            float3 vertexToLightSource = lightPosition.xyz - posW;
                            float3 lightDirection = normalize(vertexToLightSource);
                            float squaredDistance = dot(vertexToLightSource, vertexToLightSource);
                            float attenuation = 1.0 / (1.0 + unity_4LightAtten0[index] * squaredDistance);
                            float3 diffuseReflection = attenuation * unity_LightColor[index].rgb * max(0.0, dot(worldNorm, lightDirection));
                            o.vertexLighting += diffuseReflection;
                        }
            #endif
                        o.uv.zw = mul((float3x3)UNITY_MATRIX_V, worldNorm).xy * 0.5 + 0.5;
            #if _SHADOWFALLOFF
                        TRANSFER_VERTEX_TO_FRAGMENT(o);
            #endif
                        return o;
                    };

            #if _DIFFUSEFALLOFF
                    sampler2D _DiffuseLightRamp;
                    float _DiffuseIntensity;
            #endif
            #if _SPECULARFALLOFF
                    sampler2D _SpecularMask;
                    float _SpecularPower;
            #endif
            #if _RIMLIGHT
                    sampler2D _RimLightRamp;
                    float _RimPower;
                    float _Rim_BloomRange;
            #endif
            #if _REFLECTMATCAP
                    sampler2D _MatCap;
                    float _MatCapIntensity;
            #endif
                    half4 frag(v2f i) : SV_Target
                    {
                        half4 diffSamplerColor = tex2D(_MainTex, i.uv.xy);
                        half3 combinedColor = diffSamplerColor.xyz;
                        half3 normalDir = normalize(i.normal);

            #if (defined (_DIFFUSEFALLOFF)) || (defined (_RIMLIGHT))
                        half3x3 viewSpace = half3x3(-UNITY_MATRIX_V[0].xyz, -UNITY_MATRIX_V[1].xyz, UNITY_MATRIX_V[2].xyz);
            #endif

            #if _NORMALMAPON
                        float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normal);
                        float4 _NormalMap_var = tex2D(_NormalMap, TRANSFORM_TEX(i.uv.xy, _NormalMap));
                        float3 NormalMapData = float3(1,1,1);
                        NormalMapData.xy = _NormalMap_var.xy * 2 - 1;
                        NormalMapData.z = sqrt(1 - saturate(dot(NormalMapData.xy, NormalMapData.xy)));
                        float3 normalLocal = lerp(float3(0, 0, 1), NormalMapData, _NormalIntensity);
                        normalDir = normalize(mul(normalLocal, tangentTransform)); // Perturbed normals
                        i.uv.zw = mul((float3x3)UNITY_MATRIX_V, normalDir).xy * 0.5 + 0.5;
            #endif
                        half3 viewDir = normalize(i.viewDir);
                        half normalDotEye = dot(normalDir, viewDir);
                        half falloffU = clamp(1.0 - abs(normalDotEye), 0.02, 0.98);
                        half3 shadowColor = diffSamplerColor.rgb * diffSamplerColor.rgb;

            #if _DIFFUSEFALLOFF
                        half3 diffuselightDir = mul(_DiffuseAttenDir.xyz, viewSpace);
                        half NdotLClamp = saturate(falloffU * 0.5 * (dot(normalDir, diffuselightDir) + 1.0));
                        half4 falloffSamplerColor = _DiffuseIntensity * tex2D(_DiffuseLightRamp, float2(NdotLClamp, 0.25f)) * falloffU;
                        #if _NORMALMAPON
                        falloffSamplerColor *= _NormalMap_var.z;
                        #endif
                        combinedColor = lerp(combinedColor, shadowColor, falloffSamplerColor.r);
                        //combinedColor = combinedColor + falloffSamplerColor.rgb * falloffSamplerColor.a * combinedColor;
            #endif

            #if _SPECULARFALLOFF
                        half4 reflectionMaskColor = tex2D(_SpecularMask, i.uv.xy);
                        float4 lighting = lit(normalDotEye, normalDotEye, _SpecularPower);
                        float3 specularColor = saturate(lighting.z) * reflectionMaskColor.rgb * diffSamplerColor.rgb * reflectionMaskColor.a;
                        combinedColor += specularColor;
            #endif

            #if _REFLECTMATCAP
                        half3 reflectColor = tex2D(_MatCap, i.uv.zw) * _MatCapIntensity * diffSamplerColor;
                        //reflectColor = GetOverlayColor(reflectColor, combinedColor);
                        combinedColor = lerp(combinedColor,reflectColor,diffSamplerColor.a);
            #endif

            #if _SHADOWFALLOFF
                        // Cast shadows
                        shadowColor = _ShadowColor.rgb * combinedColor;
                        half attenuation = saturate(2.0 * LIGHT_ATTENUATION(i) - 1.0);
                        combinedColor = lerp(shadowColor, combinedColor, attenuation);
            #endif

            #if _RIMLIGHT
                        half3 rimlightDir = mul(_AttenDir.xyz, viewSpace);
                        half rimlightDot = saturate(0.5 * (dot(normalDir, rimlightDir) + 1.0));
                        rimlightDot = saturate(rimlightDot * falloffU);
                        rimlightDot = tex2D(_RimLightRamp, float2(rimlightDot, 0.25f)).r;
                        half3 lightColor = diffSamplerColor.rgb; // * 2.0;
                        #if _NORMALMAPON
                            rimlightDot *= _NormalMap_var.w;
                        #endif
                            half3 rimlightColor = rimlightDot * lightColor * _RimPower;
#if _DIFFUSEFALLOFF
                            rimlightColor *= (1 - NdotLClamp);
#endif
                        combinedColor += rimlightColor;
                        combinedColor += rimlightColor * combinedColor * _Rim_BloomRange * exp2(_Rim_BloomRange * 10);
            #endif

            #if _MultiColor
                        fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                        combinedColor *= gColor;
            #endif

#if defined(UseShadowMap)
                        CalculateShadowMap(combinedColor, i);
#endif

                        return half4(combinedColor,1);
                    }
                ENDCG
            }
        }

        //FallBack "Diffuse"
        Fallback "Game/Base/ShadowCaster"
}
