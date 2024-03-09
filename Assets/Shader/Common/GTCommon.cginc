
#ifndef GT_COMMON_INCLUDED
#define GT_COMMON_INCLUDED

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"
#include "Assets/Shader/Common/Lod_Macro.cginc"

//	#define SoftShadowMap 1; //
//
#if defined(FragPointLight) || defined(VexPointLight)
#define UsePointLight 1
#endif

#if (defined(UseShadowMap) || defined(UseVerticalFog) || defined(OBJBlend) || (defined(UsePointLight) || (defined(UseBakeShadow) || defined(GTCloudShadow) ||  defined(RAIN) ) && SHADER_LOD_LEVEL<2)) 
	#define USE_WORLDPOS 1
#endif




//
#ifdef UsePointLight
	fixed _PointLightCount;
	fixed4 _PointLightPosArray[3];
	fixed4 _PointLightColorArray[3];
	float3 PointLightColor(float3 normal, float3 wpos)
	{
		float3 result = 0;
		for (int i = 0; i < _PointLightCount; i++)
		{
			float dis = distance(_PointLightPosArray[i].xyz, wpos.xyz);
			fixed3 dir = (_PointLightPosArray[i].xyz - wpos.xyz);
			dir = dir * dot(dir, dir) / dis; 
			float atten = 1 - saturate(dis / _PointLightPosArray[i].w);
		//	atten *= atten * atten;
			fixed3 diffuse = (max(0,dot(dir, normal)) * 0.5 + 0.5) * _PointLightColorArray[i].rgb * atten;
			result.xyz += diffuse;
		}
		return result;
	}
#endif


//
#if defined(OBJBlend)
	uniform sampler2D _ObjectBlend;
	uniform float4 _ObjectBlendParams;
	#define GetObjBlendColor(outColor,worldPos)\
			float2 blendUV = worldPos.xz * _ObjectBlendParams.xy + _ObjectBlendParams.zw; \
			outColor = tex2D(_ObjectBlend, blendUV);
#else
	#define GetObjBlendColor(outColor,worldPos)
#endif

//
#if (defined(RAIN) && SHADER_LOD_LEVEL < 2)
uniform sampler2D _RainNoise;
uniform sampler2D _RainMask;
uniform float _RainIntensity;
uniform float4 _RainWorldParams;
uniform float4 _RainNoiseOffset;
uniform float4 _RainNoiseOffset2;
	#define RAIN_SHADING(finalColor,i)\
            float noise1 = tex2D(_RainNoise, i.worldPos.xz * _RainNoiseOffset.z + _Time.y  * _RainNoiseOffset.xy ) * _RainNoiseOffset.w;\
            float noise2 = tex2D(_RainNoise, (i.worldPos.xz * _RainNoiseOffset2.z + noise1) + _Time.y * _RainNoiseOffset2.xy);\
			float2 rainMapUv = i.worldPos.xz * _RainWorldParams.xy + _RainWorldParams.zw; \
			float rainMask = tex2D(_RainMask, rainMapUv);\
            finalColor += noise2 * _RainIntensity * rainMask;
#else
	#define RAIN_SHADING(finalColor,i)
#endif


//Shaodwmap
#if defined(UseShadowMap)
	uniform float4x4 _BakeShadowCameraMatrix;
	uniform sampler2D  _BakeShadowTexture;
	float4 _GlobalShadowColor;

#if defined(SoftShadowMap)
	float _ShadowMapPCFOffset;
	#define GetShadowMapDepth(uv,d,z) \
	d += step(tex2D(_BakeShadowTexture, shadowuv + float2(_ShadowMapPCFOffset,0)).r ,z);\
	d += step(tex2D(_BakeShadowTexture, shadowuv + float2(0,_ShadowMapPCFOffset)).r ,z);\
	d += step(tex2D(_BakeShadowTexture, shadowuv + float2(-_ShadowMapPCFOffset,0)).r,z);\
	d += step(tex2D(_BakeShadowTexture, shadowuv + float2(0,-_ShadowMapPCFOffset)).r,z);\
	d *= 0.25;
#else
	#define GetShadowMapDepth(uv,d,z) \
		d = tex2D(_BakeShadowTexture, shadowuv).r;\
		d = step(d,z);
							
#endif

//#if defined(UNITY_REVERSED_Z)
//	#define GetDepth(d)  d = 1 - d
//#else
//	#define GetDepth(d)  d = d * 0.5 + 0.5
//#endif
//	#define CalculateShadowMap(color,i)\
//		float4 shadowCoord = mul(_BakeShadowCameraMatrix, float4(i.worldPos.xyz,1));\
//		shadowCoord.xyz = shadowCoord.xyz / shadowCoord.w;\
//		float2 shadowuv = shadowCoord.xy * 0.5 + 0.5;\
//		float depth = shadowCoord.z;\
//		GetDepth(depth);\
//		float texDepth = 0;\
//		GetShadowMapDepth(shadowuv,texDepth,depth);\
//		fixed clampValue = depth>1?0:1;\
//		texDepth = depth > 1 || depth < 0 ? 1:texDepth;\
//		color.rgb = lerp(lerp(color.rgb,_GlobalShadowColor.rgb,_GlobalShadowColor.a),color.rgb,texDepth);
//#else
//	#define CalculateShadowMap(color,i)
//#endif

//if
#if defined(UNITY_REVERSED_Z)
	#define GetDepth(d)  d = 1 - d
#else
	#define GetDepth(d)  d = d * 0.5 + 0.5
#endif
	#define CalculateShadowMap(color,i)\
		float4 shadowCoord = mul(_BakeShadowCameraMatrix, float4(i.worldPos.xyz,1));\
		shadowCoord.xyz = shadowCoord.xyz / shadowCoord.w;\
		float2 shadowuv = shadowCoord.xy * 0.5 + 0.5;\
		float depth = shadowCoord.z;\
		GetDepth(depth);\
		if(depth < 1 && depth > 0)\
		{\
			float texDepth = 0;\
			GetShadowMapDepth(shadowuv,texDepth,depth);\
			color.rgb = lerp(lerp(color.rgb, _GlobalShadowColor.rgb, _GlobalShadowColor.a), color.rgb, texDepth);\
		}
#else
	#define CalculateShadowMap(color,i)
#endif
//
#if defined(NormalLerp)
	#define CalculateNormalBlend(srcNor,newNor,blendValue)  srcNor = lerp(srcNor,newNor,blendValue)
#else
	#define CalculateNormalBlend(srcNor,newNor,blendValue) srcNor = srcNor + newNor * blendValue
#endif

//
#if defined(UseBakeShadow)
	uniform sampler2D _BakeShadowTex;
	uniform float4 _BakeShadowParams;
	uniform float4 _BakeShadowParams2;

	#define CalculateBakeShadow(color,i)\
	float2 bakeUV = i.worldPos.xz * _BakeShadowParams.xy + _BakeShadowParams.zw; \
	color.rgb *= min(1,(tex2D(_BakeShadowTex, bakeUV).rgb + _BakeShadowParams2.x));

	#define CalculateBakeShadowValue(color,i,power)\
	float2 bakeUV = i.worldPos.xz * _BakeShadowParams.xy + _BakeShadowParams.zw; \
	color.rgb *= lerp(1,min(1,(tex2D(_BakeShadowTex, bakeUV).rgb + _BakeShadowParams2.x)),power);
#else
	#define CalculateBakeShadow(color,worldPos)
#endif


//
#if defined(VectorBillBoard)
	#define CalculateBillBoard(vertex)\
	float3 objViewDir = normalize(mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)));\
	float3 upDir = float3(0, -1, 0);\
	float3 rightDir = normalize(cross(objViewDir, upDir));\
	upDir = normalize(cross(objViewDir, rightDir));\
	float3 localPos = rightDir * vertex.x + upDir * vertex.y + objViewDir * vertex.z;\
	vertex.xyz = localPos.xyz;
#else
	#define CalculateBillBoard(vertex)
#endif

//
#if defined(GTCloudShadow) 
	//x,y  z  w
	uniform float4 _CloudShadowParams;
	uniform sampler2D _CloudShadowTex;
	uniform float4 _CloudShadowColor;
	uniform float _CloudShadowThreshold;

	#define GetCloudShadow(curColor,i)\
	float2 cloudShadowUV = (i.worldPos.xz) * _CloudShadowParams.z + _Time.y * _CloudShadowParams.xy;\
	float cloudShadow = tex2D(_CloudShadowTex,cloudShadowUV);\
	curColor.rgb = lerp( curColor.rgb, _CloudShadowColor.rgb , saturate((cloudShadow + _CloudShadowThreshold) * _CloudShadowParams.w));
#else
	#define GetCloudShadow(curColor,i) 
#endif


//
#if defined(UseVerticalFog)
	uniform fixed4 _VerticalFogColor;
	uniform float4 _VerticalParams;

	#define CalculateVerticalFog(curColor,worldPosY)\
	float fogFac = worldPosY * _VerticalParams.y + _VerticalParams.x;\
	curColor.rgb = lerp(_VerticalFogColor.rgb,curColor.rgb, saturate(fogFac));
#else
	#define CalculateVerticalFog(curColor,worldPosY) 
#endif

//
#if defined(UseAreaColor) 
	uniform sampler2D _AreaColorMap;
	uniform float4 _AreaColorParams;
	//worldPos.xz/mapSize.xy - ori.xz/mapSize.xy
	// -> _AreaColorParams.xy = 1/mapSize.xy, _AreaColorParams.zw = -ori.xz/mapSize.xy
	#define GetAreaColor(color,worldPos)\
	 float2 areaUV = worldPos.xz * _AreaColorParams.xy + _AreaColorParams.zw; \
	 color.rgb *= tex2D(_AreaColorMap,areaUV).rgb ;
	
#else
	#define GetAreaColor(color,worldPos)
#endif

//
#define BlendGlobalColor(col) col.rgb = col.rgb * _GlobalMultiCol.rgb * _GlobalMultiCol.a;

//
#if	defined(LIGHTMAP_ON) || defined(LIGHTMAP_INS)

	  #define CalculateLighMap(color,lightMapUV)\
		 half4 bakedColorTex = UNITY_SAMPLE_TEX2D(unity_Lightmap,lightMapUV);\
         half3 bakedColor = DecodeLightmap(bakedColorTex);\
         color.rgb *= bakedColor.rgb;
#else
	  #define CalculateLighMap(color,lightMapUV)
#endif

/*
#if defined(REALTIME_LIGHTING)
	#define CalculateLightting(color,normalDir)\
		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);\
		float3 lightColor = _LightColor0.rgb;\
		fixed3 diff = max (0, dot (normalDir.xyz,lightDirection)) * lightColor  ;\
		color.rgb *= diff.rgb;
#else 
	#define CalculateLightting(color,normalDir) 
#endif
*/

//
#if !defined(LIGHTMAP_ON) && !defined(LIGHTMAP_INS)
	#define GT_VERTEX_GI(v,normal,mPos)\
		v.vertSH.rgb = ShadeSH9 (float4(normal.xyz,1.0));\
		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);\
		float3 lightColor = _LightColor0.rgb;\
		fixed3 diff = max (0, dot (normal.xyz,lightDirection)) * lightColor;\
		v.vertSH.rgb += diff.rgb;\
		float4 SHWorldPos = mul(unity_ObjectToWorld,mPos);\
		v.vertSH.rgb += Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,\
                unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,\
                unity_4LightAtten0, SHWorldPos, normal.xyz);\

	#define GT_BLEND_VERTEX_GI(color,i)\
			color.rgb *= i.vertSH;

	#define VERTEX_GI_COORDS(idx) float3 vertSH : TEXCOORD##idx;
#else 
	#define GT_VERTEX_GI(v,normal,mPos) 
	#define GT_BLEND_VERTEX_GI(color,i) 
	#define VERTEX_GI_COORDS(idx)
#endif

// modified	HSV(Hue,Saturation/Value)
#if defined(GTColorGradation)

	uniform float4 _ColorGradationParams;

	half3 RGBtoHSV(half3 arg1)
	{
	    half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	    half4 P = lerp(half4(arg1.bg, K.wz), half4(arg1.gb, K.xy), step(arg1.b, arg1.g));
	    half4 Q = lerp(half4(P.xyw, arg1.r), half4(arg1.r, P.yzx), step(P.x, arg1.r));
	    half D = Q.x - min(Q.w, Q.y);
	    half E = 1e-10;
	    return half3(abs(Q.z + (Q.w - Q.y) / (6.0 * D + E)), D / (Q.x + E), Q.x);
	}
	
	half3 HSVtoRGB(half3 arg1)
	{
	    half4 K = half4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	    half3 P = abs(frac(arg1.xxx + K.xyz) * 6.0 - K.www);
	    return arg1.z * lerp(K.xxx, saturate(P - K.xxx), arg1.y);
	}

	float3 HSVProcess(float3 col, float3 hsvColor)
	{
	    float3 colorHSV;
	    colorHSV.xyz = RGBtoHSV(col.xyz);
	    colorHSV.x +=  359 * hsvColor.r;
	    colorHSV.x = colorHSV.x % 360;
	    colorHSV.y += hsvColor.g * 3.0;
	    colorHSV.z += hsvColor.b * 3.0;
		return HSVtoRGB(colorHSV.xyz);
	}

	#define GT_COLOR_GRADATION(col)\
	 col.rgb = HSVProcess(col,_ColorGradationParams.xyz);
#else
	#define GT_COLOR_GRADATION(col) 
#endif


#endif


