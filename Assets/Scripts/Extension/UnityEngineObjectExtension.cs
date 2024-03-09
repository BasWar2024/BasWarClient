using UnityEngine;
using XLua;

[LuaCallCSharp]
[ReflectionUse]
public static class UnityEngineObjectExtention
{
    public static bool IsNull(this UnityEngine.Object o) // IsDestroyed
    {
        return o == null;
    }
}