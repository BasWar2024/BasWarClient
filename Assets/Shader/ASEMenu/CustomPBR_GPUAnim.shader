Shader /*ase_name*/ "Hidden/Universal/CustomPBR_GPUAnim" /*end*/
{
	Properties
	{
		[NoScaleOffset] _AnimTex ("Animation Texture", 2D) = "white" { }
		[HideInInspector]_AnimFrameInCome ("AnimFrameInCome", Int) = 0
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
		Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		
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

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"


			//""
			float4 _AnimTex_TexelSize;
			TEXTURE2D(_AnimTex);    SAMPLER(sampler_AnimTex);
			UNITY_INSTANCING_BUFFER_START(Props)
			// UNITY_DEFINE_INSTANCED_PROP(half4, _CustomEmissionColor)
			// #define _CustomEmissionColor_arr Props
			// UNITY_DEFINE_INSTANCED_PROP(half4, _CampColor)
			// #define _CampColor_arr Props
			UNITY_DEFINE_INSTANCED_PROP(int, _AnimFrameInCome)
			#define _AnimFrameInCome_arr Props
			UNITY_INSTANCING_BUFFER_END(Props)

			/*ase_pragma*/

			/*ase_globals*/

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				half4 textcoord2 : TEXCOORD2;
				float4 textcoord3 : TEXCOORD3;
				//""
				/*ase_vdata:p=p;n=n;t=t;uv0=tc0.xy;uv1=tc1.xy;uv2=tc2.xyzw;uv3=tc3.xyzw;*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;

				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;

				/*ase_interp(7,):sp=sp;sc=tc2;wn.xyz=tc3.xyz;wt.xyz=tc4.xyz;wbt.xyz=tc5.xyz;wp.x=tc3.w;wp.y=tc4.w;wp.z=tc5.w;spu=tc6*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			#include "Assets/Shader/URP_Shader/Common/GPUAnimation.hlsl"
			/*ase_funcs*/
			
			VertexOutput vert(VertexInput v /*ase_vert_input*/)
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				/*ase_vert_code:v=VertexInput;o=VertexOutput*/


				GpuAnimationVertexInputs vertexInput = DecerAnimation(v.vertex, v.ase_normal, v.textcoord2, v.textcoord3);
				VertexNormalInputs normalInput = GetVertexNormalInputs(vertexInput.normalOS.xyz, v.ase_tangent);

				o.tSpace0 = float4(normalInput.normalWS, vertexInput.positionWS.x);
				o.tSpace1 = float4(normalInput.tangentWS, vertexInput.positionWS.y);
				o.tSpace2 = float4(normalInput.bitangentWS, vertexInput.positionWS.z);

				// OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				// OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);

				half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);
				
				o.fogFactorAndVertexLight = half4(0, vertexLight);
				
				o.clipPos = vertexInput.positionCS;
				return o;
				return o;
			}

			half4 UniversalFragmentPBRLit(InputData inputData, half3 albedo, half metallic, half3 specular, half smoothness, half occlusion, half3 emission, half alpha)
			{
				BRDFData brdfData;//brdf
				InitializeBRDFData(albedo, metallic, specular, smoothness, alpha, brdfData);
				//"" ""
				Light mainLight = GetMainLight(inputData.shadowCoord);

				half3 color = GlobalIllumination(brdfData, inputData.bakedGI, occlusion, inputData.normalWS, inputData.viewDirectionWS);
				//"" ""
				color += LightingPhysicallyBased(brdfData, mainLight, inputData.normalWS, inputData.viewDirectionWS);

				//""
				#ifdef _ADDITIONAL_LIGHTS
					uint pixelLightCount = GetAdditionalLightsCount();
					for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
					{
						Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
						color += LightingPhysicallyBased(brdfData, light, inputData.normalWS, inputData.viewDirectionWS);
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

				#ifdef _REFRACTION_ASE
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = (RefractionIndex - 1.0) * mul(UNITY_MATRIX_V, WorldNormal).xyz * (1.0 / (ScreenPos.z + 1.0)) * (1.0 - dot(WorldNormal, WorldViewDirection));
					float2 cameraRefraction = float2(refractionOffset.x, - (refractionOffset.y * _ProjectionParams.x));
					projScreenPos.xy += cameraRefraction;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR(projScreenPos) * RefractionColor;
					color.rgb = lerp(refraction, color.rgb, color.a);
					color.a = 1;
				#endif

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
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

			float4 _AnimTex_TexelSize;
			float3 _LightDirection;

			TEXTURE2D(_AnimTex);    SAMPLER(sampler_AnimTex);
			//""
			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_DEFINE_INSTANCED_PROP(int, _AnimFrameInCome)
			#define _AnimFrameInCome_arr Props
			UNITY_INSTANCING_BUFFER_END(Props)

			struct Attributes
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float2 texcoord : TEXCOORD0;

				half4 boneIndex : TEXCOORD2;
				float4 boneWeight : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
				float2 uv : TEXCOORD0;
				float4 positionCS : SV_POSITION;
			};

			//"" ""
			#include "Assets/Shader/URP_Shader/Common/GPUAnimation.hlsl"

			//"" ""shadowmap
			float4 GetShadowPositionHClip(Attributes input)
			{
				GpuAnimationVertexInputs vertexInput = DecerAnimation(input.positionOS, input.normalOS, input.boneIndex, input.boneWeight);
				float3 normalWS = TransformObjectToWorldNormal(input.normalOS);
				float4 positionCS = TransformWorldToHClip(ApplyShadowBias(vertexInput.positionWS, normalWS, _LightDirection));
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
				output.uv = input.texcoord;
				output.positionCS = GetShadowPositionHClip(input);
				return output;
			}

			half4 ShadowPassFragment(Varyings input) : SV_TARGET
			{
				//"" ""
				return 0;
			}
			ENDHLSL

		}
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	FallBack "Hidden/InternalErrorShader"
}
