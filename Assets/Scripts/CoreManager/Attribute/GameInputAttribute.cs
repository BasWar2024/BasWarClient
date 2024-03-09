using System;

namespace GG {
    [AttributeUsage (AttributeTargets.Class, AllowMultiple = false)]
    public class GameInputAttribute : ManagerAttribute {
        public GameInputAttribute (string tag) : base (tag) { }
    }
}