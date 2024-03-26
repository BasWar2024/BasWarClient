using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    //""
    public class EntityMoveParabolaFsm : FsmState<EntityBase>
    {
        private Fix64 m_FixMoveElpaseTime;
        private Fix64 m_FixMoveTime;
        private FixVector3 m_Fixv3MoveDistance;
        private Fix64 m_G = (Fix64)10;
        private Fix64 m_Vy0 = Fix64.Zero;

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            m_FixMoveElpaseTime = Fix64.Zero;
            m_FixMoveTime = FixVector3.Distance(owner.OriginPos, owner.TargetPos) / owner.GetFixMoveSpeed();
            if (m_FixMoveTime == (Fix64)0)
            {
                m_FixMoveTime = (Fix64)0.1;
            }
            m_Fixv3MoveDistance = owner.TargetPos - owner.OriginPos;
            m_Vy0 = m_G * m_FixMoveTime / 2;
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
            m_FixMoveElpaseTime += NewGameData._FixFrameLen;
            Fix64 timeScale = m_FixMoveElpaseTime / m_FixMoveTime;
            FixVector3 elpaseDistance = m_Fixv3MoveDistance * timeScale;
            Fix64 y = m_Vy0 * m_FixMoveElpaseTime - (Fix64)0.5 * m_G * m_FixMoveElpaseTime * m_FixMoveElpaseTime;

            owner.Fixv3LogicPosition = owner.OriginPos + new FixVector3(elpaseDistance.x, y, elpaseDistance.z);

#if _CLIENTLOGIC_
            if (owner.Trans != null)
                owner.Trans.forward = owner.Fixv3LogicPosition.ToVector3() - owner.Fixv3LastPosition.ToVector3();
#endif


            if (timeScale >= Fix64.One)
                owner.Fsm.ChangeFsmState<EntityArriveFsm>();
        }

        public override void OnLeave(EntityBase owner)
        { 
            base.OnLeave(owner);
        }
    }
}
