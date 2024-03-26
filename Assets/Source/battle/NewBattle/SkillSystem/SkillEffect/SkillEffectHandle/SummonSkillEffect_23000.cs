using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class SummonSkillEffect_23000 : SkillEffectBase
    {
        private int m_Amount;
        private SoliderType m_SoliderType;

        public override void Start()
        {
            base.Start();

            m_Amount = (int)Args[1];
            m_SoliderType = (SoliderType)(int)Args[2];
            var model = NewGameData._SummonSoliderModelDict[entityCfgId];

            for (int i = 0; i < m_Amount; i++)
            {
                if (m_SoliderType == SoliderType.CarrierAircraft || m_SoliderType == SoliderType.AirSolider ||
                    m_SoliderType == SoliderType.SuicideChildAirSolider)
                {
                    var solider = NewGameData._SoliderFactory.CreateAirSolider(m_SoliderType, OriginEntity.Fixv3LogicPosition,
                        TargetEntity.Fixv3LogicPosition, model);

                    solider.IsSummonSoldier = true;
                }
                else
                {
                    var targetPos = OriginEntity.Fixv3LogicPosition + GameTools.RandomTargetPos((Fix64)2.3);
                    var solider = NewGameData._SoliderFactory.CreateSolider(m_SoliderType,
                        new FixVector3(targetPos.x, Fix64.Zero, targetPos.z), model);

                    solider.IsSummonSoldier = true;
                }
            }
        }
    }
}
