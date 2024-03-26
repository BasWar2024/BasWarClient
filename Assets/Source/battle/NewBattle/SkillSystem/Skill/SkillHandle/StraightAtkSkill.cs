
namespace Battle
{
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class StraightAtkSkill : SkillBase
    {
        private Fix64 m_TotalTime;
        private Fix64 m_MoveTime;
        private FixVector3 m_Start2End;
        private List<EntityBase> m_EntityList;
        private bool m_IsNeedMove;
        private FixVector3 m_PrePos;
        private AtkAir m_AtkAir;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase origin, EntityBase target)
        {
            base.Start(startPos, endPos, origin, target);
            m_TotalTime = Fix64.Zero;
            m_IsNeedMove = IntArg1 > Fix64.Zero;
            m_AtkAir = (AtkAir)(int)IntArg3;

            if (!m_IsNeedMove) {
                Fixv3LogicPosition = endPos;
                DoSkill();
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_PrePos = endPos;

            m_Start2End = endPos - startPos;

            m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End)) / IntArg1;
#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1, (obj) => {
                if (Trans.Find("Spine"))
                {
                    var s2e = m_Start2End.ToVector3();
                    Trans.forward = s2e;
                }
                else
                {
                    TurnForward();
                }
            });

            NewGameData._EffectFactory.CreateEffect(StringArg3, endPos, IntArg2, m_MoveTime);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();
            if (!m_IsNeedMove) {
                return;
            }

            m_TotalTime += NewGameData._FixFrameLen;
            Fix64 t = m_TotalTime / m_MoveTime;

            if (t >= Fix64.One)
            {
                DoSkill();
                NewGameData._EntityManager.BeKill(this);
                return;
            }

            //""
            if (TargetEntity != null && TargetEntity.ObjType == ObjectType.Soldier && TargetEntity.Fixv3LogicPosition != m_PrePos)
            {
                m_PrePos = TargetEntity.Fixv3LogicPosition;
                EndPos = TargetEntity.Fixv3LogicPosition + TargetEntity.Center;
                StartPos = Fixv3LogicPosition;
                m_Start2End = EndPos - StartPos;
                m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End)) / IntArg1;
                m_TotalTime = Fix64.Zero;
            }
            Fixv3LogicPosition = StartPos + FixMath.MoveStraight(t, m_Start2End);

        }

        public override void Release()
        {
            base.Release();
            m_EntityList = null;

        }

        public void DoSkill()
        {
            if (IntArg2 <= Fix64.Zero)
            {
                TriggerSkill(OriginEntity, TargetEntity);
            }
            else
            {
                m_EntityList = GameTools.GetTargetGroup(OriginEntity.Group, TargetGroup);
                foreach (var entity in m_EntityList)
                {
                    if (!GameTools.RangeSkillAirDefenseDetected(entity, m_AtkAir))
                        continue;

                    if (FixMath.CircularRegion(Fixv3LogicPosition, entity.Fixv3LogicPosition, IntArg2 + entity.Radius))
                    {
                        TriggerSkill(OriginEntity, entity);
                    }
                }
            }

#if _CLIENTLOGIC_
            NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, Fix64.Zero, Fix64.Zero);
#endif
        }
    }
}
