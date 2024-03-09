## C# API
### LuaEnv
#### object[] DoString(string chunk, string chunkName = "chuck", LuaTable env = null)


    



    chunk: Lua
    chunkName errordebug
    env 


    return;
    return 1, helloDoStringobject double1 stringhello
    


    LuaEnv luaenv = new LuaEnv();
    object[] ret = luaenv.DoString("print(hello)\r\nreturn 1")
    UnityEngine.Debug.Log("ret="+ret[0]);
    luaenv.Dispose()

#### T LoadString<T>(string chunk, string chunkName = "chunk", LuaTable env = null)



    delegateLuaFunction



    chunk: Lua
    chunkName errordebug
    env 



    delegateLuaFunction

#### LuaTable Global;



    luaLuaTable

### void Tick()



    LuaLuaBaseLuaTable LuaFunction
    MonoBehaviourUpdate

### void AddLoader(CustomLoader loader)



    loader



    loaderdelegate byte[] CustomLoader(ref string filepath)requireloaderrequireloaderbytefilepathIDE

#### void Dispose()


    
    DisposeLuaEnv

> LuaEnvUpdateGCDispose

### LuaTable

#### T Get<T>(string key)



    keyTvaluenull


#### T GetInPath<T>(string path)



    Getpath.var i = tbl.GetInPath<int>(a.b.c)luai = tbl.a.b.cGet

#### void SetInPath<T>(string path, T val)



    GetInPaht<T>setter

#### void Get<TKey, TValue>(TKey key, out TValue value)



     APIKeystringAPI

#### void Set<TKey, TValue>(TKey key, TValue value)



     Get<TKey, TValue>setter

#### T Cast<T>()



    tableTCSharpCallLuainterfaceclassstructDictionaryList

#### void SetMetaTable(LuaTable metaTable)


    
    metaTabletablemetatable

### LuaFunction

> Luaboxingunboxingtable.Get<ABCDelegate>delegateABCDelegateC#delegatetable.Get<ABCDelegate>ABCDelegate

#### object[] Call(params object[] args)



    Lua

#### object[] Call(object[] args, Type[] returnTypes)



    Lua

#### void SetEnv(LuaTable env)



    luasetfenv

## Lua API

### CS

#### CS.namespace.class(...)



    C#,



    local v1=CS.UnityEngine.Vector3(1,1,1) 

#### CS.namespace.class.field



    C#
    


    Print(CS.UnityEngine.Vector3.one)


#### CS.namespace.enum.field


    
    

#### typeof


    
    C#typeofTypeGameObject.AddComponentType



    newGameObj:AddComponent(typeof(CS.UnityEngine.ParticleSystem))


#### 64

##### uint64.tostring



    

##### uint64.divide



    

##### uint64.compare



    0

##### uint64.remainder


    
    
    
##### uint64.parse


    

#### xlua.structclone


    
    c#
	
#### xlua.private_accessible(class)		

    
    


    xlua.private_accessible(CS.UnityEngine.GameObject)	

#### xlua.get_generic_method

    
    


~~~lua
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
~~~

#### cast


    
    internalcalcC#PerformentTest.ICalc


    
    cast(calc, typeof(CS.PerformentTest.ICalc))

API
csharptableluac#

    local v1=CS.UnityEngine.Vector3(1,1,1) 
    local v2=CS.UnityEngine.Vector3(1,1,1) 
    v1.x = 100 
    v2.y = 100 
    print(v1, v2)
    local v3 = v1 + v2
    print(v1.x, v2.x) 
    print(CS.UnityEngine.Vector3.one)
    print(CS.UnityEngine.Vector3.Distance(v1, v2))

## 

### 


|C#|Lua|
|-|-|
|sbytebyteshortushortintuintdoublecharfloat|number|
|decimal|userdata|
|longulong|userdata/lua_Integer(lua53)|
|bytes[]|string|
|bool|boolean|
|string|string|

### 

|C#|Lua|
|-|-|
|LuaTable|table|
|LuaFunction|function|
|class struct|userdatatable|
|methoddelegate|function|

#### LuaTable

C#LuaC#LuaLuaTableLuatableLuatableC#LuaTable

#### LuaFunction

C#LuaC#LuaLuaFunctionLuafunctionLuafunctionC#LuaFunction

#### LuaUserData

C# Manageredlua userdata

#### class struct:

C#classstructLuauserdata__indexuserdata
C#LuaLuauserdataLuatabletablec#

#### method delegate

delegatelua
C#luaC#LuaoutLua2N

## 

#### HOTFIX_ENABLE

hotfix

#### NOT_GEN_WARNING

warning

#### GEN_CODE_MINIMIZE


