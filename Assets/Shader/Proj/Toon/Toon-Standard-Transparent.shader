// Upgrade NOTE: replaced 'defined _DIFFUSEFALLOFF' with 'defined (_DIFFUSEFALLOFF)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Hidden/GT/Proj/Toon/Standard-Transparent" {
    Properties{
        _MainTex("Alpha", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)

        [Space(20)][Header((Outline))]_OutlineColor("", Color) = (0,0,0,1)
        _OutlineGain("",float) = 1
        _EdgeThickness("", float) = 1
        _DepthBias("",float) = 12

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
                Tags { "RenderType" = "Transparent" "IgnoreProjector"="True" "Queue"="Transparent" }
                LOD 200
                Blend SrcAlpha OneMinusSrcAlpha
            Pass {

                    Tags{ "LightMode" = "ForwardBase" }
                    CGPROGRAM
                    #pragma skip_variants LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE DYNAMICLIGHTMAP_ON DIRECTIONAL_COOKIE POINT_COOKIE SHADOWS_CUBE FOG_EXP FOG_EXP2 SPOT POINT EDITOR_VISUALIZATION
                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma shader_feature _ _DIFFUSEFALLOFF
                    //#pragma shader_feature _ _SPECULARFALLOFF
                    #pragma shader_feature _ _RIMLIGHT
                    //#pragma shader_feature _ _REFLECTMATCAP
                    //#pragma shader_feature _ _SHADOWFALLOFF
                    //#pragma shader_feature _ _NORMALMAPON
                    #pragma shader_feature _ _MultiColor

                    #include "UnityCG.cginc"
                    #include "AutoLight.cginc"

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

                        return half4(combinedColor,_Color.a);
                    }
                ENDCG
            }
            Pass
            {

                Cull Front
                ZTest Less
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                float4 _Color;

                float4 _LightColor0;

                float4 _OutlineColor;
                float _OutlineGain;

                float  _EdgeThickness = 1.0;

                float  _DepthBias = 12;

                float4 _MainTex_ST;

                sampler2D _MainTex;

                struct a2v
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float4 texcoord : TEXCOORD0;
                    float4 color : COLOR;
                };
                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float2 UV  : TEXCOORD0;
                };

                #define OUTLINE_NEAR_DISTANCE_SCALE (0)
                #define OUTLINE_FAR_DISTANCE_SCALE (20)
                #define OUTLINE_NORMAL_SCALE_MIN (0.002)
                #define OUTLINE_NORMAL_SCALE_MAX (0.012)

                v2f vert(a2v v)
                {
                    float t = unity_CameraProjection._m11;
                    const float Rad2Deg = 180 / UNITY_PI;
                    float fov = atan(1.0f / t) * 2.0 * Rad2Deg;

                    v2f o;
                    float4 pos = float4(UnityObjectToViewPos(v.vertex), 1.0);
                    float distFactor = smoothstep(OUTLINE_NEAR_DISTANCE_SCALE, OUTLINE_FAR_DISTANCE_SCALE, abs(pos.z));
                    float fovFactor = lerp(1, 1.3, smoothstep(25, 50, fov));
                    float normalScale = _EdgeThickness *
                        lerp(OUTLINE_NORMAL_SCALE_MIN * fovFactor, OUTLINE_NORMAL_SCALE_MAX * fovFactor, distFactor) * 0.1;

                    float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                    normal.z = -0.5;

                    pos = pos + float4(normalize(normal), 0) * normalScale * v.color.a;

                    o.pos = mul(UNITY_MATRIX_P, pos);
                #ifdef UNITY_REVERSED_Z
                    o.pos.z -= _DepthBias * 0.0001;
                #else
                #ifdef UNITY_UV_STARTS_AT_TOP
                    o.pos.z += _DepthBias * 0.0001 * abs(_ProjectionParams.z / _ProjectionParams.y);
                #else
                    o.pos.z += _DepthBias * 0.0001 * abs(_ProjectionParams.z / _ProjectionParams.y + 1);
                #endif
                #endif
                    o.UV = v.texcoord.xy;

                    return o;
                }

                #define BRIGHTNESS_FACTOR 0.8

                half4 frag(v2f i) : COLOR
                {
                    half4 mainMapColor = tex2D(_MainTex, i.UV);

                    half3 outlineColor = BRIGHTNESS_FACTOR
                        * mainMapColor.rgb * _OutlineColor.xyz * _OutlineGain;

                    return half4(outlineColor, _Color.a);
                }

                ENDCG
                }
        }
        //FallBack "Diffuse"
        Fallback "Game/Base/ShadowCaster"
}
