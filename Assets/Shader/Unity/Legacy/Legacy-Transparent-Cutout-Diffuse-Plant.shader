Shader "Game/Unity/Legacy/Legacy-Transparent-Cutout-Diffuse-Plant" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5

    [Space(50)][Toggle] _Wind("?", Float) = 0
    _WaveSize ("", Float) = 1
    _WindFrequency ("", Float) = 1
    _WindParam ("(XYZ), (W))", Vector) = (0,0,0,1)
    _TouchRange ("", Float) = 1.5
    _WeatherNoiseTex("WeatherNoise", 2D) = "white" {}
}

SubShader {
    Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
    LOD 200

    CGPROGRAM
    #pragma shader_feature _WIND_ON
    #pragma surface surf GTLambert alphatest:_Cutoff vertex:vertexFunc finalcolor:SurfaceShaderHeightFogColor
    #pragma multi_compile_fog
    #pragma multi_compile __ GT_WEATHER
    #pragma skip_variants SHADOWS_CUBE POINT_COOKIE FOG_EXP FOG_EXP2 DYNAMICLIGHTMAP_ON DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE

    #include "../../Common/GTSceneShaderUtilities.cginc"

    sampler2D _MainTex;
    fixed4 _Color;
    uniform fixed4 _GlobalMultiCol;

    struct Input {
        float2 uv_MainTex;      // here we need float4
        fixed4 color : COLOR;   // color.a = AO
        SURFACE_INPUT_WEATHER
        SURFACE_INPUT_FOG
        INTERNAL_DATA
    };

    // Detail bending
    float _WaveSize;
    float _WindFrequency;
    //float4 _TimeFrequency; // x: time * frequency, y: time, zw: turbulence for 2nd bending
    //float _LeafTurbulence;
    float4 _WindParam;

    //float _GroundLightingAttunation;
    //#if defined(_TOUCHBENDING)
        float4 _TouchBendingPosition;
        float4 _TouchBendingForce;
        float _TouchRange;
        float4x4 _RotMatrix;
    //#endif
    fixed _BendingControls;

    inline float4 SmoothCurve(float4 x) {
        return x * x * (3.0 - 2.0 * x );
    }
    inline float4 TriangleWave(float4 x) {
        return abs(frac(x + 0.5) * 2.0 - 1.0);
    }
    inline float4 SmoothTriangleWave(float4 x) {
        return SmoothCurve(TriangleWave(x));
    }

    inline float4 AnimateVertex (float4 pos, float3 normal, float4 animParams, float variation)
    {
        // animParams.r = branch phase
        // animParams.g = edge flutter factor
        // animParams.b = primary factor
        // animParams.a = secondary factor

    //  Preserve Length
        //float origLength = length(pos.xyz);

    //  All computation is done in worldspace
        pos.xyz = mul( unity_ObjectToWorld, pos).xyz;

    //  based on original wind bending
        float fDetailAmp = 0.1;
        float fBranchAmp = 0.3;

    //  Phases (object, vertex, branch)
        float fObjPhase = frac( (pos.x + pos.z) * _WaveSize ) + variation;
        float fBranchPhase = fObjPhase.x + animParams.r; //---> fObjPhase + vertex color red
        float fVtxPhase = dot(pos.xyz, animParams.g + fBranchPhase); // controled by vertex color green

        float timeoffset = dot(pos.xyz, _WindParam.xyz);
    //  Animate Wind
        float sinuswave = (_Time.z + timeoffset) * _WindFrequency + variation;
        //float sinuswave = _TimeFrequency.x + variation;

        float4 TriangleWaves = SmoothTriangleWave(float4( frac( (pos.x ) * _WaveSize) + sinuswave , frac( (pos.z) * _WaveSize) + sinuswave * 0.8, 0.0, 0.0));
        float Oscillation = TriangleWaves.x + (TriangleWaves.y * TriangleWaves.y);
        Oscillation = (Oscillation + 3.0) * 0.33 * _WindParam.w;

        //  x is used for edges; y is used for branches float2(_Time.y, _Time.z) // 0.193
        float2 vWavesIn = (_Time.yy + timeoffset.xx) + float2(fVtxPhase, fBranchPhase);
        //float2 vWavesIn = _TimeFrequency.y + float2(fVtxPhase, fBranchPhase);

        float4 vWaves = (frac( vWavesIn.xxyy * float4(1.975, 0.793, 0.375, 0.193) ) * 2.0 - 1.0);
        //float4 vWaves = (frac( vWavesIn.xxyy * float4(1.975, 0.793, lerp(float2(0.375, 0.193), _TimeFrequency.zw, _LeafTurbulence )) ) * 2.0 - 1.0);
        vWaves = SmoothTriangleWave( vWaves );
        float2 vWavesSum = vWaves.xz + vWaves.yw;

    //  Edge (xz) controlled by vertex green and branch bending (y) controled by vertex alpha
        float3 bend = animParams.g * fDetailAmp * normal.xyz * sign(normal.xyz); // sign important to match normals of both faces!!! otherwise edge fluttering might be corrupted.
        bend.y = animParams.a * fBranchAmp;

    //  Secondary bending
        pos.xyz += ( (vWavesSum.xyx * bend) + (_WindParam.xyz * vWavesSum.y * animParams.a) ) * Oscillation;

    //  Preserve Length / would need single game objects...
    //  pos.xyz = normalize(pos.xyz) * origLength;

    //  Primary bending / Displace position
        pos.xyz += animParams.b * _WindParam.xyz * Oscillation;

    //  Preserve Length // Does not work in worldspace...
    //  pos.xyz = normalize(pos.xyz) * origLength;

        //Touch bending
        #if defined(_TOUCHBENDING)
            //Primary displacement by touch bending
            pos.xyz += animParams.a * _TouchBendingForce.xyz * _TouchBendingForce.w;
            //Touch rotation
            pos.xyz = lerp( pos.xyz, mul(_RotMatrix, float4(pos.xyz - _TouchBendingPosition.xyz, 0)).xyz + _TouchBendingPosition.xyz, animParams.b * 10 * (1 + animParams.r ) );
        #endif

        float3 distance = pos.xyz - _TouchBendingPosition.xyz;
        float len = length(distance);

        pos.xyz += animParams.a * distance / len * _TouchBendingForce.w * max(_TouchRange - len, 0);

    //  bring pos back to local space
        pos.xyz = mul( unity_WorldToObject, pos).xyz;

        return pos;
    }


    void vertexFunc(inout appdata_full v, out Input o)
    {
        UNITY_INITIALIZE_OUTPUT(Input, o);
#if defined(_WIND_ON)
        float4 bendingCoords;
        bendingCoords.rg = v.color.rg;

        //  Legacy Bending: Primary and secondary bending stored in vertex color blue
        //  New Bending:    Primary and secondary bending stored in uv4
        //  x = primary bending = blue
        //  y = secondary = alpha
        bendingCoords.ba = v.color.bb;//(_BendingControls == 0) ? v.color.bb : v.texcoord3.xy;
                                      //    Add variation only if the shader uses UV4
        float variation = 1.0;//(_BendingControls == 0) ? 1.0 : v.color.b * 2;
                              //
        v.vertex = AnimateVertex(v.vertex, v.normal, bendingCoords, variation);
        v.normal = normalize(v.normal);
        v.tangent.xyz = normalize(v.tangent.xyz);
#endif
        GT_TRANSFER_WEATHER(o, v);
        GT_TRANSFER_FOG_SURF(o, v);
    }

    void SurfaceShaderHeightFogColor(Input IN, SurfaceOutput o, inout fixed4 color) {
        GT_APPLY_FOG(IN, color);
    }

    void surf (Input IN, inout SurfaceOutput o) {
        fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
        o.Albedo = WEATHER_ALBEDO(c, IN);
        o.Alpha = c.a;

        fixed3 gColor = lerp(fixed3(1,1,1), _GlobalMultiCol.rgb, _GlobalMultiCol.a);
        o.Albedo *= gColor;
    }

    ENDCG
}

//Fallback "Game/Unity/Legacy/Legacy-Transparent-Cutout-VertexLit"
}
