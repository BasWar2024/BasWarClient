


namespace Battle
{
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class LaserStrafeSkill : SkillBase
    {
        private enum Stage
        {
            Move = 0,
            Wait = 1,
        }

        private Fix64 m_Langth;
        private Fix64 m_Lengthd2;
        private Fix64 m_Width;
        private Fix64 m_Widthd2;
        private Fix64 m_Time;
        private Stage m_Stage;
        private AtkAir m_AtkAir;

        private FixVector3 m_S2Target; //""
        private FixVector3 m_RectangleCenterPos; //""

        private bool m_DoSkillEffect;
        private List<EntityBase> m_EntityList;

#if _CLIENTLOGIC_

        private Fix64 m_LaserLangth; //""

        private FixVector3 m_Left; //""
        private FixVector3 m_LeftStartPos;
        private FixVector3 m_RightStartPos;
        private FixVector3 m_Left2Right;

        private Transform m_Laser1;
        private Transform m_Laser1End;
        private ParticleSystemRenderer m_ParticleSystemRenderer1;

        private Transform m_Laser2;
        private Transform m_Laser2End;
        private ParticleSystemRenderer m_ParticleSystemRenderer2;
#endif

        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            m_Langth = IntArg3;
            m_Width = IntArg4;
            m_Time = Fix64.Zero;
            m_Stage = Stage.Move;

            m_S2Target = targetEntity.Fixv3LogicPosition - originEntity.Fixv3LogicPosition;

            m_DoSkillEffect = false;
            m_RectangleCenterPos = originEntity.Fixv3LogicPosition + m_S2Target;
            m_EntityList = GameTools.GetTargetGroup(OriginEntity.Group, TargetGroup);

            m_Widthd2 = m_Width / 2;
            m_Lengthd2 = m_Langth / 2;

            m_AtkAir = (AtkAir)(int)IntArg5;

#if _CLIENTLOGIC_
            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });

            m_Left = FixVector3.Cross(m_S2Target, NewGameData._FixUp);
            m_Left.Normalize();

            m_LeftStartPos = m_RectangleCenterPos + m_Left * m_Widthd2;
            m_RightStartPos = m_RectangleCenterPos - m_Left * m_Widthd2;
            m_Left2Right = m_RightStartPos - m_LeftStartPos;

            GG.ResMgr.instance.LoadGameObjectAsync(StringArg1, (obj) =>
            {
                if (BKilled)
                {
                    GG.ResMgr.instance.ReleaseAsset(obj);
                    return true;
                }

                m_Laser1 = obj.transform;
                m_Laser1.SetParent(NewGameData.BattleMono);
                m_Laser1.position = Fixv3LogicPosition.ToVector3();
                m_Laser1End = m_Laser1.Find("end");

                FixVector3 endPos1 = m_RectangleCenterPos + m_Left * m_Widthd2;

                m_ParticleSystemRenderer1 = m_Laser1.GetComponent<ParticleSystemRenderer>();

                m_LaserLangth = FixVector3.Distance(endPos1, startPos);

                m_ParticleSystemRenderer1.lengthScale = -(float)m_LaserLangth;
                m_Laser1.LookAt(endPos1.ToVector3());
                m_Laser1End.position = endPos1.ToVector3();

                return true;
            }, true, null, NewGameData._AssetOriginPos);

            GG.ResMgr.instance.LoadGameObjectAsync(StringArg1, (obj) =>
            {
                if (BKilled)
                {
                    GG.ResMgr.instance.ReleaseAsset(obj);
                    return true;
                }

                m_Laser2 = obj.transform;
                m_Laser2.SetParent(NewGameData.BattleMono);
                m_Laser2.position = Fixv3LogicPosition.ToVector3();
                m_Laser2End = m_Laser2.Find("end");

                FixVector3 endPos2 = m_RectangleCenterPos - m_Left * m_Widthd2;

                m_ParticleSystemRenderer2 = m_Laser2.GetComponent<ParticleSystemRenderer>();

                m_ParticleSystemRenderer2.lengthScale = -(float)m_LaserLangth;
                m_Laser2.LookAt(endPos2.ToVector3());
                m_Laser2End.position = endPos2.ToVector3();

                return true;
            }, true, null, NewGameData._AssetOriginPos);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

            m_Time += NewGameData._FixFrameLen;
            Fix64 t = Fix64.Min(Fix64.One, m_Time / IntArg1);

            if (m_Stage == Stage.Move)
            {

#if _CLIENTLOGIC_
                if (m_Laser1 != null && m_Laser2 != null)
                {
                    var leftEndPos = m_LeftStartPos + m_Left2Right * t;
                    var rightEndPos = m_RightStartPos - m_Left2Right * t;

                    m_LaserLangth = FixVector3.Distance(leftEndPos, StartPos);

                    m_ParticleSystemRenderer1.lengthScale = -(float)m_LaserLangth;
                    m_Laser1.LookAt(leftEndPos.ToVector3());
                    m_Laser1End.position = leftEndPos.ToVector3();

                    m_ParticleSystemRenderer2.lengthScale = -(float)m_LaserLangth;
                    m_Laser2.LookAt(rightEndPos.ToVector3());
                    m_Laser2End.position = rightEndPos.ToVector3();
                }
#endif

                if (!m_DoSkillEffect)
                {
                    if (m_Time >= IntArg1 / 2)
                    {
                        m_DoSkillEffect = true;

                        foreach (var targetEntity in m_EntityList)
                        {
                            if (!GameTools.RangeSkillAirDefenseDetected(targetEntity, m_AtkAir))
                                continue;

                            if (FixMath.Rectangle(targetEntity, m_RectangleCenterPos, m_S2Target, m_Lengthd2, m_Widthd2))
                            {
                                if (SkillEffectCfgId != 0)
                                {
                                    TriggerSkill(OriginEntity, targetEntity);
                                }
                            }
                        }
                    }
                }

                if (m_Time >= IntArg1)
                {
                    m_Time = Fix64.Zero;
                    m_Stage = Stage.Wait;
                }
            }
            else if (m_Stage == Stage.Wait)
            {
                if (m_Time >= IntArg2)
                {
                    NewGameData._EntityManager.BeKill(this);
                }
            }
        }

        public override void UpdateRenderPosition(float interpolation)
        {
            
        }

        public override void Release()
        {
            base.Release();

            m_EntityList = null;

#if _CLIENTLOGIC_

            if (m_Laser1 != null)
            {
                GG.ResMgr.instance.ReleaseAsset(m_Laser1.gameObject);
            }

            if (m_Laser2 != null)
            {
                GG.ResMgr.instance.ReleaseAsset(m_Laser2.gameObject);
            }

            m_Laser1 = null;
            m_Laser1End = null;
            m_ParticleSystemRenderer1 = null;

            m_Laser2 = null;
            m_Laser2End = null;
            m_ParticleSystemRenderer2 = null;
#endif
        }
    }
}
