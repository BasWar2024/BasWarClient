


namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
    using Spine.Unity;
    using System.Collections.Generic;

    public class EffectFactory
    {
        public List<GameObject> EffectObjList = new List<GameObject>();
        public void CreateEffect(string path, SkillBase originEntity)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                obj.transform.position = originEntity.TargetPos.ToVector3();

                obj.transform.SetParent(NewGameData.BattleMono);

                if (originEntity.EffectSizeEqualRange)
                    obj.transform.localScale = new Vector3((float)originEntity.AtkRange * 2, 0, (float)originEntity.AtkRange * 2);

                if (originEntity.IsLoopEffect)
                    originEntity.EffectGameObj = obj;
                else
                {
                    obj.transform.Find("Spine").GetComponent<SkeletonAnimation>().AnimationState.Complete += (entry) => {
                        ReleaseEffect(obj);
                    };
                }

                return true;
            }, true);
        }

        public void CreateEffect(string path, EntityBase originEntity)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                EffectObjList.Add(obj);
                obj.transform.position = originEntity.TargetPos.ToVector3();

                obj.transform.SetParent(NewGameData.BattleMono);

                obj.transform.Find("Spine").GetComponent<SkeletonAnimation>().AnimationState.Complete += (entry) => {
                    ReleaseEffect(obj);
                };

                return true;
            }, true);
        }

        public void CreateEffect(string path, FixVector3 targetPos)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                EffectObjList.Add(obj);
                obj.transform.position = targetPos.ToVector3();

                obj.transform.SetParent(NewGameData.BattleMono);

                obj.transform.Find("Spine").GetComponent<SkeletonAnimation>().AnimationState.Complete += (entry) => {
                    ReleaseEffect(obj);
                };

                return true;
            }, true);
        }


        public void ReleaseEffect(GameObject GameObj)
        {
            if (GameObj != null)
            {
                EffectObjList.Remove(GameObj);
                GG.ResMgr.instance.ReleaseAsset(GameObj);
            }
        }

        public void ReleaseAllEffect()
        {
            for (int i = EffectObjList.Count - 1; i >= 0; i--)
            {
                ReleaseEffect(EffectObjList[i]);
            }
            EffectObjList.Clear();
        }
    }
#endif
}