//GPU ANIMATION

struct GpuAnimationVertexInputs
{
    float3 positionWS; // World space position
    float3 positionVS; // View space position
    float4 positionCS; // Homogeneous clip space position
    float4 positionNDC;// Homogeneous normalized device coordinates
    float4 normalOS;//new normal

};
//""uv
float4 GetUV(int index)
{
    int row = index / _AnimTex_TexelSize.z;
    int col = index % _AnimTex_TexelSize.z;

    return float4(col / _AnimTex_TexelSize.z, row / _AnimTex_TexelSize.w, 0, 0);
}

//""
float4x4 GetMatrix(int startIndex, float boneIndex)
{
    int matrixIndex = startIndex + boneIndex * 3;

    float4 row0 = SAMPLE_TEXTURE2D_LOD(_AnimTex, sampler_AnimTex, GetUV(matrixIndex).xy, 0);
    float4 row1 = SAMPLE_TEXTURE2D_LOD(_AnimTex, sampler_AnimTex, GetUV(matrixIndex + 1).xy, 0);
    float4 row2 = SAMPLE_TEXTURE2D_LOD(_AnimTex, sampler_AnimTex, GetUV(matrixIndex + 2).xy, 0);
    float4 row3 = float4(0, 0, 0, 1);

    return float4x4(row0, row1, row2, row3);
}

GpuAnimationVertexInputs GetVertexPositionInputsLit(float3 positionOS, float4 normalOS)
{
    GpuAnimationVertexInputs input;
    input.positionWS = TransformObjectToWorld(positionOS);
    input.positionCS = TransformWorldToHClip(input.positionWS);
    input.normalOS = normalOS;
    return input;
}

GpuAnimationVertexInputs DecerAnimation(float4 positionOS, float3 normalOS, half4 boneIndex, float4 boneWeight)
{
    int currentFrame = UNITY_ACCESS_INSTANCED_PROP(_AnimFrameInCome_arr, _AnimFrameInCome);

    float4x4 bone1Matrix = GetMatrix(currentFrame, boneIndex.x);
    float4x4 bone2Matrix = GetMatrix(currentFrame, boneIndex.y);
    float4x4 bone3Matrix = GetMatrix(currentFrame, boneIndex.z);
    float4x4 bone4Matrix = GetMatrix(currentFrame, boneIndex.w);

    float4 pos = mul(bone1Matrix, positionOS) * boneWeight.x +
    mul(bone2Matrix, positionOS) * boneWeight.y +
    mul(bone3Matrix, positionOS) * boneWeight.z +
    mul(bone4Matrix, positionOS) * boneWeight.w;

    float4 normal = mul(bone1Matrix, float4(normalOS.xyz, 0)) * boneWeight.x +
    mul(bone2Matrix, float4(normalOS.xyz, 0)) * boneWeight.y +
    mul(bone3Matrix, float4(normalOS.xyz, 0)) * boneWeight.z +
    mul(bone4Matrix, float4(normalOS.xyz, 0)) * boneWeight.w;

    return GetVertexPositionInputsLit(pos.xyz, normal);
}