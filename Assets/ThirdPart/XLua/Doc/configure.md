# xLua

xLua



* static/
* static
* 
* EditorHotfixAssembly-CSharp.dlldllEditor

****

xLuaattributeluac#LuaCallCSharp

~~~csharp

[LuaCallCSharp]
publicclassA
{

}

~~~

il2cpp

****

apiBlackListAdditionalPropertiesIEnumerable&lt;Type&gt;

~~~csharp

[LuaCallCSharp]
public static List<Type> mymodule_lua_call_cs_list = new List<Type>()
{
    typeof(GameObject),
    typeof(Dictionary<string, int>),
};

~~~

 ****  **Editor** 

****



~~~csharp

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

~~~

Getter

 ****  **Editor** 

### XLua.LuaCallCSharp

C#xLua

Extension Methods

xLuaLuaCallCSharp

il2cppReflectionUse

### XLua.ReflectionUse

C#xLualink.xmlil2cpp

LuaCallCSharpReflectionUse

LuaLuaCallCSharpReflectionUse

### XLua.DoNotGen



Dictionary<Type, List<string>>fieldpropertykeyvalue

ReflectionUse1ReflectionUse2ReflectionUsewrapDoNotGenwrapDoNotGenlazy

BlackList1BlackList2BlackListDoNotGen

### XLua.CSharpCallLua

luaC# delegateC#UIdelegateList&lt;T&gt;:ForEachLuaTableGetluadelegatelua tableC# interfacedelegateinterface

### XLua.GCOptimize

C#structstructC#xLuagcluac#C#gc allocgcGC05\_NoGc

lua tablegc alloc

### XLua.AdditionalProperties

GCOptimizestructfieldpropertyfieldGCOptimizepublicfield

Dictionary&lt;Type, List&lt;string&gt;&gt;DictionaryKeyValueXLuaUnityEngineSysGCOptimize

### XLua.BlackList





List&lt;List&lt;string&gt;&gt;ListListstringstringstringstring

GameObjectFileInfo

~~~csharp

[BlackList]
public static List<List<string>> BlackList = new List<List<string>>()  {
    new List<string>(){"UnityEngine.GameObject", "networkView"},
    new List<string>(){"System.IO.FileInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
};

~~~

### Editor

### CSObjectWrapEditor.GenPath

string&quot;Assets/XLua/Gen/&quot;

### CSObjectWrapEditor.GenCodeMenu

&quot;XLua/Generate Code&quot;