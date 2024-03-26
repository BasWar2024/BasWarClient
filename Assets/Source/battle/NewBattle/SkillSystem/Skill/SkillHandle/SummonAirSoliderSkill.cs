

namespace Battle
{
    //""
    public class SummonAirSoliderSkill : SkillBase
    {
        private Fix64 m_TotalTime;
        private Fix64 m_Time;
        private EntityBase m_LockBuilding;
        private EntityBase m_OriginEntity; //""

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_TotalTime = Fix64.Zero;
            m_Time = Fix64.Zero;

            m_LockBuilding = GameTools.FindLockNearestBuilding(Fixv3LogicPosition);

            if (m_LockBuilding == null)
            {
                m_LockBuilding = NewGameData._PoolManager.Pop<EntityBase>();
                m_LockBuilding.Fixv3LogicPosition = new FixVector3(endPos.x, Fix64.Zero, endPos.z);
            }
            else
            {
                m_LockBuilding.Fixv3LogicPosition = new FixVector3(m_LockBuilding.Fixv3LogicPosition.x,
                    Fix64.Zero, m_LockBuilding.Fixv3LogicPosition.z);
            }

            m_OriginEntity = NewGameData._PoolManager.Pop<EntityBase>();
            m_OriginEntity.Fixv3LogicPosition = NewGameData.CreateLandShipPos;

        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_TotalTime += NewGameData._FixFrameLen;
            m_Time += NewGameData._FixFrameLen;

            if (m_TotalTime >= IntArg1)
            {
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            if (m_Time >= IntArg2)
            {
                m_Time -= IntArg2;

                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, m_OriginEntity, m_LockBuilding);
            }
        }

        public override void Release()
        {
            base.Release();
            //if(m_LockBuilding != null && !(m_LockBuilding is BuildingBase))
            //    NewGameData._PoolManager.Push(m_LockBuilding);

            m_LockBuilding = null;
            //if(m_OriginEntity != null)
            //    NewGameData._PoolManager.Push(m_OriginEntity);

            m_OriginEntity = null;
        }
    }
}
