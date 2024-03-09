
#ifndef GT_TERRAIN_INCLUDED
#define GT_TERRAIN_INCLUDED

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"
#include "Assets/Shader/Common/GTCommon.cginc"
#include "Assets/Shader/Common/Lod_Macro.cginc"

//
#if UseNormalMap && SHADER_LOD_LEVEL < 2 && CameraClose
    #define CanUseNormalMap 1
#endif

//
#if CanUseNormalMap && SHADER_LOD_LEVEL < 2 
    #define CanLighting 1
#endif

//
struct appdata_gtterrain
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
#if CanUseNormalMap
    float4 tangent :TANGENT;
#endif
    float2 texcoord : TEXCOORD0;
#if defined(LIGHTMAP_ON) || defined(LIGHTMAP_INS)
    float2 texcoord1 : TEXCOORD1;
#endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};



//
#if CanLighting
    uniform float _Gloss;
    uniform float _Metallic;
    uniform float4 _GTLightDir;
    uniform float4 _EnvColor;
    uniform float4 _GTLightColor;
    //
    #define TERRAIN_LIGHT_INFO(lightIn)        GTLightIn lightIn;\
            lightIn.LightmapUV = i.texcoord.zw;\
            lightIn.DiffuseColor = finalColor.rgb;\
            lightIn.LightDir = _GTLightDir;\
            lightIn.LightColor = _GTLightColor;\
            lightIn.EnvColor = _EnvColor;\
            lightIn.Glossiness = _Gloss;\
            lightIn.SpecularColor = _Metallic;\
            lightIn.WorldPos = i.worldPos.xyz;\
            lightIn.NormalDir = i.normal;

    //
    #define TERRAIN_LIGHTING(finalColor,lightdata)  finalColor.rgb = GT_LIGHT(lightdata);
#else
    #define TERRAIN_LIGHT_INFO(lightIn)        GTLightIn lightIn;\
            lightIn.LightmapUV = i.texcoord.zw;\
            lightIn.DiffuseColor = finalColor.rgb;

    #define TERRAIN_LIGHTING(finalColor,lightdata)  CalculateLighMap(finalColor,lightdata.LightmapUV)
#endif

#if UseVerticalFog || GTCloudShadow
#define WORLD_Y   i.worldPos.y
#else   
#define WORLD_Y   0
#endif

// 
#if  SHADER_LOD_LEVEL < 2
    #define TERRAIN_FINAL(finalColor,i,lightdata) \
            TERRAIN_LIGHTING(finalColor,lightdata)\
            BlendGlobalColor(finalColor);\
            GetCloudShadow(finalColor,i)\
            CalculateBakeShadow(finalColor,i)\
            CalculateShadowMap(finalColor,i)\
            RAIN_SHADING(finalColor,i)\
            UNITY_APPLY_FOG(i.fogCoord, finalColor); \
            CalculateVerticalFog(finalColor,WORLD_Y); \
            UNITY_OPAQUE_ALPHA(finalColor.a);
#else
    #define TERRAIN_FINAL(finalColor,i,lightdata) \
            BlendGlobalColor(finalColor);\
            CalculateShadowMap(finalColor,i)\
            UNITY_APPLY_FOG(i.fogCoord, finalColor); \
            CalculateVerticalFog(finalColor,WORLD_Y); \
            UNITY_OPAQUE_ALPHA(finalColor.a);

#endif




       
      

//
 float3 CalculateStylizedColor(float3 col,float3 styleColor,float _Brightness,float _MinGray,float _MaxGray,float3 _StyleColor)
{
    fixed3 styleClr = col; 
    float gray = styleClr.r * 0.299 + styleClr.g * 0.587 + styleClr.b * 0.114; 
    gray *= _Brightness; 
    gray = clamp(gray, _MinGray, _MaxGray); 
    styleClr = float3(gray, gray, gray); 
    styleClr *= _StyleColor.rgb; 
#if _STYLE_TEX
    styleClr = lerp(styleColor.rgb, styleClr, saturate(gray));
#endif
    return styleClr;
}

 // --   
#if  SHADER_LOD_LEVEL < 2
#define SHADE_COLOR(finalColor,i) \
            CalculateLighMap(finalColor,i.texcoord.zw); \
            GT_COLOR_GRADATION(finalColor);\
            BlendGlobalColor(finalColor);\
            GetCloudShadow(finalColor,i);\
            CalculateBakeShadow(finalColor,i)\
            CalculateShadowMap(finalColor,i)\
            RAIN_SHADING(finalColor,i)\
            UNITY_APPLY_FOG(i.fogCoord, finalColor); \
            CalculateVerticalFog(finalColor,WORLD_Y); \
            UNITY_OPAQUE_ALPHA(finalColor.a);

#else
#define SHADE_COLOR(finalColor,i) \
            BlendGlobalColor(finalColor);\
            CalculateShadowMap(finalColor,i)\
            UNITY_APPLY_FOG(i.fogCoord, finalColor); \
            CalculateVerticalFog(finalColor,WORLD_Y); \
            UNITY_OPAQUE_ALPHA(finalColor.a);

#define SHADING_STYLIZED(finalColor,styleColor) 
#endif

#endif


