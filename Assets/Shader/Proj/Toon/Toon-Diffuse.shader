Shader "Unlit/RoleDiffuse"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 0
        _Layer1Color("Layer1Color", Color) = (1,1,1,1)
        _Layer2Color("Layer2Color", Color) = (1,0.9412545,0.8726415,1)
        _Layer2Edge("Layer2Edge", Range(-1, 1)) = -0.2288453
        _Layer2Smooth("Layer2Smooth", Range(0, 100)) = 50
        _Layer3Color("Layer3Color", Color) = (0.9433962,0.7495041,0.6986472,1)

        _Layer3Edge("Layer3Edge", Range(-2, 2)) = -0.002714761
        _Layer3Smooth("Layer3Smooth", Range(0, 100)) = 50
        _MainTex("MainTex", 2D) = "white" {}
        _RimPower("RimPower", Range(0, 100)) = 11.40262
        _RimSmooth("RimSmooth", Range(0, 100)) = 41.10207
        
        [HDR]_RimColor("RimColor", Color) = (0,0,0,1)
         _Layer2Dot("Layer2Dot", Color) = (0,0,0,1)
        _Layer3Dot("Layer3Dot", Color) = (0,0,0,1)
        _GridColor("GridColor", Color) = (0,0,0,1)
        _GridCount("GridCount", Range(0, 500)) = 301.0403
        _GridSize("GridSize",vector) = (0,0,1,1)
        [HDR]_Emssion("Emssion", Color) = (0,0,0,1)

        _Offset_Z("Offset_Camera_Z", Range(-10,10)) = 0
        _Outline_Width("Outline_Width", Float) = 3
        _OutlineColor("OutlineColor", Color) = (0.2830189,0,0,1)
        _Farthest_Distance("Farthest_Distance", Float) = 300
        _Nearest_Distance("Nearest_Distance", Float) = 0.5
      [Toggle] _NormalInColor("", Float) = 0
        [HDR]_FresnelColor("",Color) = (1.5,1.5,0,1)
        _FresnelIntensity("",Range(0,5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Blend[_SrcBlend][_DstBlend]
        Pass
        {
            Tags{ "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile __ _Fresnel
            #pragma shader_feature _ UILIGHT

            #include "UnityCG.cginc"

            uniform float _Layer2Edge;
            uniform float _Layer2Smooth;
            uniform float _Layer3Edge;
            uniform float _Layer3Smooth;
            uniform float4 _Layer1Color;
            uniform float4 _Layer2Color;
            uniform float4 _Layer3Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _RimPower;
            uniform float _RimSmooth;
            uniform float4 _RimColor;
            uniform float4 _Emssion;
            uniform float _GridCount;
            float4 _GridSize;
            float4 _GridColor;
            float4 _Layer3Dot;
            float4 _Layer2Dot;
            float4 _Color;
#if _Fresnel 
            float4 _FresnelColor;
            float _FresnelIntensity;
#endif
#if UILIGHT
            float4 _UILightDir;
#else
            float4 _GTLightDir;
#endif
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
                float4 projPos : TEXCOORD3;
            };

            v2f vert (appdata v)
            {
                v2f o = (v2f)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.projPos = mul(UNITY_MATRIX_V, float4(o.posWorld.rgb, 0));
                o.vertexColor = v.vertexColor;
              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 _MainTex_var = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
#if UILIGHT
                float3 lightDirection = normalize(_UILightDir.xyz);
#else
                float3 lightDirection = normalize(_GTLightDir.xyz);
#endif
               
               // float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float nDotV = dot(normalDirection, viewDirection);
                float nDotl = dot(i.normalDir, lightDirection);
                float halfNDotL = nDotl * 0.5 + 0.5;
                //rim
                float3 rim = _RimColor.rgb * saturate((pow(1.0 - max(0, nDotV), _RimPower) * nDotl) * _RimSmooth) * _MainTex_var.rgb;
                //diffuse
                
                float2 sceneUVs = (abs(i.projPos.xy));
              //  float2 sceneUVs = i.uv0;
              //  sceneUVs.y *= 0.5;
                float2 gridUV = frac(sceneUVs * _GridCount) * 2 - 1 ;//[-1,1]
                float blackDot =length(gridUV);
                float2 layerDot = saturate(float2((blackDot + _GridSize.xy) * _GridSize.zw));
                float2 layer23 = halfNDotL.xx + _Layer2Edge.xx;
                layer23.y += _Layer3Edge;
                layer23 = saturate(layer23 * float2(_Layer2Smooth, _Layer3Smooth)) ;
                float3 dotColor2 = lerp(_Layer2Dot, _Layer2Color.rgb, layerDot.x );
                float3 diffuse = lerp(dotColor2, _Layer1Color.rgb, layer23.x) ;
                float3 dotColor3 = lerp(_Layer3Dot, _Layer3Color.rgb, layerDot.y );
                diffuse = lerp(dotColor3 ,diffuse, layer23.y );
                diffuse = lerp(1, diffuse, i.vertexColor.a);
                //combine
                float3 result = _MainTex_var.rgb * diffuse.rgb * _Color.rgb +  _Emssion.rgb + rim;

#if _Fresnel 
                float fresnel = (1 - nDotV);
                fresnel = saturate(fresnel * fresnel);
                result += fresnel * _FresnelColor.xyz * _FresnelIntensity;
#endif
                return float4(result, _Color.a);
            }
            ENDCG
        }

        Pass{
           Name "Outline"
           Tags {
           }
           Cull Front

           CGPROGRAM
           #pragma target 3.0
           #pragma vertex vert
           #pragma fragment frag

           #include "UnityCG.cginc"
           #pragma fragmentoption ARB_precision_hint_fastest
           
           uniform float _Outline_Width,_Nearest_Distance,_Farthest_Distance,_Offset_Z;
           float _NormalInColor;
           uniform float4 _OutlineColor;
           float4 _Color;
           struct VertexInput 
           {
               float4 vertex : POSITION;
               float3 normal : NORMAL;
               float4 color  : COLOR;
           };
           struct VertexOutput 
           {
               float4 pos : SV_POSITION;
           };
           VertexOutput vert(VertexInput v) 
           {
               VertexOutput o = (VertexOutput)0;
               float4 objPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
               float Set_Outline_Width = (_Outline_Width * 0.001 * smoothstep(_Farthest_Distance, _Nearest_Distance, distance(objPos.rgb, _WorldSpaceCameraPos))).r;
               float4 _ClipCameraPos = mul(UNITY_MATRIX_VP, float4(_WorldSpaceCameraPos.xyz, 1));
#if defined(UNITY_REVERSED_Z)
               // (DX)
                           _Offset_Z = _Offset_Z * -0.01;
           #else
               //OpenGL
                           _Offset_Z = _Offset_Z * 0.01;
           #endif
               float3 outNor = _NormalInColor == 0 ? v.normal.xyz : v.color.xyz * 2 - 1;
               o.pos = UnityObjectToClipPos(float4(v.vertex.xyz + outNor * Set_Outline_Width, 1));
               o.pos.z = o.pos.z + _Offset_Z * _ClipCameraPos.z;
               return o;
           }
           float4 frag(VertexOutput i) : COLOR {
               return fixed4(_OutlineColor.rgb,_Color.a);
           }
           ENDCG
        }
    }
}
