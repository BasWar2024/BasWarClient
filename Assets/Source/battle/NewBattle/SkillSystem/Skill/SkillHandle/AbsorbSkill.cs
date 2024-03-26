#if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    public class AbsorbSkill : SkillBase
    {
        private enum Stage
        {
            Move = 0,
            DoSkill = 1,
            Return = 2,
            DoSkill1 = 3,
        }

        private Stage m_Stage;
        private Fix64 m_TotalTime;
        private Fix64 m_MoveTime;
        private FixVector3 m_Start2End;
        private int m_AtkSkillEffect;
        private FixVector3 m_trunPos;

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_Stage = Stage.Move;
            m_TotalTime = Fix64.Zero;
            m_Start2End = endPos - startPos;
            var atkSkillModel = NewGameData._SkillModelDict[originEntity.AtkSkillId];
            m_AtkSkillEffect = atkSkillModel.skillEffectCfgId;
            m_MoveTime = Fix64.Max((Fix64)0.1, FixVector3.Model(m_Start2End)) / IntArg1;

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1, (obj) =>
            {
                Trans.forward = m_Start2End.ToVector3();
            });
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_TotalTime += NewGameData._FixFrameLen;

            switch (m_Stage)
            {
                case Stage.Move:
                    Move();
                    break;
                case Stage.DoSkill:
                    DoSkill();
                    break;
                case Stage.Return:
                    Return();
                    break;
                case Stage.DoSkill1:
                    DoSkill1();
                    break;
            }
        }

        private void Move()
        {
            Fix64 t = Fix64.Min(m_TotalTime / m_MoveTime, Fix64.One);
            Fixv3LogicPosition = StartPos + FixMath.MoveStraight(t, m_Start2End);
            if (t >= Fix64.One)
            {
                m_Stage = Stage.DoSkill;

#if _CLIENTLOGIC_
                NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, Fix64.Zero, Fix64.Zero);
#endif
            }
        }

        private void DoSkill()
        {
            if (m_AtkSkillEffect != 0)
            {
                NewGameData._FightManager.Attack(OriginEntity.GetFixAtk(), OriginEntity, TargetEntity);
            }

            m_TotalTime = Fix64.Zero;
            m_Stage = Stage.Return;

            var tempStartPos = StartPos;
            StartPos = EndPos;
            EndPos = tempStartPos;
            m_Start2End = EndPos - StartPos;

            m_trunPos = StartPos + m_Start2End * (Fix64)0.5 +
                new FixVector3(Fix64.Zero, NewGameData._Srand.Range(Fix64.One, (Fix64)4), NewGameData._Srand.Range(-(Fix64)4, (Fix64)4));
#if _CLIENTLOGIC_
            if (GameObj != null)
            {
                GameObj.SetActive(false);
                GG.ResMgr.instance.ReleaseAsset(GameObj);
            }

            CreateFromPrefab(StringArg3);
#endif
        }

        private void Return()
        {
            Fix64 t = Fix64.Min(m_TotalTime / m_MoveTime, Fix64.One);

            Fixv3LogicPosition = FixMath.BezierCurve2(t, StartPos, EndPos, m_trunPos);
            if (t >= Fix64.One)
            {
                m_Stage = Stage.DoSkill1;

#if _CLIENTLOGIC_
                NewGameData._EffectFactory.CreateEffect(StringArg4, OriginEntity.Fixv3LastPosition, Fix64.Zero, Fix64.Zero);
#endif
            }
        }

        private void DoSkill1()
        {
            if (SkillEffectCfgId != 0)
            {
                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, OriginEntity);
            }

            NewGameData._EntityManager.BeKill(this);
        }

        public override void Release()
        {
            base.Release();
        }
    }
}
