using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class EntityCreateSoliderFsm : FsmState<EntityBase>
    {
        private Fix64 m_Time;
        private Fix64 m_CreateCount;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_Time = owner.OriginAtkSpeed;
            m_CreateCount = Fix64.Zero;
        }
        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
            m_Time += NewGameData._FixFrameLen;

            if (m_Time >= owner.OriginAtkSpeed)
            {
                m_Time -= owner.OriginAtkSpeed;

                var s2m = NewGameData.MapMidPos - owner.Fixv3LogicPosition;
                s2m.Normalize();
                var targetPos = owner.Fixv3LogicPosition + s2m;
                NewGameData._SkillFactory.CreateSkill(owner.Fixv3LogicPosition, targetPos, owner,
                    owner.LockedAttackEntity, NewGameData._SkillModelDict[owner.AtkSkillId]);

                m_CreateCount += Fix64.One;

                if (m_CreateCount >= owner.OriginFixAtk)
                {
                    NewGameData._EntityManager.BeKill(owner);
                }
            }
        }
    }
}
