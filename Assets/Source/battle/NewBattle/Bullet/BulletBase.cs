

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class BulletBase : EntityBase
    {
        public EntityBase OriginEntity;
        public bool IsAoe = false;
        public string EffectResPath;

        public virtual void Init(EntityBase origin, EntityBase target, FixVector3 originPos, FixVector3 targetPos)
        {
            base.Init();
            LockedAttackEntity = target;
            OriginEntity = origin;
            OriginPos = originPos;
            TargetPos = targetPos;


#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, LookAtTarget);
#endif
        }

#if _CLIENTLOGIC_
        private void LookAtTarget()
        {
            var origin2Targer = (TargetPos - OriginPos).ToVector3();
            GameObj.transform.LookAt(GameObj.transform.position + origin2Targer);
        }
#endif

        public new virtual void Release()
        {
            base.Release();
            OriginEntity = null;
        }
    }
}
