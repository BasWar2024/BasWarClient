using System.Diagnostics;
/*
 * Tencent is pleased to support the open source community by making xLua available.
 * Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
*/

using System.Collections.Generic;
using System;
using XLua;
using System.Reflection;
using System.Linq;
using UnityEngine.Events;
using UnityEngine;

//DocXLua.doc
public static class XLuaConfig
{
    /***************lua***************/
    //--------------begin lua----------------------------
    static List<string> systemExclude = new List<string> {
       "HideInInspector", "ExecuteInEditMode",
       "AddComponentMenu", "ContextMenu",
       "RequireComponent", "DisallowMultipleComponent",
       "SerializeField", "AssemblyIsEditorAssembly",
       "Attribute", "Types",
       "UnitySurrogateSelector", "TrackedReference",
       "TypeInferenceRules", "FFTWindow",
       "RPC", "Network", "MasterServer",
       "BitStream", "HostData",
       "ConnectionTesterStatus", "GUI", "EventType",
       "EventModifiers", "FontStyle", "TextAlignment",
       "TextEditor", "TextEditorDblClickSnapping",
       "TextGenerator", "TextClipping", "Gizmos",
       "ADBannerView", "ADInterstitialAd",
       "Android", "Tizen", "jvalue",
       "iPhone", "iOS", "Windows", "CalendarIdentifier",
       "CalendarUnit", "CalendarUnit",
       "ClusterInput", "FullScreenMovieControlMode",
       "FullScreenMovieScalingMode", "Handheld",
       "LocalNotification", "NotificationServices",
       "RemoteNotificationType", "RemoteNotification",
       "SamsungTV", "TextureCompressionQuality",
       "TouchScreenKeyboardType", "TouchScreenKeyboard",
       "MovieTexture", "UnityEngineInternal",
       "Terrain", "Tree", "SplatPrototype",
       "DetailPrototype", "DetailRenderMode",
       "MeshSubsetCombineUtility", "AOT", "Social", "Enumerator",
       "SendMouseEvents", "Cursor", "Flash", "ActionScript",
       "OnRequestRebuild", "Ping",
       "ShaderVariantCollection", "SimpleJson.Reflection",
       "CoroutineTween", "GraphicRebuildTracker",
       "Advertisements", "UnityEditor", "WSA",
       "EventProvider", "Apple",
       "ClusterInput", "Motion",
       "UnityEngine.UI.ReflectionMethodsCache", "NativeLeakDetection",
       "NativeLeakDetectionMode", "WWWAudioExtensions", "UnityEngine.Experimental",

       "UnityEngine.Animator","UnityEngine.StateMachineBehaviour",
       "UnityEngine.Human","UnityEngine.Joint",
       "UnityEngine.AssetBundle","UnityEngine.Cloth",
       "UnityEngine.UI.DefaultControls","ScriptableTile"
    };

    static List<string> customExclude = new List<string> {
       "MapEditor","ScriptableObjectUtility","test","ScriptableTile", "CreateOcean", "Battle", "GrayScaleCreator",
    };

    static bool isSystemExcluded(string fullName)
    {
        for (int i = 0; i < systemExclude.Count; i++)
        {
            if (fullName.Contains(systemExclude[i]))
            {
                return true;
            }
        }
        return false;
    }
    static bool isCustomExcluded(Type type)
    {
       var fullName = type.FullName;
       for (int i = 0; i < customExclude.Count; i++)
       {
           if (fullName.Contains(customExclude[i]))
           {
               return true;
           }
       }
       return false;
    }

    [LuaCallCSharp]
    public static IEnumerable<Type> LuaCallCSharp
    {
       get
       {
           List<string> namespaces = new List<string>() // 
           {
                "UnityEngine",
                "UnityEngine.UI",
                "UnityEngine.Video",
                "UnityEngine.SceneManagement",
                "DG.Tweening",
           };
           var unityTypes = (from assembly in AppDomain.CurrentDomain.GetAssemblies()
                             where !(assembly.ManifestModule is System.Reflection.Emit.ModuleBuilder)
                             from type in assembly.GetExportedTypes()
                             where type.Namespace != null && namespaces.Contains(type.Namespace) && !isSystemExcluded(type.FullName)
                                     && type.BaseType != typeof(MulticastDelegate) && !type.IsInterface && !type.IsEnum
                             select type);

           string[] customAssemblys = new string[] {
               "Assembly-CSharp",
           };
           var customTypes = (from assembly in customAssemblys.Select(s => Assembly.Load(s))
                              from type in assembly.GetExportedTypes()
                              where  !isCustomExcluded(type) && ( type.Namespace == null || !type.Namespace.StartsWith("XLua")
                                      && type.BaseType != typeof(MulticastDelegate) && !type.IsInterface && !type.IsEnum)
                              select type);
           return unityTypes.Concat(customTypes);
       }
    }

    //LuaCallCSharpdelegateCSharpCallLualuacallback
    [CSharpCallLua]
    public static List<Type> CSharpCallLua
    {
       get
       {
           var lua_call_csharp = LuaCallCSharp;
           var delegate_types = new List<Type>();
           var flag = BindingFlags.Public | BindingFlags.Instance
               | BindingFlags.Static | BindingFlags.IgnoreCase | BindingFlags.DeclaredOnly;
           foreach (var field in (from type in lua_call_csharp select type).SelectMany(type => type.GetFields(flag)))
           {
               if (typeof(Delegate).IsAssignableFrom(field.FieldType) && !isSystemExcluded(field.ToString()))
               {

                   delegate_types.Add(field.FieldType);
               }
           }

           foreach (var method in (from type in lua_call_csharp select type).SelectMany(type => type.GetMethods(flag)))
           {
               if (typeof(Delegate).IsAssignableFrom(method.ReturnType) && !isSystemExcluded(method.ToString()))
               {

                   delegate_types.Add(method.ReturnType);
               }
               foreach (var param in method.GetParameters())
               {
                   var paramType = param.ParameterType.IsByRef ? param.ParameterType.GetElementType() : param.ParameterType;
                   if (typeof(Delegate).IsAssignableFrom(paramType) && !isSystemExcluded(param.ToString()))
                   {

                       delegate_types.Add(paramType);
                   }
               }
           }
           return delegate_types.Where(t => t.BaseType == typeof(MulticastDelegate) && !hasGenericParameter(t) && !delegateHasEditorRef(t)).Distinct().ToList();
       }
    }
    //--------------end lua----------------------------

    /******************************/
    [Hotfix]
    static IEnumerable<Type> HotfixInject
    {
       get
       {
           return (from type in Assembly.Load("Assembly-CSharp").GetTypes()
                   where type.Namespace == null || !type.Namespace.StartsWith("XLua")
                   select type);
       }
    }
    //--------------begin -------------------------
    static bool hasGenericParameter(Type type)
    {
       if (type.IsGenericTypeDefinition) return true;
       if (type.IsGenericParameter) return true;
       if (type.IsByRef || type.IsArray)
       {
           return hasGenericParameter(type.GetElementType());
       }
       if (type.IsGenericType)
       {
           foreach (var typeArg in type.GetGenericArguments())
           {
               if (hasGenericParameter(typeArg))
               {
                   return true;
               }
           }
       }
       return false;
    }

    static bool typeHasEditorRef(Type type)
    {
       if (type.Namespace != null && (type.Namespace == "UnityEditor" || type.Namespace.StartsWith("UnityEditor.")))
       {
           return true;
       }
       if (type.IsNested)
       {
           return typeHasEditorRef(type.DeclaringType);
       }
       if (type.IsByRef || type.IsArray)
       {
           return typeHasEditorRef(type.GetElementType());
       }
       if (type.IsGenericType)
       {
           foreach (var typeArg in type.GetGenericArguments())
           {
               if (typeHasEditorRef(typeArg))
               {
                   return true;
               }
           }
       }
       return false;
    }

    static bool delegateHasEditorRef(Type delegateType)
    {
       if (typeHasEditorRef(delegateType)) return true;
       var method = delegateType.GetMethod("Invoke");
       if (method == null)
       {
           return false;
       }
       if (typeHasEditorRef(method.ReturnType)) return true;
       return method.GetParameters().Any(pinfo => typeHasEditorRef(pinfo.ParameterType));
    }

    //C#Luadelegateinterface
    // AssemblydelegateCSharpCallLuaHotfixdelegatelua function
    [CSharpCallLua]
    static IEnumerable<Type> AllDelegate
    {
       get
       {
           List<Type> allTypes = new List<Type>()
           {
                typeof(Lua.DoGmDelegate),
                typeof(Action),
                typeof(Action<bool>),
                typeof(UnityAction),
                typeof(Func<GameObject, bool>),
                typeof(System.Collections.IEnumerator),
                typeof(UnityEngine.Video.VideoPlayer.EventHandler),
                typeof(OnTapDelegate),
                typeof(OnPinchDelegate),
                typeof(OnFirstFingerDragDelegate),
                typeof(OnFingerDownDelegate),
                typeof(OnFingerUpDelegate),
                typeof(OnLongPressDelegate),

           };
           return allTypes;
       }
    }
    //--------------end -------------------------

    //
    [BlackList]
    public static List<List<string>> BlackList = new List<List<string>>()  {
                new List<string>(){"System.Xml.XmlNodeList", "ItemOf"},
                new List<string>(){"UnityEngine.WWW", "movie"},
    #if UNITY_WEBGL
                new List<string>(){"UnityEngine.WWW", "threadPriority"},
    #endif
                new List<string>(){"UnityEngine.Texture2D", "alphaIsTransparency"},
                new List<string>(){"UnityEngine.Security", "GetChainOfTrustValue"},
                new List<string>(){"UnityEngine.CanvasRenderer", "onRequestRebuild"},
                new List<string>(){"UnityEngine.Light", "areaSize"},
                new List<string>(){"UnityEngine.Light", "lightmapBakeType"},
                new List<string>(){"UnityEngine.WWW", "MovieTexture"},
                new List<string>(){"UnityEngine.WWW", "GetMovieTexture"},
                new List<string>(){"UnityEngine.AnimatorOverrideController", "PerformOverrideClipListCleanup"},
    #if !UNITY_WEBPLAYER
                new List<string>(){"UnityEngine.Application", "ExternalEval"},
    #endif
                new List<string>(){"UnityEngine.GameObject", "networkView"}, //4.6.2 not support
                new List<string>(){"UnityEngine.Component", "networkView"},  //4.6.2 not support
                new List<string>(){"System.IO.FileInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
                new List<string>(){"System.IO.FileInfo", "SetAccessControl", "System.Security.AccessControl.FileSecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
                new List<string>(){"System.IO.DirectoryInfo", "SetAccessControl", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "CreateSubdirectory", "System.String", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "Create", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"UnityEngine.MonoBehaviour", "runInEditMode"},
                new List<string>(){"UnityEngine.Light","shadowRadius"},
                new List<string>(){"UnityEngine.Light","SetLightDirty"},
                new List<string>(){"UnityEngine.Light","shadowAngle"},

                new List<string>(){"UnityEngine.UI.Text", "OnRebuildRequested"},
                new List<string>(){"UnityEngine.UI.Graphic", "OnRebuildRequested"},
                new List<string>(){"UnityEngine.AnimatorControllerParameter", "name"},
                new List<string>(){"UnityEngine.AudioSettings", "GetSpatializerPluginNames"},
                new List<string>(){"UnityEngine.AudioSettings", "SetSpatializerPluginName", "System.String"},
                new List<string>(){"UnityEngine.DrivenRectTransformTracker", "StopRecordingUndo"},
                new List<string>(){"UnityEngine.DrivenRectTransformTracker", "StartRecordingUndo"},
                new List<string>(){"UnityEngine.Caching", "SetNoBackupFlag", "UnityEngine.CachedAssetBundle"},
                new List<string>(){"UnityEngine.Caching", "ResetNoBackupFlag", "UnityEngine.CachedAssetBundle"},
                new List<string>(){"UnityEngine.Caching", "SetNoBackupFlag", "System.String", "UnityEngine.Hash128"},
                new List<string>(){"UnityEngine.Caching", "ResetNoBackupFlag", "System.String", "UnityEngine.Hash128"},
                new List<string>(){"UnityEngine.Input", "IsJoystickPreconfigured", "System.String"},
                new List<string>(){"UnityEngine.LightProbeGroup", "dering"},
                new List<string>(){"UnityEngine.LightProbeGroup", "probePositions"},
                new List<string>(){"UnityEngine.Light", "SetLightDirty"},
                new List<string>(){"UnityEngine.Light", "shadowRadius"},
                new List<string>(){"UnityEngine.Light", "shadowAngle"},
                new List<string>(){"UnityEngine.ParticleSystemForceField", "FindAll"},
                new List<string>(){"UnityEngine.QualitySettings", "streamingMipmapsRenderersPerFrame"},
                new List<string>(){"UnityEngine.Texture", "imageContentsHash"},

                new List<string>(){"UnityEngine.MeshRenderer", "scaleInLightmap"},
                new List<string>(){"UnityEngine.MeshRenderer", "receiveGI"},
                new List<string>(){"UnityEngine.MeshRenderer", "stitchLightmapSeams"},
                new List<string>(){"UnityEngine.MeshRenderer", "scaleInLightmap"},
                new List<string>(){"UnityEngine.ParticleSystemRenderer", "supportsMeshInstancing"},
                new List<string>(){"UnityEngine.Light", "areaSize"},

            };

#if UNITY_2018_1_OR_NEWER
    [BlackList]
    public static Func<MemberInfo, bool> MethodFilter = (memberInfo) =>
    {
        if (memberInfo.DeclaringType.IsGenericType && memberInfo.DeclaringType.GetGenericTypeDefinition() == typeof(Dictionary<,>))
        {
            if (memberInfo.MemberType == MemberTypes.Constructor)
            {
                ConstructorInfo constructorInfo = memberInfo as ConstructorInfo;
                var parameterInfos = constructorInfo.GetParameters();
                if (parameterInfos.Length > 0)
                {
                    if (typeof(System.Collections.IEnumerable).IsAssignableFrom(parameterInfos[0].ParameterType))
                    {
                        return true;
                    }
                }
            }
            else if (memberInfo.MemberType == MemberTypes.Method)
            {
                var methodInfo = memberInfo as MethodInfo;
                if (methodInfo.Name == "TryAdd" || methodInfo.Name == "Remove" && methodInfo.GetParameters().Length == 2)
                {
                    return true;
                }
            }
        }
        return false;
    };
#endif
}
