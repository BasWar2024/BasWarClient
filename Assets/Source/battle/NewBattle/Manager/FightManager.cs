



namespace Battle
{
    using System;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    using System.Collections.Generic;

    public class FightManager
    {

#if _CLIENTLOGIC_
        public Action UpdateSkillPoint;
        public Action<int> OnHeroKilled;
#endif

        public void Attack(Fix64 hurt, EntityBase atker, EntityBase injured)
        {

            if (injured == null)
                return;

            if (injured.FixHp <= Fix64.Zero)
                return;

            if (injured.IsInvisible())
                hurt = Fix64.Zero;

            if (atker != null)
            {
                if (NewGameData._StatisticsModelDict.TryGetValue(atker.Id, out StatisticsModel resultModel))
                {
                    resultModel.Dps += hurt;
                }
            }

            atker?.AtkAction?.Invoke();
            injured?.BeAtkAction?.Invoke(atker, hurt);
            injured.GetHurt(Fix64.Max(hurt, Fix64.Zero));
            injured?.LowHpAction?.Invoke(injured.FixHp);
            //UnityTools.Log($"{NewGameData._UGameLogicFrame}, atker:{atker}:{atker.Id}, DPS:{hurt}, injured:{injured}:{injured.Id}, {injured.FixHp}/{injured.GetFixMaxHp()}, ""POS:{atker.Fixv3LogicPosition}  ""POS:{injured.Fixv3LogicPosition}");
#if _CLIENTLOGIC_
            if (injured.FixHp != injured.FixOriginHp)
            {
                if (injured.ModelType != ModelType.Model3D && injured.HpSprite != null && !injured.HpSprite.gameObject.activeSelf && injured.FixHp > Fix64.Zero)
                    injured.HpSprite.gameObject.SetActive(true);
            }
            else
            {
                if (injured.ModelType != ModelType.Model3D && injured.HpSprite != null && injured.HpSprite.gameObject.activeSelf && !injured.IsHero)
                    injured.HpSprite.gameObject.SetActive(false);
            }
#endif
            if (injured.FixHp <= Fix64.Zero)
            {
                injured.FixHp = Fix64.Zero;

                if (NewGameData._OpenLog)
                    UnityTools.Log($"{NewGameData._UGameLogicFrame}, {injured} die, CfgId={injured.CfgId}, id={injured.Id}");

                injured.DeadAction?.Invoke();
                atker?.ChangeAtkTargetAction?.Invoke();

                if (NewGameData._SkillModelDict.TryGetValue(injured.DeadSkillId, out SkillModel skillModel))
                {
                    NewGameData._SkillFactory.CreateSkill(injured.Fixv3LogicPosition, injured.Fixv3LogicPosition, injured, atker, skillModel);
                }

                if (injured.RebuildAction != null)
                {
                    injured.RebuildAction.Invoke(injured.Fixv3LogicPosition);
                    return;
                }

                NewGameData._EntityManager.BeKill(injured);

                if (injured is BuildingBase building)
                {
                    DestoryBuildingUpdateSkillPoint(injured);

                    //"" ""
                    if (NewGameData._BattleType == BattleType.UnionBattle)
                    {
                        if(!NewGameData._BuildingHpDict.ContainsKey(building.Id))
                            NewGameData._BuildingHpDict.Add(building.Id, 0);
                    }

#if _CLIENTLOGIC_
                    if (building.IsMain)
                    {
                        BattleTool.CameraShake(1f, new Vector3(2f, 2f, 0), 50, 90, true);
                        BattleTool.CamreaLookAtEntity(building, true, 7, 1);
                    }
                    else
                    {
                        BattleTool.CameraShake(0.2f, new Vector3(0.4f, 0.4f, 0), 20, 25, false);
                    }

                    if (NewGameData._DeadBuildingDict.TryGetValue((int)building.Type, out int count))
                    {
                        NewGameData._DeadBuildingDict[(int)building.Type] = ++count;
                    }
                    else
                    {
                        NewGameData._DeadBuildingDict[(int)building.Type] = 1;
                    }

                    UnityTools.SaveBuilding((int)building.Type);
#endif
                }
                else if (injured is SoliderBase solider && !solider.IsSummonSoldier)
                {
                    if (solider.BattlePos != null && solider.LockedAttackEntity != null && solider.LockedAttackEntity is BuildingBase build)
                    {
                        RemoveBuildingAroundPoint(solider, build);
                    }

                    if (injured is LandHero)
                    {
#if _CLIENTLOGIC_
                        foreach (var kv in NewGameData._OperOrder_HeroDict)
                        {
                            if (kv.Value == injured)
                            {
                                if (NewGameData._HeroSkillDataDict.TryGetValue(kv.Key + 5, out HeroSkillData data))
                                {
                                    data.Cd = Fix64.Zero;
                                }

                                OnHeroKilled?.Invoke((int)kv.Key);
                            }
                        }
#endif
                    }
                    else
                    {
                        if (NewGameData._DeadEntityDict.TryGetValue(solider.Id, out int amount))
                        {
                            NewGameData._DeadEntityDict[solider.Id] = amount + 1;
#if _CLIENTLOGIC_
                            UnityTools.SaveBattleDamage(solider.Id, amount + 1);
#endif
                        }
                        else
                        {
                            NewGameData._DeadEntityDict.Add(solider.Id, 1);
#if _CLIENTLOGIC_
                            UnityTools.SaveBattleDamage(solider.Id, 1);
#endif
                        }
                    }
                }
            }
        }

        public void Cure(Fix64 value, EntityBase target)
        {
            if (value == Fix64.Zero || target == null)
                return;

            target.Cure(value);

#if _CLIENTLOGIC_
            NewGameData._EffectFactory.CreateEffect("Eff_CureSingle", target.Fixv3LogicPosition, Fix64.Zero, Fix64.Zero);
#endif
        }

        public void DestoryBuildingUpdateSkillPoint(EntityBase building)
        {
            var radius = building.Radius;
            if (radius == (Fix64)1.5)
            {
                NewGameData._SkillPoints += (Fix64)2;
            }
            else if (radius == (Fix64)2)
            {
                NewGameData._SkillPoints += (Fix64)3;
            }
            else if (radius == (Fix64)2.5)
            {
                NewGameData._SkillPoints += (Fix64)4;
            }

#if _CLIENTLOGIC_
            UpdateSkillPoint?.Invoke();
#endif
        }

        public void Release()
        {
#if _CLIENTLOGIC_
            UpdateSkillPoint = null;
            OnHeroKilled = null;
#endif
        }

        public void EntityLockEntity(EntityBase attacker, EntityBase injured)
        {
            if (injured != null)
            {
                attacker.LockedAttackEntity = injured;
                injured.ListAttackMe.Add(attacker);
            }
        }

        /// <summary>
        /// ""
        /// </summary>
        public void ResetReachSignal()
        {
            foreach (var entity in NewGameData._SoldierList)
            {
                if (entity.SignalState != SignalState.None)
                {
                    entity.SignalState = SignalState.NoReachSignal;
                    entity.ListMovePath = null;
                    entity.BattlePos = null;
                }
            }
        }

        public void SignalLockBuild()
        {
            if (NewGameData._SignalBomb == null)
                return;

            Fix64 nearDistance = (Fix64)999999;
            foreach (var build in NewGameData._BuildingList)
            {
                var distance = FixVector3.Distance(build.Fixv3LogicPosition, NewGameData._SignalBomb.Entity.Fixv3LogicPosition);
                if (distance <= build.Radius + NewGameData._SignalBomb.IntArg3)
                {
                    if (distance < nearDistance)
                    {
                        NewGameData._SignalLockBuilding = build;
                        nearDistance = distance;
                    }
                }
            }
        }

        public void SetBuildingAroundPoint()
        {
            if (NewGameData._BuildingList.Count <= 0)
                return;

            foreach (var build in NewGameData._BuildingList)
            {
                var fixV2 = NewGameData._BuildingPathFindPointDict[build];

                if (fixV2 != null)
                {
                    List<BuildingAroundPoint> buildingAroundPointList = new List<BuildingAroundPoint>();
                    FixVector2 buildCenter = new FixVector2(build.Fixv3LogicPosition.x, build.Fixv3LogicPosition.z);
                    for (Fix64 i = Fix64.Zero; i < Fix64.PI2; i += Fix64.PI2 / (Fix64)18)
                    {
                        Fix64 x = buildCenter.x + build.Radius * Fix64.Cos(i);
                        Fix64 z = buildCenter.y + build.Radius * Fix64.Sin(i);
                        var v3 = new FixVector3(x, Fix64.Zero, z);
                        BuildingAroundPoint aroundPoint = NewGameData._PoolManager.Pop<BuildingAroundPoint>();
                        aroundPoint.FixV3 = v3;
                        aroundPoint.Use = false;
                        buildingAroundPointList.Add(aroundPoint);
                    }

                    NewGameData._BuildingAroundPointDict.Add(build, buildingAroundPointList);
                }
            }
        }

        public FixVector3 SetBuildingAroundPoint(BuildingBase build, EntityBase soldier, Fix64 radius)
        {
            var b2s = soldier.Fixv3LogicPosition - build.Fixv3LogicPosition;
            bool isOffset = FixVector3.Dot(NewGameData._FixRight, b2s) > Fix64.Zero ? true : false;
            var b2sModel = FixVector3.Model(b2s);
            var bsDot = FixVector3.Dot(NewGameData._FixForword, b2s);
            var model = FixVector3.Model(NewGameData._FixForword) * b2sModel;
            var cos = bsDot / model;

            Fix64 rad = Fix64.ACos(cos);

            if (isOffset)
            {
                rad = Fix64.PI - rad + Fix64.PI;
            }

            var soldierRadius = soldier.Radius / (Fix64)1.8;

            var clength = rad * radius;
            int index = (int)Fix64.Ceiling(clength / soldierRadius);

            Fix64 clengthHalf = (Fix64)1.2 * radius;
            int timeHalf = (int)Fix64.Ceiling(clengthHalf / soldierRadius);

            int maxIndex = (int)Fix64.Ceiling(Fix64.PI2 * radius / soldierRadius);

            List<BattlePos> battlePosList;
            if (build.EntityOccupyDict.TryGetValue(radius, out battlePosList))
            {

            }
            else
            {
                battlePosList = new List<BattlePos>();
                build.EntityOccupyDict.Add(radius, battlePosList);
            }

            int offectValue = NewGameData._Srand.Range(0, 2);
            offectValue = offectValue == 0 ? -1 : 1;
            int realIndex = GetBattlePosIndex(index, battlePosList, timeHalf, 0, maxIndex, offectValue);

            if (realIndex == -1)
            {
                if (radius <= Fix64.One)
                    radius = radius - (Fix64)0.001;
                else
                    radius = radius - (Fix64)0.25;

                return SetBuildingAroundPoint(build, soldier, radius);
            }

            var realClength = realIndex * soldierRadius;
            var realRad = realClength / radius;

            Fix64 x = build.Fixv3LogicPosition.x - radius * Fix64.Sin(realRad);
            Fix64 z = build.Fixv3LogicPosition.z + radius * Fix64.Cos(realRad);
            var v3 = new FixVector3(x, Fix64.Zero, z);
            var realTargetPos = v3;

            BattlePos battlePos = NewGameData._PoolManager.Pop<BattlePos>();
            battlePos.Init(realIndex, radius, realRad, soldierRadius, realTargetPos);
            battlePosList.Add(battlePos);
            soldier.BattlePos = battlePos;
            return v3;
        }

        /// <summary>
        /// ""
        /// </summary>
        /// <param name="index"></param>
        /// <param name="battlePosList"></param>
        /// <param name="offset"></param>
        /// <returns></returns>
        private int GetBattlePosIndex(int index, List<BattlePos> battlePosList, int indexHalf, int time, int maxIndex, int offsetValue, int offset = 0)
        {
            if (time > indexHalf)
                return -1;

            time += 1;

            foreach (var battlePos in battlePosList)
            {
                if (battlePos.Index == index)
                {
                    var value = Math.Abs(offset) + 1;
                    offset = offset >= 0 ? -value : value;
                    index += offset * offsetValue;
                    if (index < 0)
                    {
                        index += maxIndex;
                    }
                    else if (index >= maxIndex)
                    {
                        index -= maxIndex;
                    }
                    return GetBattlePosIndex(index, battlePosList, indexHalf, time, maxIndex, offsetValue, offset);
                }
            }

            return index;
        }

        public void RemoveBuildingAroundPoint(SoliderBase soldier, BuildingBase build)
        {
            var radius = soldier.BattlePos.Radius;
            if (build.EntityOccupyDict.TryGetValue(radius, out List<BattlePos> battlePosList))
            {
                battlePosList.Remove(soldier.BattlePos);
            }
        }

        //""，""，""，""entity""。
        public void ReSetAttackMe(EntityBase injured)
        {
            foreach (var entity in injured.ListAttackMe)
            {
                if (entity.BKilled)
                    continue;

                if (entity is BuildingBase build)
                {
                    build.Fsm.ChangeFsmState<EntityFindSoliderFsm>();
                }
                else if (entity is SoliderBase solider)
                {
                    solider.Fsm.ChangeFsmState<EntityFindBuildingFsm>();
                }
            }

            injured.ListAttackMe.Clear();
        }

        ////""。
        //public BuildingAroundPoint GetBuildingAroundPoint(EntityBase build, EntityBase solider)
        //{
        //    var aroundPointList = NewGameData._BuildingAroundPointDict[build];
        //    var minDistance = (Fix64)999999;
        //    BuildingAroundPoint nearPoint = null;
        //    foreach (var point in aroundPointList)
        //    {
        //        if (point.Use)
        //            continue;

        //        var distance = FixVector3.Distance(solider.Fixv3LogicPosition, point.FixV3);

        //        if (distance < minDistance)
        //        {
        //            minDistance = distance;
        //            nearPoint = point;
        //        }
        //    }

        //    if (nearPoint != null)
        //        nearPoint.Use = true;

        //    return nearPoint;
        //}

        //public void ReSetBuildingAroundPoint()
        //{
        //    foreach (var kv in NewGameData._BuildingAroundPointDict)
        //    {
        //        foreach (var value in kv.Value)
        //        {
        //            value.Use = false;
        //        }
        //    }
        //}
    }
}
