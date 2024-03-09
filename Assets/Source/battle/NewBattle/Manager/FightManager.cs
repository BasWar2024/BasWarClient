
#if _CLIENTLOGIC_
using DG.Tweening;
using UnityEngine;
#endif

namespace Battle
{
    public class FightManager
    {
        public void Attack(Fix64 hurt, EntityBase injured)
        {
            if (injured == null)
            {
                return;
            }

            if (injured.FixHp <= Fix64.Zero)
                return;

            injured.FixHp -= hurt;
            if (injured.FixHp <= (Fix64)0)
            {
                UnityTools.Log(injured + "" + NewGameData._UGameLogicFrame);
                //injured.BKilled = true;
                NewGameData._EntityManager.BeKill(injured);

                if (injured is BuildingBase)
                {
#if _CLIENTLOGIC_
                    Camera.main.DOShakePosition(0.4f, new Vector3(0.8f, 0.8f, 0), 25, 90, false);
#endif
                }
                else if (injured is LandingShip)
                {
                    var landingShip = injured as LandingShip;
                    if (!landingShip.IsLanding)
                    {
                        if (landingShip.SoliderModel != null)
                        {
                            NewGameData._DeadEntityDict.Add(landingShip.uuid, landingShip.SoliderModel.amount);
                        }
                    }
                }
                else if (injured is SoliderBase)
                {
                    var solider = injured as SoliderBase;
                    if (NewGameData._DeadEntityDict.TryGetValue(solider.uuid, out int amount))
                    {
                        NewGameData._DeadEntityDict[solider.uuid] = amount + 1;
                    }
                    else
                    {
                        NewGameData._DeadEntityDict.Add(solider.uuid, 1);
                    }
                }
            }

#if _CLIENTLOGIC_
            injured.UpdateHpSprite();
#endif
        }

        public void Cure(Fix64 value, EntityBase injured)
        {
            if (value == Fix64.Zero || injured == null)
            {
                return;
            }

            injured.FixHp += value;
            if (injured.FixHp > injured.FixOriginHp)
                injured.FixHp = injured.FixOriginHp;

#if _CLIENTLOGIC_
            injured.UpdateHpSprite();
#endif
        }

        public void ChangeAtk(EntityBase entity, Fix64 value)
        {
            if (entity == null)
                return;

            if (value > 0 && value <= entity.FixAddAtk)
                return;

            if (value < 0 && value >= entity.FixDecAtk)
                return;

            if (value > entity.FixAddAtk)
                entity.FixAddAtk = value;

            if (value < entity.FixDecAtk)
                entity.FixDecAtk = value;

            var newAtkValue = entity.FixAddAtk + entity.FixDecAtk;

            var newValue = entity.FixOriginAtk + entity.FixOriginAtk * (newAtkValue / 100); //

            entity.FixAtk = newValue;
        }

        public void ChangeAtkSpeed(EntityBase entity, Fix64 value)
        {
            if (entity == null)
                return;

            if (value > 0 && value <= entity.FixAddAtkSpeed)
                return;

            if (value < 0 && value >= entity.FixDecAtkSpeed)
                return;

            if (value > entity.FixAddAtkSpeed)
                entity.FixAddAtkSpeed = value;

            if (value < entity.FixDecAtkSpeed)
                entity.FixDecAtkSpeed = value;

            var newAtkValue = entity.FixAddAtkSpeed + entity.FixDecAtkSpeed;

            var newValue = entity.OriginAtkSpeed - entity.OriginAtkSpeed * (newAtkValue / 100); //

            entity.AtkSpeed = newValue;
        }

        public void ChangeMoveSpeed(EntityBase entity, Fix64 value)
        {
            if (entity == null)
                return;

            if (value > 0 && value <= entity.FixAddMoveSpeed)
                return;

            if (value < 0 && value >= entity.FixDecMoveSpeed)
                return;

            if (value > entity.FixAddMoveSpeed)
                entity.FixAddMoveSpeed = value;

            if (value < entity.FixDecMoveSpeed)
                entity.FixDecMoveSpeed = value;

            var newAtkValue = entity.FixAddMoveSpeed + entity.FixDecMoveSpeed;

            var newValue = entity.OriginMoveSpeed + entity.OriginMoveSpeed * (newAtkValue / 100); //
            entity.MoveSpeed = newValue;
        }

        public void StopAction(EntityBase entity)
        {
            if (entity == null)
                return;

            if (entity.StopAction)
                return;

            var stopAcionFsm = entity.Fsm.GetFsmState<EntityStopActionFsm>();

            if (stopAcionFsm == null)
                return;

            entity.StopAction = true;
            entity.Fsm.ChangeFsmState<EntityStopActionFsm>();
        }

        public void ResetAtk(EntityBase entity)
        {
            entity.FixAddAtk = Fix64.Zero;
            entity.FixDecAtk = Fix64.Zero;
            entity.FixAtk = entity.FixOriginAtk;
        }

        public void ResetAtkSpeed(EntityBase entity)
        {
            entity.FixAddAtkSpeed = Fix64.Zero;
            entity.FixDecAtkSpeed = Fix64.Zero;
            entity.AtkSpeed = entity.OriginAtkSpeed;
        }

        public void ResetMoveSpeed(EntityBase entity)
        {
            entity.FixAddMoveSpeed = Fix64.Zero;
            entity.FixDecMoveSpeed = Fix64.Zero;
            entity.MoveSpeed = entity.OriginMoveSpeed;
        }

        public void ResetStopAction(EntityBase entity)
        {
            if (entity == null)
                return;

            if (!entity.StopAction)
                return;

            entity.StopAction = false;
            if (entity is SoliderBase)
            {
                entity.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
            }
            else if (entity is BuildingBase)
            {
                entity.Fsm.ChangeFsmState<EntityFindSoliderFsm>();
            }
        }
    }
}
