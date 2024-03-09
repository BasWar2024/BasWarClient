## 

1

HOTFIX_ENABLEUnity3DFile->Build Setting->Scripting Define SymbolsAPI

HOTFIX_ENABLEbuildHOTFIX_ENABLE

2XLua/Generate Code

3"XLua/Hotfix Inject In Editor"hotfix inject finish!had injected!

hotfix inject finish!had injected!xlua.hotfixxlua.access, no field __Hitfix0_UpdateHotfix

## 



Assetsc#

## API
xlua.hotfix(class, [method_name], fix)

*           lua
* class         C#CS.Namespace.TypeName"Namespace.TypeName"C#Type.GetTypeNested TypePublic"Namespace.TypeName+NestedTypeName"
* method_name   
* fix           method_namefixfunctiontabletablekeymethod_namevaluefunction

base(csobj)

*           overridebase
* csobj         
*         base

HotfixTest2.cs

```lua
xlua.hotfix(CS.BaseTest, 'Foo', function(self, p)
    print('BaseTest', p)
    base(self):Foo(p)
end)
```

util.hotfix_ex(class, method_name, fix)

*           xlua.hotfixfixfix
* method_name   
* fix           C#lua function

## 



Hotfix

staticstaticNamespace

~~~csharp
//Assembly-CSharp.dlldllEditor
public static class HotfixCfg
{
    [Hotfix]
    public static List<Type> by_field = new List<Type>()
    {
        typeof(HotFixSubClass),
        typeof(GenericClass<>),
    };

    [Hotfix]
    public static List<Type> by_property
    {
        get
        {
            return (from type in Assembly.Load("Assembly-CSharp").GetTypes()
                    where type.Namespace == "XXXX"
                    select type).ToList();
        }
    }
}
~~~

## Hotfix Flag

Hotfix

* StatelessStateful

Statefulxlua.util.stateHotfixTest2.cs

StatefulStateless

* ValueTypeBoxing

delegateobjectboxinggctext

* IgnoreProperty



* IgnoreNotPublic

publicMonoBehaviourpublicpublic

* Inline

delegate

* IntKey



text

idhotfixididGen/Resources/hotfix_id_map.lua.txthotfix_id_map.lua.txt

IntKeyIntKey

~~~lua
return {
    ["HotfixTest"] = {
        [".ctor"] = {
            5
        },
        ["Start"] = {
            6
        },
        ["Update"] = {
            7
        },
        ["FixedUpdate"] = {
            8
        },
        ["Add"] = {
            9,10
        },
        ["OnGUI"] = {
            11
        },
    },
}
~~~

HotfixTestUpdate

~~~lua
CS.XLua.HotfixDelegateBridge.Set(7, func)
~~~

idAdd

xlua.utilauto_id_map

~~~lua
(require 'xlua.util').auto_id_map()
xlua.hotfix(CS.HotfixTest, 'Update', function(self)
        self.tick = self.tick + 1
        if (self.tick % 50) == 0 then
            print('<<<<<<<<Update in lua, tick = ' .. self.tick)
        end
    end)
~~~

hotfix_id_map.lua.txtrequire 'hotfix_id_map'


## 

* Hotfix
* delegateCSharpCallLua
* APIAPILuaLuaCallCSharp
* APIAPIC#C#APIAPILuaCallCSharpReflectionUse

## 

xlualuaC#luagettersetteraddremove

* 

method_namelua



```csharp

// fixC#
[Hotfix]
public class HotfixCalc
{
    public int Add(int a, int b)
    {
        return a - b;
    }

    public Vector3 Add(Vector3 a, Vector3 b)
    {
        return a - b;
    }


```

```lua

xlua.hotfix(CS.HotfixCalc, 'Add', function(self, a, b)
    return a + b
end)

```

selfselfStatelessC#C#this

luarefluaoutlua



* 

method_name".ctor"

lua

* 

APropgettermethod_nameget_APropsettermethod_nameset_AProp

* []

set_Itemget_Itemselfkeyvaluekey

* 

C#+op_AdditionC#+

* 

AEvent+=add_AEvent-=remove_AEventselfdelegate

xlua.private_accessible2.1.11xlua.private_accessibledelegate"&"self\['&MyEvent'\]()MyEvent

* 

method_name"Finalize"self

lua

* 



```csharp
public class GenericClass<T>
{

```

GenericClass\<double\>GenericClass\<int\>GenericClass


GenericClass<double>

```csharp
luaenv.DoString(@"
    xlua.hotfix(CS.GenericClass(CS.System.Double), {
        ['.ctor'] = function(obj, a)
            print('GenericClass<double>', obj, a)
        end;
        Func1 = function(obj)
            print('GenericClass<double>.Func1', obj)
        end;
        Func2 = function(obj)
            print('GenericClass<double>.Func2', obj)
            return 1314
        end
    })
");
```

* Unity

util.cs_generatorfunctionIEnumeratorcoroutine.yieldC#yield returnC#hotfix

~~~csharp
[XLua.Hotfix]
public class HotFixSubClass : MonoBehaviour {
    IEnumerator Start()
    {
        while (true)
        {
            yield return new WaitForSeconds(3);
            Debug.Log("Wait for 3 seconds");
        }
    }
}
~~~

~~~csharp
luaenv.DoString(@"
    local util = require 'xlua.util'
    xlua.hotfix(CS.HotFixSubClass,{
        Start = function(self)
            return util.cs_generator(function()
                while true do
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(3))
                    print('Wait for 3 seconds')
                end
            end)
        end;
    })
");
~~~

* 

xlua.hotfixtablemethod_name = function

```lua

xlua.hotfix(CS.StatefullTest, {
    ['.ctor'] = function(csobj)
        return util.state(csobj, {evt = {}, start = 0, prop = 0})
    end;
    set_AProp = function(self, v)
        print('set_AProp', v)
        self.prop = v
    end;
    get_AProp = function(self)
        return self.prop
    end;
    get_Item = function(self, k)
        print('get_Item', k)
        return 1024
    end;
    set_Item = function(self, k, v)
        print('set_Item', k, v)
    end;
    add_AEvent = function(self, cb)
        print('add_AEvent', cb)
        table.insert(self.evt, cb)
    end;
    remove_AEvent = function(self, cb)
       print('remove_AEvent', cb)
       for i, v in ipairs(self.evt) do
           if v == cb then
               table.remove(self.evt, i)
               break
           end
       end
    end;
    Start = function(self)
        print('Start')
        for _, cb in ipairs(self.evt) do
            cb(self.start, 2)
        end
        self.start = self.start + 1
    end;
    StaticFunc = function(a, b, c)
       print(a, b, c)
    end;
    GenericTest = function(self, a)
       print(self, a)
    end;
    Finalize = function(self)
       print('Finalize', self)
    end
})

```

