
namespace Battle
{
    using System;
    using System.Collections.Generic;

    public class FsmCompent<T> where T : class
    {
        private FsmState<T> currFsmState;
        private T owner;
        //private FsmState<T>[] states;
        private Dictionary<Type, FsmState<T>> stateDict;

        public void CreateFsm(T owner, params FsmState<T>[] states)
        {
            this.owner = owner;
            //this.states = states;

            stateDict = new Dictionary<Type, FsmState<T>>();

            foreach (FsmState<T> state in states)
            {
                stateDict.Add(state.GetType(), state);
                state.OnInit(owner);
            }
        }

        public void OnStart<TFsm>() where TFsm : FsmState<T>
        {
            currFsmState = GetFsmState<TFsm>();
            currFsmState.OnEnter(owner);
        }

        public void OnUpdate(T owner)
        {
            currFsmState.OnUpdate(owner);
        }

        public void ChangeFsmState<TFsm>() where TFsm : FsmState<T>
        {
            currFsmState.OnLeave(owner);
            var state = GetFsmState<TFsm>();
            currFsmState = state;
            state.OnEnter(owner);
        }

        public FsmState<T> GetFsmState<TFsm>() where TFsm : FsmState<T>
        {
            FsmState<T> state = null;
            stateDict.TryGetValue(typeof(TFsm), out state);

            if (state == null)
            {
                return null;
            }

            return state;
        }

        public FsmState<T> GetCurrState()
        {
            return currFsmState;
        }

        public void ReleaseAllFsmState()
        {
            //if(states != null)
            //    Array.Clear(states, 0, states.Length);

            owner = null;
            currFsmState = null;
            if (stateDict != null)
                stateDict.Clear();
        }
    }
}
