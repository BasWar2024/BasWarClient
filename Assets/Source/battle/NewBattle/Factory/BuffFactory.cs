

# if _CLIENTLOGIC_
using UnityEngine;
#endif
namespace Battle
{
    using System;

    public class BuffFactory
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="buffId"></param>
        /// <param name="originEntity">""BUFF""</param>
        /// <param name="targetEntity">""BUFF""</param>
        /// <returns></returns>
        public Buff CreateBuff(int buffId, EntityBase originEntity, EntityBase targetEntity)
        {
            BuffModel model = NewGameData._BuffModelDict[buffId];
            if (model == null)
                return null;

            Buff buff = NewGameData._PoolManager.Pop<Buff>();
            buff.SkillEffId = model.skillEffectCfgId;
            buff.Init();
            SetAttr(buff, model, originEntity, targetEntity);
            //buff.Start();
            return buff;
        }

        //""BUFF
        public Buff CreateTempBuff()
        {
            Buff buff = NewGameData._PoolManager.Pop<Buff>();
            buff.SkillEffId = 0;
            buff.Init();
            return buff;
        }

        private void SetAttr(Buff buff, BuffModel model, EntityBase originEntity, EntityBase targetEntity)
        {
            buff.CfgId = model.cfgId;
            buff.Name = model.name;
            buff.Model = model.model;

            buff.LifeTime = (Fix64)model.lifeTime / 1000;
            buff.Frequency = (Fix64)model.frequency / 1000;

            buff.OriginEntity = originEntity;
            buff.TargetEntity = targetEntity;
        }
    }
}