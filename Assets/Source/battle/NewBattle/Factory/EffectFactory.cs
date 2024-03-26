namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
    using Spine.Unity;
    using System.Collections.Generic;
    using System;
    //using static Spine.AnimationState;
    
    public class EffectFactory
    {
        //public List<GameObject> EffectObjList = new List<GameObject>();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="path"></param>
        /// <param name="pos"></param>
        /// <param name="size">""0"",""</param>
        /// <param name="lifeTime"></param>
        /// <param name="callBack"></param>
        public Effect CreateEffect(string path, FixVector3 pos, Fix64 size, Fix64 lifeTime, Action<GameObject, Effect> callBack = null)
        {
            if (string.IsNullOrEmpty(path))
                return null;

            var effect = NewGameData._PoolManager.Pop<Effect>();

            LoadGameObjectAsync(path, effect, pos, size, lifeTime, callBack);

            return effect;
        }

        private void LoadGameObjectAsync(string path, Effect effect, FixVector3 pos, Fix64 size, Fix64 lifeTime, Action<GameObject, Effect> callBack = null)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                obj.SetActive(false);
                effect.Init(obj.transform, pos);
                obj.transform.SetParent(NewGameData.BattleMono);
                effect.Show(obj.transform, pos, size, lifeTime);

                callBack?.Invoke(obj, effect);

                NewGameData._EffectList.Add(effect);

                return true;
            }, true, null, NewGameData._AssetOriginPos);
        }

        public Effect CreateBuffEffect(string path, FixVector3 pos, Fix64 size, Fix64 lifeTime, Action<GameObject, Effect> callBack = null)
        {
            if (string.IsNullOrEmpty(path))
                return null;

            var effect = NewGameData._PoolManager.Pop<Effect>();

            LoadBuffGameObjectAsync(path, effect, pos, size, lifeTime, callBack);

            return effect;
        }

        private void LoadBuffGameObjectAsync(string path, Effect effect, FixVector3 pos, Fix64 size, Fix64 lifeTime, Action<GameObject, Effect> callBack = null)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                obj.SetActive(false);
                effect.Init(obj.transform, pos);
                effect.Show(obj.transform, pos, size, lifeTime);

                callBack?.Invoke(obj, effect);

                return true;
            }, true, null, NewGameData._AssetOriginPos);
        }
    }
#endif
}
