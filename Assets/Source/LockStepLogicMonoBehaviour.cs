//
// @brief: 
// @version: 1.0.0
// @author helin
// @date: 03/7/2018
// 
// 
//
#if _CLIENTLOGIC_
using UnityEngine;
#endif
using Battle;
using System;
using System.Collections.Generic;
using SimpleJson;
using SimpleJson.Reflection;

public class LockStepLogicMonoBehaviour : MonoBehaviour
{

    public NewBattleLogic BattleLogic = new NewBattleLogic();
    public bool IsSignin = false;
    public Transform Terrain;
    public Transform SigninPos;
    public int SigninId;
    private SimpleSocket m_SocketClient;
    private Transform m_SigninTag;
    private Dictionary<Transform, Transform> m_Missile2WallDict = new Dictionary<Transform, Transform>(); //WALL
    public FsmCompent<LockStepLogicMonoBehaviour> Fsm;
    public Transform WarShip;
    //private NewBattleUI m_NewBattleUI;


    public OperOrder CurrOrder = OperOrder.None;

#if _CLIENTLOGIC_
    public Action ShowOperUI;
    public Action<int> CloseOperUI;
    public Action UpdateSkillPoint;
#endif

    // Use this for initialization
    void Start()
    {
#if _CLIENTLOGIC_

#else
    GameData.g_uGameLogicFrame = 0;
    GameData.g_bRplayMode = true;
    battleLogic.init();
    battleLogic.updateLogic();
#endif
    }

    public void InitBattleLogic(Int64 battleId, string battleInfo)
    {
        if (Terrain == null)
        {
            Terrain = GameObject.Find("Terrain").transform;
        }
        NewGameData._InitBattleJson = battleInfo;
        NewGameData._BattleId = battleId;
        Debug.Log(battleId);

        NewGameData.BattleMono = transform;
        m_SigninTag = Terrain.Find("LandPoint");
        m_SigninTag.gameObject.SetActive(true);
        Fsm = new FsmCompent<LockStepLogicMonoBehaviour>();
        Fsm.CreateFsm(this, new WarShipReadyFsm(), new WarShipMoveFsm(), new WarShipFightWallFsm(), new WarShipOverFsm());
        BattleLogic.Init(null, BattleStage.PreBattle);
#if _CLIENTLOGIC_
        BattleLogic.SkillPointsChange += SkillPointUpdateCallBack;
        BattleLogic.WarShipSignin += WarShipSignin;
#endif
    }

    public void WarShipSignin(int signinId)
    {
        m_SigninTag.gameObject.SetActive(false);
        BattleLogic.Stage = BattleStage.WarshipSignin;
        CurrOrder = OperOrder.LaunchSolider1;
        SigninId = signinId;
        SigninPos = Terrain.Find("SigninPos").GetChild(signinId - 1);
        GG.ResMgr.instance.LoadGameObjectAsync("WarShip", CreateWarShipSuccess);
    }

    private bool CreateWarShipSuccess(GameObject arg)
    {
        WarShip = arg.transform;
        WarShip.SetParent(NewGameData.BattleMono);
        NewGameData._SigninPosId = SigninId;
        NewGameData.CreateLandShipPos = new FixVector3((Fix64)SigninPos.position.x, NewGameData.AirHigh, (Fix64)SigninPos.position.z);
        Fsm.OnStart<WarShipReadyFsm>();
        return true;
    }

    public void StartBattle()
    {
        var deployArea = Terrain.Find("DeployArea");
        SigninId--;

        deployArea.GetChild(SigninId).gameObject.SetActive(true);
        deployArea.GetChild(SigninId - 1 == -1 ? 3 : SigninId - 1).gameObject.SetActive(true);

        ShowOperUI?.Invoke();
        BattleLogic.StartBattle();
    }

    public void OnOperOrder(OperOrder order)
    {
        CurrOrder = order;
    }

    public void OnClickHeroSkill()
    {
        if (NewGameData._Hero == null)
            return;

        CurrOrder = OperOrder.DoHeroSkill;
        BattleLogic.AcceptOperOrder(CurrOrder, FixVector3.Zero);
    }

    public void OnRePlay()
    {
        if (string.IsNullOrEmpty(NewGameData.RePlayJson))
            return;

        NewGameData.IsRePlay = true;
        BattleLogic.Init(NewGameData.RePlayJson);
        BattleLogic.StartBattle();
    }

    public void OnServerRePlay()
    {
        if (string.IsNullOrEmpty(NewGameData.RePlayJson))
            return;

        string json = NewGameData.RePlayJson;

        if (json == null)
            return;

        if (m_SocketClient == null)
        {
            m_SocketClient = new SimpleSocket();
            m_SocketClient.Init();
        }

        m_SocketClient.SendBattleRecordToServer(json);
    }

#if _CLIENTLOGIC_
    public void OnFingerUp(Vector3 mousePosition)
    {
        if (BattleLogic.IsBattlePause)
            return;

        if (BattleLogic.Stage == BattleStage.ReadyBattle)
        {
            Ray ray = Camera.main.ScreenPointToRay(mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, 1000))
            {
                string str = hit.collider.gameObject.name;
                if (str.Contains("LandPoint"))
                {
                    int i = int.Parse(str.Substring(str.Length - 1, 1));
                    WarShipSignin(i);
                }
            }
        }
        else if(BattleLogic.Stage == BattleStage.InBattle)
        {
            if (CurrOrder == OperOrder.DoHeroSkill)
                return;

            Ray ray = Camera.main.ScreenPointToRay(mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 1000, 1 << 8 | 1 << 9))
            {
                var layer = hit.collider.gameObject.layer;

                if (NewGameData._DispatchDict.TryGetValue(CurrOrder, out bool isDispatch))
                {
                    if (isDispatch)
                    {
                        UnityTools.Log("");
                        return;
                    }
                }

                if (CurrOrder <= OperOrder.LaunchSolider8) //
                {
                    if (NewGameData._OperSoliderDict.TryGetValue(CurrOrder, out SoliderModel model))
                    {
                        if (model.type != 2) //
                        {
                            if (layer == 9)
                            {
                                UnityTools.Log("");
                                return;
                            }
                        }
                    }
                }
                else if (CurrOrder == OperOrder.LaunchHero)
                {
                    if (layer == 9)
                    {
                        UnityTools.Log("");
                        return;
                    }
                }
                else if (CurrOrder >= OperOrder.DoSkill1) //
                {
                    if (NewGameData._SkillCostPointsDict.TryGetValue(CurrOrder, out Fix64 cost))
                    {
                        if (NewGameData._SkillPoints < cost)
                        {
                            UnityTools.Log("");
                            return;
                        }
                    }
                }

                bool result = BattleLogic.AcceptOperOrder(CurrOrder, new FixVector3((Fix64)hit.point.x, (Fix64)0, (Fix64)hit.point.z));

                if (result)
                {
                    SetOperOrder();
                }
            }
        }
    }

    void Update()
    {
        BattleLogic.UpdateLogic();

        if (BattleLogic.Stage == BattleStage.WarshipSignin && Fsm.GetCurrState() != null)
            Fsm.OnUpdate(this);
    }

    private void SkillPointUpdateCallBack()
    {
        UpdateSkillPoint?.Invoke();
    }
#endif

    private void SetOperOrder()
    {
        if (CurrOrder <= OperOrder.LaunchHero && CurrOrder != OperOrder.None)
        {
            NewGameData._DispatchDict[CurrOrder] = true;

            CloseOperUI?.Invoke((int)CurrOrder);

            foreach (var kv in NewGameData._DispatchDict)
            {
                if (kv.Key > OperOrder.LaunchHero)
                    continue;

                if (!kv.Value)
                {
                    CurrOrder = kv.Key;

                    return;
                }
            }

            CurrOrder = OperOrder.None;
        }
    }

    private void OnDisable()
    {
        BattleLogic.SkillPointsChange = null;
        BattleLogic.WarShipSignin = null;
        BattleLogic.UpdateTime = null;
        UpdateSkillPoint = null;
        ShowOperUI = null;
        CloseOperUI = null;

        

        //var deployArea = Terrain.Find("DeployArea");

        //for (int i = 0; i < deployArea.childCount; i++)
        //{
        //    deployArea.GetChild(i).gameObject.SetActive(false);
        //}

        //Terrain.Find("LandPoint").gameObject.SetActive(false);
        //#endif

        Fsm.ReleaseAllFsmState();
        Fsm = null;
    }

//    private void OnDestroy()
//    {
////#if _CLIENTLOGIC_
//        BattleLogic.SkillPointsChange = null;
//        BattleLogic.WarShipSignin = null;
//        BattleLogic.UpdateTime = null;
//        UpdateSkillPoint = null;
//        ShowOperUI = null;
//        CloseOperUI = null;

//        var deployArea = Terrain.Find("DeployArea");

//        for (int i = 0; i < deployArea.childCount; i++)
//        {
//            deployArea.GetChild(i).gameObject.SetActive(false);
//        }

//        Terrain.Find("LandPoint").gameObject.SetActive(false);
////#endif

//        Fsm.ReleaseAllFsmState();
//        Fsm = null;
//    }
}

