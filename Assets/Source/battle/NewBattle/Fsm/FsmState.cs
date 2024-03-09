
namespace Battle
{
    public abstract class FsmState<T> where T : class//where TEntity : class
    {
        public virtual void OnInit(T owner)
        {

        }

        public virtual void OnEnter(T owner)
        {

        }

        public virtual void OnUpdate(T owner)
        {

        }

        public virtual void OnLeave(T owner)
        {

        }

        protected virtual void OnDestroy(T owner)
        {

        }
    }

}
