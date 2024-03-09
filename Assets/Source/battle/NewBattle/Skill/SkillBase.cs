
namespace Battle
{
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class SkillBase : EntityBase
    {
        public EntityBase OriginEntity;
        public Fix64 LifeTime;
        public Fix64 ExistenceTime; //
        public Fix64 Cure;
        public Fix64 Frequency;
        public bool FollowSelf;
        public string EffectResPath;
        public BuffModel BuffModel;
        public int ApplyTo; //0 1

#if _CLIENTLOGIC_
        public bool EffectSizeEqualRange = false; //BUFFsize
        public GameObject EffectGameObj;
        public bool IsLoopEffect = false; //
#endif

        public Dictionary<EntityBase, bool> AffectEntity;
        public new FsmCompent<SkillBase> Fsm;

        public virtual void Init(FixVector3 targetPos, EntityBase origin)
        {
            base.Init();
            TargetPos = targetPos;
            OriginEntity = origin;
            OriginPos = origin == null ? NewGameData.CreateLandShipPos : origin.Fixv3LogicPosition;
            ObjType = ObjectType.Skill;
            //Group = origin.Group;
        }

#if _CLIENTLOGIC_
        protected void UpdateSize()
        {
            Trans.localScale = new UnityEngine.Vector3((float)AtkRange * 2, 0, (float)AtkRange * 2);
        }

        protected void LookAtTarget()
        {
            GameObj.transform.LookAt(GameObj.transform.position + (TargetPos.ToVector3() - NewGameData.CreateLandShipPos.ToVector3()));
        }
#endif

        public new virtual void Release()
        {
            base.Release();
            OriginEntity = null;
            AffectEntity?.Clear();
            AffectEntity = null;
        }
    }
}
