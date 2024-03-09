/*
	Lightmap or per-vertex/SH
	supports unity fog, vertical fog,GPUInstancing
*/
Shader "Game/Unity/Mobile/Mobile-Diffuse" {

	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque"  "LightMode" = "ForwardBase"}
		LOD 100

		Pass
		{
			Name "Mobile-Diffuse"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma shader_feature _ UseVerticalFog
            #pragma shader_feature _ GTCloudShadow
            #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON LIGHTMAP_INS
            #pragma skip_variants FOG_EXP FOG_EXP2


		  #include "../../Common/Lod_Macro.cginc"
		  #include "../../Common/GTCommon.cginc"

		  struct appdata
		  {
			  float4 vertex : POSITION;
			  float3 normal : NORMAL;
			  float2 uv : TEXCOORD0;
			  float2 uv1 : TEXCOORD1;
			  UNITY_VERTEX_INPUT_INSTANCE_ID
		  };

		  struct v2f
		  {
			  float4 vertex : SV_POSITION;
			  float3 normalDir : TEXCOORD0;
			  float4 uv : TEXCOORD1;
			  UNITY_FOG_COORDS(2)
			  VERTEX_GI_COORDS(3)
		  #if USE_WORLDPOS
			  float3 worldPos : TEXCOORD4;
		  #endif
  #if  defined(VexPointLight)
				  float3 pointLight : TEXCOORD5;
  #endif
				  UNITY_VERTEX_INPUT_INSTANCE_ID
			  };

			  sampler2D _MainTex;
			  float4 _MainTex_ST;
			  uniform float4 _GlobalMultiCol;
  #if LIGHTMAP_INS
			  UNITY_INSTANCING_BUFFER_START(Props)
			  UNITY_DEFINE_INSTANCED_PROP(fixed4,_LightmapST)
			  UNITY_INSTANCING_BUFFER_END(Props)
  #endif
			  v2f vert(appdata v)
			  {
				  v2f o;
				  UNITY_INITIALIZE_OUTPUT(v2f, o);
				  UNITY_SETUP_INSTANCE_ID(v);
				  UNITY_TRANSFER_INSTANCE_ID(v, o);
				  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				  o.vertex = UnityObjectToClipPos(v.vertex);
				  o.normalDir.xyz = UnityObjectToWorldNormal(v.normal);
				  o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
			  #if LIGHTMAP_ON
				  o.uv.zw = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			  #elif LIGHTMAP_INS
				  fixed4 lightmapUvOffset = UNITY_ACCESS_INSTANCED_PROP(Props, _LightmapST);
				  o.uv.zw = v.uv1.xy * lightmapUvOffset.xy + lightmapUvOffset.zw;
			  #endif
			  #if USE_WORLDPOS
				  o.worldPos.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
			  #endif
	#if defined(VexPointLight)
				  o.pointLight.xyz = PointLightColor(o.normalDir.xyz, o.worldPos.xyz);
	#endif
	#ifdef VERTEXGI
				  GT_VERTEX_GI(o,o.normalDir,v.vertex);
	#endif
				  UNITY_TRANSFER_FOG(o,o.vertex);
				  return o;
			  }

			  fixed4 frag(v2f i) : SV_Target
			  {
				  UNITY_SETUP_INSTANCE_ID(i);
			  //albedo
			  fixed4 albedo = tex2D(_MainTex, i.uv);
			  fixed4 col = albedo;
  #if  SHADER_LOD_LEVEL < 2
			  //deffuse
			  i.normalDir.xyz = normalize(i.normalDir.xyz);
			  //lightmap
			  CalculateLighMap(col,i.uv.zw);
	#ifdef VERTEXGI
			  GT_BLEND_VERTEX_GI(col,i);
	#endif
			  GetCloudShadow(col, i);
			  CalculateBakeShadow(col, i);
			  CalculateShadowMap(col, i);
  #endif

  #if defined(VexPointLight)//
				  col.xyz += i.pointLight.xyz;
  #elif defined(FragPointLight)//
				  col.xyz += PointLightColor(i.normalDir.xyz, i.worldPos.xyz);
  #endif
				  BlendGlobalColor(col);

				  GT_COLOR_GRADATION(col);
				  // apply fog
				  UNITY_APPLY_FOG(i.fogCoord, col);
  #if UseVerticalFog
				  CalculateVerticalFog(col, i.worldPos.y);
  #endif

				  return col;
			  }
			  ENDCG
		  }
		//     UsePass "Game/CommonDepthPass/Depth"
	}
		Fallback "Game/Base/ShadowCaster"
}
