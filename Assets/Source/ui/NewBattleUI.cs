

namespace Battle
{
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
    using UnityEngine.UI;
#endif
    public class NewBattleUI : MonoBehaviour
    {
        private Button m_SigninBtn1;
        private Button m_SigninBtn2;
        private Button m_SigninBtn3;
        private Button m_SigninBtn4;

        private Transform m_SigninPos1;
        private Transform m_SigninPos2;
        private Transform m_SigninPos3;
        private Transform m_SigninPos4;

        private Button m_SoliderBtn1;
        private Button m_SoliderBtn2;
        private Button m_SoliderBtn3;
        private Button m_SoliderBtn4;
        private Button m_SoliderBtn5;
        private Button m_SoliderBtn6;
        private Button m_SoliderBtn7;
        private Button m_SoliderBtn8;

        private Button m_HeroBtn1;
        private Button m_HeroSkill;

        private Button m_SkillBtn1;
        private Button m_SkillBtn2;
        private Button m_SkillBtn3;
        private Button m_SkillBtn4;
        private Button m_SkillBtn5;

        private Button m_RePlay;
        private Button m_ServerRePlay;

        private Text m_SkillPoints;

        public List<Button> SoliderBtnList = new List<Button>();
        public List<Button> SkillBtnList = new List<Button>();

        private LockStepLogicMonoBehaviour m_BattleLogicMono;

        private Camera m_BattleCamera;

        private void Start()
        {
            m_BattleLogicMono = transform.GetComponent<LockStepLogicMonoBehaviour>();

            m_SigninBtn1 = transform.Find("SigninPos/SigninBtn1").GetComponent<Button>();
            m_SigninBtn2 = transform.Find("SigninPos/SigninBtn2").GetComponent<Button>();
            m_SigninBtn3 = transform.Find("SigninPos/SigninBtn3").GetComponent<Button>();
            m_SigninBtn4 = transform.Find("SigninPos/SigninBtn4").GetComponent<Button>();

            m_SigninBtn1.onClick.AddListener(delegate { OnClickSignin(1); });
            m_SigninBtn2.onClick.AddListener(delegate { OnClickSignin(2); });
            m_SigninBtn3.onClick.AddListener(delegate { OnClickSignin(3); });
            m_SigninBtn4.onClick.AddListener(delegate { OnClickSignin(4); });

            Transform terrain = GameObject.Find("Terrain").transform;
            m_SigninPos1 = terrain.Find("SigninPos/SigninPos1");
            m_SigninPos2 = terrain.Find("SigninPos/SigninPos2");
            m_SigninPos3 = terrain.Find("SigninPos/SigninPos3");
            m_SigninPos4 = terrain.Find("SigninPos/SigninPos4");

            m_SoliderBtn1 = transform.Find("Solider/Solider1").GetComponent<Button>();
            m_SoliderBtn2 = transform.Find("Solider/Solider2").GetComponent<Button>();
            m_SoliderBtn3 = transform.Find("Solider/Solider3").GetComponent<Button>();
            m_SoliderBtn4 = transform.Find("Solider/Solider4").GetComponent<Button>();
            m_SoliderBtn5 = transform.Find("Solider/Solider5").GetComponent<Button>();
            m_SoliderBtn6 = transform.Find("Solider/Solider6").GetComponent<Button>();
            m_SoliderBtn7 = transform.Find("Solider/Solider7").GetComponent<Button>();
            m_SoliderBtn8 = transform.Find("Solider/Solider8").GetComponent<Button>();

            m_HeroBtn1 = transform.Find("Hero/Hero1").GetComponent<Button>();
            m_HeroSkill = transform.Find("Hero/HeroSkill").GetComponent<Button>();

            m_SkillBtn1 = transform.Find("Skill/Skill1").GetComponent<Button>();
            m_SkillBtn2 = transform.Find("Skill/Skill2").GetComponent<Button>();
            m_SkillBtn3 = transform.Find("Skill/Skill3").GetComponent<Button>();
            m_SkillBtn4 = transform.Find("Skill/Skill4").GetComponent<Button>();
            m_SkillBtn5 = transform.Find("Skill/Skill5").GetComponent<Button>();

            m_ServerRePlay = transform.Find("ServerRePlay").GetComponent<Button>();

            m_RePlay = transform.Find("RePlay").GetComponent<Button>();

            m_SkillPoints = transform.Find("SkillPoint").GetComponent<Text>();

            m_SoliderBtn1.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider1); });
            m_SoliderBtn2.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider2); });
            m_SoliderBtn3.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider3); });
            m_SoliderBtn4.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider4); });
            m_SoliderBtn5.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider5); });
            m_SoliderBtn6.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider6); });
            m_SoliderBtn7.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider7); });
            m_SoliderBtn8.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchSolider8); });

            m_HeroBtn1.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.LaunchHero); });
            m_HeroSkill.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.DoHeroSkill); }); //OnClickHeroSkill(); 

            m_SkillBtn1.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.DoSkill1); });
            m_SkillBtn2.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.DoSkill2); });
            m_SkillBtn3.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.DoSkill3); });
            m_SkillBtn4.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.DoSkill4); });
            m_SkillBtn5.onClick.AddListener(delegate { OnClickOperOrder(OperOrder.DoSkill5); });

            m_RePlay.onClick.AddListener(OnRePlay);
            m_ServerRePlay.onClick.AddListener(OnServerRePlay);

            SoliderBtnList.Add(m_SoliderBtn1);
            SoliderBtnList.Add(m_SoliderBtn2);
            SoliderBtnList.Add(m_SoliderBtn3);
            SoliderBtnList.Add(m_SoliderBtn4);
            SoliderBtnList.Add(m_SoliderBtn5);
            SoliderBtnList.Add(m_SoliderBtn6);
            SoliderBtnList.Add(m_SoliderBtn7);
            SoliderBtnList.Add(m_SoliderBtn8);

            SkillBtnList.Add(m_SkillBtn1);
            SkillBtnList.Add(m_SkillBtn2);
            SkillBtnList.Add(m_SkillBtn3);
            SkillBtnList.Add(m_SkillBtn4);
            SkillBtnList.Add(m_SkillBtn5);

            m_BattleCamera = GameObject.Find("BattleCamera").GetComponent<Camera>();

            HideOperUI();

            //m_BattleLogicMono.BattleLogic.SkillPointsChange += SkillPointChange;
        }

        private void SkillPointChange()
        {
            m_SkillPoints.text = NewGameData._SkillPoints.ToString();
        }

        private void OnClickSignin(int signinId)
        {
            m_BattleLogicMono.IsSignin = true;
            m_SigninBtn1.gameObject.SetActive(false);
            m_SigninBtn2.gameObject.SetActive(false);
            m_SigninBtn3.gameObject.SetActive(false);
            m_SigninBtn4.gameObject.SetActive(false);

            m_BattleLogicMono.WarShipSignin(signinId);
        }

        private void OnClickOperOrder(OperOrder order)
        {
            m_BattleLogicMono.OnOperOrder(order);
        }

        private void OnClickHeroSkill()
        {
            m_BattleLogicMono.OnClickHeroSkill();
        }

        private void OnRePlay()
        {
            m_BattleLogicMono.OnRePlay();
        }

        private void OnServerRePlay()
        {
            m_BattleLogicMono.OnServerRePlay();
        }

        private void Update()
        {
            if (m_BattleLogicMono.IsSignin)
                return;

            var signinPos1 = m_BattleCamera.WorldToScreenPoint(m_SigninPos1.position);
            var signinPos2 = m_BattleCamera.WorldToScreenPoint(m_SigninPos2.position);
            var signinPos3 = m_BattleCamera.WorldToScreenPoint(m_SigninPos3.position);
            var signinPos4 = m_BattleCamera.WorldToScreenPoint(m_SigninPos4.position);

            m_SigninBtn1.transform.position = signinPos1;
            m_SigninBtn2.transform.position = signinPos2;
            m_SigninBtn3.transform.position = signinPos3;
            m_SigninBtn4.transform.position = signinPos4;
        }

        public void SelectBtn(OperOrder oper)
        {

        }

        public void CloseBtn(OperOrder oper)
        {
            if (oper == OperOrder.None)
                return;

            if (oper < OperOrder.LaunchHero)
            {
                SoliderBtnList[(int)oper - 1].GetComponent<Image>().color = Color.red;
            }
            else if (oper == OperOrder.LaunchHero)
            {
                m_HeroBtn1.gameObject.SetActive(false);
                m_HeroSkill.gameObject.SetActive(true);
            }
        }

        public void ResetBtn()
        {

        }

        public void ShowOperUI()
        {
            for (int i = 0; i < NewGameData._OperSoliderDict.Count; i++)
            {
                SoliderBtnList[i].gameObject.SetActive(true);
            }

            if (NewGameData._OperHero != null)
                m_HeroBtn1.gameObject.SetActive(true);

            for (int i = 0; i < NewGameData._OperSkillDict.Count; i++)
            {
                SkillBtnList[i].gameObject.SetActive(true);
            }

            m_SkillPoints.gameObject.SetActive(true);

            m_SkillPoints.text = NewGameData._SkillPoints.ToString();
        }

        public void HideOperUI()
        {
            foreach (var btn in SoliderBtnList)
            {
                btn.gameObject.SetActive(false);
            }

            m_HeroBtn1.gameObject.SetActive(false);

            foreach (var btn in SkillBtnList)
            {
                btn.gameObject.SetActive(false);
            }

            m_SkillPoints.gameObject.SetActive(false);
        }
    }
}
