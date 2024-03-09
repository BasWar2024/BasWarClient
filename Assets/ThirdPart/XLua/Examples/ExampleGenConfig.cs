// /*
//  * Tencent is pleased to support the open source community by making xLua available.
//  * Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
//  * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//  * http://opensource.org/licenses/MIT
//  * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
// */

// using System.Collections.Generic;
// using System;
// using UnityEngine;
// using XLua;
// //using System.Reflection;
// //using System.Linq;

// //DocXLua.doc
// public static class ExampleGenConfig
// {
//     //luaC#C#Unity API
//     [LuaCallCSharp]
//     public static List<Type> LuaCallCSharp = new List<Type>() {
//                 typeof(System.Object),
//                 typeof(UnityEngine.Object),
//                 typeof(Vector2),
//                 typeof(Vector3),
//                 typeof(Vector4),
//                 typeof(Quaternion),
//                 typeof(Color),
//                 typeof(Ray),
//                 typeof(Bounds),
//                 typeof(Ray2D),
//                 typeof(Time),
//                 typeof(GameObject),
//                 typeof(Component),
//                 typeof(Behaviour),
//                 typeof(Transform),
//                 typeof(Resources),
//                 typeof(TextAsset),
//                 typeof(Keyframe),
//                 typeof(AnimationCurve),
//                 typeof(AnimationClip),
//                 typeof(MonoBehaviour),
//                 typeof(ParticleSystem),
//                 typeof(SkinnedMeshRenderer),
//                 typeof(Renderer),
//                 typeof(MaterialPropertyBlock),
//                 typeof(WWW),
//                 typeof(Light),
//                 typeof(Mathf),
//                 typeof(System.Collections.Generic.List<int>),
//                 typeof(Action<string>),
//                 typeof(UnityEngine.Debug),
//                 typeof(DG.Tweening.Tweener),
//                 typeof(DG.Tweening.Tween),
//                 typeof(DG.Tweening.DOTween),
//                 typeof(DG.Tweening.TweenCallback),
//                 typeof(DG.Tweening.ShortcutExtensions),
//                 typeof(DG.Tweening.ShortcutExtensions50),
//                 typeof(DG.Tweening.TweenExtensions),
//                 typeof(DG.Tweening.TweenParams),
//             };

//     //C#Luadelegateinterface
//     [CSharpCallLua]
//     public static List<Type> CSharpCallLua = new List<Type>() {
//                 typeof(Action),
//                 typeof(Func<double, double, double>),
//                 typeof(Action<string>),
//                 typeof(Action<double>),
//                 typeof(UnityEngine.Events.UnityAction),
//                 typeof(System.Collections.IEnumerator)
//             };

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
// }
