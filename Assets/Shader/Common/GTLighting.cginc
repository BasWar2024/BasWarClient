
#ifndef GT_LIGHTING_INCLUDED
#define GT_LIGHTING_INCLUDED

//
typedef struct {
    float3 NormalDir;
    float  Glossiness;
    float3 SpecularColor;
    float3 DiffuseColor;
    float3 LightDir;
    float3 WorldPos;
    float2 LightmapUV;
    float2 DynamicLightmapUV;
    float4 EnvColor;
    float4 LightColor;
} GTLightIn;



#if SHADER_LOD_LEVEL == 0 //PBR GT_PBR_LOD0
    #define GT_LIGHT(info)  GT_PBR_LOD1(info);
#elif SHADER_LOD_LEVEL == 1  
    #define GT_LIGHT(info)  GT_PBR_LOD1(info);
#else
    #define GT_LIGHT(info)  
#endif
    


float3 GT_PBR_LOD1(GTLightIn info)
{
    //Data
    float3 lightDirection = info.LightDir;
    float3 normalDirection = info.NormalDir;
    half nl = dot(normalDirection, lightDirection) ;
    half3 color = info.DiffuseColor;
    CalculateLighMap(color, info.LightmapUV);
    color *= info.LightColor.rgb * saturate(nl * 0.5 + 0.8);//
    color += info.EnvColor.rgb;
    return half4(color, 1);
}




float3 GT_PBR_LOD0(GTLightIn info)
{
    //Data
    float3 lightDirection = info.LightDir;
    float3 normalDirection = info.NormalDir;
    float3 worldPos = info.WorldPos;
    float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - worldPos);
    float3 lightColor = info.LightColor.rgb;
    float3 halfDirection = normalize(viewDirection + lightDirection);
    float gloss = info.Glossiness;
    float3 specularColor = info.SpecularColor;
    float3 diffuseColor = info.DiffuseColor;

    float attenuation = LIGHT_ATTENUATION(i);
    float3 attenColor = attenuation * lightColor.rgb;
    float Pi = 3.141592654;
    float InvPi = 0.31830988618;
    float perceptualRoughness = 1.0 - gloss;
    float roughness = perceptualRoughness * perceptualRoughness;

    float specPow = exp2(gloss * 10.0 + 1.0);

    float NdotV = abs(dot(normalDirection, viewDirection));
    float NdotH = saturate(dot(normalDirection, halfDirection));
    float VdotH = saturate(dot(viewDirection, halfDirection));
    float ndotl = dot(normalDirection, lightDirection);

    UnityLight light;
#ifdef LIGHTMAP_OFF
    light.color = lightColor;
    light.dir = lightDirection;
    light.ndotl = LambertTerm(normalDirection, light.dir);
#else
    light.color = half3(0.f, 0.f, 0.f);
    light.ndotl = 0.0f;
    light.dir = half3(0.f, 0.f, 0.f);
#endif

    //GI
    UnityGIInput d;
    d.light = light;
    d.worldPos = info.WorldPos;
    d.worldViewDir = viewDirection;
    d.atten = attenuation;
    d.ambient = info.EnvColor.rgb;
#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    d.lightmapUV = float4(info.LightmapUV.xy,info.DynamicLightmapUV.xy);
#endif
    UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection);
    lightDirection = gi.light.dir;
    lightColor = gi.light.color;

    //Specular
    float NdotL = saturate(ndotl);
    float LdotH = saturate(dot(lightDirection, halfDirection));
    float specularMonochrome;
    diffuseColor = DiffuseAndSpecularFromMetallic(diffuseColor, specularColor, specularColor, specularMonochrome);
    specularMonochrome = 1.0 - specularMonochrome;
    float visTerm = SmithJointGGXVisibilityTerm(NdotL, NdotV, roughness);
    float normTerm = GGXTerm(NdotH, roughness);
    float specularPBL = (visTerm * normTerm) * UNITY_PI;
    specularPBL = max(0, specularPBL * NdotL);
    half surfaceReduction;
    surfaceReduction = 1.0 / (roughness * roughness + 1.0);
    specularPBL *= any(specularColor) ? 1.0 : 0.0;
    float3 directSpecular = attenColor * specularPBL * FresnelTerm(specularColor, LdotH);
    half grazingTerm = saturate(gloss + specularMonochrome);
    float3 indirectSpecular = (gi.indirect.specular);
    indirectSpecular *= FresnelLerp(specularColor, grazingTerm, NdotV);
    indirectSpecular *= surfaceReduction;
    float3 specular = (directSpecular + indirectSpecular);
    NdotL = max(0.0, ndotl);
    half fd90 = 0.5 + 2 * LdotH * LdotH * (1 - gloss);
    float nlPow5 = Pow5(1 - NdotL);
    float nvPow5 = Pow5(1 - NdotV);
    float3 directDiffuse = ((1 + (fd90 - 1) * nlPow5) * (1 + (fd90 - 1) * nvPow5) * NdotL) * attenColor;
    //Final
    float3 indirectDiffuse = gi.indirect.diffuse;
    float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
    float3 finalColor = diffuse + specular;
    return finalColor;
}

#endif