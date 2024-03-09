Shader "Game/Base/ShadowCaster"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Pass
        {
            Name "Shadow"
            Tags { "LightMode" = "ShadowCaster" }
            Offset 1, 1
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct v2f {
                V2F_SHADOW_CASTER;
            };
            v2f vert( appdata_base v )
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }
            float4 frag( v2f i ) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
