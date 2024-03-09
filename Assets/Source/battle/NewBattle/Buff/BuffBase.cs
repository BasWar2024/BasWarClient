

namespace Battle
{
    public class BuffBase : EntityBase
    {
        //public int SId; //ID BUFF
        public int Id;
        //public string ResPath; //Buff
        public string IconPath;
        public string EffectResPath; //Buff
        public Fix64 Hurt; //
        public Fix64 Cure; //
        public Fix64 AddAtk; //,
        public Fix64 AddAtkSpeed; //,
        public Fix64 AddMoveSpeed; //,
        public Fix64 LifeTime; //(0 -1 -)
        public Fix64 StopAction; //0 1
        public Fix64 Frequency; // (-1)
        public int LifeType; //0: 1

        public EntityBase TargetEntity; //
        public SkillBase SkillEntity; //
        public Fix64 ElpaseTime;
        public Fix64 TotalTime;
        public virtual void Init(SkillBase originSkill, EntityBase target)
        {
            base.Init();

            ElpaseTime = Fix64.Zero;
            ObjType = ObjectType.Buff;
            //Group = originSkill.Group;
            TargetEntity = target;
            SkillEntity = originSkill;

            if (LifeTime < 0)
                LifeTime = originSkill.LifeTime - originSkill.ExistenceTime;

            if (Frequency < 0)
                Frequency = originSkill.Frequency;

            //#if _CLIENTLOGIC_
            //            CreateFromPrefab(ResPath, null);
            //#endif
        }

        public override void Release()
        {
            base.Release();

            TargetEntity = null;
            SkillEntity = null;
        }
    }
}
