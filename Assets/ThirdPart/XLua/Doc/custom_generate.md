## 

xLuaxLualink.xmlLua IDE

## 

12

## 



* eval<%=exp%>expexp
* code<% if true then end%>lua
* literalevalcodeliteral



~~~xml
<%
require "TemplateCommon"
%>

<linker>
<%ForEachCsList(assembly_infos, function(assembly_info)%>
	<assembly fullname="<%=assembly_info.FullName%>">
	    <%ForEachCsList(assembly_info.Types, function(type)
		%><type fullname="<%=type:ToString()%>" preserve="all"/>
		<%end)%>
	</assembly>
<%end)%>
</linker>
~~~

TemplateCommonForEachCsListTemplateCommon.lua.txtlua

## API

~~~csharp
public static void CSObjectWrapEditor.Generator.CustomGen(string template_src, GetTasks get_tasks)
~~~

* template_src  
* get_tasks     GetTasks

~~~csharp
public delegate IEnumerable<CustomGenTask> GetTasks(LuaEnv lua_env, UserConfig user_cfg);
~~~

* lua_env       LuaEnvLuaTableLuaEnv.NewTable
* user_cfg      
* return        CustomGenTaskIEnumerable

~~~csharp
public struct UserConfig
{
    public IEnumerable<Type> LuaCallCSharp;
    public IEnumerable<Type> CSharpCallLua;
    public IEnumerable<Type> ReflectionUse;
}
~~~

~~~csharp
public struct CustomGenTask
{
    public LuaTable Data;
    public TextWriter Output;
}
~~~



~~~csharp
public static IEnumerable<CustomGenTask> GetTasks(LuaEnv lua_env, UserConfig user_cfg)
{
    LuaTable data = lua_env.NewTable();
    var assembly_infos = (from type in user_cfg.ReflectionUse
                          group type by type.Assembly.GetName().Name into assembly_info
                          select new { FullName = assembly_info.Key, Types = assembly_info.ToList()}).ToList();
    data.Set("assembly_infos", assembly_infos);

    yield return new CustomGenTask
    {
        Data = data,
        Output = new StreamWriter(GeneratorConfig.common_path + "/link.xml",
        false, Encoding.UTF8)
    };
}
~~~

* CustomGenTask
* dataassembly_infos

## 

MenuItemxLuaGenerate CodeCSObjectWrapEditor.GenCodeMenu



~~~csharp
[GenCodeMenu]//Generate Code
public static void GenLinkXml()
{
    Generator.CustomGen(ScriptableObject.CreateInstance<LinkXmlGen>().Template.text, GetTasks);
}
~~~


psXLua\Src\Editor\LinkXmlGenlink.xml
