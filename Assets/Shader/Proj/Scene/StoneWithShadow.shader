// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Game/TA/Water/StoneWithShadow"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _LightMap ("LightMap Tex", 2D) = "white" {}

        [Header((DayNight))][Toggle(_DayNight)] _DayNight("_DayNight", Float) = 1
        [Space(20)]

        // Common
        [PowerSlider(3.0)] _Shininess ("Shininess", Range (0, 10)) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend Mode", Float) = 10
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
        _ColorMask("ColorMask", Float) = 15
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4
         //
        [Space(20)]
        _ShadowTex ("ShadowTex", 2D) = "white" {}
        _ShadowColor ("ShadowColor", Color) = (0, 0, 0, 1)
        _LightDir("LightDir",Vector)=(0.56,0.61,0.49,-3.85)
        _ShadowFalloff("ShadowFalloff", Float) = 0
        //
         [Space(20)]
       //  [Toggle(_Wave)] _Wave("ShowWave", Float) = 0
        _WaveTex ("WaveTex", 2D) = "black" {}
        _WaveSize("WaveSize",Range(0.01,1))=0.274//
        _WaveOffset("WaveOffset(xy&zw)",vector)=(0,0,-0.2,0.5)//
        [HDR]_WaveColor ("WaveTexColor", Color) = (1,1,1,1)
        _WaveHeight ("WaveHeight", Float) = -3.02
        _WaveArea ("WaveArea", Range(0.001, 100)) = 2
    }

    SubShader
    {
        LOD 200
        Tags { "RenderType" = "Opaque" }
        Pass
        {
            Name "BASE"
            Tags{ "Queue" = "Background+500" "RenderType" = "Opaque" "LightMode" = "ForwardBase" }
            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            ZTest [_ZTest]
            ColorMask [_ColorMask]
            CGPROGRAM

            #pragma vertex vert_tex_base
            #pragma fragment frag_tex_base
            #pragma multi_compile_instancing
            #pragma multi_compile NO_SKIN ROOTOFF_BLENDOFF_KEEPUV2 ROOTOFF_BLENDOFF
            #pragma shader_feature _ _DayNight

            #define FOG_LINEAR
            #define _Wave 1

            #include "UnityCG.cginc"
            #include "Assets/Shader/Common/GPUSkinningInclude.cginc"
            #include "Assets/Shader/Common/GTCommon.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
#if USE_SKIN
                float4 uv3 : TEXCOORD2;
#endif
#if SKIN_KEEP_UV2
                float4 uv4 : TEXCOORD3;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                //SHADOW_COORDS(4)
                UNITY_FOG_COORDS(5)

           #if _Wave
                float3 posWorld:TEXCOORD2;
           #endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


            uniform sampler2D _MainTex;
            uniform fixed4 _MainTex_ST;
            uniform sampler2D _LightMap;
            uniform fixed4 _LightMap_ST;

       #if _Wave
            uniform sampler2D _WaveTex;
            half _WaveSize,_WaveArea,_WaveHeight;
            half4 _WaveOffset,_WaveColor;
       #endif
            //uniform fixed4 _Color;
            uniform fixed _Shininess;
        #if _DayNight
            uniform fixed4 _GlobalMultiCol;
        #endif

            UNITY_INSTANCING_BUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert_tex_base (appdata v)
            {
                v2f o;

                UNITY_INITIALIZE_OUTPUT(v2f, o);

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
#if SKIN_KEEP_UV2
                v.vertex = skin2(v.vertex, v.uv4, v.uv3);
#elif USE_SKIN
                v.vertex = skin2(v.vertex, v.uv2, v.uv3);
#endif
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord0.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
                o.texcoord1 = TRANSFORM_TEX(v.uv2, _LightMap);

            #if _Wave
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.texcoord0.zw = o.posWorld.xz * _WaveSize + _WaveOffset.zw * _Time.y;
            #endif
                //TRANSFER_SHADOW(o);
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            fixed4 frag_tex_base (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);

                fixed4 col = tex2D(_MainTex, i.texcoord0.xy) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);

                col.rgb *= DecodeLightmap(tex2D(_LightMap, i.texcoord1));
                col *= _Shininess;
            #if _Wave
               float2 waveUV = i.texcoord0.zw+(col.rg-0.5)*_WaveOffset.xy;
               float3 waveColor = tex2D(_WaveTex,waveUV).rgb*_WaveColor;
               float waveField =(1-saturate(abs((i.posWorld.g-_WaveHeight)/_WaveArea)));
                col.rgb += waveColor*waveField;
            #endif
            #if _DayNight
                BlendGlobalColor(col)
            #endif

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }

            ENDCG
        }

       //pass
        Pass
        {
        	Name "Shadow"
        	Stencil
        	{
        		Ref 0
        		Comp equal
        		Pass incrWrap
        		Fail keep
        		ZFail keep
        	}
        	Blend SrcAlpha OneMinusSrcAlpha
        	//ZWrite off
        	CGPROGRAM
        	#pragma vertex vert
        	#pragma fragment frag

            #pragma multi_compile_instancing
            #pragma multi_compile NO_SKIN  ROOTOFF_BLENDOFF_KEEPUV2
            #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW

            #include "UnityCG.cginc"
            #include "Assets/Shader/Common/Lod_Macro.cginc"
            #include "Assets/Shader/Common/GPUSkinningInclude.cginc"

        	struct appdata
        	{
        	    float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
#if USE_SKIN
                float4 uv3 : TEXCOORD2;
#endif
#if SKIN_KEEP_UV2
                float4 uv4 : TEXCOORD3;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
        	};
        	struct v2f
        	{
        	    float4 pos : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                UNITY_FOG_COORDS(5)
                UNITY_VERTEX_INPUT_INSTANCE_ID
        	};

        	float4 _LightDir;
        	float4 _ShadowColor;
        	float _ShadowFalloff;
            uniform sampler2D _ShadowTex;
            uniform fixed4 _ShadowTex_ST;

        	float3 ShadowProjectPos(float4 vertPos)
        	{
        		float3 shadowPos;
        		float3 worldPos = mul(unity_ObjectToWorld , vertPos).xyz;
        		float3 lightDir = normalize(_LightDir.xyz);
        		shadowPos.y = min(worldPos .y , _LightDir.w);
        		shadowPos.xz = worldPos .xz - lightDir.xz * max(0 , worldPos .y - _LightDir.w) / lightDir.y;

        		return shadowPos;
        	}

        	v2f vert (appdata v)
        	{
        		v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
#if SKIN_KEEP_UV2
                v.vertex = skin2(v.vertex, v.uv4, v.uv3);
#elif USE_SKIN
                v.vertex = skin2(v.vertex, v.uv2, v.uv3);
#endif
        		float3 shadowPos = ShadowProjectPos(v.vertex);
        		o.pos = UnityWorldToClipPos(shadowPos);
        		float3 center = float3( unity_ObjectToWorld[0].w , _LightDir.w , unity_ObjectToWorld[2].w);
        		float falloff = 1-saturate(distance(shadowPos , center) * _ShadowFalloff);
                o.texcoord0 = TRANSFORM_TEX(v.uv, _ShadowTex);
                return o;
        	}

        	fixed4 frag (v2f i) : SV_Target
        	{
                UNITY_SETUP_INSTANCE_ID(i);
             #if  SHADER_LOD_LEVEL>1
                fixed4 col = float4(0,0,0,0.4) ;
             #else
                fixed4 col = tex2D(_ShadowTex, i.texcoord0.xy) * _ShadowColor ;
             #endif

                return col;
        	}
        	ENDCG
        }
    }

}
