

namespace Battle
{

#if _CLIENTLOGIC_
    using UnityEngine;
    using Spine.Unity;
    using System;
#endif
    public class GameObjectBase
    {
        //
        public bool BKilled = false;
        public bool CanRelease = false;

        //
        public string ResPath = "";
        public ModelType ModelType = ModelType.Model2D;
        public Direction8 Direction8 = Direction8.None;
        public Direction30 Direction30 = Direction30.None;

        public ObjectType ObjType = ObjectType.None;

#if _CLIENTLOGIC_
        public GameObject GameObj;
        public Transform Trans;
        public Transform SpineTrans; //spine
        public SkeletonAnimation SpineAnim;
        public float AngleY;
        public SpriteRenderer HpSprite; //sprite
#endif

        //
        public FixVector3 Fixv3LastPosition = new FixVector3(Fix64.Zero, Fix64.Zero, Fix64.Zero);

        //
        public FixVector3 Fixv3LogicPosition = new FixVector3(Fix64.Zero, Fix64.Zero, Fix64.Zero);

        //
        public FixVector3 Fixv3LogicRotation;

        //
        public FixVector3 Fixv3LogicScale;
        //
        public Fix64 Radius = Fix64.One;


#if _CLIENTLOGIC_
        public void CreateFromPrefab(string path, Action callBack)
        {
            if (string.IsNullOrEmpty(path))
                return;

            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) => {
                GameObj = obj;
                Trans = GameObj.transform;
                Trans.SetParent(NewGameData.BattleMono);
                switch (ObjType)
                {
                    case ObjectType.Soldier:
                        if(ModelType == ModelType.Model2D)
                        {
                            SpineTrans = Trans.Find("Spine");
                            SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();
                            HpSprite = Trans.Find("Hp").GetComponent<SpriteRenderer>();
                            HpSprite.size = new Vector2(0.75f, HpSprite.size.y);
                        }
                        break;
                    case ObjectType.Tower:
                        SpineTrans = Trans.Find("Spine");
                        SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();
                        HpSprite = Trans.Find("Hp").GetComponent<SpriteRenderer>();
                        HpSprite.size = new Vector2(0.75f, HpSprite.size.y);
                        HpSprite.gameObject.SetActive(true);
                        break;
                    case ObjectType.Skill:
                        SpineTrans = Trans.Find("Spine");
                        if(SpineTrans != null)
                            SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();

                        break;
                    case ObjectType.Bullet:

                        break;
                    case ObjectType.Trap:
                        SpineTrans = Trans.Find("Spine");
                        SpineAnim = SpineTrans.GetComponent<SkeletonAnimation>();
                        break;
                    default:

                        break;
                }

                callBack?.Invoke();
                SetGameObjectPosition(Fixv3LogicPosition);
                return true;
            }, true);
    }
#endif
        //- 
        // 
        // @param animationName 
        // @return; none
        public void PlayAnimation(string animationName)
        {
#if _CLIENTLOGIC_

#endif
        }

        //- 
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

        //- 
        // 
        // @param value 
        // @return; none
        public void SetScale(FixVector3 value)
        {
            Fixv3LogicScale = value;

#if _CLIENTLOGIC_
            Trans.localScale = value.ToVector3();
#endif
        }

        //- 
        // 
        // @return; 
        public FixVector3 GetScale()
        {
            return Fixv3LogicScale;
        }

        //- 
        // 
        // @param value 
        // @return; none
        public void SetRotation(FixVector3 value)
        {
            Fixv3LogicRotation = value;
#if _CLIENTLOGIC_
            Trans.localEulerAngles = value.ToVector3();
            SetVisible(true);
#endif
        }

        //- 
        // 
        // @return; 
        public FixVector3 getRotation()
        {
            return Fixv3LogicRotation;
        }

        //- 
        // 
        // @param value 
        // @return; none
        public void SetVisible(bool value)
        {
#if _CLIENTLOGIC_
            GameObj.SetActive(value);
#endif
        }

        //- gameobject
        // 
        // @return; none
        public void DestroyGameObject()
        {
#if _CLIENTLOGIC_
            GameObject.Destroy(GameObj);
            Trans.localPosition = new Vector3(10000, 10000, 0);
#endif
        }

        //- 
        // 
        // @param position 
        // @return; none
        public void SetGameObjectPosition(FixVector3 position)
        {
#if _CLIENTLOGIC_
            Trans.localPosition = position.ToVector3();
#endif
        }
    }
}

