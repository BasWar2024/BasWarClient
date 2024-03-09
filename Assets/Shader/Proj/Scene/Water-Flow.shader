// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Game/Proj/Water/Water-Flow" {
    Properties{
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Base (RGB) Trans (A)", 2D) = "white" {}

        [Header(Flow Param)]
        _FlowTrans("Speed(xy) Scale(zw)", Vector) = (0, 0, 1, 1)
        _FlowRot("Flow Rotation", Range(0, 360)) = 0
        _FlickRate("Flick Rate", Range(0, 100)) = 1
    }

    SubShader{
            Tags {
                "Queue"="Transparent"
                "IgnoreProjector"="True"
                "RenderType" = "Transparent"
                "LightMode" = "ForwardBase"
            }
            LOD 200

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            Pass {
                    Tags{ "LightMode" = "ForwardBase" }
                    CGPROGRAM

                    #pragma skip_variants LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE DYNAMICLIGHTMAP_ON DIRECTIONAL_COOKIE POINT_COOKIE SHADOWS_CUBE FOG_EXP FOG_EXP2 SPOT POINT EDITOR_VISUALIZATION

                    #pragma vertex vert
                    #pragma fragment frag

                    #include "UnityCG.cginc"

                    struct appdata_t
                    {
                        float4 vertex : POSITION;
                        float2 texcoord : TEXCOORD0;
                    };

                    struct v2f
                    {
                        float4 pos : SV_POSITION;
                        float2 uv : TEXCOORD0;
                    };

                    uniform float4 _MainTex_ST;
                    uniform float4 _FlowTrans;
                    uniform float _FlowRot;

                    v2f vert (appdata_t v)
                    {
                        v2f o;
                        o.pos = UnityObjectToClipPos(v.vertex);

                        float2 flowCoord = v.texcoord * _FlowTrans.zw + _Time.x * _FlowTrans.xy;
                        float2 flowUV = TRANSFORM_TEX(flowCoord, _MainTex);
                        flowUV -= 0.5;
                        float tx = flowUV.x;
                        float ty = flowUV.y;
                        flowUV.x = tx * cos(_FlowRot) + ty * sin(_FlowRot) + 0.5;
                        flowUV.y = ty * cos(_FlowRot) - tx * sin(_FlowRot) + 0.5;

                        o.uv = flowUV;

                        return o;
                    }

                    uniform float4 _Color;
                    uniform sampler2D _MainTex;
                    uniform float _FlickRate;
                    uniform fixed4 _GlobalMultiCol;

                    float4 frag (v2f i) : COLOR
                    {
                        float4 finalColor = tex2D(_MainTex, i.uv);
                        finalColor.a = saturate(abs(sin(_Time.x * _FlickRate)) + 0.2) * finalColor.a;
                        finalColor *= _Color;

                        fixed3 white = fixed3(1,1,1);
                        fixed3 gColor = lerp(white, _GlobalMultiCol.rgb, _GlobalMultiCol.a);
                        finalColor.rgb *= gColor;

                        return finalColor;
                    }
                ENDCG
            }
        }

        //FallBack "Diffuse"
}
