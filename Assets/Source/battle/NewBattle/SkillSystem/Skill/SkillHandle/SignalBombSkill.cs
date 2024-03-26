
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class SignalBombSkill : SkillBase
    {
        private enum Stage
        {
            Move = 0,
            Do = 1,
        }

        public EntityBase Entity; //""，""
        private Stage m_Stage;
        private Fix64 m_TotalTime;
        private Fix64 m_MoveTime;
        private FixVector3 m_Start2End;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase origin, EntityBase target)
        {
            base.Start(startPos, endPos, origin, target);
            m_Stage = Stage.Move;
            m_TotalTime = Fix64.Zero;
            m_Start2End = endPos - startPos;
            m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End)) / IntArg1;
#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();
            m_TotalTime += NewGameData._FixFrameLen;
            if (m_Stage == Stage.Move)
            {
                Move();
            }
            else if (m_Stage == Stage.Do)
            {
                if (m_TotalTime >= IntArg2)
                {
                    NewGameData._EntityManager.BeKill(this);
                }
            }
        }

        private void Move()
        {
            var t = m_TotalTime / m_MoveTime;
            Fixv3LogicPosition = StartPos + FixMath.MoveStraight(t, m_Start2End);

            if (t >= Fix64.One)
            {
                m_Stage = Stage.Do;
                m_TotalTime = Fix64.Zero ;
                Entity = NewGameData._PoolManager.Pop<EntityBase>();
                Entity.Fixv3LogicPosition = new FixVector3(Fixv3LogicPosition.x, Fix64.Zero, Fixv3LogicPosition.z);

#if _CLIENTLOGIC_
                NewGameData._EffectFactory.CreateEffect(StringArg2, Fixv3LogicPosition, IntArg3, IntArg2);
#endif
                DoSkill();
            }
        }

        private void DoSkill()
        {
            if (NewGameData._SignalBomb != null)
            {
                NewGameData._EntityManager.BeKill(NewGameData._SignalBomb);
            }

            NewGameData._AStar.InitStarSavePath();

            //NewGameData._FightManager.ReSetBuildingAroundPoint();
            NewGameData._SignalLockBuilding = null;
            NewGameData._SignalBomb = this;
            NewGameData._FightManager.SignalLockBuild();

            NewGameData._FightManager.ResetReachSignal();

            foreach (var entity in NewGameData._BuildingList)
            {
                BuildingBase build = entity as BuildingBase;
                build.ReSetBattlePos();
            }

            foreach (var entity in NewGameData._SoldierList)
            {
                if (entity.SignalState != SignalState.None)
                {
                    if (entity.IsStopAction())
                        continue;

                    if (entity.FlashMoveDelayTime == Fix64.Zero)
                        entity.Fsm.ChangeFsmState<EntityFindSignalFsm>();
                    else
                        entity.Fsm.ChangeFsmState<EntityMoveFlashFindSignalFsm>();
                }
            }
        }

        public override void Release()
        {
            base.Release();

            if (Entity != null)
            {
                Entity.Release();
                NewGameData._PoolManager.Push(Entity);                
                Entity = null;
            }

            if (NewGameData._SignalBomb == this)
            {
                NewGameData._SignalLockBuilding = null;
                NewGameData._SignalBomb = null;

                NewGameData._AStar.InitStarSavePath();

                foreach (var entity in NewGameData._SoldierList)
                {
                    if (entity.SignalState == SignalState.NoReachSignal)
                    {
                        entity.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                    }
                }
            }
        }
    }
}
