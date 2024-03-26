
namespace Battle
{
    using System;
    using System.Collections.Generic;

    public class EntityFindBuildingFsm : FsmState<EntityBase>
    {
        private EntityBase m_Owner;
        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            m_Owner = owner;
            if (owner.BuildAroundPoint != null)
            {
                owner.BuildAroundPoint.Use = false;
                NewGameData._PoolManager.Push(owner.BuildAroundPoint);
                owner.BuildAroundPoint = null;
            }

            Fix64 minDistance = (Fix64)99999999;
            EntityBase nearestObj = null;
            foreach (var building in NewGameData._BuildingList)
            {
                if (building.BKilled)
                    continue;

                var buildingPos = new FixVector2(building.Fixv3LogicPosition.x, building.Fixv3LogicPosition.z);
                var distance = FixVector2.Distance(new FixVector2(owner.Fixv3LogicPosition.x, owner.Fixv3LogicPosition.z), buildingPos);

                if (minDistance > distance)
                {
                    if (owner.InAtkRange != Fix64.Zero && distance < owner.InAtkRange)
                    {
                        continue;
                    }

                    minDistance = distance;
                    nearestObj = building;
                }
            }

            if(nearestObj != null)
            {
                NewGameData._FightManager.EntityLockEntity(owner, nearestObj);
                if (FixVector3.SqrMagnitude(owner.Fixv3LogicPosition - owner.LockedAttackEntity.Fixv3LogicPosition) <=
                    Fix64.Square(owner.AtkRange + owner.LockedAttackEntity.Radius)) //""
                {
                    owner.Fsm.ChangeFsmState<EntityAtkFsm>();
                    return;
                }
//------------------------------------
                BuildingAroundPoint aroundPoint = NewGameData._PoolManager.Pop<BuildingAroundPoint>();
                BuildingBase build = nearestObj as BuildingBase;
                var targetPos = NewGameData._FightManager.SetBuildingAroundPoint(build, owner, build.Radius + owner.AtkRange);
                if (!owner.IsInTheSky)
                    targetPos = GameTools.BoundaryMap(targetPos);

                aroundPoint.FixV3 = targetPos;
                owner.BuildAroundPoint = aroundPoint;
                owner.Fsm.ChangeFsmState<EntityMoveFsm>();
//------------------------------------

                //if (owner.IsInTheSky)
                //{
                //    BuildingAroundPoint aroundPoint = NewGameData._PoolManager.Pop<BuildingAroundPoint>();
                //    BuildingBase build = nearestObj as BuildingBase;
                //    var targetPos = NewGameData._FightManager.SetBuildingAroundPoint(build, owner, build.Radius + owner.AtkRange);

                //    aroundPoint.FixV3 = targetPos;
                //    owner.BuildAroundPoint = aroundPoint;
                //    owner.Fsm.ChangeFsmState<EntityMoveFsm>();
                //}
                //else
                //{
                //    NewGameData._AStar.PushFindMovePathComd(owner, nearestObj, FindMovePathCallBack);
                //    //owner.Fsm.ChangeFsmState<EntityAStarMoveFsm>();
                //}
            }
        }

        private void FindMovePathCallBack(List<ASPoint> obj)
        {
            if (obj != null && obj.Count > 0)
            {
                if(m_Owner.LockedAttackEntity != null)
                    m_Owner.Fsm.ChangeFsmState<EntityAStarMoveFsm>();
                else
                    m_Owner.Fsm.ChangeFsmState<EntityIdleFsm>();
            }
            else
            {
                m_Owner.Fsm.ChangeFsmState<EntityIdleFsm>();
            }
        }

        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
            m_Owner = null;
        }
    }
}
