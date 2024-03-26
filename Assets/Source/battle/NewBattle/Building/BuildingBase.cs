

namespace Battle
{
    using System;
    using System.Collections.Generic;

#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class BuildingBase : EntityBase, IFightingUnits
    {
        public bool IsMain = false;
        public string EffectResPath;
        public string DeadResPath;
        public BuildingType Type; //1--"",2--"",3--"",4--"",8--""
        public BuildingSubType SubType; //0--"",1--"",2--""
        public bool IsConstruct; //"" 1"" 0""
        public int IntArgs1;
        public int IntArgs2;
        public int IntArgs3;
        public int Level;

        //public ASPoint ASPoint;//List<ASPoint> ASPointList

        //K:""，V：""
        public Dictionary<Fix64, List<BattlePos>> EntityOccupyDict;

        public string Floor;

#if _CLIENTLOGIC_
        public string ConstructResPath;
        public GameObject ConstructObj;
        public Transform Tinyblackholes;
        public Transform Platform;
#endif

        public override void Init()
        {
            base.Init();
            IsMain = false;
            Type = BuildingType.None;
            SubType = BuildingSubType.None;

            if (EntityOccupyDict == null)
            {
                EntityOccupyDict = new Dictionary<Fix64, List<BattlePos>>();
            }
        }

        public override void Start()
        {
            base.Start();

            ObjType = Type == BuildingType.Mineral ? ObjectType.Mineral : ObjectType.Tower;
            Group = GroupType.EnemyGroup; //""

#if _CLIENTLOGIC_
            CreateFromPrefab(ResPath, CreatePrefabCallBack);
#endif
        }

        public override void UpdateLogic()
        {
            base.UpdateLogic();

//#if _CLIENTLOGIC_
//            DisplayBuff();
//#endif
        }

#if _CLIENTLOGIC_
        public virtual void CreatePrefabCallBack()
        {
            if (Type == BuildingType.Mineral)
                return;

            if (Direction == 30)
            {
                SpineAnim.SpineAnimPlay("idle_0", true);
            }
            else
            {
                SpineAnim.SpineAnimPlay("idle", true);
            }

            if (IsConstruct)
            {
                SetConstructRes();
                NewGameData._GameObjFactory.CreateGameObj(ConstructResPath, new FixVector3(Fixv3LogicPosition.x, (Fix64)0.2, Fixv3LogicPosition.z), CreateConstructPrefabCallBack);
                SpineAnim.SpineAnimPlay(null, false);
            }
            CreatePlatform();

            Tinyblackholes = Trans.Find("Eff/Eff_Tinyblackholes");
            if (Tinyblackholes != null)
            {
                Tinyblackholes.gameObject.SetActive(true);
                Tinyblackholes.localScale = Vector3.one * (float)AtkRange * 2;
            }

            if (FixHp != FixOriginHp)
            {
                HpSprite.gameObject.SetActive(true);
                UpdateHpSprite();
            }
        }

        public void CreateConstructPrefabCallBack(GameObject obj)
        {
            ConstructObj = obj;
        }

        private void SetConstructRes()
        {
            if (Radius == (Fix64)1)
            {
                ConstructResPath = "install2x2";
            }
            else if (Radius == (Fix64)1.5)
            {
                ConstructResPath = "install3x3";
            }
            else if (Radius == (Fix64)2)
            {
                ConstructResPath = "install4x4";
            }
            else if (Radius == (Fix64)2.5)
            {
                ConstructResPath = "install5x5";
            }
            else
            {
                ConstructResPath = "install1x1";
            }
        }

        private void CreatePlatform()
        {
            //string name;
            //if (Radius == (Fix64)1.5)
            //{
            //    name = "Building_platform_3x3";
            //}
            //else if (Radius == (Fix64)2)
            //{
            //    name = "Building_platform_4x4";
            //}
            //else if (Radius == (Fix64)2.5)
            //{
            //    name = "Building_platform_5x5";
            //}
            //else
            //{
            //    name = "Building_platform_2x2";
            //}

            NewGameData._GameObjFactory.CreateGameObj(Floor, Fixv3LogicPosition, CreatePlatformCallBack);
        }

        private void CreatePlatformCallBack(GameObject obj)
        {
            Platform = obj.transform;
            Platform.transform.SetParent(NewGameData.Platform);
        }
#endif

        public void ReSetBattlePos()
        {
            if (EntityOccupyDict.Count != 0)
            {
                foreach (var kv in EntityOccupyDict)
                {
                    foreach (var battlePos in kv.Value)
                    {
                        NewGameData._PoolManager.Push(battlePos);
                    }
                }

                EntityOccupyDict.Clear();
            }
        }

        public override void Release()
        {
#if _CLIENTLOGIC_
            if (Tinyblackholes != null)
            {
                Tinyblackholes.localScale = Vector3.one;
                Tinyblackholes = null;
            }

#endif
            base.Release();

            EffectResPath = null;
            DeadResPath = null;
            //ASPoint = null;


            ReSetBattlePos();

            //ASPointList.Clear();

#if _CLIENTLOGIC_
            ConstructResPath = null;

            if(ConstructObj != null)
                NewGameData._GameObjFactory.ReleaseGameObj(ConstructObj);

            if(Platform != null)
                NewGameData._GameObjFactory.ReleaseGameObj(Platform.gameObject);

#endif
        }
    }

}