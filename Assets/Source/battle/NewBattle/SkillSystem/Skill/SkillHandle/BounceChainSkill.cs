using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class BounceChainSkill : SkillBase
    {
        private List<EntityBase> m_BlackBuildList;
        private Fix64 m_Time;
        private Fix64 m_MoveTime;
        private FixVector3 m_Start2End;
        private Fix64 m_JumpNum;
        private Fix64 m_MaxJumpNum;
        private bool m_WaitVanish;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_Time = Fix64.Zero;
            EndPos = targetEntity.Fixv3LogicPosition + targetEntity.Center;
            m_MoveTime = FixVector3.Distance(startPos, endPos) / IntArg1;
            m_Start2End = EndPos - startPos;
            m_JumpNum = Fix64.Zero;
            m_MaxJumpNum = IntArg4;
            m_BlackBuildList = new List<EntityBase>();
            m_BlackBuildList.Add(targetEntity);
            m_WaitVanish = false;
#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1, (obj) => {
                TurnForward();
            });
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_Time += NewGameData._FixFrameLen;

            if (m_WaitVanish)
            {
                
                if (m_Time >= IntArg3)
                {
                    NewGameData._EntityManager.BeKill(this);
                }
            }
            else
            {
                var t = m_Time / m_MoveTime;

                Fixv3LogicPosition = StartPos + FixMath.MoveStraight(t, m_Start2End);           

                if (t >= Fix64.One)
                {
                    StartPos = Fixv3LogicPosition;

                    DoSkill();

#if _CLIENTLOGIC_
                    if (m_JumpNum == Fix64.Zero)
                    {
                        NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, Fix64.Zero, Fix64.Zero);
                    }
                    else
                    {
                        NewGameData._EffectFactory.CreateEffect(StringArg3, EndPos, Fix64.Zero, Fix64.Zero);
                    }
#endif

                    if (m_JumpNum >= m_MaxJumpNum)
                    {
                        m_Time = Fix64.Zero;
                        m_WaitVanish = true;
                    }
                    else
                    {
                        m_JumpNum += Fix64.One;

                        EntityBase build = FindBuilding();
                        if (build == null)
                        {
                            m_Time = Fix64.Zero;
                            m_WaitVanish = true;
                        }
                        else
                        {
                            EndPos = build.Fixv3LogicPosition + build.Center;
                            m_Start2End = EndPos - StartPos;
                            m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End)) / IntArg1;
                            m_Time = Fix64.Zero;
                            TargetEntity = build;
                        }
                    }
                }
            }
        }

        private void DoSkill()
        {
            if (SkillEffectCfgId != 0)
            {
                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity, m_JumpNum);
            }
        }

        private EntityBase FindBuilding()
        {
            EntityBase nearBuild = null;
            Fix64 nearDistance = (Fix64)99999999;
            foreach (var build in NewGameData._BuildingList)
            {
                if (build.BKilled)
                    continue;

                if (m_BlackBuildList.Contains(build))
                    continue;

                var distance = FixVector3.SqrMagnitude(Fixv3LogicPosition - build.Fixv3LogicPosition);
                if (distance <= Fix64.Square(IntArg2 + build.Radius))
                {
                    if (distance < nearDistance)
                    {
                        nearDistance = distance;
                        nearBuild = build;
                    }
                }
            }

            if (nearBuild != null)
                m_BlackBuildList.Add(nearBuild);

            return nearBuild;
        }

        public override void Release()
        {
            base.Release();

            m_BlackBuildList?.Clear();
            m_BlackBuildList = null;
        }
    }
}
