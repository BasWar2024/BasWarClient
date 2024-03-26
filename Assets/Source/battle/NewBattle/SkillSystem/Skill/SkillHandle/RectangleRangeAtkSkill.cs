# if _CLIENTLOGIC_
using UnityEngine;
#endif
namespace Battle
{
    using System.Collections.Generic;
    public class RectangleRangeAtkSkill : SkillBase
    {
        private Fix64 m_TotalTime;
        //private Fix64 m_MoveTime;
        //private FixVector3 m_Start2End;
        private List<EntityBase> m_EntityList;

        private Fix64 m_Lengthd2;
        private Fix64 m_Widthd2;
        private FixVector3 m_OriginPos;
        private FixVector3 m_Forword;
        private FixVector3 m_RectCenter;
        private AtkAir m_AtkAir;

#if _CLIENTLOGIC_
        private ParticleSystemRenderer m_ParticleSystemRenderer;
        private Transform m_LaserStart;
        private Transform m_LaserEnd;
#endif

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase origin, EntityBase target)
        {
            base.Start(startPos, endPos, origin, target);
            m_TotalTime = Fix64.Zero;

            m_EntityList = GameTools.GetTargetGroup(OriginEntity.Group, TargetGroup);
            m_Lengthd2 = IntArg1 / 2;
            m_Widthd2 = IntArg2 / 2;
            m_OriginPos = OriginEntity.Fixv3LogicPosition;
            m_Forword = TargetEntity.Fixv3LogicPosition - m_OriginPos;
            m_Forword = new FixVector3(m_Forword.x, Fix64.Zero, m_Forword.z);
            m_Forword.Normalize();
            m_AtkAir = (AtkAir)(int)IntArg3;

            //""
            Set4Vertex();

#if _CLIENTLOGIC_
            CreateFromPrefab(StringArg1, CreateObjCallBack);
#endif
            Fixv3LogicPosition = startPos;
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();
            m_TotalTime += NewGameData._FixFrameLen;

            if (m_TotalTime >= (Fix64)1)
            {
                NewGameData._EntityManager.BeKill(this);
            }
        }

#if _CLIENTLOGIC_
        private void CreateObjCallBack(GameObject gameObject)
        {
            m_ParticleSystemRenderer = GameObj.GetComponent<ParticleSystemRenderer>();
            m_LaserStart = GameObj.transform.Find("start");
            m_LaserEnd = GameObj.transform.Find("end");
            var mainParticle = GameObj.GetComponent<ParticleSystem>();
            mainParticle.Clear();
            mainParticle.time = 0;
            mainParticle.startSize = (float)IntArg2;
            mainParticle.Play();
            var startChildCount = m_LaserStart.childCount;
            for (int i = 0; i < startChildCount; i++)
            {
                ParticleSystem ps = m_LaserStart.GetChild(i).GetComponent<ParticleSystem>();
                ps.Clear();
                ps.time = 0;
                ps.startSize = (float)IntArg2;
                ps.Play();
            }

            var endChildCount = m_LaserEnd.childCount;
            for (int i = 0; i < endChildCount; i++)
            {
                ParticleSystem ps = m_LaserEnd.GetChild(i).GetComponent<ParticleSystem>();
                ps.Clear();
                ps.time = 0;
                ps.startSize = (float)IntArg2;
                ps.Play();
            }

            UpdateLaserPos();
        }

        private void UpdateLaserPos()
        {
            if (m_ParticleSystemRenderer != null)
            {
                Vector3 atkPos = (Fixv3LogicPosition + OriginEntity.Center + OriginEntity.AtkSkillShowRadius * m_Forword).ToVector3();

                Vector3 endPos = atkPos + m_Forword.ToVector3() * (float)m_Lengthd2 * 2;
                var startToEnd = endPos - atkPos;
                Trans.position = atkPos;

                m_ParticleSystemRenderer.lengthScale = -startToEnd.magnitude;
                Trans.LookAt(endPos);

                m_LaserStart.position = atkPos;
                m_LaserEnd.position = endPos;
            }
        }
#endif

        private void Set4Vertex()
        {
            //var x = m_Forword.x;
            //var z = m_Forword.z;
            //var b = Fix64.One;
            //var a = -(z / x);

            //FixVector3 right = new FixVector3(a, Fix64.Zero, b);
            //right.Normalize();
            m_RectCenter = m_OriginPos + m_Forword * m_Lengthd2;

            //var m_P1 = m_OriginPos - right * m_Widthd2 + m_Forword * m_Length2 * (Fix64)2;
            //var m_P2 = m_OriginPos - right * m_Widthd2;
            //var m_P3 = m_OriginPos + right * m_Widthd2;
            //var m_P4 = m_OriginPos + right * m_Widthd2 + m_Forword * m_Length2 * (Fix64)2;

            foreach (var entity in m_EntityList)
            {
                if (!GameTools.RangeSkillAirDefenseDetected(entity, m_AtkAir))
                    continue;

                if (FixMath.Rectangle(entity, m_RectCenter, m_Forword, m_Lengthd2, m_Widthd2))
                {
                    TriggerSkill(OriginEntity, entity);
                }
            }

//#if _CLIENTLOGIC_
//            DrawTool.DrawRectangle(OriginEntity.Trans, m_P1.ToVector3(), m_P2.ToVector3(), m_P3.ToVector3(), m_P4.ToVector3());
//#endif
        }

        public override void Release()
        {
            base.Release();
            m_EntityList = null;

#if _CLIENTLOGIC_
            m_ParticleSystemRenderer = null;
            m_LaserStart = null;
            m_LaserEnd = null;
#endif
        }
    }
}
