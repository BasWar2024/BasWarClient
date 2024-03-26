
namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
    using Spine.Unity;
    using Spine;

    public class Effect
    {
        public Fix64 LifeTime;
        public Transform Trans;

        private Vector3 m_OriginScale; //""
        private Fix64 m_TotalTime;

        public bool BKilled = false;

        private SkeletonAnimation m_Anim;
        private Fix64 m_EndTime = (Fix64)0.3f;
        private Fix64 m_ShowEndTime;

        private string m_AfterFinishAnimName;

        public Buff Buff;

        public bool IsEnd;

        public void Init(Transform trans, FixVector3 pos)
        {
            BKilled = false;
            Trans = trans;
            Trans.position = pos.ToVector3();

            var trailRenderers = Trans.GetComponentsInChildren<TrailRenderer>();
            if (trailRenderers != null)
            {
                foreach (var tail in trailRenderers)
                {
                    tail.Clear();
                }
            }
        }

        public void Show(Transform trans, FixVector3 pos, Fix64 size, Fix64 lifeTime)
        {
            LifeTime = lifeTime == Fix64.Zero ? (Fix64)0.5f : lifeTime;
            m_TotalTime = Fix64.Zero;
            m_AfterFinishAnimName = null;
            m_OriginScale = Trans.localScale;

            Transform spine = Trans.Find("Spine");
            if (spine != null) {
                m_Anim = spine.GetComponent<SkeletonAnimation>();
            }

            m_ShowEndTime = LifeTime - m_EndTime;
            //m_Anim.AnimationState.ClearTracks();
            IsEnd = false;

            if (size != Fix64.Zero)
            {
                float scale = (float)size * 2;
                Trans.localScale = Vector3.one * scale;
            }

            if (Trans.Find("Spine"))
            {
                PlayOneTimeAnim("start", "loop");
            }
            else if (Trans.Find("Eff"))
            {
                ParticleSystemEventHandler.Get(Trans.Find("Eff").gameObject).SetOnStop(BeKill);
            }

            Trans.gameObject.SetActive(true);
        }

        public void PlayOneTimeKill(string animName)
        {
            IsEnd = true;
            if (Trans != null && Trans.Find("Spine"))
            {
                //m_Anim.AnimationState.ClearTracks();
                //m_Anim.AnimationState.Complete -= BeKill;
                m_Anim.AnimationState.Complete += BeKill;
                m_Anim.SpineAnimPlay(animName, false);
            }
        }

        public void PlayOneTimeAnim(string animName, string afterFinishAnimName)
        {
            m_AfterFinishAnimName = afterFinishAnimName;
            if (Trans != null && Trans?.Find("Spine"))
            {
                //m_Anim.AnimationState.ClearTracks();
                //m_Anim.AnimationState.Complete -= ChangeAnim;
                m_Anim.AnimationState.Complete += ChangeAnim;
                m_Anim.SpineAnimPlay(animName, false);
            }
        }
        
        public void ChangeAnim(TrackEntry gameObject)
        {
            if (Trans != null && Trans?.Find("Spine"))
            {
                m_Anim.AnimationState.Complete -= ChangeAnim;
                //m_Anim.AnimationState.ClearTracks();
                m_Anim.SpineAnimPlay(m_AfterFinishAnimName, true);
            }
        }

        public void UpdateLogic()
        {
            if (Buff == null && !IsEnd)
            {
                m_TotalTime += NewGameData._FixFrameLen;
                if (m_TotalTime >= m_ShowEndTime)
                {
                    IsEnd = true;
                    PlayOneTimeKill("end");
                }
            }
        }

        public void ReSetTime()
        {
            m_TotalTime = Fix64.Zero;
        }

        private void BeKill(GameObject gameObject)
        {
            if (Trans != null)
            {
                ParticleSystemEventHandler.Get(Trans.Find("Eff").gameObject).ClearDelegates();
                //Release();
                BKilled = true;
            }
        }

        private void BeKill(TrackEntry gameObject)
        {
            if (m_Anim != null)
            {
                m_Anim.AnimationState.Complete -= BeKill;
                //m_Anim.AnimationState.ClearTracks();
                //Release();
                Trans.gameObject.SetActive(false);
                BKilled = true;
            }
        }

        public void BeKill()
        {
            BKilled = true;
        }

        public void Release()
        {
            if (Trans != null)
            {
                //m_Anim.AnimationState.Complete -= ChangeAnim;
                //m_Anim.AnimationState.Complete -= BeKill;
                Trans.localScale = m_OriginScale;
                Trans.SetParent(NewGameData.BattleMono);
                GG.ResMgr.instance.ReleaseAsset(Trans.gameObject);
                Trans.gameObject.SetActive(false);
                Trans = null;
            }

            if (m_Anim != null)
            {
                m_Anim.AnimationState.Complete -= BeKill;
                m_Anim.AnimationState.Complete -= ChangeAnim;
                m_Anim = null;
            }

            m_AfterFinishAnimName = null;
            m_TotalTime = Fix64.Zero;
            Buff = null;

            NewGameData._PoolManager.Push(this);
        }
    }
#endif
}
