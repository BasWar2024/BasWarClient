using System;
using UniRx.Triggers;
using UnityEngine;

namespace GG {
    public class MonoView : MonoBehaviour 
    {
        public Action onStart = null;
        public void Start () 
        {
            if (onStart != null)
            {
                onStart.Invoke();
            }
        }
    }
}