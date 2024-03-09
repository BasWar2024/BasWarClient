## What&Why

XLua

* luajit64
* 
* ZeroBraneStudioluasocket
* tdr 4 lua

XLua

lua-rapidjsonxLuac/c++

## How



1. buildXLua Plugin
2. xLuaC# APIluarequire
3. 64XLua64C#

### &



1. xLuaCUnityAssets

    lua-rapidjsonrapidjson$UnityProj\build\lua-rapidjson\includerapidjson.cpp$UnityProj\build\lua-rapidjson\source$UnityProj

2. CMakeLists.txt

    xLuaPluginscmakemakefile
    
    xLuaCMakeLists.txtlist
    
    1. THIRDPART_INC
    2. THIRDPART_SRC
    3. THIRDPART_LIB

    rapidjson

        #begin lua-rapidjson
        set (RAPIDJSON_SRC lua-rapidjson/source/rapidjson.cpp)
        set_property(
            SOURCE ${RAPIDJSON_SRC}
            APPEND
            PROPERTY COMPILE_DEFINITIONS
            LUA_LIB
        )
        list(APPEND THIRDPART_INC  lua-rapidjson/include)
        set (THIRDPART_SRC ${THIRDPART_SRC} ${RAPIDJSON_SRC})
        #end lua-rapidjson

    

3. 

    make__lua.

    windows 64lua53make_win64_lua53.batandroidluajitmake_android_luajit.sh

    plugin_lua53plugin_luajitlua53luajit

    androidlinuxNDK

### C#

luaCluaopen_xxxxxxlua-rapidjsonluaopen_rapidjsonluaios

XLuaAPILuaEnv

    public void AddBuildin(string name, LuaCSFunction initer)



    namebuildinrequire
    initerpublic delegate int lua_CSFunction(IntPtr L)MonoPInvokeCallbackAttributeapi

luaopen_rapidjson

LuaDLL.Luapinvokeluaopen_rapidjsonC#lua_CSFunctionluaopen_rapidjson

    namespace LuaDLL
    { 
        public partial class Lua
        { 
            [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
            public static extern int luaopen_rapidjson(System.IntPtr L);

            [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
            public static int LoadRapidJson(System.IntPtr L)
            {
                return luaopen_rapidjson(L);
            }
        }
    }

AddBuildin

    luaenv.AddBuildin("rapidjson", LuaDLL.Lua.LoadRapidJson);

oklua

    local rapidjson = require('rapidjson')
    local t = rapidjson.decode('{"a":123}')
    print(t.a)
    t.a = 456
    local s = rapidjson.encode(t)
    print('json', s)

### 64

i64lib.hinclude64
API

    //int64/uint64
    void lua_pushint64(lua_State* L, int64_t n);
    void lua_pushuint64(lua_State* L, uint64_t n);
    //posint64/uint64
    int lua_isint64(lua_State* L, int pos);
    int lua_isuint64(lua_State* L, int pos);
    //posint64/uint64
    int64_t lua_toint64(lua_State* L, int pos);
    uint64_t lua_touint64(lua_State* L, int pos);

APIrapidjson.cpp

