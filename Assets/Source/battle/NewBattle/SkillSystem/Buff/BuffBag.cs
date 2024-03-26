
using System.Collections.Generic;
using System.Linq;

#if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    public class BuffBag
    {
        private Queue<Buff> m_PushBagQueue;
        public Dictionary<BuffAttr, List<BuffValue>> BuffAttrDict;
        private EntityBase m_Entity;
#if _CLIENTLOGIC_
        public Dictionary<BuffAttr, Effect> BuffEffectDict;
#endif

        public void Init(EntityBase entity)
        {
            if (m_PushBagQueue == null)
                m_PushBagQueue = new Queue<Buff>();

            if (BuffAttrDict == null)
                BuffAttrDict = new Dictionary<BuffAttr, List<BuffValue>>();

            m_Entity = entity;

#if _CLIENTLOGIC_
            if (BuffEffectDict == null)
                BuffEffectDict = new Dictionary<BuffAttr, Effect>();
#endif
        }

        public void PushBag(Buff buff)
        {
            m_PushBagQueue.Enqueue(buff);
            //buff.Start();
        }

        public Fix64 GetSoloBuffAttrValue(BuffAttr buffAttr)
        {
            if (BuffAttrDict.TryGetValue(buffAttr, out List<BuffValue> buffValues))
            {
                if (buffValues.Count > 0)
                {
                    return buffValues[0].GetValue();
                }
            }

            return Fix64.Zero;
        }

        public Fix64 GetMultBuffAttrValue(BuffAttr buffAttr)
        {
            Fix64 value = Fix64.Zero;
            if (BuffAttrDict.TryGetValue(buffAttr, out List<BuffValue> buffValues))
            {
                foreach (var buffvalue in buffValues)
                {
                    value += buffvalue.GetValue();
                }
            }

            return value;
        }

        public BuffValue CreateBuffValue(BuffAttr buffAttr, Buff buff, Fix64 value, BuffType buffType)
        {
            BuffValue buffValue = NewGameData._PoolManager.Pop<BuffValue>();
            buffValue.Init(buff, value, buffType);
            BuffAttrDict[buffAttr].Add(buffValue);

#if _CLIENTLOGIC_
            ShowBuffEffect(buffAttr, buff, Fix64.One);
#endif
            return buffValue;
        }

        public void ReleaseBuffValue(BuffAttr buffAttr, BuffValue buffValue)
        {
            BuffAttrDict[buffAttr].Remove(buffValue);

#if _CLIENTLOGIC_
            EndEffect(buffAttr);
#endif
            buffValue.Release();
        }

        public void PushBuffValue(BuffAttr attrType, Buff buff, Fix64 value, BuffType buffType)
        {
            if (!BuffAttrDict.ContainsKey(attrType))
            {
                BuffAttrDict.Add(attrType, new List<BuffValue>());
            }

            List<BuffValue> buffValues = BuffAttrDict[attrType];
            if (buffType == BuffType.Sole_MaxValue)
            {
                if (buffValues.Count > 0)
                {
                    BuffValue buffValue = buffValues[0];
                    if (buffValue.GetValue() < value)
                    {
                        ReleaseBuffValue(attrType, buffValue);
                        CreateBuffValue(attrType, buff, value, buffType);
                    }
                    else if (buffValue.GetValue() == value)
                    {
                        buffValue.GetBuff().ReSetTime();
                        buff.Release();
                        //#if _CLIENTLOGIC_
                        //                        ReSetEffectTime(attrType, buffValue.GetBuff());
                        //#endif
                    }
                    else
                    {
                        buff.Release();
                    }
                }
                else
                {
                    CreateBuffValue(attrType, buff, value, buffType);
                }
            }
            else if (buffType == BuffType.Sole_MinValue)
            {
                if (buffValues.Count > 0)
                {
                    BuffValue buffValue = buffValues[0];
                    if (buffValue.GetValue() > value)
                    {
                        ReleaseBuffValue(attrType, buffValue);
                        CreateBuffValue(attrType, buff, value, buffType);
                    }
                    else if (buffValue.GetValue() == value)
                    {
                        buffValue.GetBuff().ReSetTime();
                        buff.Release();
                        //#if _CLIENTLOGIC_
                        //                        ReSetEffectTime(attrType, buffValue.GetBuff());
                        //#endif
                    }
                    else
                    {
                        buff.Release();
                    }
                }
                else
                {
                    CreateBuffValue(attrType, buff, value, buffType);
                }
            }
            else if (buffType == BuffType.Sole_Cover)
            {
                if (buffValues.Count > 0)
                {
                    BuffValue buffValue = buffValues[0];
                    ReleaseBuffValue(attrType, buffValue);
                }
                CreateBuffValue(attrType, buff, value, buffType);
            }
            else if (buffType == BuffType.SoleCfgid_MaxValue)
            {
                bool isCfgId = false;

                for (int i = buffValues.Count - 1; i >= 0; i--)
                {
                    BuffValue buffValue = buffValues[i];
                    if (buffValue.GetBuff().CfgId == buff.CfgId)
                    {
                        isCfgId = true;

                        if (buffValue.GetValue() < value)
                        {
                            ReleaseBuffValue(attrType, buffValue);
                            CreateBuffValue(attrType, buff, value, buffType);
                        }
                        else if (buffValue.GetValue() == value)
                        {
                            buffValue.GetBuff().ReSetTime();
                            buff.Release();
                            //#if _CLIENTLOGIC_
                            //                            ReSetEffectTime(attrType, buffValue.GetBuff());
                            //#endif
                        }
                        else
                        {
                            buff.Release();
                        }

                        break;
                    }
                }

                if (!isCfgId)
                {
                    CreateBuffValue(attrType, buff, value, buffType);
                }
            }
            else if (buffType == BuffType.Sole)
            {
                CreateBuffValue(attrType, buff, value, buffType);
            }
        }

        public void UpdateLogic()
        {
            for (int i = BuffAttrDict.Count - 1; i >= 0; i--)
            {
                var kv = BuffAttrDict.ElementAt(i);
                List<BuffValue> buffValues = kv.Value;

                for (int j = buffValues.Count - 1; j >= 0; j--)
                {
                    Buff buff = buffValues[j].GetBuff();

                    if (buff.IsEnd)
                    {
                        ReleaseBuffValue(kv.Key, buffValues[j]);
                        continue;
                    }

                    buff.UpdateLogic();
                }
            }
            //#if _CLIENTLOGIC_
            //            for (int i = BuffEffectDict.Count - 1; i >= 0; i--)
            //            {
            //                var kv = BuffEffectDict.ElementAt(i);
            //                if (kv.Value != null)
            //                {
            //                    Effect effect = kv.Value;
            //                    effect.UpdateLogic();
            //                }
            //            }
            //#endif

            while (m_PushBagQueue.Count > 0)
            {
                Buff newBuff = m_PushBagQueue.Dequeue();
                newBuff.Start();
            }
        }

#if _CLIENTLOGIC_
        public void ShowBuffEffect(BuffAttr buffAttr, Buff buff, Fix64 scale)
        {
            if (BuffEffectDict.TryGetValue(buffAttr, out Effect oldEffect))
            {
                if (oldEffect != null)
                {
                    return;
                }
            }
            else
                BuffEffectDict.Add(buffAttr, null);

            if (m_Entity == null || m_Entity.Trans == null || string.IsNullOrEmpty(buff.Model))
                return;

            if (m_Entity.BuffBagRoot == null)
                m_Entity.BuffBagRoot = m_Entity.Trans.Find("BuffBag");

            Effect effect = NewGameData._EffectFactory.CreateBuffEffect(buff.Model, FixVector3.Zero, scale, buff.LifeTime, (go, eff) => {

                if (buff.IsEnd || m_Entity == null)
                {
                    eff.Release();
                    return;
                }

                if (m_Entity != null)
                {
                    if (m_Entity.BKilled)
                    {
                        eff.Release();
                        return;
                    }

                    go.transform.parent = m_Entity.BuffBagRoot;
                    go.transform.localPosition = Vector3.zero;
                    go.transform.localScale = Vector3.one;

                    eff.Buff = buff;
                    BuffEffectDict[buffAttr] = eff;
                }
            });
        }

        public void EndEffect(BuffAttr buffAttr)
        {
            Effect effect = BuffEffectDict[buffAttr];
            BuffEffectDict[buffAttr] = null;
            if (effect != null)
            {
                effect.Release();
                PopBuffEffect(buffAttr);
            }
        }

        //""BuffAttr Effect""
        private void PopBuffEffect(BuffAttr buffAttr)
        {
            if (BuffAttrDict.TryGetValue(buffAttr, out List<BuffValue> buffValues))
            {
                if (buffValues.Count > 0)
                {
                    ShowBuffEffect(buffAttr, buffValues[0].GetBuff(), Fix64.One);
                }
            }
        }

        public void NowEndEffect(BuffAttr buffAttr)
        {
            Effect effect = BuffEffectDict[buffAttr];
            if (effect != null)
            {
                effect.BeKill();
                BuffEffectDict[buffAttr] = null;
            }
        }

        //public void ReSetEffectTime(BuffAttr buffAttr, Buff buff)
        //{
        //    Effect effect = BuffEffectDict[buffAttr];
        //    if (effect != null && effect.Buff == buff)
        //    {
        //        effect.ReSetTime();
        //    }
        //}
#endif

        public void Release()
        {
            for (int i = BuffAttrDict.Count - 1; i >= 0; i--)
            {
                var kv = BuffAttrDict.ElementAt(i);

                if (kv.Value != null)
                {
                    List<BuffValue> buffValues = kv.Value;

                    foreach (var buffValue in buffValues)
                    {
                        buffValue.Release();
                    }

                    buffValues.Clear();
                }
            }

            while (m_PushBagQueue.Count > 0)
            {
                var buff = m_PushBagQueue.Dequeue();
                buff.Release();
            }

#if _CLIENTLOGIC_
            for (int i = BuffEffectDict.Count - 1; i >= 0; i--)
            {
                var kv = BuffEffectDict.ElementAt(i);
                if (kv.Value != null)
                {
                    kv.Value.Release();
                }
            }

            BuffEffectDict.Clear();
#endif
            m_Entity = null;
            m_PushBagQueue.Clear();
            BuffAttrDict.Clear();
        }
    }
}
