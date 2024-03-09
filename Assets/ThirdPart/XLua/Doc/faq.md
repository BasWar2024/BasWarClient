# FAQ

## xLua

xLuazip

## xLua

Assets\XLua\GenXLua.docGenPath

xLuaxLuaAssembly-CSharp

## xLua

luaLuaCallCSharpUNITY_EDITORBlackListdelegateluadelegateCSharpCallLua

HotfixdelegateluadelegateCSharpCallLua

xLua[](configure.md)xLuaapixLua[ExampleConfig.cs](../Editor/ExampleConfig.cs)

## luatxt



TextAssetResourcesUnityluaUnity

CustomLoaderpackage.path

xLualuatxtxLuaTextAsset

## (il2cppandroid)iosattempt to call a nil value

il2cppc#apidllC#

LuaCallCSharpC#link.xmlReflectionUsexlualink.xmlil2cpp

## Unity 2018

2.1.142.1.14

1

Api Compatibility Level.NET Standard 2.0.NET Standard 2.0emit

Api Compatibility Level.NET 4.xUnity.NET Standard 2.0

2

Unity 2018.NET 4.X EquivalentAPI

unity\Editor\Data\MonoBleedingEdge\lib\mono\unityjit\mscorlib.dll

unity\Editor\Data\MonoBleedingEdge\lib\mono\4.7.1-api\mscorlib.dll

201986Dictionary<int, int>Dictionary<float, int>Dictionary201986unity 2018Dictionary[](https://github.com/Tencent/xLua/blob/master/Assets/XLua/Editor/ExampleConfig.cs#L277)Dictionary

## Plugins

PluginsxLua_Project_Root/build

cmakecmakemake_xxxx_yyyy.zzxxxxiosandroidyyyylua53luajitzzwindowsbatsh

windowsVisual Studio 2015

androidlinuxNDKANDROID_NDKNDK

iososxmac

## xlua.access, no field __Hitfix0_Update

[Hotfix](hotfix.md)

## visual studio 2017UWP

visual studio 20171Window2ARMVisual C++ARM64Visual C++ARM64C++Windows

## visual studio 2015

build\vs2015batbuild

## please install the Tools

ToolsAssetsmaster

## This delegate/interface must add to CSharpCallLua : XXX

xLuaCSharpCallLua

XXXCSharpCallLua

XLua/Generate Code

## unity5.5"XLua/Hotfix Inject In Editor""WARNING: The runtime version supported by this application is unavailable."

.net3.5unity5.5MonoBleedingEdgemono3.5warning

INJECT_WITHOUT_TOOLwarning

## hotfixevent

xlua.private_accessible

"&"delegateself\['&MyEvent'\]()MyEvent

## Unity Coroutine

[Hotfix](hotfix.md)

## NGUIUGUI/DOTween

xLuaC#luaC#

## CustomLoaderfilepath

luarequire 'a.b'CustomLoader"a.b"//luaa/b.luareffilepathUTF8byte[]

## 

xLualuaC#



## 

Clear Generated Code

## 



build



## CSC# API

lazyloadUnityEngine.GameObjectCS.UnityEngine.GameObjectlua

## LuaCallSharpCSharpCallLua

luaC#GameObject.FindgameobjectGameObjectLuaCallSharpluaUIC#luadelegateCSharpCallLua

List<int>.Find(Predicate<int> match)List<int>LuaCallSharpPredicate<int>CSharpCallLuamatchC#lua

This delegate/interface must add to CSharpCallLua : XXXXXXCSharpCallLua

## gc alloc

delegateluaLuaTableLuaFunctiongcgc

1decimal

2

3structstruct

23GCOptimize

## ios

ios1jit2stripping

C#delegateinterfaceluaemitjit

luaC#ReflectionUseLuaCallSharpGenerate Codelink.xml

CSharpCallLuaLuaCallSharp

## 

1(../Examples/09_GenericMethod/)

2


xLua

```csharp
// C#
public static Button GetButton(this GameObject go)
{
    return go.GetComponent<Button>();
}
```

```lua
-- lua
local go = CS.UnityEngine.GameObject.Find("button")
go:GetButton().onClick:AddListener(function()
    print('onClick')
end)
```

3xlua2.1.12C#
```csharp
public class GetGenericMethodTest
{
    int a = 100;
    public int Foo<T1, T2>(T1 p1, T2 p2)
    {
        Debug.Log(typeof(T1));
        Debug.Log(typeof(T2));
        Debug.Log(p1);
        Debug.Log(p2);
        return a;
    }

    public static void Bar<T1, T2>(T1 p1, T2 p2)
    {
        Debug.Log(typeof(T1));
        Debug.Log(typeof(T2));
        Debug.Log(p1);
        Debug.Log(p2);
    }
}
```
lua
```lua
local foo_generic = xlua.get_generic_method(CS.GetGenericMethodTest, 'Foo')
local bar_generic = xlua.get_generic_method(CS.GetGenericMethodTest, 'Bar')

local foo = foo_generic(CS.System.Int32, CS.System.Double)
local bar = bar_generic(CS.System.Double, CS.UnityEngine.GameObject)

-- call instance method
local o = CS.GetGenericMethodTest()
local ret = foo(o, 1, 2)
print(ret)

-- call static method
bar(2, nil)
```



* mono
* il2cpp
* il2cppC#hotfixC#hotfix


## luaC#

C#void Foo(int a)void Foo(short a)intshortluanumber

## //

//UNITY_EDITOR//

## this[string field]this[object field]luaDictionary\<string, xxx\>, Dictionary\<object, xxx\>luadic['abc']dic.abc

1AnimationGetComponent2keyDictionarydic['TryGetValue']DictionaryTryGetValue

2.1.11get_Itemset_Itemthis[string field]this[object field]apikey

~~~lua
dic:set_Item('a', 1)
dic:set_Item('b', 2)
print(dic:get_Item('a'))
print(dic:get_Item('b'))
~~~

2.1.11DictionaryTryGetValueC#Extension method

## UnityC#nullluanilDestroyGameObject

C#nullUnityEngine.Object==Destroyobj == nulltrueC#nullSystem.Object.ReferenceEquals(null, obj)

UnityEngine.Object

~~~csharp
[LuaCallCSharp]
[ReflectionUse]
public static class UnityEngineObjectExtention
{
    public static bool IsNull(this UnityEngine.Object o) // IsDestroyed
    {
        return o == null;
    }
}
~~~

luaUnityEngine.ObjectIsNull

~~~lua
print(go:GetComponent('Animator'):IsNull())
~~~

## 

mscorlibAssembly-CSharpCS.namespace.typename()typenametypename["typename"]List<string>

~~~lua
local lst = CS.System.Collections.Generic["List`1[System.String]"]()
~~~

typenameC#typeof().ToString()

mscorlibAssembly-CSharpC#

~~~lua
local dic = CS.System.Activator.CreateInstance(CS.System.Type.GetType('System.Collections.Generic.Dictionary`2[[System.String, mscorlib],[UnityEngine.Vector3, UnityEngine]],mscorlib'))
dic:Add('a', CS.UnityEngine.Vector3(1, 2, 3))
print(dic:TryGetValue('a'))
~~~

xLuav2.1.12

~~~lua
-- local List_String = CS.System.Collections.Generic['List<>'](CS.System.String) -- another way
local List_String = CS.System.Collections.Generic.List(CS.System.String)
local lst = List_String()

local Dictionary_String_Vector3 = CS.System.Collections.Generic.Dictionary(CS.System.String, CS.UnityEngine.Vector3)
local dic = Dictionary_String_Vector3()
dic:Add('a', CS.UnityEngine.Vector3(1, 2, 3))
print(dic:TryGetValue('a'))
~~~


## LuaEnv.Disposetry to dispose a LuaEnv with C# callback!

C#luadelegateluadelegate

delegateC#

C#LuaTable.Getnull

lualua

xlua.hotfix(class, method, func)C#xlua.hotfix(class, method, nil)

Dispose

xluaC#luautil.print_func_ref_by_csharplua

~~~lua
local util = require 'xlua.util'
util.print_func_ref_by_csharp()
~~~

main.lua2C#

~~~bash
LUA: main.lua:2
LUA: main.lua:13
~~~

## LuaEnv.Dispose

DisposelualualuaC#

## C#objectlongint

[11](../Examples/11_RawObject/RawObjectTest.cs)


## C#

util.hotfix_exC#

~~~lua
local util = require 'xlua.util'
util.hotfix_ex(CS.HotfixTest, 'Add', function(self, a, b)
   local org_sum = self:Add(a, b)
   print('org_sum', org_sum)
   return a + b
end)
~~~

## C#

2.1.8C#luaBirdagelualuaC#

2.1.9 xlua.utilcreatedelegate

C#

~~~csharp
public class TestClass
{
    public void Foo(int a)
    { 
    }
	
    public static void SFoo(int a)
    {
    }

public delegate void TestDelegate(int a);
~~~

FooTestDelegate
~~~lua
local util = require 'xlua.util'

local d1 = util.createdelegate(CS.TestDelegate, obj, CS.TestClass, 'Foo', {typeof(CS.System.Int32)}) --Foo2TestClass
local d2 = util.createdelegate(CS.TestDelegate, nil, CS.TestClass, 'SFoo', {typeof(CS.System.Int32)})

obj_has_TestDelegate.field = d1 + d2 --fieldFooSFooLua

~~~

## Lua



1luaresumeluaresumeassert



~~~lua
coroutine.resume(co, ...)
~~~



~~~lua
assert(coroutine.resume(co, ...))
~~~

2catch

sdktry-catch

## 

outPhysics.Raycastshortint

out2017-9-22Physics.RaycastshortintExtension method

hotfix

xlua.tofunctionxlua.tofunctionMethodBaseluaC#

~~~csharp
class TestOverload
{
    public int Add(int a, int b)
    {
        Debug.Log("int version");
        return a + b;
    }

    public short Add(short a, short b)
    {
        Debug.Log("short version");
        return (short)(a + b);
    }
}
~~~



~~~lua
local m1 = typeof(CS.TestOverload):GetMethod('Add', {typeof(CS.System.Int16), typeof(CS.System.Int16)})
local m2 = typeof(CS.TestOverload):GetMethod('Add', {typeof(CS.System.Int32), typeof(CS.System.Int32)})
local f1 = xlua.tofunction(m1) --MethodBasetofunction
local f2 = xlua.tofunction(m2)

local obj = CS.TestOverload()

f1(obj, 1, 2) --short
f2(obj, 1, 2) --int
~~~

xlua.tofunction

## interface

obj:ExtentionMethod()CS.ExtentionClass.ExtentionMethod(obj)

## xLuaWrap

[13](../Examples/13_BuildFromCLI/)Unity

## DelegatesGensBridge.cs

HotfixABHotfixAB

VSFind All References

## 

luac

lua326432luac32[](compatible_bytecode.md)

## luac#



* 1luaC#
* 2luagc

gclualuaC#gcgc

lualua

gcluagc20M40Mgc

xLuaC#lualua4C#C#gc



* 1GcPausegc2002coco2dx100gcGcStepmulgc200GcStepmulcoco2dx5000
* 2gcLuaEnv.FullGcluacollectgarbage('collect')

## crash

Player Setting/Scripting Define SymbolsTHREAD_SAFE

c#socket

