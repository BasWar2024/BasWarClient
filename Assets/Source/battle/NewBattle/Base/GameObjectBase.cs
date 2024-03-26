

namespace Battle
{

#if _CLIENTLOGIC_
    using UnityEngine;
    using Spine.Unity;
    using System;
#endif
    public class GameObjectBase
    {
        //""
        public bool BKilled = false;
        public bool CanRelease = false;

        //""
        public string ResPath = "";
        public ModelType ModelType = ModelType.Model2D;
        public int Direction = 0;  //""

        public ObjectType ObjType = ObjectType.None;

        public Fix64 AngleY; //""2D""

#if _CLIENTLOGIC_
        public GameObject GameObj;
        public Transform Trans;
        public Transform BuffBagRoot;
        public Transform SpineTrans; //spine""
        public SkeletonAnimation SpineAnim; //""，""spine

        public SpriteRenderer HpSprite; //""sprite
        public TextMesh MessageText; //""sprite
        public float GreenHp = 60f;
        public float OrangeHp = 30f;
        public float RedHp = 0;

        //3D""
        public Quaternion CurrRotation;
        public Quaternion LastRotation;

        public Animator Anim;
#endif

        //""
        public FixVector3 Fixv3LogicRotation;

        //""
        public FixVector3 Fixv3LogicScale;
        //""
        public Fix64 Radius = Fix64.One;

        public FixVector3 Fixv3LogicPosition;
        public FixVector3 Fixv3LastPosition;

        public virtual void Init()
        {
            BKilled = false;
            CanRelease = false;
            ResPath = null;
            ModelType = ModelType.Model2D;
            Direction = 0;
            ObjType = ObjectType.None;

            Fixv3LastPosition = FixVector3.Zero;
            Fixv3LogicPosition = FixVector3.Zero;
            Fixv3LogicScale = FixVector3.Zero;
            Radius = Fix64.One;

            AngleY = Fix64.Zero;
            Fixv3LogicRotation = FixVector3.Zero;
#if _CLIENTLOGIC_
            Anim = null;
            GameObj = null;
            Trans = null;
            SpineTrans = null;
            SpineAnim = null;
            HpSprite = null;
            MessageText = null;
            CurrRotation = Quaternion.identity;
            LastRotation = Quaternion.identity;
#endif
        }

        public virtual void Start()
        {

        }

        public void ReleaseGameObj()
        {
            ResPath = null;
#if _CLIENTLOGIC_
            if (GameObj != null)
            {
                if (SpineAnim != null)
                    SpineAnim.SetColor(Color.white);

                GG.ResMgr.instance.ReleaseAsset(GameObj);
                GameObj = null;
                Trans = null;
                SpineTrans = null;
                SpineAnim = null;
                HpSprite = null;
                MessageText = null;
                Anim = null;
                BuffBagRoot = null;
            }
#endif
        }

#if _CLIENTLOGIC_

        public void CreateFromPrefab(string path, Action callBack = null)
        {
            if (string.IsNullOrEmpty(path))
                return;

            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                GameObj = obj;
                GameObj.SetActive(false);
                Trans = GameObj.transform;
                Trans.SetParent(NewGameData.BattleMono);

                var trailRenderers = Trans.GetComponentsInChildren<TrailRenderer>();
                if (trailRenderers != null)
                {
                    foreach (var tail in trailRenderers)
                    {
                        tail.Clear();
                    }
                }

                switch (ObjType)
                {
                    case ObjectType.Soldier:
                        if (ModelType == ModelType.Model2D)
                        {
                            SpineTrans = Trans.Find("Spine");
                            SetHpSprite();
                        }
                        else if (ModelType == ModelType.Model2D_Tank)
                        {
                            SpineTrans = Trans.Find("Body/Spine");
                            SetHpSprite();
                        }
                        else
                        {
                            Trans.Find("Hp")?.gameObject.SetActive(false);
                            Anim = Trans.Find("body")?.GetComponent<Animator>();
                        }
                        break;
                    case ObjectType.Tower:
                        SpineTrans = Trans.Find("Spine");
                        SetHpSprite();
                        HpSprite.color = NewGameData.HpPurple;
                        break;
                    case ObjectType.Trap:
                        SpineTrans = Trans.Find("Spine");
                        SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();
                        break;
                    case ObjectType.Mineral:
                        SpineTrans = Trans.Find("Spine");
                        SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();
                        break;

                    default:

                        break;
                }

                callBack?.Invoke();
                OnCreateFromPrefab();
                SetGameObjectPosition(Fixv3LogicPosition);

                GameObj.SetActive(true);
                return true;
            }, true, null, NewGameData._AssetOriginPos);
        }

        protected virtual void OnCreateFromPrefab() {

        }

        private void SetHpSprite()
        {
            
            SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();
            SpineAnim.SetColor(new Color(1, 1, 1, 0.5f));
            SpineAnim.timeScale = 1;

            Transform hp = Trans.Find("Hp");
            hp.SetActiveEx(true);
            hp.localScale = Vector3.one;

            HpSprite = hp.Find("Hp").GetComponent<SpriteRenderer>();
            HpSprite.color = NewGameData.HpGreen;
            //HpSprite.transform.Find("Level").gameObject.SetActive(false);
            HpSprite.size = new Vector2(0.75f, HpSprite.size.y);
            HpSprite.gameObject.SetActive(false);
            SpineAnim.SetColor(Color.white);

            MessageText = hp.Find("TxtMessage").GetComponent<TextMesh>();
            MessageText.SetActiveEx(NewGameData._IsShowBattleDetail);

            if (this is BuildingBase) {
                MessageText.transform.position = Trans.position;
            }

            
        }

        public void ChangeHpColor(Fix64 value)
        {
            if (HpSprite == null)
                return;

            if (value >= NewGameData.HpGreenValue)
            {
                HpSprite.color = NewGameData.HpGreen;
            }
            else if (value >= NewGameData.HpOrangeValue)
            {
                HpSprite.color = NewGameData.HpOrange;
            }
            else
            {
                HpSprite.color = NewGameData.HpRed;
            }
        }
#endif
        //- ""
        // 
        // @param animationName ""
        // @return; none
        public void PlayAnimation(string animationName)
        {
#if _CLIENTLOGIC_

#endif
        }

        //- ""
        // 
        // @return; none
        public void StopAnimation()
        {
#if _CLIENTLOGIC_
            Animation animation = Trans.GetComponent<Animation>();
            if (null != animation)
            {
                animation.Stop();
            }
#endif
        }

        //- ""
        // 
        // @param value ""
        // @return; none
        public void SetScale(FixVector3 value)
        {
            Fixv3LogicScale = value;

#if _CLIENTLOGIC_
            Trans.localScale = value.ToVector3();
#endif
        }

        //- ""
        // 
        // @return; ""
        public FixVector3 GetScale()
        {
            return Fixv3LogicScale;
        }

        //- ""
        // 
        // @param value ""
        // @return; none
        public void SetRotation(FixVector3 value)
        {
            Fixv3LogicRotation = value;
#if _CLIENTLOGIC_
            Trans.localEulerAngles = value.ToVector3();
            SetVisible(true);
#endif
        }

        //- ""
        // 
        // @param value ""
        // @return; none
        public void SetVisible(bool value)
        {
#if _CLIENTLOGIC_
            GameObj.SetActive(value);
#endif
        }

        //- ""
        // 
        // @param position ""
        // @return; none
        public void SetGameObjectPosition(FixVector3 position)
        {
#if _CLIENTLOGIC_
            Trans.localPosition = position.ToVector3();
#endif
        }
    }
}

