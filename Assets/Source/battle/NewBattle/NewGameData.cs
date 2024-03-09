

using System;
using System.Collections.Generic;
using Battle;
using SimpleJson;

//namespace Battle
//{
public class NewGameData
{
    //
    public static int _UGameLogicFrame = 0;

    public static AStar _AStar = new AStar();

    //json
    //public static string InitBattleJson = "{\"BuildingList\":[{\"cfgId\":0,\"model\":\"Base_spine\",\"explosionEffect\":\"Eff_BuildingDie_3x3\",\"wreckageModel\":\"dead_platform_3x3\",\"x\":30.5,\"z\":30.5,\"maxHp\":300,\"atk\":0,\"atkSpeed\":0,\"atkRange\":0,\"radius\":2500,\"bulletCfgId\":0,\"isMain\":1,\"type\":2}],\"TrapList\":[{\"cfgId\":0,\"model\":\"High-explosivemayflymines_spine\",\"explosionEffect\":\"Eff_BuildingDie_1x1\",\"x\":30,\"z\":20,\"buffCfgId\":7,\"alertRange\":1000,\"atkRange\":2000,\"radius\":1000,\"delayExplosionTime\":500}],\"SoliderList\":[{\"cfgId\":1,\"model\":\"Particlegunner_spine\",\"icon\":\"Particlegunner_icon\",\"amount\":12,\"moveSpeed\":5000,\"maxHp\":2000,\"atk\":60,\"atkSpeed\":500,\"atkRange\":2000,\"radius\":1000,\"originCost\":0,\"addCost\":0,\"bulletCfgId\":1,\"flashMoveDelayTime\":500,\"type\":1}],\"Hero\":{\"cfgId\":10,\"model\":\"alien_spine\",\"icon\":\"Particlegunner_spine\",\"moveSpeed\":2800,\"maxHp\":1000,\"atk\":12,\"atkSpeed\":300,\"atkRange\":300,\"radius\":1000,\"flashMoveDelayTime\":0,\"bulletCfgId\":0},\"MainShip\":{\"cfgId\":20,\"model\":\"'01'\",\"skillPoint\":80},\"SkillList\":[{\"cfgId\":10,\"model\":\"Bullet_Missile\",\"icon\":\"skill1_icon\",\"effectModel\":\"Missile_spine\",\"buffCfgId\":1,\"moveSpeed\":65000,\"lifeTime\":0,\"frequency\":0,\"range\":1000,\"originCost\":1,\"addCost\":1,\"followSelf\":0,\"type\":2}],\"HeroSkill\":{\"cfgId\":10,\"model\":\"GroupBUFF_spine2\",\"icon\":\"skill5_icon\",\"effectModel\":\"\",\"buffCfgId\":5,\"moveSpeed\":20000,\"lifeTime\":3000,\"frequency\":500,\"range\":4000,\"originCost\":3,\"addCost\":3,\"followSelf\":1,\"type\":1},\"BulletList\":[{\"cfgId\":1,\"model\":\"Bullet_Particlegunner\",\"explosionEffect\":\"\",\"type\":1,\"moveSpeed\":30000,\"atkRange\":0}],\"BuffList\":[{\"cfgId\":1,\"model\":\"\",\"atk\":100,\"cure\":0,\"addAtk\":0,\"addAtkSpeed\":0,\"addMoveSpeed\":0,\"stopAction\":0,\"lifeTime\":0,\"frequency\":0,\"lifeType\":0},{\"cfgId\":7,\"model\":\"\",\"atk\":300,\"cure\":0,\"addAtk\":0,\"addAtkSpeed\":0,\"addMoveSpeed\":0,\"stopAction\":0,\"lifeTime\":0,\"frequency\":0,\"lifeType\":0}]}";
    public static string _InitBattleJson = "";
    public static Int64 _BattleId;
    public static Fix64 _FixFrameLen = Fix64.FromRaw(273);
    public static Dictionary<Int64, int> _DeadEntityDict = new Dictionary<Int64, int>(); // KV

    public static bool _Victory = false;

    public static float _CumTime = 0;//
    public static float _Time = 0;
    public static float _MaxReadyTime = 40;
    public static float _MaxBattleTime = 240;

    public static string RePlayJson;

    //
    public static SRandom _Srand = new SRandom(1000);

    //Y0
    public static Fix64 AirHigh = (Fix64)5;
    public static Fix64 WarShipHigh = (Fix64)10;

    public static SignalBombSkill _SignalBomb = null; //
    public static EntityBase _SignalLockBuilding = null; //

    public static int _SigninPosId;
    public static FixVector3 _SigninPos1 = new FixVector3((Fix64)55, AirHigh, (Fix64)55);
    public static FixVector3 _SigninPos2 = new FixVector3((Fix64)55, AirHigh, (Fix64)3);
    public static FixVector3 _SigninPos3 = new FixVector3((Fix64)3, AirHigh, (Fix64)3);
    public static FixVector3 _SigninPos4 = new FixVector3((Fix64)3, AirHigh, (Fix64)55);

    public static FixVector3 _FixForword = new FixVector3(Fix64.Zero, Fix64.Zero, Fix64.One);
    public static float _HpBarMaxWidth = 0.75f; //

    public static bool IsRePlay = false;

    public static FightManager _FightManager = new FightManager();
    public static EntityManager _EntityManager = new EntityManager();

    //
    public static List<EntityBase> _BuildingList = new List<EntityBase>();

    //
    public static List<EntityBase> _TrapList = new List<EntityBase>();

    //
    public static List<EntityBase> _SoldierList = new List<EntityBase>();

    public static EntityBase _Hero;

    //
    public static List<EntityBase> _BulletList = new List<EntityBase>();

    //
    public static List<EntityBase> _SkillList = new List<EntityBase>();

    //BUFF
    public static List<EntityBase> _BuffList = new List<EntityBase>();

    //
    public static List<OperInfo> _OperInfoList = new List<OperInfo>();
    //
    public static List<OperInfo> _OperInfoRePlayList = new List<OperInfo>();
    //jsonlistlist
    public static Dictionary<int, OperInfo> _OperInfoRePlayDict = new Dictionary<int, OperInfo>();
    //
    public static Queue<OperInfo> _OperInfoPool = new Queue<OperInfo>();

    //
    public static Dictionary<OperOrder, SoliderModel> _OperSoliderDict = new Dictionary<OperOrder, SoliderModel>();
    public static HeroModel _OperHero;
    public static Dictionary<OperOrder, SkillModel> _OperSkillDict = new Dictionary<OperOrder, SkillModel>();
    public static HeroSkillModel _OperHeroSkill;
    public static Dictionary<int, BulletModel> _OperBulletDict = new Dictionary<int, BulletModel>();
    public static Dictionary<int, BuffModel> _OperBuffDict = new Dictionary<int, BuffModel>();

    //
    public static List<EntityBase> _DeadList = new List<EntityBase>();

    public static BuildingFactory _BuildingFactory = new BuildingFactory();
    public static SoliderFactory _SoliderFactory = new SoliderFactory();
    public static HeroFactory _HeroFactory = new HeroFactory();
    public static BulletsFactory _BulletFactory = new BulletsFactory();
    public static SkillFactory _SkillFactory = new SkillFactory();
    public static BuffFactory _BuffFactory = new BuffFactory();
    public static TrapFactory _TrapFactory = new TrapFactory();
#if _CLIENTLOGIC_
    public static EffectFactory _EffectFactory = new EffectFactory();
    public static GameObjFactory _GameObjFactory = new GameObjFactory();
    public static UnityEngine.Transform BattleMono;
#endif
    public static FixVector3 CreateLandShipPos = FixVector3.Zero;
    public static FixVector3 MapMidPos = new FixVector3((Fix64)29, Fix64.Zero, (Fix64)29);
    public static FixVector3 MapMidAirPos = new FixVector3((Fix64)29, AirHigh, (Fix64)29);

    public static Fix64 _SkillPoints = Fix64.Zero; //
    public static Dictionary<OperOrder, Fix64> _SkillCostPointsDict = new Dictionary<OperOrder, Fix64>();

    public static InitBattleModel _InitBattleModel; //JsonData

    public static Dictionary<OperOrder, bool> _DispatchDict = new Dictionary<OperOrder, bool>(); //18hero

    public static Dictionary<EntityBase, FixVector2> _BuildingPathFindPointDict = new Dictionary<EntityBase, FixVector2>(); //

    public static Dictionary<EntityBase, List<BuildingAroundPoint>> _BuildingAroundPointDict = new Dictionary<EntityBase, List<BuildingAroundPoint>>(); //

    public static void BulletLaunch2Entiy(EntityBase bullet, EntityBase injured)
    {
        if(injured == null)
        {
            UnityTools.Log("");
            return;
        }

        if (injured.BKilled)
            return;

        injured.ListAttackMeBullet.Add(bullet);
        bullet.LockedAttackEntity = injured;
    }

    public static void EntityLockEntity(EntityBase attacker, EntityBase injured)
    {
        attacker.LockedAttackEntity = injured;
        injured.ListAttackMe.Add(attacker);
    }

    /// <summary>
    /// 
    /// </summary>
    public static void ResetReachSignal()
    {
        foreach (var entity in _SoldierList)
        {
            if (entity.SignalState != SignalState.None)
                entity.SignalState = SignalState.NoReachSignal;
        }

        if (_Hero != null)
        {
            _Hero.SignalState = SignalState.NoReachSignal;
        }
    }

    public static void SignalLockBuild()
    {
        if (_SignalBomb == null)
            return;

        foreach (var build in _BuildingList)
        {
            var distance = FixVector3.Distance(build.Fixv3LogicPosition, _SignalBomb.Fixv3LogicPosition);
            if (distance <= build.Radius + _SignalBomb.Radius)
            {
                _SignalLockBuilding = build;
                return;
            }
        }
    }

    public static void SetBuildingAroundPoint()
    {
        if (_BuildingList.Count <= 0)
            return;

        foreach (var build in _BuildingList)
        {
            var fixV2 = _BuildingPathFindPointDict[build];

            if(fixV2 != null)
            {
                List<BuildingAroundPoint> buildingAroundPointList = new List<BuildingAroundPoint>();
                FixVector2 buildCenter = new FixVector2(build.Fixv3LogicPosition.x, build.Fixv3LogicPosition.z);
                for (Fix64 i = Fix64.Zero; i < Fix64.PI2; i += Fix64.PI2 / 18)
                {
                    Fix64 x = buildCenter.x + build.Radius * Fix64.Cos(i);
                    Fix64 z = buildCenter.y + build.Radius * Fix64.Sin(i);
                    BuildingAroundPoint aroundPoint = new BuildingAroundPoint(new FixVector3(x, Fix64.Zero, z), false);
                    buildingAroundPointList.Add(aroundPoint);
                }

                _BuildingAroundPointDict.Add(build, buildingAroundPointList);
            }
        }
    }

    //
    public static BuildingAroundPoint GetBuildingAroundPoint(EntityBase build)
    {
        //FixVector3 build2Solider = solider.Fixv3LogicPosition - build.Fixv3LogicPosition;
        var aroundPointList = _BuildingAroundPointDict[build];
        foreach (var point in aroundPointList)
        {
            if (!point.Use)
            {
                point.Use = true;
                return point;
            }
        }

        return null;
    }

    //cppjson
    public static InitBattleModel CreateBattleModel(string json)
    {
        var initBattleJsonObj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(json);
        InitBattleModel initBattleModel = new InitBattleModel();

        var buildingList = initBattleJsonObj.GetJsonArray("BuildingList");
        var soliderList = initBattleJsonObj.GetJsonArray("SoliderList");
        var hero = initBattleJsonObj.GetJsonObject("Hero");
        var mainShip = initBattleJsonObj.GetJsonObject("MainShip");
        var skillList = initBattleJsonObj.GetJsonArray("SkillList");
        var heroSkill = initBattleJsonObj.GetJsonObject("HeroSkill");
        var bulletList = initBattleJsonObj.GetJsonArray("BulletList");
        var buffList = initBattleJsonObj.GetJsonArray("BuffList");
        var trapList = initBattleJsonObj.GetJsonArray("TrapList");

        if(buildingList != null)
        {
            initBattleModel.BuildingList = new List<BuildingModel>();

            foreach (var building in buildingList)
            {
                var buildingJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(building.ToString());
                BuildingModel buildingModel = new BuildingModel();
                buildingModel.cfgId = buildingJobj.GetInt("cfgId");
                buildingModel.model = buildingJobj.GetString("model");
                buildingModel.explosionEffect = buildingJobj.GetString("explosionEffect");
                buildingModel.wreckageModel = buildingJobj.GetString("wreckageModel");
                buildingModel.x = buildingJobj.GetFloat("x");
                buildingModel.z = buildingJobj.GetFloat("z");
                buildingModel.maxHp = buildingJobj.GetInt("maxHp");
                buildingModel.atk = buildingJobj.GetInt("atk");
                buildingModel.atkSpeed = buildingJobj.GetInt("atkSpeed");
                buildingModel.atkRange = buildingJobj.GetInt("atkRange");
                buildingModel.radius = buildingJobj.GetInt("radius");
                buildingModel.atkAir = buildingJobj.GetInt("atkAir");
                buildingModel.bulletCfgId = buildingJobj.GetInt("bulletCfgId");
                buildingModel.isMain = buildingJobj.GetInt("isMain");
                buildingModel.type = buildingJobj.GetInt("type");

                initBattleModel.BuildingList.Add(buildingModel);
            }
        }

        if (soliderList != null)
        {
            initBattleModel.SoliderList = new List<SoliderModel>();

            foreach (var solider in soliderList)
            {
                var soliderJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(solider.ToString());
                SoliderModel soliderModel = new SoliderModel();
                soliderModel.cfgId = soliderJobj.GetInt("cfgId");
                soliderModel.uuid = soliderJobj.GetLong("uuid");
                soliderModel.model = soliderJobj.GetString("model");
                soliderModel.icon = soliderJobj.GetString("icon");
                soliderModel.amount = soliderJobj.GetInt("amount");
                soliderModel.moveSpeed = soliderJobj.GetInt("moveSpeed");
                soliderModel.maxHp = soliderJobj.GetInt("maxHp");
                soliderModel.atk = soliderJobj.GetInt("atk");
                soliderModel.atkSpeed = soliderJobj.GetInt("atkSpeed");
                soliderModel.atkRange = soliderJobj.GetInt("atkRange");
                soliderModel.radius = soliderJobj.GetInt("radius");
                soliderModel.originCost = soliderJobj.GetInt("originCost");
                soliderModel.addCost = soliderJobj.GetInt("addCost");
                soliderModel.bulletCfgId = soliderJobj.GetInt("bulletCfgId");
                //solidetModel.IsAtkAndReturn = soliderJobj.GetInt("IsAtkAndReturn");
                soliderModel.flashMoveDelayTime = soliderJobj.GetInt("flashMoveDelayTime");
                soliderModel.type = soliderJobj.GetInt("type");

                initBattleModel.SoliderList.Add(soliderModel);
            }
        }

        var heroJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(hero.ToString());
        HeroModel heroModel = new HeroModel();
        heroModel.cfgId = heroJobj.GetInt("cfgId");
        heroModel.model = heroJobj.GetString("model");
        heroModel.icon = heroJobj.GetString("icon");
        heroModel.moveSpeed = heroJobj.GetInt("moveSpeed");
        heroModel.maxHp = heroJobj.GetInt("maxHp");
        heroModel.atk = heroJobj.GetInt("atk");
        heroModel.atkSpeed = heroJobj.GetInt("atkSpeed");
        heroModel.atkRange = heroJobj.GetInt("atkRange");
        heroModel.radius = heroJobj.GetInt("radius");
        heroModel.flashMoveDelayTime = heroJobj.GetInt("flashMoveDelayTime");
        heroModel.bulletCfgId = heroJobj.GetInt("bulletCfgId");

        initBattleModel.Hero = heroModel;

        var mainShipJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(mainShip.ToString());
        MainShipModel mainShipModel = new MainShipModel();
        mainShipModel.cfgId = mainShipJobj.GetInt("cfgId");
        mainShipModel.model = mainShipJobj.GetString("model");
        mainShipModel.skillPoint = mainShipJobj.GetInt("skillPoint");

        initBattleModel.MainShip = mainShipModel;

        if(skillList != null)
        {
            initBattleModel.SkillList = new List<SkillModel>();

            foreach (var skill in skillList)
            {
                var skillJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(skill.ToString());
                SkillModel skillModel = new SkillModel();
                skillModel.cfgId = skillJobj.GetInt("cfgId");
                skillModel.model = skillJobj.GetString("model");
                skillModel.icon = skillJobj.GetString("icon");
                skillModel.effectModel = skillJobj.GetString("effectModel");
                skillModel.buffCfgId = skillJobj.GetInt("buffCfgId");
                skillModel.moveSpeed = skillJobj.GetInt("moveSpeed");
                skillModel.lifeTime = skillJobj.GetInt("lifeTime");
                skillModel.frequency = skillJobj.GetInt("frequency");
                skillModel.range = skillJobj.GetInt("range");
                skillModel.originCost = skillJobj.GetInt("originCost");
                skillModel.addCost = skillJobj.GetInt("addCost");
                skillModel.followSelf = skillJobj.GetInt("followSelf");
                skillModel.type = skillJobj.GetInt("type");
                //skillModel.ApplyTo = skillJobj.GetInt("ApplyTo");

                initBattleModel.SkillList.Add(skillModel);
            }
        }

        var heroSkillJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(heroSkill.ToString());
        HeroSkillModel heroSkillModel = new HeroSkillModel();
        heroSkillModel.cfgId = heroSkillJobj.GetInt("cfgId");
        heroSkillModel.model = heroSkillJobj.GetString("model");
        heroSkillModel.icon = heroSkillJobj.GetString("icon");
        heroSkillModel.effectModel = heroSkillJobj.GetString("effectModel");
        heroSkillModel.buffCfgId = heroSkillJobj.GetInt("buffCfgId");
        heroSkillModel.moveSpeed = heroSkillJobj.GetInt("moveSpeed");
        heroSkillModel.lifeTime = heroSkillJobj.GetInt("lifeTime");
        heroSkillModel.frequency = heroSkillJobj.GetInt("frequency");
        heroSkillModel.range = heroSkillJobj.GetInt("range");
        heroSkillModel.originCost = heroSkillJobj.GetInt("originCost");
        heroSkillModel.addCost = heroSkillJobj.GetInt("addCost");
        heroSkillModel.followSelf = heroSkillJobj.GetInt("followSelf");
        heroSkillModel.type = heroSkillJobj.GetInt("type");
        //heroSkillModel.ApplyTo = heroSkillJobj.GetInt("ApplyTo");

        initBattleModel.HeroSkill = heroSkillModel;

        if (bulletList != null)
        {
            initBattleModel.BulletList = new List<BulletModel>();

            foreach (var bullet in bulletList)
            {
                var bulletJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(bullet.ToString());
                BulletModel bulletModel = new BulletModel();
                bulletModel.cfgId = bulletJobj.GetInt("cfgId");
                bulletModel.model = bulletJobj.GetString("model");
                bulletModel.explosionEffect = bulletJobj.GetString("explosionEffect");
                bulletModel.type = bulletJobj.GetInt("type");
                bulletModel.moveSpeed = bulletJobj.GetInt("moveSpeed");
                bulletModel.atkRange = bulletJobj.GetInt("atkRange");

                initBattleModel.BulletList.Add(bulletModel);
            }
        }

        if (buffList != null)
        {
            initBattleModel.BuffList = new List<BuffModel>();

            foreach (var buff in buffList)
            {
                var buffJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(buff.ToString());
                BuffModel buffModel = new BuffModel();
                buffModel.cfgId = buffJobj.GetInt("cfgId");
                buffModel.model = buffJobj.GetString("model");
                //buffModel.EffectResPath = buffJobj.GetString("EffectResPath");
                buffModel.atk = buffJobj.GetInt("atk");
                buffModel.cure = buffJobj.GetInt("cure");
                buffModel.addAtk = buffJobj.GetInt("addAtk");
                buffModel.addAtkSpeed = buffJobj.GetInt("addAtkSpeed");
                buffModel.addMoveSpeed = buffJobj.GetInt("addMoveSpeed");
                buffModel.stopAction = buffJobj.GetInt("stopAction");
                buffModel.lifeTime = buffJobj.GetInt("lifeTime");
                buffModel.frequency = buffJobj.GetInt("frequency");
                buffModel.lifeType = buffJobj.GetInt("lifeType");

                initBattleModel.BuffList.Add(buffModel);
            }
        }

        if (trapList != null)
        {
            initBattleModel.TrapList = new List<TrapModel>();

            foreach (var trap in trapList)
            {
                var trapJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(trap.ToString());
                TrapModel trapModel = new TrapModel();
                trapModel.cfgId = trapJobj.GetInt("cfgId");
                trapModel.model = trapJobj.GetString("model");
                trapModel.explosionEffect = trapJobj.GetString("explosionEffect");
                trapModel.x = trapJobj.GetFloat("x");
                trapModel.z = trapJobj.GetFloat("z");
                trapModel.buffCfgId = trapJobj.GetInt("buffCfgId");
                trapModel.alertRange = trapJobj.GetInt("alertRange");
                trapModel.atkRange = trapJobj.GetInt("atkRange");
                trapModel.radius = trapJobj.GetInt("radius");
                trapModel.delayExplosionTime = trapJobj.GetInt("delayExplosionTime");

                initBattleModel.TrapList.Add(trapModel);
            }
        }

        return initBattleModel;
    }

    public static BattleInfo CreateBattleInfo(string json)
    {
        BattleInfo battleInfo = new BattleInfo();
        var battleinfoJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(json);
        var operInfoList = battleinfoJobj.GetJsonArray("OperInfoList");
        var initBattle = battleinfoJobj.GetJsonObject("InitBattle");

        battleInfo.SigninId = battleinfoJobj.GetInt("SigninId");

        battleInfo.OperInfoList = new List<OperInfo>();

        foreach (var operInfo in operInfoList)
        {
            OperInfo info = new OperInfo();
            var operInfoJobj = SimpleJson.SimpleJson.DeserializeObject<JsonObject>(operInfo.ToString());
            info.GameFrame = operInfoJobj.GetInt("GameFrame");
            info.Order = operInfoJobj.GetInt("Order");
            info.X = operInfoJobj.GetFloat("X");
            info.Y = operInfoJobj.GetFloat("Y");
            info.Z = operInfoJobj.GetFloat("Z");

            battleInfo.OperInfoList.Add(info);
        }


        battleInfo.InitBattle = CreateBattleModel(initBattle.ToString());

        return battleInfo;
    }

    public static void Init()
    {
        foreach (var entity in _BuildingList)
        {
            entity.Release();
        }

        foreach (var entity in _TrapList)
        {
            entity.Release();
        }

        foreach (var entity in _SoldierList)
        {
            entity.Release();
        }

        foreach (var entity in _BulletList)
        {
            entity.Release();
        }

        foreach (var skill in _SkillList)
        {
            skill.Release();
        }

        foreach (var buff in _BuffList)
        {
            buff.Release();
        }

        foreach (var entity in _DeadList)
        {
            entity.Release();
        }

        foreach (var list in _BuildingAroundPointDict)
        {
            list.Value.Clear();
        }

        _Victory = false;
        _SignalBomb = null;
        _SignalLockBuilding = null;

        _Hero?.Release();
        //_SId = 0;
        _SkillPoints = Fix64.Zero;

        _InitBattleModel?.Release();
        _AStar.Init();
        _Time = 0;
        _UGameLogicFrame = 0;
        _OperSoliderDict.Clear();
        _OperSkillDict.Clear();
        _OperBulletDict.Clear();
        _OperBuffDict.Clear();
        _OperHero = null;
        _OperHeroSkill = null;
        _BuildingList.Clear();
        _TrapList.Clear();
        _SoldierList.Clear();
        _Hero = null;
        _BulletList.Clear();
        _SkillList.Clear();
        _BuffList.Clear();
        _OperInfoList.Clear();
        _DeadList.Clear();
        //_StopActionList.Clear();
        _OperInfoRePlayList.Clear();
        _OperInfoRePlayDict.Clear();
        _OperInfoPool.Clear();
        _DispatchDict.Clear();
        _SkillCostPointsDict.Clear();
        _BuildingPathFindPointDict.Clear();
        _BuildingAroundPointDict.Clear();
        _DeadEntityDict.Clear();
#if _CLIENTLOGIC_
        _EffectFactory.ReleaseAllEffect();
        _GameObjFactory.ReleaseAllObj();
#endif
    }

    public static void Release()
    {
#if _CLIENTLOGIC_
        BattleMono = null;
#endif
        IsRePlay = false;
        RePlayJson = "";
        Init();
    }
}
//}
