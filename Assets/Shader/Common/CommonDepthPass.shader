Shader "Game/CommonDepthPass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

         Pass
        {
            Tags { "RenderType" = "Opaque"   "LightMode" = "Deferred" }
            Name "Depth"
            ColorMask 0
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
             struct a2v
             {
                 float4 vertex : POSITION;
                 UNITY_VERTEX_INPUT_INSTANCE_ID
             };
             struct v2f
             {
                 float4 vertex : SV_POSITION;
                 UNITY_VERTEX_INPUT_INSTANCE_ID
             };

             v2f vert(a2v v)
             {
                 v2f o;
                 UNITY_INITIALIZE_OUTPUT(v2f, o);
                 UNITY_SETUP_INSTANCE_ID(v);
                 UNITY_TRANSFER_INSTANCE_ID(v, o);
                 o.vertex = UnityObjectToClipPos(v.vertex);
                 return o;
             }

             fixed4 frag(v2f i) : SV_Target
             {
                   UNITY_SETUP_INSTANCE_ID(i);
                 return 0;
             }
             ENDCG
        }
    }
}
