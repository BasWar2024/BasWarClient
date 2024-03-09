using System;

namespace GG {
    /// <summary>
    /// UIView UI 
    /// </summary>
    [AttributeUsage (AttributeTargets.Class, AllowMultiple = false)]
    public class UIViewAttribute : ManagerAttribute {
        // public PanelType panelType { get; private set; }
        /// <summary>
        /// 
        /// </summary>
        public string entries { get; private set; }
        /// <summary>
        ///  -1  
        /// </summary>
        public float destructionDelayed { get; private set; }
        /// <summary>
        /// Manager 
        /// </summary>
        /// <param name="tag"></param>
        /// <param name="resPath"></param>
        /// <returns></returns> 
        public UIViewAttribute (string tag, float destructionDelayed, string entries) : base (tag) {
            // this.panelType = panelType;
            this.entries = entries;
            this.destructionDelayed = destructionDelayed;
        }
    }
}