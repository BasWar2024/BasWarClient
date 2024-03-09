namespace GG {
    public interface IResService {
        /// <summary>
        /// 
        /// </summary>
        void Init ();
        /// <summary>
        ///  
        /// 
        /// </summary>
        void OnStart (Callback finishCB);
        void OnServiceDisable ();
    }
}