using System;

namespace GG {
    [AttributeUsage (AttributeTargets.Class, AllowMultiple = false)]
    public class ResServiceAttribute : ManagerAttribute {
        public ResServiceAttribute (string tag) : base (tag) { }
    }
}