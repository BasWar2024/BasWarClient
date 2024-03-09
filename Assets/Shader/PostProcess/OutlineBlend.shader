Shader "Hidden/PostProcessing/OutlineBlend"
{
    HLSLINCLUDE

        #pragma target 3.0
        #include "Assets/ThirdPart/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        TEXTURE2D_SAMPLER2D(_OutlineTex, sampler_OutlineTex);
        
        float4 OutlineBlend(VaryingsDefault i) : SV_Target
        {
            float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
            float4 outlineColor = SAMPLE_TEXTURE2D(_OutlineTex, sampler_OutlineTex, i.texcoord);

            //float gray = outlineColor.r*0.299 + outlineColor.g*0.587 + outlineColor.b*0.114;
            //color = lerp(color, outlineColor, 1 - gray);
            
            color *= outlineColor;

            return color;
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        // (0) blend outlineTex
        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment OutlineBlend

            ENDHLSL
        }
    }
}
