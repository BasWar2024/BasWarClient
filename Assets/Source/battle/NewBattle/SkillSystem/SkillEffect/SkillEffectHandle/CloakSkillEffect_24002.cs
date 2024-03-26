


namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class CloakSkillEffect_24002 : SkillEffectBase
    {
#if _CLIENTLOGIC_
        private Color m_CloakColor = new Color(1, 1f, 1f, 0.5f);
#endif
        public override void Start()
        {
            base.Start();
            NewGameData._BuffManager.Cloak(Buff, OriginEntity, TargetEntity);
#if _CLIENTLOGIC_
            TargetEntity.SpineAnim?.SetColor(m_CloakColor);
#endif
        }

        public override void Leave()
        {
            if (TargetEntity != null)
            {
#if _CLIENTLOGIC_
                TargetEntity.SpineAnim?.SetColor(Color.white);
#endif
            }

            base.Leave();
        }
    }
}
