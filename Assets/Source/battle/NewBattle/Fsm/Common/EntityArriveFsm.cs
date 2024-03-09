
namespace Battle
{
    public class EntityArriveFsm : FsmState<EntityBase>
    {
        public override void OnInit(EntityBase owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);
            if (owner is BulletBase)
            {
                var bullet = (BulletBase)owner;

#if _CLIENTLOGIC_
                if (!string.IsNullOrEmpty(bullet.EffectResPath))
                    NewGameData._EffectFactory.CreateEffect(bullet.EffectResPath, bullet);
#endif

                if (bullet.IsAoe)
                {
                    var targetList = bullet.OriginEntity.ObjType == ObjectType.Soldier ? NewGameData._BuildingList : NewGameData._SoldierList;
                    foreach (var target in targetList)
                    {
                        if (FixVector3.Distance(target.Fixv3LogicPosition, bullet.TargetPos) <= bullet.AtkRange + target.Radius)
                        {
                            NewGameData._FightManager.Attack(bullet.OriginEntity.FixAtk, target);
                        }
                    }

                    if(bullet.OriginEntity.ObjType == ObjectType.Tower)
                    {
                        if (NewGameData._Hero != null)
                        {
                            if (FixVector3.Distance(NewGameData._Hero.Fixv3LogicPosition, bullet.TargetPos) <= bullet.AtkRange + NewGameData._Hero.Radius)
                            {
                                NewGameData._FightManager.Attack(bullet.OriginEntity.FixAtk, NewGameData._Hero);
                            }
                        }
                    }
                }
                else
                {
                    NewGameData._FightManager.Attack(bullet.OriginEntity.FixAtk, bullet.LockedAttackEntity);
                }
                NewGameData._EntityManager.BeKill(owner);
            }
            else if (owner is LandingShip)
            {
                LandingShip ship = (LandingShip)owner;
                ship.IsLanding = true;
                if (ship.SoliderModel != null)
                {
                    SoliderModel model = ship.SoliderModel;
                    bool horizontal = owner.TargetPos.z > 52 || owner.TargetPos.z < 6 ? true : false;
                    for (int i = 0; i < model.amount; i++)
                    {
                        var solider = NewGameData._SoliderFactory.CreateSolider(SoliderType.LandSolider,
                            new FixVector3(owner.Fixv3LogicPosition.x + (horizontal ? i * (Fix64)0.3 : Fix64.Zero),
                            Fix64.Zero, owner.Fixv3LogicPosition.z + (horizontal ? Fix64.Zero : i * (Fix64)0.3)), model);

                        solider.uuid = ship.uuid;
                        solider.Fsm.OnStart<EntityFindBuildingFsm>();
                    }
                    owner.Fsm.ChangeFsmState<EntitAirSoliderReverseFsm>();
                }
                else if (ship.HeroModel != null)
                {
                    HeroModel model = ship.HeroModel;

                    var solider = NewGameData._HeroFactory.CreateHero(SoliderType.LandHero,
                        new FixVector3(owner.Fixv3LogicPosition.x, Fix64.Zero, owner.Fixv3LogicPosition.z), model);

                    solider.Fsm.OnStart<EntityFindBuildingFsm>();

                    owner.Fsm.ChangeFsmState<EntitAirSoliderReverseFsm>();
                }
            }
            else if (owner is AirSolider)
            {
                SoliderBase solider = (SoliderBase)owner;
                if (solider.IsAtkAndReturn == 0)
                {
                    owner.Fsm.OnStart<EntityFindBuildingFsm>();
                }
                else
                {
                    owner.Fsm.OnStart<EntityCarpetAtkFsm>();
                }
            }
        }

        public override void OnUpdate(EntityBase owner)
        {
            base.OnUpdate(owner);
        }
        public override void OnLeave(EntityBase owner)
        {
            base.OnLeave(owner);
        }
    }
}

