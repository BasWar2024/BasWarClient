#ifndef GT_SCENE_SHADER_UTILITIES
#define GT_SCENE_SHADER_UTILITIES

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"
#include "UnityGlobalIllumination.cginc"

//x = 1:On 0:Off
//y = HeightDensity
//z = (-1/(end-start))
//w = (end/(end-start))
uniform half4 gt_HeightFogParams;



inline half CalculateFogFactor(float4 vertex)
{
	#if defined(FOG_LINEAR)
		float4 pos = UnityObjectToClipPos(vertex);
		half fog_factor = max((UNITY_Z_0_FAR_FROM_CLIPSPACE(pos.z) * unity_FogParams.z + unity_FogParams.w), 0);
	#else
		half fog_factor = 1;
	#endif
    if (gt_HeightFogParams.x == 1)
    {
        float3 posWorld = mul(unity_ObjectToWorld, vertex).xyz;
        fog_factor -= max(1 - (gt_HeightFogParams.w - posWorld.y) / (gt_HeightFogParams.w - gt_HeightFogParams.z), 0);
    }
	return fog_factor;
}


inline half CalculateFogFactor(float4 vertex, float4 pos)
{
	#if defined(FOG_LINEAR)
		half fog_factor = max((UNITY_Z_0_FAR_FROM_CLIPSPACE(pos.z) * unity_FogParams.z + unity_FogParams.w), 0);
	#else
		half fog_factor = 1;
	#endif
	if (gt_HeightFogParams.x == 1)
	{
		float3 posWorld = mul(unity_ObjectToWorld, vertex).xyz;
		fog_factor -= max(1 - (gt_HeightFogParams.w - posWorld.y) / (gt_HeightFogParams.w - gt_HeightFogParams.z), 0);
	}
	return fog_factor;
}


//// Linear half-space fog, from https://www.terathon.com/lengyel/Lengyel-UnifiedFog.pdf
//float ComputeHalfSpace(float3 wsDir)
//{
//	float3 wpos = _CameraWS + wsDir;
//	float FH = _HeightParams.x;
//	float3 C = _CameraWS;
//	float3 V = wsDir;
//	float3 P = wpos;
//	float3 aV = _HeightParams.w * V;
//	float FdotC = _HeightParams.y;
//	float k = _HeightParams.z;
//	float FdotP = P.y - FH;
//	float FdotV = wsDir.y;
//	float c1 = k * (FdotP + FdotC);
//	float c2 = (1 - 2 * k) * FdotP;
//	float g = min(c2, 0.0);
//	g = -length(aV) * (c1 - g * g / abs(FdotV + 1.0e-5f));
//	return g;
//}


//x:day time
//y:wet weight
//z:snow weight
uniform float4 gt_WeatherParams;
UNITY_DECLARE_TEX2D_HALF(gt_Lightmap1);

uniform sampler2D _WeatherNoiseTex; uniform float4 _WeatherNoiseTex_ST;
uniform float4 _SnowColor;
uniform float4 _RainSkyColor;
uniform float4 _SnowSkyColor;

inline fixed3 WeatherAlbedo(fixed3 albedo, half2 uv, half3 normalDir)
{
	#ifdef GT_WEATHER
		if (gt_WeatherParams.y < 0) //
		{
			albedo = lerp(albedo, _RainSkyColor.rgb * albedo, abs(gt_WeatherParams.y));
		}
		//if (gt_WeatherParams.y < 0) //
		//{
		//	fixed _Melt_var = tex2D(_WeatherNoiseTex, uv).r;
		//	fixed rain_logging = saturate((normalDir.y - (1 + _Melt_var) * (1 - abs(gt_WeatherParams.y) * 0.7f)) * 8.0f);
		//	albedo = lerp(albedo, _RainSkyColor.rgb * albedo, rain_logging);
		//}
		if (gt_WeatherParams.y > 0) //
		{
			fixed _Melt_var = tex2D(_WeatherNoiseTex, uv).r;
			fixed snow_logging = saturate((normalDir.y - (1 + _Melt_var) * (1 - gt_WeatherParams.y * 0.45f)) * 16.0f);
			//fixed snow_logging = saturate((normalDir.y - (1.5 - saturate(_Melt_var + gt_WeatherParams.y * 2 - 1))) * 8);
			albedo = lerp(albedo, _SnowColor.rgb, snow_logging);
			albedo = lerp(albedo, albedo * _SnowSkyColor, gt_WeatherParams.y);
		}
	#endif
	return albedo;
}

inline UnityGI GTGI_Base(UnityGIInput data, half occlusion, half3 normalWorld)
{
	UnityGI o_gi;
	ResetUnityGI(o_gi);

	// Base pass with Lightmap support is responsible for handling ShadowMask / blending here for performance reason
	#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
		half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
		float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
		float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
		data.atten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
	#endif

	o_gi.light = data.light;
	o_gi.light.color *= data.atten;

	#if UNITY_SHOULD_SAMPLE_SH
		o_gi.indirect.diffuse = ShadeSHPerPixel(normalWorld, data.ambient, data.worldPos);
	#endif

	#if defined(LIGHTMAP_ON)
		// Baked lightmaps
		half4 bakedColorTex = UNITY_SAMPLE_TEX2D(unity_Lightmap, data.lightmapUV.xy);
		half3 bakedColor = half3(0, 0, 0);
		if (gt_WeatherParams.x > 0.01)
		{
			half4 bakedColorDarkTex = UNITY_SAMPLE_TEX2D(gt_Lightmap1, data.lightmapUV.xy);
			bakedColor = DecodeLightmap(lerp(bakedColorTex, bakedColorDarkTex, gt_WeatherParams.x));
		}
		else
		{
			bakedColor = DecodeLightmap(bakedColorTex);
		}

		#ifdef DIRLIGHTMAP_COMBINED
			fixed4 bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, data.lightmapUV.xy);
			o_gi.indirect.diffuse = DecodeDirectionalLightmap(bakedColor, bakedDirTex, normalWorld);
			#if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
				ResetUnityLight(o_gi.light);
				o_gi.indirect.diffuse = SubtractMainLightWithRealtimeAttenuationFromLightmap(o_gi.indirect.diffuse, data.atten, bakedColorTex, normalWorld);
			#endif
		#else // not directional lightmap
			o_gi.indirect.diffuse = bakedColor;
			#if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
				ResetUnityLight(o_gi.light);
				o_gi.indirect.diffuse = SubtractMainLightWithRealtimeAttenuationFromLightmap(o_gi.indirect.diffuse, data.atten, bakedColorTex, normalWorld);
			#endif
		#endif
	#endif

	#ifdef DYNAMICLIGHTMAP_ON
		// Dynamic lightmaps
		fixed4 realtimeColorTex = UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, data.lightmapUV.zw);
		half3 realtimeColor = DecodeRealtimeLightmap(realtimeColorTex);
		#ifdef DIRLIGHTMAP_COMBINED
			half4 realtimeDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, data.lightmapUV.zw);
			o_gi.indirect.diffuse += DecodeDirectionalLightmap(realtimeColor, realtimeDirTex, normalWorld);
		#else
			o_gi.indirect.diffuse += realtimeColor;
		#endif
	#endif

	o_gi.indirect.diffuse *= occlusion;
	return o_gi;
}

inline half4 LightingGTLambert(SurfaceOutput s, UnityGI gi)
{
	half4 c;
	c = UnityLambertLight(s, gi.light);
	#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
		c.rgb += s.Albedo * gi.indirect.diffuse;
	#endif
	return c;
}

inline void LightingGTLambert_GI(SurfaceOutput s, UnityGIInput data, inout UnityGI gi)
{
	#ifdef GT_WEATHER
		gi = GTGI_Base(data, 1.0, s.Normal);
	#else
		gi = UnityGlobalIllumination(data, 1.0, s.Normal);
	#endif
}

#ifdef GT_WEATHER
	#define GT_WEATHER_COORDS(idx0, idx1) half4 WeatherNoiseTexUVAndFogCoord : TEXCOORD##idx0; half3 worldNormal : TEXCOORD##idx0;
	#define GT_FOG_COORDS(idx)

	#define SURFACE_INPUT_WEATHER half4 WeatherNoiseTexUVAndFogCoord; half3 worldNormal; INTERNAL_DATA

	#define GT_TRANSFER_WEATHER(IN, v) IN.WeatherNoiseTexUVAndFogCoord.xy = TRANSFORM_TEX(v.texcoord, _WeatherNoiseTex)

	#define SURFACE_INPUT_FOG

	#define WEATHER_ALBEDO(c, IN) WeatherAlbedo(c.rgb, IN.WeatherNoiseTexUVAndFogCoord.xy, IN.worldNormal)
#else
	#define GT_WEATHER_COORDS(idx0, idx1)
	#define GT_FOG_COORDS(idx) half4 WeatherNoiseTexUVAndFogCoord : TEXCOORD##idx;

	#define SURFACE_INPUT_WEATHER

	#define GT_TRANSFER_WEATHER(IN, v)

	#define SURFACE_INPUT_FOG half4 WeatherNoiseTexUVAndFogCoord;

	#define WEATHER_ALBEDO(c, IN) c.rgb
#endif

#define GT_TRANSFER_FOG(o, v, pos) o.WeatherNoiseTexUVAndFogCoord.w = CalculateFogFactor(v.vertex, pos)
#define GT_TRANSFER_FOG_SURF(o, v) o.WeatherNoiseTexUVAndFogCoord.w = CalculateFogFactor(v.vertex)

#ifdef UNITY_PASS_FORWARDADD
	#define GT_APPLY_FOG(IN, col) col.rgb = lerp(float3(0, 0, 0), col.rgb, saturate(IN.WeatherNoiseTexUVAndFogCoord.w))
#else
	#define GT_APPLY_FOG(IN, col) col.rgb = lerp(unity_FogColor.rgb, col.rgb, saturate(IN.WeatherNoiseTexUVAndFogCoord.w))
#endif


inline fixed SmoothEdgeHalf(fixed alpha, fixed fade)
{
	return saturate(1.0f - abs(abs(alpha - 0.5f) * 2.0f - 0.5f) * 2.0f) * 0.5f / fade;
}

inline fixed SmoothEdge(fixed alpha, fixed fade)
{
	return saturate(1.0f - abs(alpha - 0.5f) * 2.0f) / fade;
}





uniform sampler2D gt_ShadowTexture;
uniform float4x4 gt_ShadowVPMatrix;
uniform float4 gt_ShadowColor;
inline fixed3 ShadowAlbedo(fixed3 rgb, half4 shadowProjectCoord) {
	// step(a, x) ->> x < a return 0, x >= a return 1
	// v = 0 
	float v = 1 - step(DecodeFloatRGBA(tex2D(gt_ShadowTexture, shadowProjectCoord.xy)), shadowProjectCoord.z);
	fixed3 tempRgb = lerp(gt_ShadowColor * rgb, rgb, v);

	float x = shadowProjectCoord.x;
	float y = shadowProjectCoord.y;
	float z = shadowProjectCoord.z;
	float isClip = (x < 0 || x > 1) || (y < 0 || y > 1) || (z < 0 || z > 1);
	fixed3 resRgb = lerp(tempRgb, rgb, isClip);
	return resRgb;
}

#ifdef GT_DYNAMIC_SHADOW
//
	#define SURFACE_INPUT_SHADOW_PROJECTOR_COORD half4 ShadowProjectCoord;
	#define GT_SHADOW_COORD(idx) half4 ShadowProjectCoord : TEXCOORD##idx;
	#define GT_TRANSFER_SHADOW_PROJECTOR_COORD(IN, v) float4 worldPos = mul(UNITY_MATRIX_M, v.vertex); IN.ShadowProjectCoord = mul(gt_ShadowVPMatrix, worldPos); IN.ShadowProjectCoord.xyz = IN.ShadowProjectCoord.xyz / IN.ShadowProjectCoord.w * 0.5 + 0.5;
	#define SHADOW_ALBEDO(c, IN) ShadowAlbedo(c.rgb, IN.ShadowProjectCoord);

#else
	#define SURFACE_INPUT_SHADOW_PROJECTOR_COORD
	#define GT_SHADOW_COORD(idx)
	#define GT_TRANSFER_SHADOW_PROJECTOR_COORD(IN, v)
	#define SHADOW_ALBEDO(c,IN) c.rgb
#endif




uniform float4 gt_InteractTime;
uniform sampler2D gt_WaveMap;
uniform sampler2D gt_PressureMap;
uniform float4x4 gt_InteractVPs[4];
uniform float4 gt_InteractAreas[4];

inline fixed4 GetCasacadeInteractWeights_Sphere(float3 wpos)
{
	float2 fromCenter0 = wpos.xz - gt_InteractAreas[0].xz;
	float2 fromCenter1 = wpos.xz - gt_InteractAreas[1].xz;
	float2 fromCenter2 = wpos.xz - gt_InteractAreas[2].xz;
	float2 fromCenter3 = wpos.xz - gt_InteractAreas[3].xz;
	float4 distances2 = float4(dot(fromCenter0, fromCenter0), dot(fromCenter1, fromCenter1), dot(fromCenter2, fromCenter2), dot(fromCenter3, fromCenter3));
	fixed4 weights = distances2 < float4(gt_InteractAreas[0].w, gt_InteractAreas[1].w, gt_InteractAreas[2].w, gt_InteractAreas[3].w);
	weights.yzw = saturate(weights.yzw - weights.xyz);
	return weights;
}

inline fixed4 GetCasacadeInteractWeights_Square(float3 wpos)
{
	float2 fromCenter0 = wpos.xz - gt_InteractAreas[0].xz;
	float2 fromCenter1 = wpos.xz - gt_InteractAreas[1].xz;
	float2 fromCenter2 = wpos.xz - gt_InteractAreas[2].xz;
	float2 fromCenter3 = wpos.xz - gt_InteractAreas[3].xz;
	float4 distances2 = float4(max(fromCenter0.x, fromCenter0.y), max(fromCenter1.x, fromCenter1.y), max(fromCenter2.x, fromCenter2.y), max(fromCenter3.x, fromCenter3.y));
	fixed4 weights = distances2 < float4(gt_InteractAreas[0].w, gt_InteractAreas[1].w, gt_InteractAreas[2].w, gt_InteractAreas[3].w);
	weights.yzw = saturate(weights.yzw - weights.xyz);
	return weights;
}

//,
inline float2 GetInteractCoords(float4 wpos)
{
	fixed4 cascadeWeights = (fixed4)0;
#ifdef _INTERACT_SPLIT_SPHERE
	cascadeWeights = GetCasacadeInteractWeights_Sphere(wpos.xyz);
#elif _INTERACT_SPLIT_SQUARE
	cascadeWeights = GetCasacadeInteractWeights_Square(wpos.xyz);
#endif

#ifdef _INTERACT_TWO_CASCADES
	float2 sc0 = (mul(gt_InteractVPs[0], wpos).xy * 0.5f + 0.5f) * float2(0.5f, 1.0f);
	float2 sc1 = (mul(gt_InteractVPs[1], wpos).xy * 0.5f + 0.5f) * float2(0.5f, 1.0f) + float2(0.5f, 0.0f);
	return (sc0 * cascadeWeights[0] + sc1 * cascadeWeights[1]);
#elif _INTERACT_FOUR_CASCADES
	float2 sc0 = (mul(gt_InteractVPs[0], wpos).xy * 0.5f + 0.5f) * float2(0.5f, 0.5f);
	float2 sc1 = (mul(gt_InteractVPs[1], wpos).xy * 0.5f + 0.5f) * float2(0.5f, 0.5f) + float2(0.5f, 0.0f);
	float2 sc2 = (mul(gt_InteractVPs[2], wpos).xy * 0.5f + 0.5f) * float2(0.5f, 0.5f) + float2(0.0f, 0.5f);
	float2 sc3 = (mul(gt_InteractVPs[3], wpos).xy * 0.5f + 0.5f) * float2(0.5f, 0.5f) + float2(0.5f, 0.5f);
	return (sc0 * cascadeWeights[0] + sc1 * cascadeWeights[1] + sc2 * cascadeWeights[2] + sc3 * cascadeWeights[3]);
#else
	return mul(gt_InteractVPs[0], wpos).xy * 0.5f + 0.5f;
#endif
}


uniform sampler2D gt_ReflectionTex;
uniform float4x4 gt_ReflectionVP;
uniform sampler2D gt_ReflectionMask;
uniform float gt_ReflectionIntensity;

inline fixed3 ReflectionComine(fixed3 color, float2 ref_coord, float2 mask_coord)
{
	fixed3 ref_col = tex2D(gt_ReflectionTex, ref_coord).rgb;
	fixed mask_var = tex2D(gt_ReflectionMask, mask_coord).r;
	return gt_ReflectionIntensity * mask_var * ref_col;
}

inline fixed3 ReflectionComine(float3 worldPos, float2 mask_coord)
{
	float4 ref_coord = mul(gt_ReflectionVP, float4(worldPos, 1.0f));
	ref_coord = ref_coord / ref_coord.w * 0.5f + 0.5f;
	fixed3 ref_col = tex2D(gt_ReflectionTex, ref_coord.xy).rgb;
	fixed mask_var = tex2D(gt_ReflectionMask, mask_coord).r;
	return gt_ReflectionIntensity * mask_var * ref_col;
}

#ifdef GT_REFLECTION
	#define SURFACE_INPUT_REFLECTION_COORD float3 worldPos;
	//#ifdef GT_DYNAMIC_SHADOW
	//	#define GT_TRANSFER_REFLECTION_COORD(IN, v) IN.ReflectionCoord = mul(gt_ReflectionVP, worldPos).xy;
	//#else
	//	#define GT_TRANSFER_REFLECTION_COORD(IN, v) float4 worldPos = mul(UNITY_MATRIX_M, v.vertex); IN.ReflectionCoord = mul(gt_ReflectionVP, worldPos).xy;
	//#endif
	#define GT_REFLECTION_COLOR(IN, uv_mask) ReflectionComine(IN.worldPos, uv_mask);
#else
	#define SURFACE_INPUT_REFLECTION_COORD
	//#define GT_TRANSFER_REFLECTION_COORD(IN, v)
	#define GT_REFLECTION_COLOR(IN, uv_mask) half3(0, 0, 0);
#endif

#endif //GT_SCENE_SHADER_UTILITIES