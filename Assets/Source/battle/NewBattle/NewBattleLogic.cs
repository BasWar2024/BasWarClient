



namespace Battle
{
    using SimpleJson;
    using System;
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class NewBattleLogic
    {
        //(, )
        public bool IsBattlePause = true;

        //
        private LockStepLogic m_LockStepLogic = new LockStepLogic();
        //
        public BattleStage Stage;
        //public bool IsBattleReady = true;

#if _CLIENTLOGIC_
        public Action SkillPointsChange;
        public Action<int> WarShipSignin;
        public Action<int> UpdateTime;
        public Action<bool> ShowResult;
        public Action<string> EndBattle;
#endif

        /// <summary>
        /// JSON
        /// </summary>
        /// <param name="json"></param>
        public void Init(string json = null, BattleStage stage = BattleStage.InBattle)
        {
            NewGameData.Init();
            LoadData(json);
            //
            m_LockStepLogic.Init();
            m_LockStepLogic.SetCallUnit(this);

            //
            UnityTools.SetTimeScale(1);

            CreateBuilding();
            CreateTrap();
            NewGameData.SetBuildingAroundPoint();
            //
            IsBattlePause = false;

            Stage = stage;
        }

        public void LoadData(string json)
        {
            if (NewGameData.IsRePlay && json != null)
            {
                BattleInfo battleinfo = NewGameData.CreateBattleInfo(json);
                NewGameData._OperInfoRePlayList = battleinfo.OperInfoList;
                NewGameData._SigninPosId = battleinfo.SigninId;
                NewGameData._InitBattleModel = battleinfo.InitBattle;
                NewGameData.CreateLandShipPos = NewGameData._SigninPosId == 1 ? NewGameData._SigninPos1 : (NewGameData._SigninPosId == 2 ? NewGameData._SigninPos2 :
               (NewGameData._SigninPosId == 3 ? NewGameData._SigninPos3 : NewGameData._SigninPos4));
                if (NewGameData._OperInfoRePlayList.Count > 0)
                {
                    foreach (var oper in NewGameData._OperInfoRePlayList)
                    {
                        NewGameData._OperInfoRePlayDict.Add(oper.GameFrame, oper);
                    }
                }
            }
            else
            {
                NewGameData._InitBattleModel = NewGameData.CreateBattleModel(NewGameData._InitBattleJson);
                NewGameData._SkillPoints = (Fix64)NewGameData._InitBattleModel.MainShip.skillPoint;
            }

            if (NewGameData._InitBattleModel.SoliderList != null)
            {
                for (int i = 0; i < NewGameData._InitBattleModel.SoliderList.Count; i++)
                {
                    NewGameData._OperSoliderDict.Add((OperOrder)i + 1, NewGameData._InitBattleModel.SoliderList[i]);
                    NewGameData._DispatchDict.Add((OperOrder)i + 1, false);
                }
            }

            if (NewGameData._InitBattleModel.Hero != null)
            {
                NewGameData._OperHero = NewGameData._InitBattleModel.Hero;
                NewGameData._DispatchDict.Add(OperOrder.LaunchHero, false);
            }

            if (NewGameData._InitBattleModel.HeroSkill != null)
            {
                NewGameData._OperHeroSkill = NewGameData._InitBattleModel.HeroSkill;
                NewGameData._DispatchDict.Add(OperOrder.DoHeroSkill, false);
                NewGameData._SkillCostPointsDict.Add(OperOrder.DoHeroSkill, (Fix64)NewGameData._OperHeroSkill.originCost);
            }

            if (NewGameData._InitBattleModel.SkillList != null)
            {
                for (int i = 0; i < NewGameData._InitBattleModel.SkillList.Count; i++)
                {
                    var skillModel = NewGameData._InitBattleModel.SkillList[i];
                    NewGameData._OperSkillDict.Add((OperOrder)i + 11, skillModel);
                    NewGameData._SkillCostPointsDict.Add((OperOrder)i + 11, (Fix64)skillModel.originCost);
                }

            }

            if (NewGameData._InitBattleModel.BulletList != null)
            {
                for (int i = 0; i < NewGameData._InitBattleModel.BulletList.Count; i++)
                {
                    var bulletModel = NewGameData._InitBattleModel.BulletList[i];
                    if (!NewGameData._OperBulletDict.ContainsKey(bulletModel.cfgId))
                    {
                        NewGameData._OperBulletDict.Add(bulletModel.cfgId, bulletModel);
                    }
                }
            }

            if (NewGameData._InitBattleModel.BuffList != null)
            {
                for (int i = 0; i < NewGameData._InitBattleModel.BuffList.Count; i++)
                {
                    var buffModel = NewGameData._InitBattleModel.BuffList[i];
                    if (!NewGameData._OperBuffDict.ContainsKey(buffModel.cfgId))
                    {
                        NewGameData._OperBuffDict.Add(buffModel.cfgId, buffModel);
                    }
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public void StartBattle()
        {
            NewGameData._Srand = new SRandom(1000);
            IsBattlePause = false;
            Stage = BattleStage.InBattle;

            m_LockStepLogic.Init();
            NewGameData._UGameLogicFrame = 0;

            foreach (var building in NewGameData._BuildingList)
            {
                building.Fsm.OnStart<EntityFindSoliderFsm>();
            }
        }

        public bool AcceptOperOrder(OperOrder order, FixVector3 v3)
        {
            if (order == OperOrder.None)
                return false;

            var info = CreateOperInfo(order, v3);
            NewGameData._OperInfoPool.Enqueue(info);

            return true;
        }

        public void DoOperOrder(OperInfo oper)
        {
            if (oper.Order == 0)
                return;

            if (oper.Order <= 8) //
            {
                var soliderModel = NewGameData._OperSoliderDict[(OperOrder)oper.Order];
                if (soliderModel.type == 1)
                {
                    FixVector3 targetPos = new FixVector3((Fix64)oper.X, (Fix64)oper.Y, (Fix64)oper.Z);
                    var landship = NewGameData._SoliderFactory.CreateSolider(SoliderType.LandingShip, targetPos, soliderModel);
                    //landship.TeamNumber = oper.Order; //
                    landship.Fsm.OnStart<EntityMoveStraightFsm>();
                }
                else if (soliderModel.type == 2)
                {
                    var forword = (NewGameData.MapMidAirPos - NewGameData.CreateLandShipPos);
                    forword.Normalize();
                    for (int i = 0; i < soliderModel.amount; i++)
                    {
                        FixVector3 targetPos = new FixVector3((Fix64)oper.X, NewGameData.AirHigh, (Fix64)oper.Z);
                        var originPos = NewGameData.CreateLandShipPos - forword * ((Fix64)i * 5);
                        var airSolider = NewGameData._SoliderFactory.CreateAirSolider(SoliderType.AirSolider, originPos, targetPos, soliderModel);
                        //airSolider.TeamNumber = oper.Order; //
                        airSolider.Fsm.OnStart<EntityMoveStraightFsm>();
                    }
                }
            }
            else if (oper.Order == 9) //
            {
                var heroModel = NewGameData._OperHero;
                FixVector3 targetPos = new FixVector3((Fix64)oper.X, (Fix64)oper.Y, (Fix64)oper.Z);
                var landship = NewGameData._SoliderFactory.CreateSolider(SoliderType.LandingShip, targetPos, heroModel);
                landship.Fsm.OnStart<EntityMoveStraightFsm>();
            }
            else if (oper.Order == 10)
            {
                if (NewGameData._Hero == null)
                    return;

                var skill = NewGameData._SkillFactory.CreateHeroSkill();
                skill.Fsm.OnStart<SkillCommonDoGroupFsm>();


                var cost = NewGameData._SkillCostPointsDict[(OperOrder)oper.Order];
                NewGameData._SkillPoints -= cost;
                NewGameData._SkillCostPointsDict[(OperOrder)oper.Order] = cost + NewGameData._OperHeroSkill.addCost;

#if _CLIENTLOGIC_
                SkillPointsChange?.Invoke();
#endif
            }
            else //
            {
                var skillModel = NewGameData._OperSkillDict[(OperOrder)oper.Order];
                FixVector3 targetPos;
                SkillBase skill;
                UnityTools.Log("skillModel.type:" + skillModel.type);

                //switch (skillModel.type)
                //{
                //    case 2:
                //        targetPos = new FixVector3((Fix64)oper.X, (Fix64)oper.Y, (Fix64)oper.Z);
                //        skill = NewGameData._SkillFactory.CreateSkill(targetPos, skillModel);
                //        skill.Fsm.OnStart<SkillMoveStraightFsm>();
                //        break;
                //    case 3:
                //        targetPos = new FixVector3((Fix64)oper.X, (Fix64)oper.Y, (Fix64)oper.Z);
                //        skill = NewGameData._SkillFactory.CreateSkill(targetPos, skillModel);
                //        skill.Fsm.OnStart<SkillMoveStraightFsm>();
                //        break;
                //    case 4:
                //        targetPos = new FixVector3((Fix64)oper.X, (Fix64)oper.Y, (Fix64)oper.Z);
                //        skill = NewGameData._SkillFactory.CreateSkill(targetPos, skillModel);
                //        skill.Fsm.OnStart<SkillMoveStraightFsm>();
                //        break;
                //    case 5:
                //        break;
                //    default:
                //        break;
                //}

                targetPos = new FixVector3((Fix64)oper.X, (Fix64)oper.Y, (Fix64)oper.Z);
                skill = NewGameData._SkillFactory.CreateSkill(targetPos, skillModel);
                skill.Fsm.OnStart<SkillMoveStraightFsm>();

                var cost = NewGameData._SkillCostPointsDict[(OperOrder)oper.Order];
                NewGameData._SkillPoints -= cost;
                NewGameData._SkillCostPointsDict[(OperOrder)oper.Order] = cost + skillModel.addCost;

#if _CLIENTLOGIC_
                SkillPointsChange?.Invoke();
#endif
            }
        }

        //- 
        // Some description, can be over several lines.
        // @return value description.
        // @author
        public void UpdateLogic()
        {
            //
            if (IsBattlePause)
                return;

            //
            m_LockStepLogic.UpdateLogic();
        }

        //- 
        // 
        // @return none
        public void FrameLockLogic()
        {
            if (NewGameData.IsRePlay)
            {
                if (NewGameData._OperInfoRePlayDict.TryGetValue(NewGameData._UGameLogicFrame, out OperInfo oper))
                {
                    AcceptOperOrder((OperOrder)oper.Order, new FixVector3((Fix64)oper.X, (Fix64)oper.Y, (Fix64)oper.Z));
                }
            }

            CheckOper();

            CheckBKill();
            CheckRemove();
            CheckResult();

            RecordLastPos();

            NewGameData._Hero?.UpdateLogic();

            for (int i = 0; i < NewGameData._SkillList.Count; i++)
            {
                NewGameData._SkillList[i].UpdateLogic();
            }

            for (int i = 0; i < NewGameData._BuffList.Count; i++)
            {
                NewGameData._BuffList[i].UpdateLogic();
            }            

            for (int i = 0; i < NewGameData._BuildingList.Count; i++)
            {
                NewGameData._BuildingList[i].UpdateLogic();
            }

            for (int i = 0; i < NewGameData._TrapList.Count; i++)
            {
                NewGameData._TrapList[i].UpdateLogic();
            }

            for (int i = 0; i < NewGameData._SoldierList.Count; i++)
            {
                NewGameData._SoldierList[i].UpdateLogic();
            }

            for (int i = 0; i < NewGameData._BulletList.Count; i++)
            {
                NewGameData._BulletList[i].UpdateLogic();
            }

            NewGameData._AStar.UpdateLogic();
        }

        //
        public void CheckOper()
        {
            if (NewGameData._OperInfoPool.Count > 0)
            {
                while (NewGameData._OperInfoPool.Count > 0)
                {
                    var oper = NewGameData._OperInfoPool.Dequeue();
                    oper.GameFrame = NewGameData._UGameLogicFrame;
                    NewGameData._OperInfoList.Add(oper);
                    DoOperOrder(oper);
                }
            }
        }

        public void CheckBKill()
        {
            for (int i = 0; i < NewGameData._DeadList.Count; i++)
            {
                var entity = NewGameData._DeadList[i];

                if (entity is SkillBase)
                {
                    var skill = entity as SkillBase;
                    skill.Fsm.ChangeFsmState<SkillOverFsm>();
                }
                else
                {
                    if (entity.Fsm != null)
                    {
                        entity.Fsm.ChangeFsmState<EntityDeadFsm>();
                    }
                }

                entity.UpdateLogic();
            }
        }


        //bekill = trueadddeadlist
        public void CheckRemove()
        {

            for (int i = NewGameData._DeadList.Count - 1; i >= 0; i--)
            {
                var entity = NewGameData._DeadList[i];

                if (entity is IFightingUnits)
                {
                    for (int j = 0; j < entity.ListAttackMe.Count; j++)
                    {
                        entity.ListAttackMe[j].LockedAttackEntity = null;
                    }
                    for (int j = 0; j < entity.ListAttackMeBullet.Count; j++)
                    {
                        entity.ListAttackMeBullet[j].LockedAttackEntity = null;
                    }
                }

                entity.Release();

                if (entity is BulletBase)
                {
                    NewGameData._BulletList.Remove(entity);
                }
                else if (entity is BuffBase)
                {
                    NewGameData._BuffList.Remove(entity);
                }
                else if (entity is SkillBase)
                {
                    NewGameData._SkillList.Remove(entity);
                }
                else if (entity is BuildingBase)
                {
                    NewGameData._BuildingList.Remove(entity);
                }
                else if (entity is SoliderBase)
                {
                    if (entity is LandHero)
                        NewGameData._Hero = null;
                    else 
                        NewGameData._SoldierList.Remove(entity);
                }
                else if (entity is TrapBase)
                {
                    NewGameData._TrapList.Remove(entity);
                }

                if (entity.CanRelease)
                {
                    if (entity.Fsm != null)
                    {
                        entity.Fsm.ReleaseAllFsmState();
                        entity.Fsm = null;
                    }
                    NewGameData._DeadList.Remove(entity);
                }
            }
        }

        public void CheckResult()
        {
            if (NewGameData._Victory)
            {
                IsBattlePause = true;
                Stage = BattleStage.EndBattle;
#if _CLIENTLOGIC_
                ShowResult?.Invoke(true);

                 EndBattle endBattle = new EndBattle(NewGameData._BattleId, Appconst.BattleVersion, 1,
                     NewGameData._SigninPosId, NewGameData._OperInfoList, NewGameData._DeadEntityDict);

                var endBattleJson = JsonUtility.ToJson(endBattle);
                UnityTools.Log(endBattleJson);
                EndBattle?.Invoke(endBattleJson);
#endif
                UnityTools.Log("" + NewGameData._UGameLogicFrame);

                if (!NewGameData.IsRePlay)
                {
#if _CLIENTLOGIC_
                    RecordRePlay();
#endif
                }
            }
        }

        private void RecordRePlay()
        {
            BattleInfo info = new BattleInfo();
            info.OperInfoList = NewGameData._OperInfoList;
            info.SigninId = NewGameData._SigninPosId;
            info.InitBattle = NewGameData._InitBattleModel;
            //var json = SimpleJson.SerializeObject(info);
            var json = JsonUtility.ToJson(info);
            NewGameData.RePlayJson = json;
            UnityTools.Log(NewGameData.RePlayJson);
        }

        //- 
        // ,,,,
        // @return none
        public void UpdateRenderPosition(float interpolation)
        {
            ////
            for (int i = 0; i < NewGameData._SoldierList.Count; i++)
            {
                NewGameData._SoldierList[i].UpdateRenderPosition(interpolation);
            }

            NewGameData._Hero?.UpdateRenderPosition(interpolation);

            for (int i = 0; i < NewGameData._BulletList.Count; i++)
            {
                NewGameData._BulletList[i].UpdateRenderPosition(interpolation);
            }

            for (int i = 0; i < NewGameData._SkillList.Count; i++)
            {
                NewGameData._SkillList[i].UpdateRenderPosition(interpolation);
            }
        }

        //- 
        // 
        // @return none.
        public void RecordLastPos()
        {
            //
            for (int i = 0; i < NewGameData._SoldierList.Count; i++)
            {
                NewGameData._SoldierList[i].RecordLastPos();
            }

            NewGameData._Hero?.RecordLastPos();

            for (int i = 0; i < NewGameData._BulletList.Count; i++)
            {
                NewGameData._BulletList[i].RecordLastPos();
            }

            for (int i = 0; i < NewGameData._SkillList.Count; i++)
            {
                NewGameData._SkillList[i].RecordLastPos();
            }
        }

        private OperInfo CreateOperInfo(OperOrder order, FixVector3 v3)
        {
            OperInfo info = new OperInfo();
            info.Init(order, v3);
            return info;
        }

        private void CreateBuilding()
        {
            var buildingList = NewGameData._InitBattleModel.BuildingList;
            foreach (var model in buildingList)
            {
                var building = NewGameData._BuildingFactory.CreateBuilding(model);
                //building.Fsm.OnStart<EntityFindSoliderFsm>();
                NewGameData._AStar.SetWallPoint(building, new FixVector2(building.Fixv3LogicPosition.x, building.Fixv3LogicPosition.z), building.Radius);

                if(building.Type == BuildingType.DefenseTower)
                    building.SpineAnim.SpineAnimPlayAuto30Turn(building, "idle", true);
            }
        }

        private void CreateTrap()
        {
            var trapList = NewGameData._InitBattleModel.TrapList;
            if (trapList != null)
            {
                foreach (var model in trapList)
                {
                    var trap = NewGameData._TrapFactory.CreateTrap(model);
                    trap.Fsm.OnStart<TrapIdleFsm>();
                }
            }
        }

        public void UpdateTime1Sec()
        {
            if (Stage == BattleStage.ReadyBattle)
            {
                if (NewGameData._Time <= 0)
                {
#if _CLIENTLOGIC_
                    WarShipSignin?.Invoke(1);
                    Stage = BattleStage.WarshipSignin;
                    return;
#endif
                }
#if _CLIENTLOGIC_
                UpdateTime?.Invoke((int)NewGameData._Time);
#endif
            }
            else if(Stage == BattleStage.InBattle)
            {
                if (NewGameData._Time <= 0)
                {
                    IsBattlePause = true;
                    Stage = BattleStage.EndBattle;
#if _CLIENTLOGIC_
                    RecordRePlay();
                    ShowResult?.Invoke(false);
#endif

                    UnityTools.Log("" + NewGameData._UGameLogicFrame);
                    return;
                }
#if _CLIENTLOGIC_
                UpdateTime?.Invoke((int)NewGameData._Time);
#endif
            }
        }

        //public string GetBattleDamageJson()
        //{
            
        //}
    }
}
