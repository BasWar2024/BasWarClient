using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    //""
    public class EntityAirSelfDestructAtkFsm : FsmState<EntityBase>
    {
        public override void OnEnter(EntityBase owner)
        {
            base.OnEnter(owner);

            var model = NewGameData._SkillModelDict[owner.AtkSkillId];
            foreach (var target in NewGameData._BuildingList)
            {
                if (FixVector3.Distance(target.Fixv3LogicPosition, owner.TargetPos) <= owner.AtkRange + target.Radius)
                {
                    //NewGameData._FightManager.Attack(owner.GetFixAtk(), null, target);
                    NewGameData._SkillFactory.CreateSkill(owner.Fixv3LogicPosition, owner.Fixv3LogicPosition, owner, target, model);
                }
            }

#if _CLIENTLOGIC_
            NewGameData._EffectFactory.CreateEffect(model.stringArg2, owner.Fixv3LogicPosition, Fix64.Zero, Fix64.Zero);

            AudioFmodMgr.instance.ActionPlayBattleAudio?.Invoke(owner.CfgId, BattleAudioType._AttackAudio, owner.Trans);
#endif

            NewGameData._FightManager.Attack((Fix64)9999999, null, owner);
        }
    }
}
