using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UniRx;
using UnityEngine;
namespace GG {
    /// <summary>
    /// 
    /// 1. UI
    /// </summary>
    public class ManagerLauncher {
        Dictionary<string, IManager> mgrs = new Dictionary<string, IManager> ();

        // C# 
        public ManagerLauncher () {
            //Reflect
            List<Type> allTypes = new List<Type> ();
            //DLL ALLtype
            var assembly = Assembly.GetAssembly (typeof (ManagerLauncher));
            if (assembly == null) {
                Debug.Log ("dll is null");
            }
            allTypes = assembly.GetTypes ().ToList ();
            //
            allTypes = allTypes.Distinct ().ToList ();
            foreach (var t in allTypes) {
                if (t != null && t.BaseType != null && t.BaseType.FullName != null &&
                    t.BaseType.FullName.Contains ("ManagerBase`2")) {
                    Debug.Log ("-" + t);
                    var i = t.BaseType.GetProperty ("Inst").GetValue (null, null) as IManager;
                    mgrs.Add (t.ToString (), i);
                }
            }
            //
            foreach (var t in allTypes) {
                foreach (var iMgr in mgrs) {
                    iMgr.Value.CheckNeedClassType (t);
                }
            }
            //
            foreach (var m in mgrs) {
                m.Value.Init ();
            }
        }
    }
}