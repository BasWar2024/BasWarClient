using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

// 
struct ComponentInfo
{
    public string name;
    public string type;
    public string path;
    public ComponentInfo(string name, string type, string path)
    {
        this.name = name;
        this.type = type;
        this.path = path;
    }
}

public class UICodeMaker
{
    static readonly string kDefaultOutputPathCSharp = Application.dataPath + "/Script/Game/Logic/UI"; // 
    static readonly string kDefaultOutputPathLua = Application.dataPath + "/Lua/UI"; // 
    static readonly Dictionary<string, Type> Cfg = new Dictionary<string, Type>()
        {
            //  
            { "btn", typeof(GameObject)},
            { "scbar", typeof(Scrollbar)},
            { "scRect", typeof(ScrollRect)},
            { "drop", typeof(Dropdown)},
            { "input", typeof(InputField)},
            { "slider", typeof(Slider)},
            { "img", typeof(Image)},
            { "rawImg", typeof(RawImage)},
            { "tog", typeof(Toggle)},
            { "txt", typeof(Text)},
            { "tmp", typeof(TextMeshProUGUI)},
            { "go", typeof(GameObject)},
            { "tf", typeof(Transform)},
            { "rtf", typeof(RectTransform)},
        };

    //[MenuItem("Tools/UI/1.ViewLogicC#", false, 1)]
    static void MakeCodeCSharp()
    {
        MakeCode(false);
    }

    [MenuItem("Tools/UI/ViewLogicLua", false, 2)]
    static void MakeCodeLua()
    {
        MakeCode(true);
    }

    static void MakeCode(bool isLua)
    {
        // 
        GameObject[] selGO = Selection.GetFiltered<GameObject>(SelectionMode.Assets);
        if (selGO == null || selGO.Length == 0)
        {
            Debug.LogError("\"Resources/UI\" Prefab!");
            return;
        }

        // 
        string choosePath = string.Empty;
        if(isLua)
        {
            choosePath = EditorUtility.OpenFolderPanel("Select Folder", kDefaultOutputPathLua, "");
        }
        else
        {
            choosePath = EditorUtility.OpenFolderPanel("Select Folder", kDefaultOutputPathCSharp, "");
        }

        if (string.IsNullOrEmpty(choosePath)) return;
        choosePath += "/";

        foreach (GameObject GO in selGO)
        {
            if (string.IsNullOrEmpty(AssetDatabase.GetAssetPath(GO))) // Hierarchy
            {
                Debug.LogError("\"Resources/UI\" Prefab!");
                return;
            }

            // 
            List<ComponentInfo> totalInfo = new List<ComponentInfo>();
            ParseGameObject(GO.transform, "", totalInfo, true);

            // ViewLogic
            if(isLua)
            {
                MakeViewCodeLua(GO, choosePath, totalInfo);
                MakeLogicCodeLua(GO, choosePath, totalInfo);
            }
            else
            {
                MakeViewCodeCSharp(GO, choosePath, totalInfo);
                MakeLogicCodeCSharp(GO, choosePath, totalInfo);
            }
        }
        AssetDatabase.Refresh();
    }

    // 
    static void ParseGameObject(Transform trans, string filePath, List<ComponentInfo> totalInfo, bool isRoot = false)
    {
        if (!isRoot)
        {
            filePath += trans.name;
        }

        foreach(KeyValuePair<string, Type> kv in Cfg)
        {
            string name = kv.Key;
            Type type = kv.Value;
            if (type == typeof(GameObject))
            {
                if (trans != null && (trans.name.StartsWith(name) || trans.name.StartsWith(FirstToUpper(name))))
                {
                    string[] typeParam = type.ToString().Split('.');
                    totalInfo.Add(new ComponentInfo(FirstToLower(trans.name), typeParam[typeParam.Length - 1], filePath));
                }
            }
            else
            {
                Component component = trans.GetComponent(type);
                if (component != null && (trans.name.StartsWith(name) || trans.name.StartsWith(FirstToUpper(name))))
                {
                    string[] typeParam = type.ToString().Split('.');
                    totalInfo.Add(new ComponentInfo(FirstToLower(trans.name), typeParam[typeParam.Length - 1], filePath));
                }
            }

        }

        if (!isRoot)
        {
            filePath += "/";
        }

        // 
        for (int i = 0; i < trans.childCount; i++)
        {
            ParseGameObject(trans.GetChild(i), filePath, totalInfo);
        }
    }

    // 
    static string FirstToLower(string str)
    {
        str = str.Substring(0, 1).ToLower() + str.Substring(1);
        return str;
    }

    // 
    static string FirstToUpper(string str)
    {
        str = str.Substring(0, 1).ToUpper() + str.Substring(1);
        return str;
    }

    // 
    static string ToUnderScore(string str)
    {
        if(str != null && str.Length > 0)
        {
            StringBuilder result = new StringBuilder();
            // 
            result.Append(str.Substring(0, 1).ToLower());
            // 
            for(int i = 1; i < str.Length; i++)
            {
                string s = str.Substring(i, 1);
                // 
                if(s.Equals(s.ToUpper()))
                {
                    result.Append("_");
                    result.Append(s.ToLower());
                }
                else
                {
                    result.Append(s);
                }
            }
            return result.ToString();
        }
        return "";
    }

    // LuaView
    static void MakeViewCodeLua(GameObject GO, string folderPath, List<ComponentInfo> totalInfo)
    {
        FileStream viewFile = null;
        StreamWriter writer = null;
        try
        {
            // string viewFileClassName = "ui_" + ToUnderScore(GO.name) + "View";
            string viewFileClassName = FirstToUpper(GO.name) + "View";

            string viewFilePath = folderPath + viewFileClassName + ".lua";
            bool reCreate = false;
            if(File.Exists(viewFilePath))
            {
                reCreate = true;
            }
            viewFile = new FileStream(viewFilePath, FileMode.Create);
            writer = new StreamWriter(viewFile);
            StringBuilder sb = new StringBuilder();

            // 
            sb.Append("\n");
            sb.Append(viewFileClassName +" = class(\"" +  viewFileClassName +  "\")\n");
            sb.Append("\n");
            sb.Append(viewFileClassName + ".ctor = function(self, transform)\n");
            sb.Append("\n");
            sb.Append("    self.transform = transform\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // go
            for(int i = 0; i < totalInfo.Count; i++)
            {
                if(totalInfo[i].type == "Transform")
                {
                    sb.Append("    self." + totalInfo[i].name + " = transform:Find(\"" + totalInfo[i].path + "\")\n");
                }
                else if (totalInfo[i].type == "GameObject")
                {
                    sb.Append("    self." + totalInfo[i].name + " = transform:Find(\"" + totalInfo[i].path + "\").gameObject\n");
                }
                else
                {
                    sb.Append("    self." + totalInfo[i].name + " = transform:Find(\"" + totalInfo[i].path + "\"):GetComponent(\"" + totalInfo[i].type + "\")\n");
                }
                writer.Write(sb);
                sb.Remove(0, sb.Length);
            }

            sb.Append("end\n\n");
            sb.Append("return " + viewFileClassName);

            writer.Write(sb);
            sb.Remove(0, sb.Length);

            if(reCreate)
            {
                Debug.Log(viewFilePath + "!");
            }
            else
            {
                Debug.Log(viewFilePath + "!");
            }
        }
        catch(IOException ex)
        {
            Debug.LogError(string.Format("An IOException has been thrown when make UI View code with name is {0}!", GO.name));
            Debug.LogException(ex);
        }
        finally
        {
            if(writer != null)
            {
                writer.Close();
            }
            if(viewFile != null)
            {
                viewFile.Close();
            }
        }
    }

    // LuaLogic
    static void MakeLogicCodeLua(GameObject GO, string folderPath, List<ComponentInfo> totalInfo)
    {
        FileStream logicFile = null;
        StreamWriter writer = null;
        try
        {
            string viewName = FirstToUpper(GO.name) + "View";
            string logicName = FirstToUpper(GO.name);
            string logicFilePath = folderPath + logicName + ".lua";
            string[] pathArr = folderPath.Split('/');
            string folderName = pathArr[pathArr.Length - 2]; // : .../ui/folderName/
            if(File.Exists(logicFilePath)) return; // Logic

            logicFile = new FileStream(logicFilePath, FileMode.Create);
            writer = new StreamWriter(logicFile);
            StringBuilder sb = new StringBuilder();

            // 
            sb.Append("\n");
            // sb.Append("module(\"ui\", package.seeall)\n");
            sb.Append("\n");
            sb.Append(logicName + " = class(\"" + logicName + "\", ggclass.UIBase)\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // ctor
            //sb.Append(logicName + ".ctor = function(self, name, args, onload)\n");
            sb.Append("function " + logicName + ":ctor(args, onload)\n");
            sb.Append("    ggclass.UIBase.ctor(self, args, onload)\n");
            sb.Append("\n");
            // sb.Append("    self.props.prefabPath = \""+ AssetDatabase.GetAssetPath(GO) + "\"\n");
            sb.Append("    self.layer = UILayer.normal\n");
            sb.Append("    self.events = { }\n");
            sb.Append("end\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // onAwake
            // sb.Append(logicName + ".onAwake = function(self)\n");
            sb.Append("function " + logicName + ":onAwake()\n");
            sb.Append("    self.view = ggclass." + viewName + ".new(self.transform)\n\n");
            sb.Append("end\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // onShow
            // sb.Append(logicName + ".onShow = function(self, show)\n");
            sb.Append("function " + logicName + ":onShow()\n");
            sb.Append("    self:bindEvent()\n");
            sb.Append("\n");
            sb.Append("end\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // onHide
            sb.Append("function " + logicName + ":onHide()\n");
            sb.Append("    self:releaseEvent()\n");
            sb.Append("\n");
            sb.Append("end\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // 
            // sb.Append(logicName + ".bindEvent = function(self)\n");
            sb.Append("function " + logicName + ":bindEvent()\n");
            sb.Append("    local view = self.view\n");
            sb.Append("\n");
            for(int i = 0; i < totalInfo.Count; i++)
            {
                if(totalInfo[i].name.StartsWith("btn") || totalInfo[i].name.StartsWith("Btn"))
                {
                    sb.Append("    CS.UIEventHandler.Get(view." + totalInfo[i].name  + "):SetOnClick(function()\n");
                    sb.Append("        self:on"+ FirstToUpper(totalInfo[i].name) + "()\n");
                    sb.Append("    end)\n");
                    writer.Write(sb);
                    sb.Remove(0, sb.Length);
                }
            }
            sb.Append("end\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // 
            // sb.Append(logicName + ".releaseEvent = function(self)\n");
            sb.Append("function " + logicName + ":releaseEvent()\n");
            sb.Append("    local view = self.view\n");
            sb.Append("\n");
            for(int i = 0; i < totalInfo.Count; i++)
            {
                if(totalInfo[i].name.StartsWith("btn") || totalInfo[i].name.StartsWith("Btn"))
                {
                    sb.Append("    CS.UIEventHandler.Clear(view." + totalInfo[i].name + ")\n");
                    writer.Write(sb);
                    sb.Remove(0, sb.Length);
                }
            }
            sb.Append("\n");
            sb.Append("end\n");
            sb.Append("\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // go
            // sb.Append(logicName + ".onDestroy = function(self)\n");
            sb.Append("function " + logicName + ":onDestroy()\n");
            sb.Append("    local view = self.view\n");
            sb.Append("\n");
            sb.Append("end\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // 
            for(int i = 0; i < totalInfo.Count; i++)
            {
                if(totalInfo[i].name.StartsWith("btn") || totalInfo[i].name.StartsWith("Btn"))
                {
                    sb.Append("\n");
                    sb.Append("function " + logicName + ":on" + FirstToUpper(totalInfo[i].name) + "()\n");
                    sb.Append("\n");
                    sb.Append("end\n");
                    writer.Write(sb);
                    sb.Remove(0, sb.Length);
                }
            }
            sb.Append("\n");
            sb.Append("return " + logicName);
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            Debug.Log(logicFilePath + "!");
        }
        catch(IOException ex)
        {
            Debug.LogError(string.Format("An IOException has been thrown when make UI Logic code with name is {0}!", GO.name));
            Debug.LogException(ex);
            return;
        }
        finally
        {
            if(writer != null)
            {
                writer.Close();
            }
            if(logicFile != null)
            {
                logicFile.Close();
            }
        }
    }

    // CSharpView
    static void MakeViewCodeCSharp(GameObject GO, string folderPath, List<ComponentInfo> totalInfo)
    {
        FileStream viewFile = null;
        StreamWriter writer = null;
        try
        {
            string viewFilePath = folderPath + GO.name + "View.cs";
            string viewFileClassName = GO.name + "View";
            bool reCreate = false;
            if (File.Exists(viewFilePath))
            {
                reCreate = true;
            }
            viewFile = new FileStream(viewFilePath, FileMode.Create);
            writer = new StreamWriter(viewFile);
            StringBuilder sb = new StringBuilder();

            // 
            sb.Append("using UI.Ext;\n");
            sb.Append("using UnityEngine;\n");
            sb.Append("using UnityEngine.UI;\n\n");
            sb.Append("public class " + viewFileClassName + " : UIView\n");
            sb.Append("{\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // 
            for (int i = 0; i < totalInfo.Count; i++)
            {
                writer.Write("    private " + totalInfo[i].type + " _" + FirstToLower(totalInfo[i].name) + ";\n");
                writer.Write(sb);
                sb.Remove(0, sb.Length);
            }

            // 
            for (int i = 0; i < totalInfo.Count; i++)
            {
                sb.Append("\n    public ");
                sb.Append(totalInfo[i].type + " ");
                sb.Append(totalInfo[i].name + "\n");
                sb.Append("    {\n");
                sb.Append("        get\n");
                sb.Append("        {\n");
                sb.Append("            if (_" + FirstToLower(totalInfo[i].name) + " == null)\n");
                if (totalInfo[i].type == "Transform")
                {
                    sb.Append("                _" + FirstToLower(totalInfo[i].name) + " = transform.Find(\"" + totalInfo[i].path + "\");\n");
                }
                else
                {
                    sb.Append("                _" + FirstToLower(totalInfo[i].name) + " = transform.Find(\"" + totalInfo[i].path + "\").GetComponent<" + totalInfo[i].type + ">();\n");
                }
                sb.Append("\n");
                sb.Append("            return _" + FirstToLower(totalInfo[i].name) + ";\n");
                sb.Append("        }\n");
                sb.Append("    }\n");
                writer.Write(sb);
                sb.Remove(0, sb.Length);
            }

            // 
            sb.Append("}");
            writer.Write(sb);
            sb.Remove(0, sb.Length);
            if (reCreate)
            {
                Debug.Log(viewFilePath + "!");
            }
            else
            {
                Debug.Log(viewFilePath + "!");
            }

        }
        catch (IOException ex)
        {
            Debug.LogError(string.Format("An IOException has been thrown when make UI View code with name is {0}!", GO.name));
            Debug.LogException(ex);
        }
        finally
        {
            if (writer != null)
            {
                writer.Close();
            }
            if (viewFile != null)
            {
                viewFile.Close();
            }
        }
    }

    // CSharpLogic
    static void MakeLogicCodeCSharp(GameObject GO, string folderPath, List<ComponentInfo> totalInfo)
    {
        FileStream logicFile = null;
        StreamWriter writer = null;
        try
        {
            string logicFilePath = folderPath + GO.name + "Logic.cs";
            string logicFileClassName = GO.name + "Logic";
            if (File.Exists(logicFilePath)) return; // Logic

            logicFile = new FileStream(logicFilePath, FileMode.Create);
            writer = new StreamWriter(logicFile);
            StringBuilder sb = new StringBuilder();

            // 
            sb.Append("using System;\n");
            sb.Append("using UnityEngine;\n\n");
            sb.Append("public class " + logicFileClassName + " : UIBase\n");
            sb.Append("{\n");
            sb.Append("    private " + GO.name + "View" + " View;\n\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // Init
            sb.Append("    public override UIBase Init(Action<GameObject> onLoaded = null)\n");
            sb.Append("    {\n");
            sb.Append("        uiInfo = new UIInfo(UILayer.Normal, UIShowMode.Normal);\n\n");
            sb.Append("        string prefabPath = \"" + AssetDatabase.GetAssetPath(GO) + "\";\n");
            sb.Append("        LoadPrefab(prefabPath, onLoaded);\n");
            sb.Append("        return this;\n");
            sb.Append("    }\n\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // BindUIEvent
            sb.Append("    protected override void BindUIEvent()\n");
            sb.Append("    {\n");
            for (int i = 0; i < totalInfo.Count; i++)
            {
                if(totalInfo[i].name.StartsWith("btn") || totalInfo[i].name.StartsWith("Btn"))
                {
                    sb.Append("        UIEventHandler.Get(View." + totalInfo[i].name + ").SetOnClick(OnClick" + FirstToUpper(totalInfo[i].name) + ");\n");
                    writer.Write(sb);
                    sb.Remove(0, sb.Length);
                }
            }
            sb.Append("    }\n\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // OnClickBtn
            for (int i = 0; i < totalInfo.Count; i++)
            {
                if(totalInfo[i].name.StartsWith("btn") || totalInfo[i].name.StartsWith("Btn"))
                {
                    sb.Append("    private void OnClick" + FirstToUpper(totalInfo[i].name) + "()\n");
                    sb.Append("    {\n");
                    sb.Append("        //todo\n");
                    sb.Append("    }\n\n");
                    writer.Write(sb);
                    sb.Remove(0, sb.Length);
                }
            }

            // InitView
            sb.Append("    protected override void InitView()\n");
            sb.Append("    {\n");
            sb.Append("        View = _mod.AddComponent<" + GO.name + "View" + ">();\n");
            sb.Append("    }\n\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // ReleaseEvent
            sb.Append("    protected override void ReleaseEvent()\n");
            sb.Append("    {\n");
            for (int i = 0; i < totalInfo.Count; i++)
            {
                if (totalInfo[i].name.StartsWith("btn") || totalInfo[i].name.StartsWith("Btn"))
                {
                    sb.Append("        UIEventHandler.Clear(View." + totalInfo[i].name + ");\n");
                    writer.Write(sb);
                    sb.Remove(0, sb.Length);
                }
            }
            sb.Append("        base.ReleaseEvent();\n");
            sb.Append("    }\n");
            writer.Write(sb);
            sb.Remove(0, sb.Length);

            // 
            sb.Append("}");
            writer.Write(sb);
            sb.Remove(0, sb.Length);
            Debug.Log(logicFilePath + "!");
        }
        catch (IOException ex)
        {
            Debug.LogError(string.Format("An IOException has been thrown when make UI Logic code with name is {0}!", GO.name));
            Debug.LogException(ex);
            return;
        }
        finally
        {
            if (writer != null)
            {
                writer.Close();
            }
            if (logicFile != null)
            {
                logicFile.Close();
            }
        }
    }
}
