

namespace Battle
{
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    //BUFF
    public class SkillCommonDoGroupFsm : FsmState<SkillBase>
    {
        private Fix64 m_ElpaseTime;
        private Dictionary<EntityBase, bool> m_EntityDict; //
        private List<EntityBase> m_EntityList;

        public override void OnInit(SkillBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(SkillBase owner)
        {
            base.OnEnter(owner);

            m_ElpaseTime = Fix64.Zero;
            owner.ExistenceTime = Fix64.Zero;
            m_EntityDict = new Dictionary<EntityBase, bool>();

            if (owner.ApplyTo == 1)
            {
                m_EntityList = NewGameData._BuildingList;
            }
            else if (owner.ApplyTo == 0)
            {
                m_EntityList = NewGameData._SoldierList;
            }

            DoSkill(owner);

#if _CLIENTLOGIC_

            //BUFF
            if (!string.IsNullOrEmpty(owner.EffectResPath))
            {
                NewGameData._EffectFactory.CreateEffect(owner.EffectResPath, owner);
            }
#endif
        }

        public override void OnUpdate(SkillBase owner)
        {
            base.OnUpdate(owner);

            m_ElpaseTime += NewGameData._FixFrameLen;
            owner.ExistenceTime += NewGameData._FixFrameLen;

            if (owner.BuffModel == null)
                return;

            if (owner.FollowSelf) //
            {
                if (owner.OriginEntity == null) // 
                {
                    NewGameData._EntityManager.BeKill(owner);
                    return;
                }

                owner.Fixv3LogicPosition = owner.OriginEntity.Fixv3LogicPosition;
            }

            if (m_ElpaseTime >= owner.Frequency)
            {
                m_ElpaseTime -= owner.Frequency;

                DoSkill(owner);
            }

            if (owner.ExistenceTime >= owner.LifeTime)
            {
                NewGameData._EntityManager.BeKill(owner);
            }
        }

        private void DoSkill(SkillBase owner)
        {
            if (owner.BuffModel == null)
                return;

            foreach (var target in m_EntityList)
            {
                if (m_EntityDict.ContainsKey(target))
                    continue;

                if (target is LandingShip) //
                    continue;

                if (FixVector3.Distance(target.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + target.Radius)
                {
                    NewGameData._BuffFactory.CreateBuff(owner, target);
                    m_EntityDict.Add(target, false);
                }
            }

            if (owner.ApplyTo == 0)
            {
                if (NewGameData._Hero != null)
                {
                    if (!m_EntityDict.ContainsKey(NewGameData._Hero))
                    {
                        if (FixVector3.Distance(NewGameData._Hero.Fixv3LogicPosition, owner.Fixv3LogicPosition) <= owner.AtkRange + NewGameData._Hero.Radius)
                        {
                            NewGameData._BuffFactory.CreateBuff(owner, NewGameData._Hero);
                            m_EntityDict.Add(NewGameData._Hero, false);
                        }
                    }
                }
            }
        }

        public override void OnLeave(SkillBase owner)
        {
            base.OnLeave(owner);

            m_EntityDict.Clear();
            m_EntityDict = null;
        }
    }
}

