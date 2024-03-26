using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class SkillEffectBase
    {
        public int CfgId;
        public int Type;
        public List<Fix64> Args;
        public int RangeType;
        public Fix64 Range;
        public int SkillEffectCfgId;
        public int BuffCfgId;
        public int entityCfgId;
        public int skillCfgId;

        protected Buff Buff;

        protected SkillEffectModel SkillEffModel;
        public EntityBase OriginEntity;
        public EntityBase TargetEntity;

        public virtual void Init(SkillEffectModel model, EntityBase originEntity, EntityBase targetEntity,
            Buff buff, params Fix64[] args)
        {
            SkillEffModel = model;
            OriginEntity = originEntity;
            TargetEntity = targetEntity;
            if (Args == null)
            {
                Args = new List<Fix64>();
            }

            //OriginEntity=null""，""，""
            if (OriginEntity == null)
            {
                OriginEntity = NewGameData._MainShipEntity;
            }

            Buff = buff;
        }

        public virtual void Start()
        {
             
        }

        public virtual void Update()
        {

        }

        public virtual void Leave()
        {
            SkillEffModel = null;
            OriginEntity = null;
            TargetEntity = null;
            Args.Clear();
            Buff = null;
            Args = null;
            NewGameData._PoolManager.Push(this);
        }

        public virtual void DoNextSkillEffect()
        {
            if (SkillEffectCfgId != 0)
            {
                NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, OriginEntity, TargetEntity);
            }
        }
    }
}
