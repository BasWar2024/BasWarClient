Shader "Game/TA/Vertex-Wave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _XDirection("XDirection,speed", Vector) = (0,0.01,0,5)
        _YDirection("YDirection,scale", Vector) = (-0.1,0.1,0.1,1)
        _Frequency("Frequency X,Y", Vector) = (100,100,0,0)
     //   _Grey("Grey", float) = 0
        _GreyColor("GreyColor", Color) = (1,1,1,1)
        _NormalDeviation("NormalDeviation",Range(0.001,5)) = 0.1
        [Toggle(FORW)] FORW("", Float) = 1
        [HDR]_LightColor("LightColor",Color) = (0.1,0.1,0.1,1)//
        _LightVector("LightVector(xyz for lightDir,w for power)",vector) = (0.5,0.5,-0.25,40)//
        [Toggle(UseNormal)] UseNormal("UseNormal", Float) = 0
         _UseWind("",Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
        LOD 100
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma shader_feature _ UseNormal
            #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
            #pragma skip_variants FOG_EXP FOG_EXP2

            #include "../../Common/Lod_Macro.cginc"
            #include "../../Common/GTCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            #if LIGHTMAP_ON
                float2 uv2 : TEXCOORD1;
            #endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
            #if LIGHTMAP_ON
                float4 uv : TEXCOORD0;
            #else
                float2 uv : TEXCOORD0;
            #endif
                float4 vertex : SV_POSITION;
            #if UseNormal &&  SHADER_LOD_LEVEL < 2
                float3 normalDir : TEXCOORD1;
                float3 posWorld : TEXCOORD2;
            #endif
                UNITY_FOG_COORDS(3)
                VERTEX_GI_COORDS(4)

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            uniform sampler2D _MainTex;
            uniform float _GlobalWind, _UseWind;
            uniform float4 _XDirection, _YDirection;
            uniform float4 _GlobalMultiCol;
            uniform float4 _GreyColor;
            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(fixed4, _MainTex_ST)
            UNITY_DEFINE_INSTANCED_PROP(fixed4, _InstanceProp0)
            UNITY_INSTANCING_BUFFER_END(Props)

    #if UseNormal &&  SHADER_LOD_LEVEL < 2
            uniform float4 _LightVector, _LightColor;
    #endif
            uniform float   _NormalDeviation,FORW;
            uniform float4 _Frequency;

            inline float3 GetWaveOffset(float3 vertex,float4 color)
            {
                float frequency = _Time.y * _XDirection.w;
                frequency = lerp(frequency, frequency * _GlobalWind, _UseWind);
                //-1,10.5
                float2 offset = (sin(frequency + vertex.xy * _Frequency.xy) + FORW) *  lerp(1,0.5, FORW) * color.r;
                float3 reualt = (offset.x * _XDirection.xyz + offset.y * _YDirection.xyz) * _YDirection.w ;
                return reualt;
            }
            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                //
                float3 v0 = v.vertex.xyz + GetWaveOffset(v.vertex.xyz + worldPos.x , v.color);
#if UseNormal &&  SHADER_LOD_LEVEL < 2
                //
                float3 newX = v.vertex.xyz + float3(_NormalDeviation, 0, 0);
                float3 newZ = v.vertex.xyz + float3(0, 0, _NormalDeviation);
                float3 v1 = newX + GetWaveOffset(newX + worldPos.x, v.color);
                float3 v2 = newZ + GetWaveOffset(newZ + worldPos.x, v.color);
                float3 newNormal = normalize(cross(normalize(v2-v0), normalize(v1-v0)));
                o.normalDir.xyz = UnityObjectToWorldNormal(newNormal);
                v.vertex.xyz = v0.xyz;
                o.posWorld.xyz = worldPos;
#else
                v.vertex.xyz = v0.xyz;
#endif

                o.vertex = UnityObjectToClipPos(v.vertex);
                float4 tileoffset = UNITY_ACCESS_INSTANCED_PROP(Props, _MainTex_ST);
                o.uv.xy =  v.uv.xy * tileoffset.xy + tileoffset.zw;

            #if LIGHTMAP_ON
                o.uv.zw = v.uv2.xy * unity_LightmapST.xy + unity_LightmapST.zw;
            #endif
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                fixed4 col = tex2D(_MainTex, i.uv);

#if UseNormal &&  SHADER_LOD_LEVEL < 2
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDir = normalize(i.normalDir.xyz);
                //deffuse
                float3 lightDirection = normalize(_LightVector.xyz);
                float3 lightColor = _LightColor.rgb;
                fixed3 diff = max(0, dot(normalDir.xyz, lightDirection)) + 0.2;
                col.rgb *= diff.rgb;

                half spec = max(0, dot(normalDir, normalize(normalize(lightDirection.xyz) + viewDirection)));
                spec = saturate(pow(spec, _LightVector.w));
                col.rgb = col.rgb + spec * _LightColor;

                //lightmap
                CalculateLighMap(col, i.uv.zw);
#endif
                BlendGlobalColor(col);
           //     GT_COLOR_GRADATION(col);
                //
                col.rgb = UNITY_ACCESS_INSTANCED_PROP(Props, _InstanceProp0.x) > 0 ? dot( col.rgb, float3(0.2,0.7,0.1)) * _GreyColor : col.rgb;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
