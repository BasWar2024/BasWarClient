Shader "Hidden/PostProcessing/GaussianBlur"
{
    HLSLINCLUDE

        #pragma target 3.0
        #include "Assets/ThirdPart/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

        float _blurSize;
        float _samples;
        float _stdDeviation;

        // 
        //#define PI 3.14159265359
        #define E 2.71828182846

        // Vertical Blur
        float4 VerticalBlur(VaryingsDefault i) : SV_Target
        {
            if(_stdDeviation == 0)
                return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

            float4 color = 0;
            float sum = 0;

            for(float index = 0; index < _samples; index++)
            {
                //get the offset of the sample
                float offset = (index/(_samples-1) - 0.5) * _blurSize;
                //get uv coordinate of sample
                float2 uv = i.texcoord + float2(0, offset);
            
                //calculate the result of the gaussian function
                float stdDevSquared = _stdDeviation*_stdDeviation;
                float gauss = (1 / sqrt(2*PI*stdDevSquared)) * pow(E, -((offset*offset)/(2*stdDevSquared)));
                //add result to sum
                sum += gauss;
                //multiply color with influence from gaussian function and add it to sum color
                color += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv) * gauss;
            }

            //divide the sum of values by the amount of samples
            color = color / sum;
            return color;
        }

        // Horizontal Blur
        float4 HorizontalBlur(VaryingsDefault i) : SV_Target
        {
            if(_stdDeviation == 0)
                return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

            float invAspect = _ScreenParams.y / _ScreenParams.x;
            float4 color = 0;
            float sum = 0;

            for(float index = 0; index < _samples; index++)
            {
                //get the offset of the sample
                float offset = (index/(_samples-1) - 0.5) * _blurSize * invAspect;
                //get uv coordinate of sample
                float2 uv = i.texcoord + float2(offset, 0);

                //calculate the result of the gaussian function
                float stdDevSquared = _stdDeviation*_stdDeviation;
                float gauss = (1 / sqrt(2*PI*stdDevSquared)) * pow(E, -((offset*offset)/(2*stdDevSquared)));
                //add result to sum
                sum += gauss;
                //multiply color with influence from gaussian function and add it to sum color
                color += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv) * gauss;
            }
            //divide the sum of values by the amount of samples
            color = color / sum;
            return color;
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        // (0) Vertical Blur
        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment VerticalBlur

            ENDHLSL
        }

        // (1) Horizontal Blur
        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment HorizontalBlur

            ENDHLSL
        }
    }
}
