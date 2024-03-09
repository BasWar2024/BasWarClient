Shader "Game/Proj/ANI/Tree-Vertex-Ani" {
    Properties {
        _Color ("Main Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Texture", 2D) = "white" {}
        //_MaskTex("Mask", 2D) = "black" {}
        //_MaskColor("Mask Color", Color) = (1, 1, 1,1)
       [Toggle(UseSelfLightMap)] UseSelfLightMap("", Float) = 0 //
        _SelfLightmap("", 2D) = "white" {}
        _SelfLightExp("",Float) = 1
      //  [Toggle(_ANION)] _ANION("_ANION", Float) = 0
        _Amplitude("", Float) = 1
        _Direction("Direction", Vector) = (0,0,0,0)
        _Frequency("", Float) = 1
        _BaseLineY("BaseLine Y", Float) = 1
        _Rigidness("",Float) = 1
        _UseWind("",Range(0,1)) = 0
        [Toggle(UseAreaColor)] UseAreaColor("", Float) = 0
        _AreaColorMap("", 2D) = "white" {}
        _AreaColorParams("",Vector) = (0,0,0,0)
        [Toggle(VectorBillBoard)] VectorBillBoard("", Float) = 0
        [Toggle(UseAlphaClip)] UseAlphaClip("", Float) = 0
        _Cutoff("", Range(0,1)) = 0.5
        BakeShadowValue("2D", Range(0,1)) = 1
        [Toggle(Interaction)] Interaction("", Float) = 0
        [Toggle(RecvShadow)] RecvShadow("", Float) = 0
        _InteractionRadio("", Float) = 1
        // Cull
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2.0
    }
    SubShader {
        Tags{
            "RenderType" = "TransparentCutout"
            "LightMode" = "ForwardBase"
            "DisableBatching" = "True"
            "PlanarShadow" = "Game/Proj/TreePlanarShadow"
        }
        Cull[_CullMode]
        Pass {
            CGPROGRAM

            #include "../../Common/GTCommon.cginc"
            #include "../../Common/GTLighting.cginc"
            #include "../../Common/Lod_Macro.cginc"

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile __ SHADER_LOD_MID SHADER_LOD_LOW
            #pragma multi_compile __ UseBakeShadow
            #pragma multi_compile __ UseAlphaClip
            #pragma shader_feature UseAreaColor
            #pragma shader_feature _ GTCloudShadow
            #pragma shader_feature VectorBillBoard
            #pragma shader_feature Interaction
            #pragma shader_feature _ UseShadowMap
            #pragma shader_feature _ UseSelfLightMap
            #pragma shader_feature _ RecvShadow
            #pragma skip_variants FOG_EXP FOG_EXP2

            #define _ANION  1
        #if UseSelfLightMap
            uniform sampler2D _SelfLightmap;
            uniform fixed4 _SelfLightmap_ST;
            float _SelfLightExp;
        #endif
            uniform fixed4 _Color,_GlobalMultiCol;// ,_MaskColor;
            uniform sampler2D _MainTex;
            uniform fixed4 _MainTex_ST;

           /* uniform sampler2D _MaskTex;
            uniform fixed4 _MaskTex_ST;*/

            uniform float4 _GTLightDir;
            uniform float4 _EnvColor;
            uniform float4 _GTLightColor;
        #if UseBakeShadow && !UseSelfLightMap
            float BakeShadowValue;
        #endif
        #if UseAlphaClip
            uniform fixed _Cutoff;
        #endif
        #if _ANION
            uniform float _Amplitude,_Rigidness;
            uniform float4 _Direction;
            uniform float _Frequency;
            uniform float _BaseLineY;
            uniform float _GlobalWind,_UseWind;
            inline float3 CalVertexPosition(float3 pos,float4 wPos)
            {
                float offset = step(_BaseLineY, pos.y) * (pos.y - _BaseLineY);
                float amp = _Amplitude * offset;
                float3 newPos = pos;
                float frequency = _Frequency * _Time.y;
                frequency = lerp(frequency,frequency * _GlobalWind,_UseWind);
                newPos += amp * sin(wPos.zyx * _Rigidness + frequency) * _Direction.xyz ;
                return newPos;
            }
        #endif
#if Interaction
            float4 _GrassInterPos;
            float _InteractionRadio;
#endif
            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;

                #if defined(LIGHTMAP_ON) || defined(UseSelfLightMap)
                    float2 texcoord1 : TEXCOORD1;
                #endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                #if defined(LIGHTMAP_ON) || defined(UseSelfLightMap)
                    float4 texcoord0 : TEXCOORD0;
                #else
                    fixed2 texcoord0 : TEXCOORD0;
                #endif
                    float3 normalDir : TEXCOORD1;
                UNITY_FOG_COORDS(3)
                float3 worldPos :TEXCOORD4;
                VERTEX_GI_COORDS(5)
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                v.vertex.xyz = CalVertexPosition(v.vertex.xyz, wPos);
                o.worldPos = wPos;
#if Interaction
                float dis = distance(_GrassInterPos.xyz, wPos.xyz);
                float3 interOffset = 1 - saturate(dis / _GrassInterPos.w );
                float3 interDir = normalize(wPos.xyz - _GrassInterPos.xyz);
                interDir *= interOffset * _InteractionRadio;
                v.vertex.xyz += interDir * (wPos.y - _BaseLineY);
#endif
                CalculateBillBoard(v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord0.xy = TRANSFORM_TEX(v.texcoord0, _MainTex);
                #if defined(LIGHTMAP_ON)
                    o.texcoord0.zw = v.texcoord1 * unity_LightmapST.xy + unity_LightmapST.zw;
                #elif defined(UseSelfLightMap)
                    o.texcoord0.zw = TRANSFORM_TEX(v.texcoord1, _SelfLightmap) ;
                #endif
                UNITY_TRANSFER_FOG(o, o.pos);
                o.normalDir = mul(v.normal, (float3x3)unity_WorldToObject);
              //  GT_VERTEX_GI(o, o.normalDir, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                fixed4 col = tex2D(_MainTex, i.texcoord0.xy) * _Color;
             //   fixed4 mask = tex2D(_MaskTex, i.texcoord0.xy) * _MaskColor;
                #if UseAlphaClip
                    clip(col.a - _Cutoff);
                #endif

#if  SHADER_LOD_LEVEL < 2
               //deffuse
               i.normalDir.xyz = normalize(i.normalDir.xyz);

#if UseSelfLightMap
               fixed3 slm = DecodeLightmap(tex2D(_SelfLightmap, i.texcoord0.zw)) * _SelfLightExp;
              // fixed3 slm = tex2D(_SelfLightmap, i.texcoord0.zw) * _SelfLightExp;
               col.rgb *= slm.rgb;
#else
               CalculateLighMap(col, i.texcoord0.zw);
#endif
               GetCloudShadow(col, i);
            #if UseBakeShadow && !UseSelfLightMap
               CalculateBakeShadowValue(col, i, BakeShadowValue);
            #endif
            #if defined(UseShadowMap) && defined(RecvShadow)
                   CalculateShadowMap(col, i);
            #endif
#endif
         /*       #if defined(LIGHTMAP_ON)
                    fixed3 lm = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, i.texcoord0.zw));
                    col.rgb *= lm;
                #endif*/
          /*      float3 lightDirection = _GTLightDir;
                float3 normalDirection = i.normalDir;*/
                // half nl = dot(normalDirection, lightDirection) * 0.5 +0.8;

                // col.rgb *= nl;
                // col.rgb += _EnvColor;
                // col.rgb += mask.r*0.5;
                #if defined(UseAreaColor)
                    GetAreaColor(col, i.worldPos);
                #endif


                BlendGlobalColor(col)
                UNITY_APPLY_FOG(i.fogCoord, col);


                return col;
            }

            ENDCG
        }
     //   UsePass "Game/CommonDepthPass/Depth"
    }

    Fallback "Game/Base/ShadowCaster"
}
