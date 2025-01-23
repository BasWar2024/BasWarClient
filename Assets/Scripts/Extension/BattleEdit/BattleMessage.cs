
namespace Battle
{
    using SimpleJson;
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;
    using UnityEngine.UI;


    public class BattleMessage : MonoBehaviour
    {
        private Button m_BtnClose;
        private Queue<BattleMessageItem> m_ItemPool;
        private List<BattleMessageItem> m_AtkItemList;
        private List<BattleMessageItem> m_DefItemList;
        private Transform m_messageItem;
        private InitBattleModel m_InitBattleModel;

        private Transform atkContent;
        private Transform defContent;

        void Awake()
        {
            m_AtkItemList = new List<BattleMessageItem>();
            m_DefItemList = new List<BattleMessageItem>();
            m_ItemPool = new Queue<BattleMessageItem>();
            m_messageItem = transform.Find("MessageItem");
            m_messageItem.SetActiveEx(false);

            m_BtnClose = transform.Find("ViewBg/Bg/BtnClose").GetComponent<Button>();
            m_BtnClose.onClick.AddListener(() =>
            {
                gameObject.SetActive(false);
            });

            atkContent = transform.Find("AtkScrollView/Viewport/Content");
            defContent = transform.Find("DefScrollView/Viewport/Content");
        }
        // Start is called before the first frame update
        void Start()
        {
            Refresh();
        }

        // Update is called once per frame
        void Update()
        {

        }

        public void SetBattleInfo(string info)
        {
            m_InitBattleModel = NewGameData.CreateBattleModel(info);
            //Refresh();
        }

        public void Refresh()
        {
            if (m_messageItem == null || m_InitBattleModel == null)
            {
                return;
            }
            ClearAllItem();

            BattleMessageItem heroItem = GetItem(BattleMessageType.atk);
            heroItem.SetHeroModel(m_InitBattleModel.heros[0]);

            foreach (var soldier in m_InitBattleModel.soliders)
            {
                BattleMessageItem soldierItem = GetItem(BattleMessageType.atk);
                soldierItem.SetSoldierModel(soldier);
            }

            if (m_InitBattleModel.summonSoliders != null) {
                foreach (var item in m_InitBattleModel.summonSoliders)
                {
                    BattleMessageItem skillItem = GetItem(BattleMessageType.atk);
                    skillItem.SetSoldierModel(item, true);
                }
            }

            for (int i = 0; i < m_InitBattleModel.skills.Count; i++)
            {
                if (i < 4)
                {
                    BattleMessageItem skillItem = GetItem(BattleMessageType.atk);
                    var item = NewGameData._InitBattleModel.skills[i];
                    skillItem.SetSkillModel(item);
                }
            }

            foreach (var item in m_InitBattleModel.builds)
            {
                if (item.subType != 0)
                {
                    BattleMessageItem buildItem = GetItem(BattleMessageType.def);
                    buildItem.SetBuildModel(item);
                }
            }
        }

        public void ClearAllItem()
        {
            if (m_AtkItemList.Count > 0)
            {
                for (int i = m_AtkItemList.Count - 1; i >= 0; i--)
                {
                    BattleMessageItem item = m_AtkItemList[i];
                    m_AtkItemList.RemoveAt(i);
                    m_ItemPool.Enqueue(item);
                    item.gameObject.SetActiveEx(false);
                }
            }

            if (m_DefItemList.Count > 0)
            {
                for (int i = m_DefItemList.Count - 1; i >= 0; i--)
                {
                    BattleMessageItem item = m_DefItemList[i];
                    m_DefItemList.RemoveAt(i);
                    m_ItemPool.Enqueue(item);
                    item.gameObject.SetActiveEx(false);
                }
            }
        }

        enum BattleMessageType
        {
            atk,
            def,
        }
        BattleMessageItem GetItem(BattleMessageType type)
        {
            BattleMessageItem item;

            if (m_ItemPool.Count > 0)
            {
                item = m_ItemPool.Dequeue();
            }
            else
            {
                GameObject go = Instantiate(m_messageItem.gameObject);
                item = new BattleMessageItem(go);
            }

            if (type == BattleMessageType.atk)
            {
                m_AtkItemList.Add(item);
                item.transform.SetParent(atkContent);
            }
            else if (type == BattleMessageType.def)
            {
                m_DefItemList.Add(item);

                item.transform.SetParent(defContent);
            }
            item.transform.SetAsLastSibling();
            item.gameObject.SetActive(true);
            item.Init(m_InitBattleModel);

            return item;
        }
    }

    //------------------------------------------------------------------------------

    public class BattleMessageItem
    {
        public GameObject gameObject;
        public Transform transform;
        public RectTransform rectTransform;
        InitBattleModel m_InitBattleModel;

        Text m_TxtType;
        InputField m_InputId;
        InputField m_InputAtkID;
        Text m_TxtSkillEffect;

        Text m_Txt1;

        Button m_BtnExpand;
        RectTransform m_LayoutExpand;
        GameObject m_BattleMessageSkillItem;

        List<BattleMessageSkillItem> m_BattleMessageSkillItemList;

        public BattleMessageItem(GameObject go)
        {
            gameObject = go;
            transform = go.transform;
            rectTransform = go.GetComponent<RectTransform>();

            m_TxtType = transform.Find("TxtType").GetComponent<Text>();
            m_InputId = transform.Find("InputId").GetComponent<InputField>();
            m_InputAtkID = transform.Find("InputAtkID").GetComponent<InputField>();
            m_TxtSkillEffect = transform.Find("TxtSkillEffect").GetComponent<Text>();

            m_Txt1 = transform.Find("Txt1").GetComponent<Text>();

            m_BtnExpand = transform.Find("BtnExpand").GetComponent<Button>();
            m_BtnExpand.onClick.AddListener(OnBtnExpand);
            m_LayoutExpand = transform.Find("LayoutExpand").GetComponent<RectTransform>();
            m_BattleMessageSkillItem = m_LayoutExpand.Find("BattleMessageSkillItem").gameObject;
            m_BattleMessageSkillItem.SetActive(false);

            m_BattleMessageSkillItemList = new List<BattleMessageSkillItem>();
            //m_BattleMessageSkillItemList.Add(new BattleMessageSkillItem(GameObject.Instantiate(m_BattleMessageSkillItem)));
        }

        public void Init(InitBattleModel initBattleModel)
        {
            m_InitBattleModel = initBattleModel;
            m_InputId.text = "";
            m_TxtType.text = "";
            m_InputAtkID.text = "";
            m_TxtSkillEffect.text = "";

            m_Txt1.text = "";
            m_LayoutExpand.gameObject.SetActive(false);
            //SetSkillModels(new SkillModel[] {});
        }

        SkillModel GetSkill(int skillID)
        {
            foreach (var item in m_InitBattleModel.skills)
            {
                if (item.cfgId == skillID)
                {
                    return item;
                }
            }
            return null;
        }

        public void SetHeroModel(HeroModel model)
        {
            m_TxtType.text = """";
            m_InputId.text = "CfgID:" + model.cfgId;
            m_InputAtkID.text = "AtkSkillID:" + model.atkSkillId;
            //SkillModel heroSkill = m_InitBattleModel.heroSkill;
            //m_TxtSkillEffect.text = "SkillId:" + heroSkill.cfgId;

            //m_Txt1.text = "atk:" + model.atk + "  atkSpeed:" + model.atkSpeed + "  atkRange:" + model.atkRange +
            //    "  inAtkRange:" + model.inAtkRange + "  maxHp:" + model.maxHp + "  moveSpeed:" + model.moveSpeed +
            //    "  shield:" + model.shield + "  radius:" + model.radius + "  flashMoveDelayTime:" + model.flashMoveDelayTime +
            //    "  model:" + model.model + "  icon:" + model.icon + "  center:" + model.center + "  deadEffect:" + model.deadEffect +
            //    "  atkType:" + model.atkType + "  atkReadyTime" + model.atkReadyTime + "  level:" + model.level +
            //    "  atkSkillShowRadius:" + model.atkSkillShowRadius + "  isMedical:" + model.isMedical + "  isDeminer:" + model.isDeminer;

            //SetSkillModels(new SkillModel[] { GetSkill(model.atkSkillId), heroSkill });
        }

        public void SetSkillModel(SkillModel model)
        {
            //m_TxtType.text = """";
            //m_InputId.text = "CfgID:" + model.cfgId.ToString();
            //m_InputAtkID.text = "SkillEffectId:" + model.skillEffectCfgId;
            //m_TxtSkillEffect.text = "";
            //m_Txt1.text = "originCost:" + model.originCost + "  addCost:" + model.addCost + "  moveSpeed:" + model.moveSpeed +
            //     "  lifeTime:" + model.lifeTime + "  frequency:" + model.frequency + "  range:" + model.range +
            //      "  icon:" + model.icon + "  model:" + model.model + "  effectModel:" + model.effectModel + "  subModel:" + model.subModel +
            //      "  subEffectModel:" + model.subEffectModel + "  type:" + model.type + "  targetGroup:" + model.targetGroup +
            //      "  geometry:" + model.geometry + "  skillEffectCfgId:" + model.skillEffectCfgId + " intArgs1:" + model.intArgs1 +
            //      "  intArgs2:" + model.intArgs2 + "  intArgs3:" + model.intArgs3 + "  vanishTime:" + model.vanishTime + "  useArea:" + model.useArea;


            //SetSkillModels(new SkillModel[] { model });
        }

        public void SetSoldierModel(SoliderModel model, bool isSummon = false)
        {
            string type = "";
            switch (model.type)
            {
                case 1:
                    type = """";
                    break;
                case 2:
                    type = """";
                    break;

                case 3:
                    type = """";
                    break;
                case 4:
                    type = """";
                    break;
                case 5:
                    type = """";
                    break;
                default:
                    break;
            }

            m_InputId.text = "CfgID:" + model.cfgId;
            if (isSummon)
            {
                type += "("")";
            }
            m_TxtType.text = type;
            m_InputAtkID.text = "AtkSkillID:" + model.atkSkillId.ToString();
            m_TxtSkillEffect.text = "";

            m_Txt1.text = "atk:" + model.atk + "  atkSpeed:" + model.atkSpeed + "  atkRange:" + model.atkRange +
                "  inAtkRange:" + model.inAtkRange + "  maxHp:" + model.maxHp + "  moveSpeed:" + model.moveSpeed + "  model:" + model.model +
                "  icon:" + model.icon + "  amount:" + model.amount + "  shield:" + model.shield + "  radius:" + model.radius +
                "  atkSkillId" + model.atkSkillId + "  flashMoveDelayTime:" + "  type:" + model.type +
                "  center:" + model.center + "  deadEffect:" + model.deadEffect + "  atkType:" + model.atkType +
                "  atkReadyTime:" + model.atkReadyTime + "  atkSkillShowRadius:" + model.atkSkillShowRadius + "  isMedical:" + model.isMedical +
                "  isDeminer:" + model.isDeminer;

            SetSkillModels(new SkillModel[] { GetSkill(model.atkSkillId) });
        }

        public void SetBuildModel(BuildingModel model)
        {
            string type = "";
            switch (model.subType)
            {
                case 1:
                    type = """";
                    break;
                case 2:
                    type = """";
                    break;
                case 3:
                    type = """";
                    break;

                default:
                    break;
            }

            m_InputId.text = "CfgID:" + model.cfgId.ToString();
            m_TxtType.text = type;
            m_InputAtkID.text = "AtkSkillID:" + model.atkSkillId.ToString();
            m_TxtSkillEffect.text = "";

            m_Txt1.text = "atk:" + model.atk + "  atkSpeed:" + model.atkSpeed + "  atkRange:" + model.atkRange +
            "  inAtkRange:" + model.inAtkRange + "  maxHp:" + model.maxHp + "  radius:" + model.radius + "model:" + model.model +
            "  explosionEffect:" + model.explosionEffect + "  wreckageModel:" + model.wreckageModel + "  X:" + model.x + "  Z:" + model.z +
            "  atkAir:" + model.atkAir + "  atkSkillId:" + model.atkSkillId + "  isMain:" + model.isMain + " atkType:" + model.atkType +
            "  atkReadyTime" + model.atkReadyTime + "  atkSkillShowRadius:" + model.atkSkillShowRadius;

            SetSkillModels(new SkillModel[] { GetSkill(model.atkSkillId) });
        }

        public void SetSkillModels(SkillModel[] skillModels)
        {
            if (skillModels != null && skillModels.Length > 0)
            {
                for (int i = 0; i < skillModels.Length; i++)
                {
                    if (i + 1 > m_BattleMessageSkillItemList.Count)
                    {
                        BattleMessageSkillItem newItem = new BattleMessageSkillItem(GameObject.Instantiate(m_BattleMessageSkillItem));
                        newItem.transform.SetParent(m_LayoutExpand, false);
                        m_BattleMessageSkillItemList.Add(newItem);
                    }

                    BattleMessageSkillItem item = m_BattleMessageSkillItemList[i];
                    item.gameObject.SetActive(true);
                    item.Init(m_InitBattleModel);
                    item.SetSkillModel(skillModels[i]);

                    if (i == 0)
                    {
                        item.rectTransform.anchoredPosition = new Vector2(0, -5);
                    }
                    else
                    {
                        BattleMessageSkillItem frontItem = m_BattleMessageSkillItemList[i - 1];
                        item.rectTransform.anchoredPosition = new Vector2(0, frontItem.rectTransform.anchoredPosition.y - frontItem.rectTransform.rect.height - 5);
                    }
                }

                if (m_BattleMessageSkillItemList.Count > skillModels.Length)
                {

                    for (int i = skillModels.Length; i < m_BattleMessageSkillItemList.Count; i++)
                    {
                        m_BattleMessageSkillItemList[i - 1].gameObject.SetActive(false);
                    }
                }

                BattleMessageSkillItem lastItem = m_BattleMessageSkillItemList[skillModels.Length - 1];
                m_LayoutExpand.SetRectSizeY(Mathf.Abs(lastItem.rectTransform.anchoredPosition.y) + lastItem.rectTransform.rect.height + 5);
            }
            else
            {
                foreach (var item in m_BattleMessageSkillItemList)
                {
                    item.gameObject.SetActive(false);
                }
                m_LayoutExpand.SetRectSizeY(0);
            }
        }

        public void SetMessage(int cfgId = 0, string type = "", int atkSkillID = 0, int skillEffectId = 0, SkillModel[] skillModels = null)
        {
            m_InputId.text = "CfgID:" + cfgId.ToString();
            m_TxtType.text = type;
            m_InputAtkID.text = "AtkSkillID:" + atkSkillID.ToString();
            m_TxtSkillEffect.text = "SkillEffectID:" + skillEffectId.ToString();

            SetSkillModels(skillModels);
        }

        float m_DefaultHeight = 170;

        public void OnBtnExpand()
        {
            m_LayoutExpand.SetActiveEx(!m_LayoutExpand.gameObject.activeSelf);

            if (m_LayoutExpand.gameObject.activeSelf)
            {
                transform.GetComponent<RectTransform>().SetRectSizeY(m_DefaultHeight + m_LayoutExpand.rect.height + 5);
            }
            else
            {
                transform.GetComponent<RectTransform>().SetRectSizeY(m_DefaultHeight);

            }
        }
    }
    //------------------------------------------------------------------------------
    public struct BattleMessageSkillSubInfo
    {
        public Transform transform;
        public RectTransform rect;
        public InputField m_InputId;
        public Text m_TxtType;
        public Text m_Txt1;

        public BattleMessageSkillSubInfo(Transform trans)
        {
            transform = trans;
            rect = trans.GetComponent<RectTransform>();
            m_InputId = trans.Find("InputId").GetComponent<InputField>();
            m_TxtType = trans.Find("TxtType").GetComponent<Text>();
            m_Txt1 = trans.Find("Txt1").GetComponent<Text>();
        }

        public void SetMessage(int id, string type)
        {
            m_InputId.text = id.ToString();
            m_TxtType.text = type;
        }
    }

    //------------------------------------------------------------------------------
    public class BattleMessageSkillItem
    {
        float m_SkillSubInfoSpencing = 5;
        float m_DefaultHeight = 38;

        public GameObject gameObject;
        public Transform transform;
        public RectTransform rectTransform;
        InitBattleModel m_InitBattleModel;

        Transform m_LayoutSubInfo;

        Text m_TxtType;
        InputField m_InputId;

        List<BattleMessageSkillSubInfo> m_SubInfoList;

        int m_SubInfoCount = 0;

        public BattleMessageSkillItem(GameObject go)
        {
            go.SetActive(true);
            gameObject = go;
            transform = go.transform;
            rectTransform = go.GetComponent<RectTransform>();

            m_TxtType = transform.Find("TxtType").GetComponent<Text>();
            m_InputId = transform.Find("InputId").GetComponent<InputField>();
            m_LayoutSubInfo = transform.Find("LayoutSubInfo");
            m_SubInfoList = new List<BattleMessageSkillSubInfo> { new BattleMessageSkillSubInfo(m_LayoutSubInfo) };
        }

        public void Init(InitBattleModel initBattleModel)
        {
            m_InitBattleModel = initBattleModel;
            m_SubInfoCount = 0;

            foreach (var item in m_SubInfoList)
            {
                item.transform.SetActiveEx(false);
            }
        }

        public void SetSkillModel(SkillModel skillModel)
        {
            if (skillModel == null)
            {
                gameObject.SetActive(false);
                rectTransform.SetRectSizeY(0);
                return;
            }

            gameObject.SetActive(true);

            m_InputId.text = "SkillCfgId:" + skillModel.cfgId;
            m_TxtType.text = GetSkillTypeName(skillModel.type);

            if (skillModel.skillEffectCfgId > 0)
            {
                SetSubSkillEffect(skillModel.skillEffectCfgId);
            }
            rectTransform.SetRectSizeY(m_DefaultHeight + m_SubInfoCount *
                (m_LayoutSubInfo.GetComponent<RectTransform>().rect.height + m_SkillSubInfoSpencing) - m_SkillSubInfoSpencing + 5);
        }

        void SetSubSkillEffect(int skillEffectId)
        {
            SkillEffectModel skillEffectModel = null;
            foreach (var effect in m_InitBattleModel.skillEffects)
            {
                if (effect.cfgId == skillEffectId)
                {
                    skillEffectModel = effect;
                }
            }
            if (skillEffectModel != null)
            {
                m_SubInfoCount++;

                BattleMessageSkillSubInfo item = GetSubInfoItem(m_SubInfoCount);
                item.SetMessage(skillEffectModel.cfgId, "skillEffect");
                item.m_Txt1.text = "type:" + skillEffectModel.type.ToString() + "  range:" + skillEffectModel.range.ToString();

                if (skillEffectModel.buffCfgId > 0)
                {
                    SetSubBuff(skillEffectModel.buffCfgId);
                }

                if (skillEffectModel.skillCfgId > 0)
                {
                    SetSubSkill(skillEffectModel.skillCfgId);
                }

                if (skillEffectModel.skillEffectCfgId > 0)
                {
                    SetSubSkillEffect(skillEffectModel.skillEffectCfgId);
                }
            }
        }

        void SetSubBuff(int id)
        {
            BuffModel buffModel = null;
            foreach (var item in m_InitBattleModel.buffs)
            {
                if (item.cfgId == id)
                {
                    buffModel = item;
                }
            }
            if (buffModel != null)
            {
                m_SubInfoCount++;
                BattleMessageSkillSubInfo item = GetSubInfoItem(m_SubInfoCount);
                item.SetMessage(buffModel.cfgId, "buff");
                item.m_Txt1.text = "name:" + buffModel.name + "  lifeTime:" + buffModel.lifeTime.ToString() +
                    "  frequency:" + buffModel.frequency.ToString();

                if (buffModel.skillEffectCfgId > 0)
                {
                    SetSubSkillEffect(buffModel.skillEffectCfgId);
                }
            }
        }

        void SetSubSkill(int id)
        {
            SkillModel model = null;
            foreach (var item in m_InitBattleModel.skills)
            {
                if (item.cfgId == id)
                {
                    model = item;
                }
            }
            if (model != null)
            {
                //m_SubInfoCount++;
                //BattleMessageSkillSubInfo item = GetSubInfoItem(m_SubInfoCount);
                //item.SetMessage(model.cfgId, "skill");
                //item.m_Txt1.text = "range:" + model.range.ToString() + "  lifeTime:" + model.lifeTime.ToString() +
                //    "  frequency:" + model.frequency.ToString();

                //if (model.skillEffectCfgId > 0)
                //{
                //    SetSubSkillEffect(model.skillEffectCfgId);
                //}
            }
        }

        public BattleMessageSkillSubInfo GetSubInfoItem(int index)
        {
            if (m_SubInfoList.Count < index)
            {
                BattleMessageSkillSubInfo newItem = new BattleMessageSkillSubInfo(GameObject.Instantiate(transform.Find("LayoutSubInfo")));
                newItem.transform.SetParent(transform);
                m_SubInfoList.Add(newItem);

                if (index > 1)
                {
                    BattleMessageSkillSubInfo frontItem = m_SubInfoList[index - 2];
                    newItem.rect.anchoredPosition = new Vector2(frontItem.rect.anchoredPosition.x,
                        frontItem.rect.anchoredPosition.y - frontItem.rect.rect.height - m_SkillSubInfoSpencing);
                }
            }

            BattleMessageSkillSubInfo item = m_SubInfoList[index - 1];
            item.transform.SetActiveEx(true);
            return item;
        }

        public string GetSkillTypeName(int type)
        {
            switch (type)
            {
                case 1:
                    return "RangeSkill";

                    break;
                case 2:
                    return "SignalBombSkill";
                    break;
                case 3:
                    return "SummonSkill";
                    break;

                case 4:
                    return "BounceChainSkill";
                    break;

                case 5:
                    return "PointLocationRangeSkill";
                    break;

                case 6:
                    return "SummonAirSoliderSkill";
                    break;

                case 7:
                    return "StraightAtkSkill";
                    break;

                case 8:
                    return "RectangleRangeAtkSkill";
                    break;

                case 9:
                    return "FireRainSkill";
                    break;

                case 10:
                    return "Inhalation";
                    break;

                case 11:
                    return "BezierCurveSkill";
                    break;

                case 12:
                    return "Laser";
                    break;


                case 13:
                    return "Cluster";
                    break;

                default:
                    return "";
                    break;
            }

        }


    }

}