/*
    +
*/
Shader "Game/TA/PlanarReflection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} //a
        [HDR]_FresnelColor("FresnelColor",Color)=(1,1,1,1) //
        _LightVector("LightVector(xyz for lightDir)",vector)=(.5,.5,-0.25,50000)//
        [Space(20)]
        _ParallaxTex ("ParallaxTex", 2D) = "black" {} //
        [HDR]_ParallaxColor("ParallaxColor",Color)=(1,1,1,1) //
        _ParallaxIntensity("ParallaxIntensity",Range(-1,1))=0.35 //
        [Space(20)]
        [HDR]_ReflectColor("ReflectColor",Color)=(1,1,1,1) //
        _RefOffset("RefOffset",vector)=(0,0,1,1)//
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
             #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            //
            //#pragma multi_compile_instancing
            #pragma multi_compile __ UsePlaneReflection
            #include "UnityCG.cginc"
            #include "UnityStandardBRDF.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
                half3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uv : TEXCOORD0;
                float4 normal:TEXCOORD1;
                float3 viewDir:TEXCOORD2;
            #if UsePlaneReflection
                float4 uv2 : TEXCOORD3;
            #else
                float2 uv2 : TEXCOORD3;
            #endif
                UNITY_FOG_COORDS(4)
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            uniform sampler2D _MainTex;
            uniform fixed4 _MainTex_ST;
            uniform sampler2D _ParallaxTex;
            uniform fixed4 _ParallaxTex_ST;

            uniform float4 _FresnelColor;
            uniform float4 _ParallaxColor;
            uniform float4 _LightVector;
            uniform fixed _ParallaxIntensity;

         #if UsePlaneReflection
            uniform sampler2D _PlaneReflection;
            uniform fixed4 _RefOffset;
            uniform float4 _ReflectColor;
         #endif

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal.xyz = UnityObjectToWorldNormal(v.normal);
                o.viewDir.xyz = WorldSpaceViewDir(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv.xy,_MainTex);
                o.uv.zw = v.uv2.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                o.uv2.xy = TRANSFORM_TEX(v.uv3.xy,_ParallaxTex);
            #if UsePlaneReflection
                float4 sceneUVs = ComputeScreenPos (o.vertex);
                o.uv2.zw = ((sceneUVs.xy ));
                o.normal.w = sceneUVs.w;
            #endif
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                fixed4 baseColor = tex2D(_MainTex, i.uv.xy);
                fixed4 col = baseColor;
                float3 worldNormal = normalize(i.normal.xyz);
                float3 viewDirection = normalize(i.viewDir);
                float3 lightDirection = normalize(_LightVector.xyz);
                //diffuse
                float nl = dot(worldNormal.xyz, lightDirection.xyz);
                half halfLambert = nl * 0.5 + 0.5;
                col.rgb *= halfLambert;
                //lightmap
                float3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv.zw));
                col.rgb *= lm;
                //fresnel
                float nv = max(0, dot(worldNormal,viewDirection));
                float fresnel = (1-nv) * halfLambert;
                col.rgb += saturate(fresnel * fresnel *fresnel * fresnel) * _FresnelColor;
                // parallax spec
                fixed parallaxMask = baseColor.a;
                fixed parallaxOffset = -i.viewDir.z * _ParallaxIntensity;
                float3 parallaxColor = tex2D(_ParallaxTex,i.uv2.xy + parallaxOffset).rgb * _ParallaxColor.rgb * saturate(1 - parallaxMask + _ParallaxColor.a);
                col.rgb += parallaxColor;
                //planar reflection
           #if UsePlaneReflection
                float4 sceneColor = tex2D(_PlaneReflection, (i.uv2.zw/i.normal.w + _RefOffset.x) * _RefOffset.zw);
                col.rgb += sceneColor.rgb * fresnel * _ReflectColor;
           #endif
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
