// /*
//  * Tencent is pleased to support the open source community by making xLua available.
//  * Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
//  * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//  * http://opensource.org/licenses/MIT
//  * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
// */

// using System.Collections.Generic;
// using System;
// using XLua;
// using System.Reflection;
// using System.Linq;

// //DocXLua.doc
// public static class ExampleConfig
// {
//     /***************lua***************/
//     //--------------begin lua----------------------------
//     //static List<string> exclude = new List<string> {
//     //    "HideInInspector", "ExecuteInEditMode",
//     //    "AddComponentMenu", "ContextMenu",
//     //    "RequireComponent", "DisallowMultipleComponent",
//     //    "SerializeField", "AssemblyIsEditorAssembly",
//     //    "Attribute", "Types",
//     //    "UnitySurrogateSelector", "TrackedReference",
//     //    "TypeInferenceRules", "FFTWindow",
//     //    "RPC", "Network", "MasterServer",
//     //    "BitStream", "HostData",
//     //    "ConnectionTesterStatus", "GUI", "EventType",
//     //    "EventModifiers", "FontStyle", "TextAlignment",
//     //    "TextEditor", "TextEditorDblClickSnapping",
//     //    "TextGenerator", "TextClipping", "Gizmos",
//     //    "ADBannerView", "ADInterstitialAd",
//     //    "Android", "Tizen", "jvalue",
//     //    "iPhone", "iOS", "Windows", "CalendarIdentifier",
//     //    "CalendarUnit", "CalendarUnit",
//     //    "ClusterInput", "FullScreenMovieControlMode",
//     //    "FullScreenMovieScalingMode", "Handheld",
//     //    "LocalNotification", "NotificationServices",
//     //    "RemoteNotificationType", "RemoteNotification",
//     //    "SamsungTV", "TextureCompressionQuality",
//     //    "TouchScreenKeyboardType", "TouchScreenKeyboard",
//     //    "MovieTexture", "UnityEngineInternal",
//     //    "Terrain", "Tree", "SplatPrototype",
//     //    "DetailPrototype", "DetailRenderMode",
//     //    "MeshSubsetCombineUtility", "AOT", "Social", "Enumerator",
//     //    "SendMouseEvents", "Cursor", "Flash", "ActionScript",
//     //    "OnRequestRebuild", "Ping",
//     //    "ShaderVariantCollection", "SimpleJson.Reflection",
//     //    "CoroutineTween", "GraphicRebuildTracker",
//     //    "Advertisements", "UnityEditor", "WSA",
//     //    "EventProvider", "Apple",
//     //    "ClusterInput", "Motion",
//     //    "UnityEngine.UI.ReflectionMethodsCache", "NativeLeakDetection",
//     //    "NativeLeakDetectionMode", "WWWAudioExtensions", "UnityEngine.Experimental",
//     //};

//     //static bool isExcluded(Type type)
//     //{
//     //    var fullName = type.FullName;
//     //    for (int i = 0; i < exclude.Count; i++)
//     //    {
//     //        if (fullName.Contains(exclude[i]))
//     //        {
//     //            return true;
//     //        }
//     //    }
//     //    return false;
//     //}

//     //[LuaCallCSharp]
//     //public static IEnumerable<Type> LuaCallCSharp
//     //{
//     //    get
//     //    {
//     //        List<string> namespaces = new List<string>() // 
//     //        {
//     //            "UnityEngine",
//     //            "UnityEngine.UI"
//     //        };
//     //        var unityTypes = (from assembly in AppDomain.CurrentDomain.GetAssemblies()
//     //                          where !(assembly.ManifestModule is System.Reflection.Emit.ModuleBuilder)
//     //                          from type in assembly.GetExportedTypes()
//     //                          where type.Namespace != null && namespaces.Contains(type.Namespace) && !isExcluded(type)
//     //                                  && type.BaseType != typeof(MulticastDelegate) && !type.IsInterface && !type.IsEnum
//     //                          select type);

//     //        string[] customAssemblys = new string[] {
//     //            "Assembly-CSharp",
//     //        };
//     //        var customTypes = (from assembly in customAssemblys.Select(s => Assembly.Load(s))
//     //                           from type in assembly.GetExportedTypes()
//     //                           where type.Namespace == null || !type.Namespace.StartsWith("XLua")
//     //                                   && type.BaseType != typeof(MulticastDelegate) && !type.IsInterface && !type.IsEnum
//     //                           select type);
//     //        return unityTypes.Concat(customTypes);
//     //    }
//     //}

//     ////LuaCallCSharpdelegateCSharpCallLualuacallback
//     //[CSharpCallLua]
//     //public static List<Type> CSharpCallLua
//     //{
//     //    get
//     //    {
//     //        var lua_call_csharp = LuaCallCSharp;
//     //        var delegate_types = new List<Type>();
//     //        var flag = BindingFlags.Public | BindingFlags.Instance
//     //            | BindingFlags.Static | BindingFlags.IgnoreCase | BindingFlags.DeclaredOnly;
//     //        foreach (var field in (from type in lua_call_csharp select type).SelectMany(type => type.GetFields(flag)))
//     //        {
//     //            if (typeof(Delegate).IsAssignableFrom(field.FieldType))
//     //            {
//     //                delegate_types.Add(field.FieldType);
//     //            }
//     //        }

//     //        foreach (var method in (from type in lua_call_csharp select type).SelectMany(type => type.GetMethods(flag)))
//     //        {
//     //            if (typeof(Delegate).IsAssignableFrom(method.ReturnType))
//     //            {
//     //                delegate_types.Add(method.ReturnType);
//     //            }
//     //            foreach (var param in method.GetParameters())
//     //            {
//     //                var paramType = param.ParameterType.IsByRef ? param.ParameterType.GetElementType() : param.ParameterType;
//     //                if (typeof(Delegate).IsAssignableFrom(paramType))
//     //                {
//     //                    delegate_types.Add(paramType);
//     //                }
//     //            }
//     //        }
//     //        return delegate_types.Where(t => t.BaseType == typeof(MulticastDelegate) && !hasGenericParameter(t) && !delegateHasEditorRef(t)).Distinct().ToList();
//     //    }
//     //}
//     //--------------end lua----------------------------

//     /******************************/
//     //[Hotfix]
//     //static IEnumerable<Type> HotfixInject
//     //{
//     //    get
//     //    {
//     //        return (from type in Assembly.Load("Assembly-CSharp").GetTypes()
//     //                where type.Namespace == null || !type.Namespace.StartsWith("XLua")
//     //                select type);
//     //    }
//     //}
//     //--------------begin -------------------------
//     //static bool hasGenericParameter(Type type)
//     //{
//     //    if (type.IsGenericTypeDefinition) return true;
//     //    if (type.IsGenericParameter) return true;
//     //    if (type.IsByRef || type.IsArray)
//     //    {
//     //        return hasGenericParameter(type.GetElementType());
//     //    }
//     //    if (type.IsGenericType)
//     //    {
//     //        foreach (var typeArg in type.GetGenericArguments())
//     //        {
//     //            if (hasGenericParameter(typeArg))
//     //            {
//     //                return true;
//     //            }
//     //        }
//     //    }
//     //    return false;
//     //}

//     //static bool typeHasEditorRef(Type type)
//     //{
//     //    if (type.Namespace != null && (type.Namespace == "UnityEditor" || type.Namespace.StartsWith("UnityEditor.")))
//     //    {
//     //        return true;
//     //    }
//     //    if (type.IsNested)
//     //    {
//     //        return typeHasEditorRef(type.DeclaringType);
//     //    }
//     //    if (type.IsByRef || type.IsArray)
//     //    {
//     //        return typeHasEditorRef(type.GetElementType());
//     //    }
//     //    if (type.IsGenericType)
//     //    {
//     //        foreach (var typeArg in type.GetGenericArguments())
//     //        {
//     //            if (typeHasEditorRef(typeArg))
//     //            {
//     //                return true;
//     //            }
//     //        }
//     //    }
//     //    return false;
//     //}

//     //static bool delegateHasEditorRef(Type delegateType)
//     //{
//     //    if (typeHasEditorRef(delegateType)) return true;
//     //    var method = delegateType.GetMethod("Invoke");
//     //    if (method == null)
//     //    {
//     //        return false;
//     //    }
//     //    if (typeHasEditorRef(method.ReturnType)) return true;
//     //    return method.GetParameters().Any(pinfo => typeHasEditorRef(pinfo.ParameterType));
//     //}

//     // AssemblydelegateCSharpCallLuaHotfixdelegatelua function
//     //[CSharpCallLua]
//     //static IEnumerable<Type> AllDelegate
//     //{
//     //    get
//     //    {
//     //        BindingFlags flag = BindingFlags.DeclaredOnly | BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public;
//     //        List<Type> allTypes = new List<Type>();
//     //        var allAssemblys = new Assembly[]
//     //        {
//     //            Assembly.Load("Assembly-CSharp")
//     //        };
//     //        foreach (var t in (from assembly in allAssemblys from type in assembly.GetTypes() select type))
//     //        {
//     //            var p = t;
//     //            while (p != null)
//     //            {
//     //                allTypes.Add(p);
//     //                p = p.BaseType;
//     //            }
//     //        }
//     //        allTypes = allTypes.Distinct().ToList();
//     //        var allMethods = from type in allTypes
//     //                         from method in type.GetMethods(flag)
//     //                         select method;
//     //        var returnTypes = from method in allMethods
//     //                          select method.ReturnType;
//     //        var paramTypes = allMethods.SelectMany(m => m.GetParameters()).Select(pinfo => pinfo.ParameterType.IsByRef ? pinfo.ParameterType.GetElementType() : pinfo.ParameterType);
//     //        var fieldTypes = from type in allTypes
//     //                         from field in type.GetFields(flag)
//     //                         select field.FieldType;
//     //        return (returnTypes.Concat(paramTypes).Concat(fieldTypes)).Where(t => t.BaseType == typeof(MulticastDelegate) && !hasGenericParameter(t) && !delegateHasEditorRef(t)).Distinct();
//     //    }
//     //}
//     //--------------end -------------------------

//     //
//     [BlackList]
//     public static List<List<string>> BlackList = new List<List<string>>()  {
//                 new List<string>(){"System.Xml.XmlNodeList", "ItemOf"},
//                 new List<string>(){"UnityEngine.WWW", "movie"},
//     #if UNITY_WEBGL
//                 new List<string>(){"UnityEngine.WWW", "threadPriority"},
//     #endif
//                 new List<string>(){"UnityEngine.Texture2D", "alphaIsTransparency"},
//                 new List<string>(){"UnityEngine.Security", "GetChainOfTrustValue"},
//                 new List<string>(){"UnityEngine.CanvasRenderer", "onRequestRebuild"},
//                 new List<string>(){"UnityEngine.Light", "areaSize"},
//                 new List<string>(){"UnityEngine.Light", "lightmapBakeType"},
//                 new List<string>(){"UnityEngine.WWW", "MovieTexture"},
//                 new List<string>(){"UnityEngine.WWW", "GetMovieTexture"},
//                 new List<string>(){"UnityEngine.AnimatorOverrideController", "PerformOverrideClipListCleanup"},
//     #if !UNITY_WEBPLAYER
//                 new List<string>(){"UnityEngine.Application", "ExternalEval"},
//     #endif
//                 new List<string>(){"UnityEngine.GameObject", "networkView"}, //4.6.2 not support
//                 new List<string>(){"UnityEngine.Component", "networkView"},  //4.6.2 not support
//                 new List<string>(){"System.IO.FileInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
//                 new List<string>(){"System.IO.FileInfo", "SetAccessControl", "System.Security.AccessControl.FileSecurity"},
//                 new List<string>(){"System.IO.DirectoryInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
//                 new List<string>(){"System.IO.DirectoryInfo", "SetAccessControl", "System.Security.AccessControl.DirectorySecurity"},
//                 new List<string>(){"System.IO.DirectoryInfo", "CreateSubdirectory", "System.String", "System.Security.AccessControl.DirectorySecurity"},
//                 new List<string>(){"System.IO.DirectoryInfo", "Create", "System.Security.AccessControl.DirectorySecurity"},
//                 new List<string>(){"UnityEngine.MonoBehaviour", "runInEditMode"},
//                 new List<string>(){"UnityEngine.Light","shadowRadius"},
//                 new List<string>(){"UnityEngine.Light","SetLightDirty"},
//                 new List<string>(){"UnityEngine.Light","shadowAngle"},
//             };

// #if UNITY_2018_1_OR_NEWER
//     [BlackList]
//     public static Func<MemberInfo, bool> MethodFilter = (memberInfo) =>
//     {
//         if (memberInfo.DeclaringType.IsGenericType && memberInfo.DeclaringType.GetGenericTypeDefinition() == typeof(Dictionary<,>))
//         {
//             if (memberInfo.MemberType == MemberTypes.Constructor)
//             {
//                 ConstructorInfo constructorInfo = memberInfo as ConstructorInfo;
//                 var parameterInfos = constructorInfo.GetParameters();
//                 if (parameterInfos.Length > 0)
//                 {
//                     if (typeof(System.Collections.IEnumerable).IsAssignableFrom(parameterInfos[0].ParameterType))
//                     {
//                         return true;
//                     }
//                 }
//             }
//             else if (memberInfo.MemberType == MemberTypes.Method)
//             {
//                 var methodInfo = memberInfo as MethodInfo;
//                 if (methodInfo.Name == "TryAdd" || methodInfo.Name == "Remove" && methodInfo.GetParameters().Length == 2)
//                 {
//                     return true;
//                 }
//             }
//         }
//         return false;
//     };
// #endif
// }
