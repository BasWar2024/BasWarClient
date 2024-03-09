
Shader "Game/TA/Water/Water"
{

	Properties {
     _WaterColor("WaterColor",Color) = (0,0.25,0.4,1)//
     _FarColor("FarColor",Color)=(0.2,1,1,0.3)//
     _EdgeColor("EdgeColor",Color)=(1,1,1,0.75)//
      _EdgeMap("EdgeMap", 2D) = "white" {}//y
     _EdgeStrength("EdgeStrength",Range(0,10))=0.5//
     _BumpMap("BumpMap", 2D) = "white" {}//

     _StaticRefMap("",2D) = "white" {}//
     _StaticRefStrength("",Range(0,2)) = 0//
     _StaticRefWave("",Range(0,2)) = 0.02//

     _HightLightMask("HightLightMask", 2D) = "white" {}//
     _BumpPower("BumpPower",Range(0.01,10))=0.42//
     _WaveSize("WaveSize",Range(0.01,1))=0.048//
     _WaveOffset("WaveOffset(xy&zw)",vector)=(0.02,0.02,0,-0.1)//
     _Fresnel("Fresnel",Range(0,10))=1//
     _Reflect("Reflect",Range(0,2))=0//
     _ReflectWave("ReflectWave",Range(0,2))= 0.02//
     _RefOffset("RefOffset",vector)=(0,0,1,1)//
    [HDR]_LightColor("LightColor",Color)=(1,1,1,1)//
     _LightVector("LightVector(xyz for lightDir,w for power)",vector)=(0.5,0.5,-0.25,50000)//
     [Toggle(UseRefraction)] UseRefraction("UseRefraction", Float) = 0
	}
		SubShader{
				Tags{ "RenderType" = "Opaque" "Queue" = "Transparent" "LightMode" = "ForwardBase"}
				Blend SrcAlpha OneMinusSrcAlpha
				LOD 200

		Pass{
		    CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag
            #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
            #pragma multi_compile __ UseRefraction  //
            #pragma multi_compile_fog
            #pragma skip_variants FOG_EXP FOG_EXP2

            #include "UnityCG.cginc"
            #include "../../Common/Lod_Macro.cginc"

        fixed4 _WaterColor;
        fixed4 _FarColor;

    	sampler2D _BumpMap;
    	half _BumpPower;

        sampler2D _EdgeMap;
        uniform float4 _EdgeMap_ST;

    #if  SHADER_LOD_LEVEL < 2
        sampler2D _HightLightMask;
        uniform float4 _HightLightMask_ST;
    #endif
        uniform sampler2D _StaticRefMap;
        uniform float4 _StaticRefMap_ST;
        float _StaticRefStrength, _StaticRefWave;

    	half _WaveSize;
        half4 _WaveOffset;
        float _Fresnel;
        fixed4 _EdgeColor;
        fixed4 _LightColor;
        half4 _LightVector;
        float _EdgeStrength;
        uniform fixed4 _GlobalMultiCol;

     #if  defined(UseRefraction)
        uniform sampler2D _GTGrabAfterForwardOpaque;
        float _Reflect,_ReflectWave;
        float4 _RefOffset;
     #endif
		struct a2v {
			float4 vertex:POSITION;
            float4 texcoord : TEXCOORD0;
			half3 normal : NORMAL;
            float4 tangent :TANGENT;
            float2 texcoord2 : TEXCOORD1;

#if  SHADER_LOD_LEVEL<2
#endif
		};

		struct v2f
		{
			half4 pos : POSITION;
            half4 uv:TEXCOORD0;
			half3 normal:TEXCOORD1;
        #if  SHADER_LOD_LEVEL<2
            half4 waveUV : TEXCOORD2;
            half4 worldPos:TEXCOORD3;
            float3 tangentDir : TEXCOORD5;
            float3 bitangentDir : TEXCOORD6;
        #endif
            half4 uv2:TEXCOORD7;
            half4 projPos:TEXCOORD4;
            UNITY_FOG_COORDS(8)
		};

		half2 fract(half2 val)
		{
			return val - floor(val);
		}

		v2f vert(a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
            float4 wPos = mul(unity_ObjectToWorld,v.vertex);
            o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _EdgeMap);
        #if  SHADER_LOD_LEVEL==0
            o.uv.zw = TRANSFORM_TEX(v.texcoord.zw, _HightLightMask);
        #endif
         o.normal.xyz = UnityObjectToWorldNormal(v.normal);
        #if  SHADER_LOD_LEVEL<2
            o.waveUV.xy = wPos.xz * _WaveSize + _WaveOffset.xy * _Time.y;
            o.waveUV.zw = wPos.xz * _WaveSize + _WaveOffset.zw * _Time.y;
            o.worldPos = mul(unity_ObjectToWorld, v.vertex);
            o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
            o.bitangentDir = normalize(cross(o.normal, o.tangentDir) * v.tangent.w);
        #endif
            o.uv2.xy = TRANSFORM_TEX(v.texcoord2.xy, _StaticRefMap);

        #if  defined(UseRefraction)
            o.projPos = ComputeScreenPos (o.pos);
        #endif
            UNITY_TRANSFER_FOG(o, o.pos);
			return o;
		}


		fixed4 frag(v2f i):COLOR {
			//
            fixed4 col =_WaterColor;

            //
            float edge = tex2D(_EdgeMap,i.uv.xy).r;
            //
        #if  SHADER_LOD_LEVEL>1 //
            half3  nor = normalize(i.normal);
            col = _FarColor*0.4+_WaterColor*0.6;
        #else
            float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normal);
            float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
            half3 nor = UnpackNormal((tex2D(_BumpMap,(i.waveUV.xy)) + tex2D(_BumpMap,(i.waveUV.zw * 1.2)))*0.5);
          //  nor = normalize(i.normal + nor.xyz * half3(1,1,0)* _BumpPower);
            nor.xy *= _BumpPower;
            nor = normalize(mul(nor, tangentTransform));

               //
            half fresnel = dot(nor,normalize(viewDir));
            fresnel = saturate(fresnel*_Fresnel);
            fresnel = 1-fresnel;
            col = lerp(col,_FarColor,fresnel);


        #endif
            //()
            float4 texRef = tex2D(_StaticRefMap, i.uv2.xy + nor.xz * _StaticRefWave);
            texRef.rgb *= _StaticRefStrength;
            col.rgb += texRef.rgb;
            //
            col.rgb = saturate(col.rgb+(1-edge)*_EdgeColor.rgb*_EdgeStrength);
            //
            col.a = lerp(_EdgeColor.a,col.a,edge);
            edge = saturate((_EdgeColor.a - 1) * 3 * (1 - edge) + (edge));
            //
    #if defined(UseRefraction)
            #if SHADER_LOD_LEVEL<2
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                sceneUVs.xy = (sceneUVs.xy+_RefOffset.xy)*_RefOffset.zw;
                float4 sceneColor = tex2D(_GTGrabAfterForwardOpaque, sceneUVs.xy+nor.xz*_ReflectWave);
                float3 refColor = sceneColor.rgb*_Reflect;
                col.rgb += refColor;//*(fresnel);
                col.rgb = lerp(refColor.rgb,col.rgb,edge);
                col.a = 1;
             #else
                col.a = 0.5;
             #endif
    #endif


    #if SHADER_LOD_LEVEL < 2
            //
            half specmask = tex2D(_HightLightMask,fract(i.uv.zw)).r;
            half spec = max(0,dot(nor,normalize(normalize(_LightVector.xyz) + normalize(viewDir))));
            spec = saturate(pow(spec,_LightVector.w));
            col.rgb = col.rgb + spec * _LightColor * specmask;
    #endif
            col.rgb *= _GlobalMultiCol.rgb;
            UNITY_APPLY_FOG(i.fogCoord, col);
            return col;
}
		ENDCG
	}
	}
	FallBack OFF
}