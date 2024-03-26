
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class ShieldStabSkill : SkillBase
    {
        private Fix64 m_Range;
        private Fix64 m_Distance;
        private Fix64 m_LifeTime;
        private Fix64 m_Frequency;

        private FixVector3 m_Forword;
        private FixVector3 m_SkillPos;
        private Fix64 m_TotalTime;
        private Fix64 m_Time;

#if _CLIENTLOGIC_
        private Transform m_Model2;
#endif

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_Range = IntArg1;
            m_Distance = IntArg2;
            m_LifeTime = IntArg3;
            m_Frequency = IntArg4;

            m_Forword = (targetEntity.Fixv3LogicPosition - originEntity.Fixv3LogicPosition).GetNormalized();
            m_SkillPos = m_Forword * m_Distance + originEntity.Center;
            m_TotalTime = Fix64.Zero;
            m_Time = Fix64.Zero;

            originEntity.ImmuneBuff = true;

#if _CLIENTLOGIC_

            m_Model2 = null;

            CreateFromPrefab(StringArg1, (obj) =>
            {
                obj.transform.forward = -m_Forword.ToVector3();
            });

            GG.ResMgr.instance.LoadGameObjectAsync(StringArg2, (obj) =>
            {
                if (BKilled)
                {
                    GG.ResMgr.instance.ReleaseAsset(obj);
                    return true;
                }

                m_Model2 = obj.transform;
                m_Model2.forward = m_Forword.ToVector3();
                m_Model2.localScale = new Vector3((float)m_Range, (float)m_Range, (float)m_Range);

                return true;
            }, true, null, NewGameData._AssetOriginPos);
#endif

        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            if(m_TotalTime >= m_LifeTime || OriginEntity == null || OriginEntity.BKilled)
            {
                if (OriginEntity != null)
                {
                    OriginEntity.ImmuneBuff = false;
                }

                NewGameData._EntityManager.BeKill(this);
                return;
            }

            m_TotalTime += NewGameData._FixFrameLen;
            Fixv3LogicPosition = OriginEntity.Fixv3LogicPosition + m_SkillPos;

#if _CLIENTLOGIC_
            if (m_Model2 != null)
            {
                m_Model2.transform.position = Fixv3LogicPosition.ToVector3();
            }
#endif

            m_Time += NewGameData._FixFrameLen;
            if (m_Time >= m_Frequency)
            {
                DoSkill();
                m_Time -= m_Frequency;
            }
        }

        private void DoSkill()
        {
            var entityList = GameTools.GetTargetGroup(OriginEntity.Group, TargetGroup);
            foreach (var entity in entityList)
            {
                if (!GameTools.RangeSkillAirDefenseDetected(entity, AtkAir.AtkLand))
                    continue;

                if (FixMath.CircularRegion(Fixv3LogicPosition, entity.Fixv3LogicPosition, m_Range + entity.Radius))
                {
#if _CLIENTLOGIC_
                    NewGameData._EffectFactory.CreateEffect(StringArg3, entity.Fixv3LogicPosition, Fix64.One, Fix64.Zero);
#endif
                    TriggerSkill(OriginEntity, entity);
                }
            }
        }

        public override void Release()
        {
#if _CLIENTLOGIC_
            if (m_Model2 != null)
            {
                GG.ResMgr.instance.ReleaseAsset(m_Model2.gameObject);
            }

            m_Model2 = null;
#endif
            base.Release();
        }
    }
}
