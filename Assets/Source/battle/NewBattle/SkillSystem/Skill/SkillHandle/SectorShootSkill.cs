
using System.Collections.Generic;


namespace Battle
{
    public class SectorSkillBullet : EntityBase
    {
        public FixVector3 Forword;

        public override void Start()
        {
            base.Start();

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, CreateCallBack);
#endif
        }

        private void CreateCallBack()
        {
#if _CLIENTLOGIC_
            Trans.forward = Forword.ToVector3();
#endif
        }
    }

    public class SectorShootSkill : SkillBase
    {

        private Dictionary<EntityBase, FixVector3> m_BulletForwordDict;

        private Fix64 m_SumRad;
        private FixVector3 m_S2e;
        private Fix64 m_TotalTime;
        private Fix64 m_MoveTime;
        private bool m_IsAtk;
        private List<EntityBase> m_EntityList;
        private AtkAir m_AtkAir;
        private GroupType m_SelfGroup;

        public override void Init()
        {
            base.Init();

            if (m_BulletForwordDict == null)
            {
                m_BulletForwordDict = new Dictionary<EntityBase, FixVector3>();
            }
        }

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);

            m_IsAtk = false;
            m_SumRad = Fix64.Deg1ToRad * IntArg3;
            m_S2e = endPos - startPos;
            m_S2e.Normalize();

            m_MoveTime = IntArg2 / IntArg1;
            m_TotalTime = Fix64.Zero;

            Fix64 angle = IntArg3 / IntArg4;
            Fix64 startAngle = -IntArg3 / 2;

            m_AtkAir = (AtkAir)(int)IntArg5;

            m_SelfGroup = GroupType.PlayerGroup;
            if (originEntity != null)
            {
                m_SelfGroup = originEntity.Group;
            }

            for (int i = 0; i < (int)IntArg4; i++)
            {
                var forword = FixMath.Vector3Rotate(m_S2e, startAngle + i * angle);
                SectorSkillBullet bullet = NewGameData._EntityFactory.CreateEntity<SectorSkillBullet>(StringArg1, startPos, false);
                bullet.Forword = forword;
                bullet.Start();
                m_BulletForwordDict.Add(bullet, forword);
            }
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();
            m_TotalTime += NewGameData._FixFrameLen;
            var t = m_TotalTime / m_MoveTime;

            foreach (var kv in m_BulletForwordDict)
            {
                kv.Key.Fixv3LogicPosition = StartPos + kv.Value * IntArg2 * t;
            }

            if (!m_IsAtk)
            {
                if (t >= (Fix64)0.5)
                {
                    DoSkill();
                    m_IsAtk = true;
                }
            }

            if (t >= Fix64.One)
            {
                DoEffect();
                NewGameData._EntityManager.BeKill(this);
            }

        }

        private void DoSkill()
        {
            m_EntityList = GameTools.GetTargetGroup(m_SelfGroup, TargetGroup);
            foreach (var entity in m_EntityList)
            {
                if (!GameTools.RangeSkillAirDefenseDetected(entity, m_AtkAir))
                    continue;

                bool inSector = FixMath.InSector(m_S2e, StartPos, entity.Fixv3LogicPosition, IntArg2, entity.Radius, IntArg3);
                if (inSector && SkillEffectCfgId != 0)
                {
                    NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, entity);

                }
            }
        }

        private void DoEffect()
        {
#if _CLIENTLOGIC_

            foreach (var kv in m_BulletForwordDict)
            {
                NewGameData._EffectFactory.CreateEffect(StringArg2, StartPos + kv.Value * IntArg2, Fix64.Zero, Fix64.Zero);
            }
#endif
        }

        public override void Release()
        {

            foreach (var kv in m_BulletForwordDict)
            {
                kv.Key.CanRelease = true;
                NewGameData._EntityManager.BeKill(kv.Key);
            }

            m_BulletForwordDict.Clear();

            m_EntityList = null;
            base.Release();
        }
    }
}
