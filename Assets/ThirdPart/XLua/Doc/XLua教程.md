## xLua

### Lua

1. 

    LuaEnv.DoStringLua
    

        luaenv.DoString("print('hello world')")

    XLua\Tutorial\LoadLuaScript\ByString
    > 

2. Lua

    luarequire
    

        DoString("require 'byfile'")

    XLua\Tutorial\LoadLuaScript\ByFile

    requireloader
    xLualoaderResourceloaderResourceResourcesluatxt

    LuaDoString("require 'main'")main.lualualua main.lua

    LuaxLuaLoader

3. Loader

    xLualoader

        public delegate byte[] CustomLoader(ref string filepath);
        public void LuaEnv.AddLoader(CustomLoader loader)

    AddLoaderluarequirefilepathbyteloaderlua
    IIPSIFSloaderIIPSloader
    XLua\Tutorial\LoadLuaScript\Loader

### C#Lua

C#Lua
XLua\Tutorial\CSharpCallLua

1. 
    LuaEnv.GlobalGet
    
        luaenv.Global.Get<int>("a")
        luaenv.Global.Get<string>("b")
        luaenv.Global.Get<bool>("c")

2. table

    Get
    1. classstruct

        classtablepublic{f1 = 100, f2 = 100}public int f1;public int f2;class
        xLuanew

        tableclass
        classclasstable

        GCOptimize
        

    2. interface
    
        InvalidCastExceptioninterfacegetgettablesetinterfacelua

    3. by valueDictionary<>List<>

        classinterfacetablekeyvalue

    4. by refLuaTable
    
        2

3. function

    Get
    1. delegate

        InvalidCastException

        delegate
        function
        c#outref

        outrefdelegate

        delegate

    2. LuaFunction
        
        
        LuaFunctionCallobjectlua

4. 

    1. luatablefunctionlua functiondelegatedelegatetable

    2. luadelegateinterfacexLuaxluadelegateinterfacedelegateinterface

### LuaC#

> XLua\Tutorial\LuaCallCSharp

#### new C#

C#new

    var newGameObj = new UnityEngine.GameObject();

Lua

    local newGameObj = CS.UnityEngine.GameObject()



    1. luanew
    2. C#CS

xluaGameObjectstring

    local newGameObj2 = CS.UnityEngine.GameObject('helloworld')

#### C#

##### 

    CS.UnityEngine.Time.deltaTime

##### 

    CS.UnityEngine.Time.timeScale = 0.5

##### 

    CS.UnityEngine.GameObject.Find('helloworld')



    local GameObject = CS.UnityEngine.GameObject
    GameObject.Find('helloworld')

#### C#

##### 

    testobj.DMF

##### 

    testobj.DMF = 1024

##### 



    testobj:DMFunc()

##### 

xlua

##### outref

LuaC#refoutlua 

LuaC#outreflua

##### 


    testobj:TestFunc(100)
    testobj:TestFunc('hello')

TestFuncTestFunc

xlualuaC#C#intfloatdoubleluanumberTestFunc

##### 

+-*/==-<<= %[]

##### 

C#

##### 
C#

    void VariableParamsFunc(int a, params string[] strs)

lua

    testobj:VariableParamsFunc(5, 'hello', 'john')

##### Extension methods

C#lua

##### 

Extension methods

##### 



    testobj:EnumTestFunc(CS.Tutorial.TestEnum.E1)

EnumTestFuncTutorial.TestEnum

__CastFrom

    CS.Tutorial.TestEnum.__CastFrom(1)
    CS.Tutorial.TestEnum.__CastFrom('E1')

##### delegate+-

C#delegatelua

+C#+C# delegatelua

-+delegate

> Psdelegateluafunction

##### event

testobjpublic event Action TestEvent;



    testobj:TestEvent('+', lua_event_callback)



    testobj:TestEvent('-', lua_event_callback)

##### 64

    Lua5364longulong64luajitlua5.164xlua64C#longulonguserdata
    
    lua64
    
    lua number
    
    64int64ulonglongluaulongjavaAPIAPI

##### C#table

C#luatabletablepublic
C#Bclass

    public struct A
    {
        public int a;
    }

    public struct B
    {
        public A b;
        public double c;
    }



    void Foo(B b)

lua

    obj:Foo({b = {a = 100}, c = 200})

##### C#typeof

UnityEngine.ParticleSystemType

    typeof(CS.UnityEngine.ParticleSystem)

##### 

luaxluainterfacexluainterface

    cast(calc, typeof(CS.Tutorial.Calc))

CS.Tutorial.Calccalc
