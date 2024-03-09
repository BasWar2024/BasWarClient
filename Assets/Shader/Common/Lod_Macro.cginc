#ifndef LOD_MACRO
#define LOD_MACRO

#ifndef SHADER_LOD_LEVEL
#if defined(SHADER_LOD_MID)
    #define SHADER_LOD_LEVEL 1
#elif defined(SHADER_LOD_LOW)
    #define SHADER_LOD_LEVEL 2
#else
    #define SHADER_LOD_LEVEL 0
#endif


#if SHADER_LOD_LEVEL > 0
    #pragma fragmentoption ARB_precision_hint_fastest
#endif

#endif




#endif