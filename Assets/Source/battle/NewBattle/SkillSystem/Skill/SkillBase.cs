
namespace Battle
{
#if _CLIENTLOGIC_
    using Spine.Unity;
    using UnityEngine;
#endif
    using System;
    using System.Collections.Generic;

    public abstract class SkillBase 
    {
        public long Id;
        public int CfgId;
        //public string Name;
        public string Icon;
        public int Type;
        public int SkillType;
        public TargetGroup TargetGroup;
        public int SkillEffectCfgId;
        public Fix64 OriginCost;
        public Fix64 AddCost;
        public Fix64 SkillCd;
        public AreaType UseArea;
        public int Level;
        public int Quality;
        public Fix64 ReleaseDistance;
        public Fix64 SkillAnimTime;
        public Fix64 SkillDelayTime;

        public Fix64 IntArg1;
        public Fix64 IntArg2;
        public Fix64 IntArg3;
        public Fix64 IntArg4;
        public Fix64 IntArg5;
        public Fix64 IntArg6;
        public Fix64 IntArg7;
        public Fix64 IntArg8;
        public Fix64 IntArg9;
        public Fix64 IntArg10;
        public Fix64 IntArg11;
        public Fix64 IntArg12;
        public Fix64 IntArg13;
        public Fix64 IntArg14;
        public Fix64 IntArg15;

        public string StringArg1;
        public string StringArg2;
        public string StringArg3;
        public string StringArg4;
        public string StringArg5;
        public string StringArg6;
        public string StringArg7;
        public string StringArg8;
        public string StringArg9;
        public string StringArg10;


        public FixVector3 StartPos;
        public FixVector3 EndPos;
        public EntityBase OriginEntity;
        public EntityBase TargetEntity;
        protected GroupType Group;

        public FixVector3 Fixv3LogicPosition;
        public FixVector3 Fixv3LastPosition;

        public bool BKilled = false;

#if _CLIENTLOGIC_
        public Transform SpineTrans; //spine""
        public SkeletonAnimation SpineAnim;
        public GameObject GameObj;
        public Transform Trans;

        //3D""
        public Quaternion CurrRotation;
        public Quaternion LastRotation;
#endif

        public virtual void Init()
        {
            BKilled = false;

#if _CLIENTLOGIC_
            CurrRotation = Quaternion.Euler(0, 0, 0);
            LastRotation = Quaternion.Euler(0, 0, 0);
#endif
        }

        public virtual void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            StartPos = startPos;
            EndPos = endPos;
            OriginEntity = originEntity;
            TargetEntity = targetEntity;

            if (originEntity != null)
            {
                Group = originEntity.Group;
            }
            else
            {
                Group = GroupType.PlayerGroup;
            }

            UpdateRenderPosition(0);
            RecordLastPos();

#if _CLIENTLOGIC_
            RecordLastRotation();

            AudioFmodMgr.instance.ActionPlaySkillAudio?.Invoke(CfgId, BattleAudioType._BeginAudio, null, (instance) =>
            {
                //instance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
                instance.release();
            });
#endif     
        }

        public virtual void UpdateLogic()
        {

        }

        public void TriggerSkill(EntityBase originEntity, EntityBase targetEntity, Buff buff = null, params Fix64[] args)
        {
            if (SkillEffectCfgId != 0)
            {
                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, buff, originEntity, targetEntity, args);
            }
        }

#if _CLIENTLOGIC_
        public void CreateFromPrefab(string path, Action<GameObject> callBack = null)
        {
            if (string.IsNullOrEmpty(path))
                return;

            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                if (BKilled)
                {
                    GG.ResMgr.instance.ReleaseAsset(obj);
                    return true;
                }

                GameObj = obj;
                Trans = GameObj.transform;
                Trans.SetParent(NewGameData.BattleMono);
                Trans.position = Fixv3LogicPosition.ToVector3();

                SpineTrans = Trans.Find("Spine");
                if (SpineTrans != null)
                    SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();
                callBack?.Invoke(obj);

                var trailRenderers = Trans.GetComponentsInChildren<TrailRenderer>();
                if (trailRenderers != null)
                {
                    foreach (var tail in trailRenderers)
                    {
                        tail.Clear();
                    }
                }

                return true;
            }, true, null, NewGameData._AssetOriginPos);
        }

        protected virtual void TurnForward()
        {
            var origin2Targer = (EndPos - StartPos).ToVector3();
            Trans.forward = origin2Targer;
        }

        protected virtual void TurnForwardUpdate()
        {
            if (Trans != null) {
                Trans.forward = Fixv3LogicPosition.ToVector3() - Fixv3LastPosition.ToVector3();
            }
        }
#endif

        public virtual void UpdateRenderPosition(float interpolation)
        {
#if _CLIENTLOGIC_
            if (GameObj == null || Trans == null)
            {
                return;
            }

            if (interpolation != 0)
            {
                Trans.localPosition = Vector3.Lerp(Fixv3LastPosition.ToVector3(), Fixv3LogicPosition.ToVector3(), interpolation);
            }
            else
            {
                Trans.localPosition = Fixv3LogicPosition.ToVector3();
            }
#endif
        }

        public void RecordLastPos()
        {
            Fixv3LastPosition = Fixv3LogicPosition;
        }

#if _CLIENTLOGIC_
        //""，""3D""
        public void RecordLastRotation()
        {
            LastRotation = CurrRotation;
        }
#endif

        public virtual void Release()
        {
#if _CLIENTLOGIC_
            ReleaseGameObj();
#endif
            OriginEntity = null;
            TargetEntity = null;

            SkillEffectCfgId = 0;
            //buffCfgId = 0;

            NewGameData._PoolManager.Push(this);
        }

        public virtual void ReleaseGameObj()
        {
#if _CLIENTLOGIC_
            if (GameObj != null)
            {

                GG.ResMgr.instance.ReleaseAsset(GameObj);
                GameObj = null;
                Trans = null;
                SpineTrans = null;
                SpineAnim = null;
            }
#endif
        }
    }
}
