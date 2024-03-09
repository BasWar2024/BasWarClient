namespace GG {
    public interface IView {
        //
        void Init ();
        //
        void OnEnter (bool withAnim);
        //
        void OnExit (bool withAnim);
    }
}