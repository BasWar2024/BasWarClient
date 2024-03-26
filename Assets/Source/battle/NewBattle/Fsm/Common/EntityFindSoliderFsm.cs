
namespace Battle
{
    public class EntityFindSoliderFsm : FsmState<EntityBase>
    {
        //""，""，""
        private int m_FindSoldierFrameLen = 5;
        private int m_CurrFrameLen;
        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_CurrFrameLen = 5;
            if (owner is BuildingBase)
            {
                var building = owner as BuildingBase;
                if (building.Type == BuildingType.NorDevelop || building.Type == BuildingType.NorEconomy || building.IsConstruct)
                {
                    owner.Fsm.ChangeFsmState<EntityIdleFsm>();
                    return;
                }
            }
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);

            if (owner.GetFixAtk() == Fix64.Zero)
                return;

            m_CurrFrameLen++;

            if (m_CurrFrameLen <= m_FindSoldierFrameLen)
                return;
            else
                m_CurrFrameLen = 0;

            Fix64 minLandDistance = (Fix64)999999999999;
            Fix64 minAirDistance = (Fix64)999999999999;
            EntityBase nearestLandObj = null; //""
            EntityBase nearestAirObj = null; //""
            foreach (var solider in NewGameData._SoldierList)
            {
                if (solider.IsInvisible() || solider.IsCloak() || solider.IsSmoke())
                    continue;

                if (!GameTools.AirDefenseDetected(solider, owner))
                    continue;

                var distance = FixVector3.SqrMagnitude(solider.Fixv3LogicPosition - owner.Fixv3LogicPosition);
                if (distance <= Fix64.Square(owner.AtkRange + solider.Radius))
                {
                    if (owner.InAtkRange != Fix64.Zero && distance < Fix64.Square(owner.InAtkRange))
                    {
                        continue;
                    }

                    if (solider.IsInTheSky)
                    {
                        if (distance < minAirDistance)
                        {
                            minAirDistance = distance;
                            nearestAirObj = solider;
                        }
                    }
                    else
                    {
                        if (distance < minLandDistance)
                        {
                            minLandDistance = distance;
                            nearestLandObj = solider;
                        }
                    }
                }

                EntityBase nearestObj = null;
                if (owner.FirstAtk == 0)
                {
                    if (minLandDistance > minAirDistance)
                    {
                        nearestObj = nearestAirObj;
                    }
                    else
                    {
                        nearestObj = nearestLandObj;
                    }
                }
                else if (owner.FirstAtk == 1)
                {
                    if (nearestLandObj != null)
                    {
                        nearestObj = nearestLandObj;
                    }
                    else
                    {
                        nearestObj = nearestAirObj;
                    }
                }
                else if (owner.FirstAtk == 2)
                {
                    if (nearestAirObj != null)
                    {
                        nearestObj = nearestAirObj;
                    }
                    else
                    {
                        nearestObj = nearestLandObj;
                    }
                }

                if (nearestObj != null)
                {
                    NewGameData._FightManager.EntityLockEntity(owner, nearestObj);
                    owner.Fsm.ChangeFsmState<Entity2AtkFsm>();
                }
            }
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}

