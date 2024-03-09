
namespace Battle
{

    using System.Collections.Generic;

#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class EntityBase : GameObjectBase
    {
        public FsmCompent<EntityBase> Fsm;

        public GroupType Group = GroupType.None;

        public Fix64 FixOriginHp = Fix64.Zero;
        public Fix64 FixHp = Fix64.Zero;

        public Fix64 FixOriginAtk = Fix64.Zero;
        public Fix64 FixAtk = Fix64.Zero;
        public Fix64 FixAddAtk = Fix64.Zero; //BUFF
        public Fix64 FixDecAtk = Fix64.Zero; //BUFF 

        public Fix64 OriginMoveSpeed = Fix64.Zero;
        public Fix64 MoveSpeed = Fix64.One;
        public Fix64 FixAddMoveSpeed = Fix64.Zero; //BUFF
        public Fix64 FixDecMoveSpeed = Fix64.Zero; //BUFF 

        public Fix64 OriginAtkSpeed = Fix64.Zero;
        public Fix64 AtkSpeed = Fix64.Zero;
        public Fix64 FixAddAtkSpeed = Fix64.Zero; //BUFF
        public Fix64 FixDecAtkSpeed = Fix64.Zero; //BUFF 

        ///

        public Fix64 AtkRange = Fix64.Zero;

        public int BulletId;
        //public string BulletResPath;
        //public BulletType BulletType;

        public SignalState SignalState = SignalState.None;

        //
        public List<EntityBase> ListAttackMe = new List<EntityBase>();

        //()
        public List<EntityBase> ListAttackMeBullet = new List<EntityBase>();

        //
        public EntityBase LockedAttackEntity = null;

        //
        public List<ASPoint> ListMovePath;

        //
        public FixVector3 TargetPos;
        //
        public FixVector3 OriginPos;

        public bool StopAction = false; //
        public bool IsInvisible = false; //
        public bool IsInTheSky = false; //
        public Fix64 FlashMoveDelayTime = Fix64.Zero; // 0 0
        public bool IsDetonate = false; //
        public AtkType AtkType = AtkType.AtkBoth; //
        public BuildingAroundPoint BuildAroundPoint; //

        public virtual void Init()
        {
            UpdateRenderPosition(0);
            RecordLastPos();
        }

        public virtual void UpdateLogic()
        {

        }

        public void UpdateRenderPosition(float interpolation)
        {
#if _CLIENTLOGIC_
            if (BKilled || GameObj == null)
            {
                return;
            }

            if (Fixv3LastPosition == FixVector3.Zero)
                return;

            //,
            if (interpolation != 0)
            {
                Trans.localPosition = Vector3.Lerp(Fixv3LastPosition.ToVector3(), Fixv3LogicPosition.ToVector3(), interpolation);
            }
            else
            {
                Trans.localPosition = Fixv3LogicPosition.ToVector3();
            }
#endif
        }

#if _CLIENTLOGIC_
        // Spinerad
        public void UpdateSpineRenderRotation(AnimType animType)
        {
            if (ModelType == ModelType.Model2D)
            {
                if (LockedAttackEntity == null)
                    return;

                if (ObjType == ObjectType.Soldier)
                    UpdateDirection8Cos(animType);
                else if (ObjType == ObjectType.Tower)
                    UpdateDirection30Cos();
            }
        }


        //
        public void UpdateDirection8Cos(AnimType animType)
        {
            var self2lock = animType == AnimType.Atk || animType == AnimType.FlashIdle ? LockedAttackEntity.Fixv3LogicPosition - Fixv3LogicPosition : Fixv3LogicPosition - Fixv3LastPosition;
            SetAngleY(self2lock);
        }

        //
        public void UpdateDirection30Cos()
        {
            var self2lock = LockedAttackEntity.Fixv3LogicPosition - Fixv3LogicPosition;
            SetAngleY(self2lock);
        }

        private void SetAngleY(FixVector3 self2lock)
        {
            self2lock.Normalize();

            Quaternion quat = Quaternion.FromToRotation(self2lock.ToVector3(), NewGameData._FixForword.ToVector3());
            AngleY = quat.eulerAngles.y;
        }

        public void UpdateHpSprite()
        {
            if (HpSprite == null)
                return;

            HpSprite.size = new Vector2(0.75f * (float)FixHp / (float)FixOriginHp, HpSprite.size.y);
        }
#endif

        /// <summary>
        /// 
        /// </summary>
        public virtual void LoadProperties()
        {

        }

        //- 
        // 
        // @param damage 
        // @return none
        //public void BeDamage(Fix64 damage, bool isSrcCrit = false)
        //{
        //    if (false == BKilled)
        //    {
        //        //,0
        //        FixHp = FixHp - damage;

        //        if (FixHp <= Fix64.Zero)
        //        {
        //            NewGameData._EntityManager.BeKill()
        //            //BKilled = true;
        //        }
        //    }
        //}

        //- 
        // 
        // @return none.
        public void RecordLastPos()
        {
            Fixv3LastPosition = Fixv3LogicPosition;
        }

        //-
        //
        // @param position 
        // @return none
        virtual public void SetPosition(FixVector3 position)
        {
            Fixv3LogicPosition = position;
        }

        // - 
        //
        // @return 
        public FixVector3 GetPosition()
        {
            return Fixv3LogicPosition;
        }

        public void ReleaseGameObj()
        {
#if _CLIENTLOGIC_
            if (GameObj != null)
            {
                GG.ResMgr.instance.ReleaseAsset(GameObj);
                GameObj = null;
                Trans = null;
            }
#endif
        }

        public virtual void Release()
        {
            ReleaseGameObj();

            ListAttackMe?.Clear();
            ListAttackMe = null;
            ListAttackMeBullet?.Clear();
            ListAttackMeBullet = null;
            LockedAttackEntity = null;
            ListMovePath?.Clear();
            ListMovePath = null;
            BuildAroundPoint = null;
        }
    }
}
