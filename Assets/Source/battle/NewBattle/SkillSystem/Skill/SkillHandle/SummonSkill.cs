
namespace Battle
{
    public class SummonSkill : SkillBase
    {
        public override void Start(FixVector3 startPos, FixVector3 endPos, EntityBase originEntity, EntityBase targetEntity)
        {
            base.Start(startPos, endPos, originEntity, targetEntity);
            //m_TotalTime = Fix64.Zero;
            if (UseArea == AreaType.LandArea)
            {
                endPos = GameTools.CorrectLandingPos(endPos, Fix64.Zero, GameTools.GetLandArea(endPos));
            }

            if (IntArg1 == Fix64.One) //""
                Fixv3LogicPosition = startPos;
            else
                Fixv3LogicPosition = endPos;


#if _CLIENTLOGIC_
            NewGameData._EffectFactory.CreateEffect(StringArg1, EndPos, Fix64.Zero, Fix64.Zero);
#endif

            DoSkill();
        }

        private void DoSkill()
        {
            EntityBase originEntity = null;
            EntityBase targetEntity = null;
            originEntity = NewGameData._PoolManager.Pop<EntityBase>();
            if (IntArg1 == Fix64.One)
            {
                FixVector3 entityCenter = OriginEntity.Fixv3LogicPosition + OriginEntity.Center +
                    OriginEntity.AtkSkillShowRadius * FixMath.Vector3Rotate(NewGameData._FixForword, OriginEntity.AngleY);

                originEntity.Fixv3LogicPosition = entityCenter;
                targetEntity = TargetEntity;
            }
            else
            {
                originEntity.Fixv3LogicPosition = Fixv3LogicPosition;
                targetEntity = originEntity;
            }

#if _CLIENTLOGIC_
            NewGameData._EffectFactory.CreateEffect(StringArg2, EndPos, Fix64.Zero, Fix64.Zero);
#endif
            NewGameData._SkillEffectFactory.CreateSkillEffect(SkillEffectCfgId, null, originEntity, targetEntity);
            NewGameData._PoolManager.Push(originEntity);
            NewGameData._EntityManager.BeKill(this);
        }

        public override void Release()
        {
            base.Release();
        }
    }
}
