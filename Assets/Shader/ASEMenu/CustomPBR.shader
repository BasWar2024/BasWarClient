Shader /*ase_name*/ "Hidden/Universal/CustomPBR" /*end*/
{
	Properties
	{
		/*ase_props*/
	}

	SubShader
	{
		/*ase_subshader_options:Name=Additional Options
		Option:Workflow:Specular,Metallic:Metallic
		Specular:SetDefine:_SPECULAR_SETUP 1
		Specular:ShowPort:Forward:Specular
		Specular:HidePort:Forward:Metallic
		Metallic:RemoveDefine:_SPECULAR_SETUP 1
		Metallic:ShowPort:Forward:Metallic
		Metallic:HidePort:Forward:Specular
		Option:Surface:Opaque,Transparent:Opaque
		Opaque:SetPropertyOnSubShader:RenderType,Opaque
		Opaque:SetPropertyOnSubShader:RenderQueue,Geometry
		Opaque:SetPropertyOnPass:Forward:ZWrite,On
		Opaque:HideOption:  Refraction Model
		Opaque:HideOption:  Blend
		Transparent:SetPropertyOnSubShader:RenderType,Transparent
		Transparent:SetPropertyOnSubShader:RenderQueue,Transparent
		Transparent:SetPropertyOnPass:Forward:ZWrite,Off
		Transparent:ShowOption:  Refraction Model
		Transparent:ShowOption:  Blend
		Option:  Refraction Model:None,Legacy:None
		None,disable:HidePort:Forward:Refraction Index
		None,disable:HidePort:Forward:Refraction Color
		None,disable:RemoveDefine:_REFRACTION_ASE 1
		None,disable:RemoveDefine:REQUIRE_OPAQUE_TEXTURE 1
		None,disable:RemoveDefine:ASE_NEEDS_FRAG_SCREEN_POSITION
		Legacy:ShowPort:Forward:Refraction Index
		Legacy:ShowPort:Forward:Refraction Color
		Legacy:SetDefine:_REFRACTION_ASE 1
		Legacy:SetDefine:REQUIRE_OPAQUE_TEXTURE 1
		Legacy:SetDefine:ASE_NEEDS_FRAG_SCREEN_POSITION
		Option:  Blend:Alpha,Premultiply,Additive,Multiply:Alpha
		Alpha:SetPropertyOnPass:Forward:BlendRGB,SrcAlpha,OneMinusSrcAlpha
		Premultiply:SetPropertyOnPass:Forward:BlendRGB,One,OneMinusSrcAlpha
		Additive:SetPropertyOnPass:Forward:BlendRGB,One,One
		Multiply:SetPropertyOnPass:Forward:BlendRGB,DstColor,Zero
		Alpha,Premultiply,Additive:SetPropertyOnPass:Forward:BlendAlpha,One,OneMinusSrcAlpha
		Multiply:SetPropertyOnPass:Forward:BlendAlpha,One,Zero
		Premultiply:SetDefine:_ALPHAPREMULTIPLY_ON 1
		Alpha,Additive,Multiply,disable:RemoveDefine:_ALPHAPREMULTIPLY_ON 1
		disable:SetPropertyOnPass:Forward:BlendRGB,One,Zero
		disable:SetPropertyOnPass:Forward:BlendAlpha,One,Zero
		Option:Two Sided:On,Cull Back,Cull Front:Cull Back
		On:SetPropertyOnSubShader:CullMode,Off
		Cull Back:SetPropertyOnSubShader:CullMode,Back
		Cull Front:SetPropertyOnSubShader:CullMode,Front
		Option:Cast Shadows:false,true:true
		true:IncludePass:ShadowCaster
		false,disable:ExcludePass:ShadowCaster
		Option:Receive Shadows:false,true:true
		true:RemoveDefine:_RECEIVE_SHADOWS_OFF 1
		false:SetDefine:_RECEIVE_SHADOWS_OFF 1
		Option:GPU Instancing:false,true:true
		true:SetDefine:pragma multi_compile_instancing
		false:RemoveDefine:pragma multi_compile_instancing
		Option:LOD CrossFade:false,true:true
		true:SetDefine:pragma multi_compile _ LOD_FADE_CROSSFADE
		false:RemoveDefine:pragma multi_compile _ LOD_FADE_CROSSFADE
		Port:Forward:Emission
		On:SetDefine:_EMISSION
		Port:Forward:Alpha Clip Threshold
		On:SetDefine:_ALPHATEST_ON 1
		Port:Forward:Normal
		On:SetDefine:_NORMALMAP 1
		*/
		Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "Queue" = "Geometry+0" }
		
		Cull Back
		HLSLINCLUDE
		#pragma target 2.0
		ENDHLSL

		/*ase_pass*/
		Pass
		{
			/*ase_main_pass*/
			Name "Forward"
			Tags { "LightMode" = "UniversalForward" }
			
			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0, 0
			ColorMask RGBA
			/*ase_stencil*/

			HLSLPROGRAM

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#if ASE_SRP_VERSION <= 70108
				#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			/*ase_pragma*/

			/*ase_globals*/

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				/*ase_vdata:p=p;n=n;t=t;uv1=tc1.xyzw*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 screenPos : TEXCOORD6;
				#endif
				/*ase_interp(7,):sp=sp;sc=tc2;wn.xyz=tc3.xyz;wt.xyz=tc4.xyz;wbt.xyz=tc5.xyz;wp.x=tc3.w;wp.y=tc4.w;wp.z=tc5.w;spu=tc6*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			/*ase_funcs*/

			VertexOutput vert(VertexInput v /*ase_vert_input*/)
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				/*ase_vert_code:v=VertexInput;o=VertexOutput*/
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = /*ase_vert_out:Vertex Offset;Float3;8;-1;_Vertex*/defaultVertexValue/*end*/;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = /*ase_vert_out:Vertex Normal;Float3;10;-1;_Normal*/v.ase_normal/*end*/;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float3 positionVS = TransformWorldToView(positionWS);
				float4 positionCS = TransformWorldToHClip(positionWS);

				VertexNormalInputs normalInput = GetVertexNormalInputs(v.ase_normal, v.ase_tangent);

				o.tSpace0 = float4(normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4(normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4(normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);

				half3 vertexLight = VertexLighting(positionWS, normalInput.normalWS);
				
				o.fogFactorAndVertexLight = half4(0, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord(vertexInput);
				#endif
				
				o.clipPos = positionCS;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif
				return o;
			}

			// ""
			half3 HalfLightingPhysicallyBased(BRDFData brdfData, half3 lightColor, half3 lightDirectionWS, half lightAttenuation, half3 normalWS, half3 viewDirectionWS)
			{
				half NdotL = saturate(dot(normalWS, lightDirectionWS) * 0.5 + 0.5);
				half3 radiance = lightColor * (lightAttenuation * NdotL);
				return DirectBDRF(brdfData, normalWS, lightDirectionWS, viewDirectionWS) * radiance;
			}

			half3 MineLightingPhysicallyBased(BRDFData brdfData, Light light, half3 normalWS, half3 viewDirectionWS)
			{
				return HalfLightingPhysicallyBased(brdfData, light.color, light.direction, light.distanceAttenuation * light.shadowAttenuation, normalWS, viewDirectionWS);
			}

			half4 UniversalFragmentPBRLit(InputData inputData, half3 albedo, half metallic, half3 specular, half smoothness, half occlusion, half3 emission, half alpha)
			{
				BRDFData brdfData;//brdf
				InitializeBRDFData(albedo, metallic, specular, smoothness, alpha, brdfData);
				//"" ""
				Light mainLight = GetMainLight(inputData.shadowCoord);

				half3 color = GlobalIllumination(brdfData, inputData.bakedGI, occlusion, inputData.normalWS, inputData.viewDirectionWS);
				//"" ""
				color += MineLightingPhysicallyBased(brdfData, mainLight, inputData.normalWS, inputData.viewDirectionWS);

				//""
				#ifdef _ADDITIONAL_LIGHTS
					uint pixelLightCount = GetAdditionalLightsCount();
					for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
					{
						Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
						color += MineLightingPhysicallyBased(brdfData, light, inputData.normalWS, inputData.viewDirectionWS);
					}
				#endif

				color += emission;
				return half4(color, alpha);
			}

			half4 frag(VertexOutput IN /*ase_frag_input*/) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition(IN.clipPos.xyz, unity_LODFade.x);
				#endif

				/*ase_local_var:wn*/float3 WorldNormal = normalize(IN.tSpace0.xyz);
				/*ase_local_var:wt*/float3 WorldTangent = IN.tSpace1.xyz;
				/*ase_local_var:wbt*/float3 WorldBiTangent = IN.tSpace2.xyz;
				/*ase_local_var:wp*/float3 WorldPosition = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
				/*ase_local_var:wvd*/float3 WorldViewDirection = _WorldSpaceCameraPos.xyz - WorldPosition;
				/*ase_local_var:sc*/float4 ShadowCoords = float4(0, 0, 0, 0);
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					/*ase_local_var:spu*/float4 ScreenPos = IN.screenPos;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord(WorldPosition);
				#endif
				
				#if SHADER_HINT_NICE_QUALITY
					WorldViewDirection = SafeNormalize(WorldViewDirection);
				#endif

				/*ase_frag_code:IN=VertexOutput*/
				float3 Albedo = /*ase_frag_out:Albedo;Float3;0;-1;_Albedo*/float3(0.5, 0.5, 0.5)/*end*/;
				float3 Normal = /*ase_frag_out:Normal;Float3;1*/float3(0, 0, 1)/*end*/;
				float3 Emission = /*ase_frag_out:Emission;Float3;2;-1;_Emission*/0/*end*/;
				float3 Specular = /*ase_frag_out:Specular;Float3;9*/0.5/*end*/;
				float Metallic = /*ase_frag_out:Metallic;Float;3*/0/*end*/;
				float Smoothness = /*ase_frag_out:Smoothness;Float;4*/0.5/*end*/;
				float Occlusion = /*ase_frag_out:Occlusion;Float;5*/1/*end*/;
				float Alpha = /*ase_frag_out:Alpha;Float;6;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;7;-1;_AlphaClip*/0.5/*end*/;
				float3 RefractionColor = /*ase_frag_out:Refraction Color;Float3;12;-1;_RefractionColor*/1/*end*/;
				float RefractionIndex = /*ase_frag_out:Refraction Index;Float;13;-1;_RefractionIndex*/1/*end*/;
				
				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal)));
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldNormal;
					#else
						inputData.normalWS = normalize(WorldNormal);
					#endif
				#endif

				inputData.fogCoord = 0;

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = float3(1, 1, 1);

				half4 color = UniversalFragmentPBRLit(
					inputData,
					Albedo,
					Metallic,
					Specular,
					Smoothness,
					Occlusion,
					Emission,
					Alpha);

				// #ifdef _REFRACTION_ASE
				// 	float4 projScreenPos = ScreenPos / ScreenPos.w;
				// 	float3 refractionOffset = (RefractionIndex - 1.0) * mul(UNITY_MATRIX_V, WorldNormal).xyz * (1.0 / (ScreenPos.z + 1.0)) * (1.0 - dot(WorldNormal, WorldViewDirection));
				// 	float2 cameraRefraction = float2(refractionOffset.x, - (refractionOffset.y * _ProjectionParams.x));
				// 	projScreenPos.xy += cameraRefraction;
				// 	float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR(projScreenPos) * RefractionColor;
				// 	color.rgb = lerp(refraction, color.rgb, color.a);
				// 	color.a = 1;
				// #endif

				return color;
			}

			ENDHLSL

		}
		
		/*ase_pass_end*/

		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On
			ZTest LEqual
			ColorMask 0
			Cull[_Cull]

			HLSLPROGRAM

			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0

			// -------------------------------------
			// Material Keywords
			#pragma shader_feature _ALPHATEST_ON

			//--------------------------------------
			// GPU Instancing
			#pragma multi_compile_instancing

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

			//""pass ""
			CBUFFER_START(UnityPerMaterial)
				float4 _BaseMap_ST;
				half4 _BaseColor;
				half4 _SpecColor;
				half4 _CustomEmissionColor;
				half4 _CampColor;
				half _Cutoff;
				half _Smoothness;
				half _Metallic;
				half _BumpScale;
				half _OcclusionStrength;
				half _Surface;
			CBUFFER_END

			float3 _LightDirection;

			struct Attributes
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
				float2 uv : TEXCOORD0;
				float4 positionCS : SV_POSITION;
			};

			float4 GetShadowPositionHClip(Attributes input)
			{
				float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
				float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

				float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

				#if UNITY_REVERSED_Z
					positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
				#else
					positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
				#endif

				return positionCS;
			}

			Varyings ShadowPassVertex(Attributes input)
			{
				Varyings output;
				UNITY_SETUP_INSTANCE_ID(input);

				output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
				output.positionCS = GetShadowPositionHClip(input);
				return output;
			}

			half4 ShadowPassFragment(Varyings input) : SV_TARGET
			{
				Alpha(SampleAlbedoAlpha(input.uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap)).a, _BaseColor, _Cutoff);
				return 0;
			}
			ENDHLSL

		}
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	FallBack "Hidden/InternalErrorShader"
}
