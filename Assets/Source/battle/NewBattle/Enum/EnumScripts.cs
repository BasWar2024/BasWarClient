
namespace Battle
{
    public enum OperOrder
    {
        None = 0,
        Launch1 = 1,
        Launch2 = 2,
        Launch3 = 3,
        Launch4 = 4,
        Launch5 = 5,

        DoHeroSkill1 = 6,
        DoHeroSkill2 = 7,
        DoHeroSkill3 = 8,
        DoHeroSkill4 = 9,
        DoHeroSkill5 = 10,

        DoSkill1 = 11,
        DoSkill2 = 12,
        DoSkill3 = 13,
        DoSkill4 = 14,
    }

    public enum GroupType
    {
        None = 0,
        PlayerGroup = 1,
        EnemyGroup = 2,
    }

    public enum ObjectType
    {
        None = 0,
        Soldier = 1,
        Tower = 2,
        Bullet = 3,
        Skill = 4,
        Trap = 5,
        Buff = 6,
        Mineral = 7,
    }

    public enum SoliderType
    {
        None = 0,
        LandSolider = 1,
        BomberAirSolider = 2,
        LandingShip = 3,
        Tank = 4,
        SuicideAirSolider = 5, //"" ""
        Arsenal = 6, //""
        CarrierAircraft = 7,//""
        LandSolider16Dir = 8,//16""
        SuicideMonAirSolider = 9, //""
        AirSolider = 10, //""
        SuicideChildAirSolider = 11, //""

        LandHero = 99,
    }

    public enum BuildingType
    {
        None = 0,
        NorEconomy = 1, //""
        NorDevelop = 2, //""
        DefenseTower = 3, //""
        Trap = 4, //""
        Mineral = 8 //""

    }

    public enum BuildingSubType
    {
        None = 0,
        DefenseTower = 1,
        Trap = 2,
    }

    public enum SkillType
    {
        None = 0,
        RangeSkill = 1,
        SignalBombSkill = 2,
        SummonSkill = 3, //""
        BounceChainSkill = 4, //""
        PointLocationRangeSkill = 5, //""
        SummonAirSoliderSkill = 6, //""
        StraightAtkSkill = 7, //""
        RectangleRangeAtkSkill = 8, //""
        FireRainSkill = 9, //""
        Inhalation = 10, //""
        BezierCurveSkill = 11, //""
        Laser = 12, //""
        Cluster = 13, //""
        AbsorbSkill = 14, //""（""A，""B）
        SectorShootSkill = 15, //""
        LaserStrafeSkill = 16, //""
        ChargeSkill = 17, //""
        UpthrowStraightSkill = 18, //""（""）
        RangeMoreTargetSkill = 19, //""N""，""
        SkillEmitterSkill = 20,  //""
        SectorSkill = 21, //""
        RangeMoreTargetOneHurt18Skill = 22, //""（""18""，""）
        TornadoSkill = 23, //""，""
        ShieldStabSkill = 24, //""，""E
        ThundercloundSkill = 25, //""
        ReBuildSkill = 26, //""
    }

    public enum TrapType
    {
        None = 0,
        NormalTrap = 1,
    }

    public enum FindPathType
    {
        None = 0,
        FindBuilding = 1,
        FindSignal = 2,
        FindSignalLockBuilding = 3,
    }

    public enum SignalState
    {
        None = 0, //""
        ReachSignal = 1, //""
        NoReachSignal = 2, //""
    }

    public enum ModelType
    {
        None = 0,
        Model2D = 1,
        Model3D = 2,
        Model2D_Tank = 3,
    }

    public enum AnimType
    {
        Idle = 0,
        Move = 1,
        Atk = 2,
        Dead = 3,
        FlashIdle = 4,
        Ready = 5,
        Birth = 6,
    }

    public enum BattleStage
    {
        PreBattle = 0,
        ReadyBattle = 1,
        WarshipSignin = 2,
        InBattle = 3,
        EndBattle = 4,
        PushReport2Server = 5, //""
    }

    public enum AtkAir
    {
        AtkBoth = 0,
        AtkLand = 1,
        AtkAir = 2,
    }

    public enum BattleType
    {
        Battle = 0, //PVP""
        Replay = 1, //PVP""
        UnionBattle = 2, //""，""，""
        //UnionBattleReplay = 3, //""，""
    }

    public enum TargetGroup
    {
        All = 0,
        Teammate = 1,
        Enemy = 2,
        Self = 3,
    }
    
    public enum GeometryType
    {
        None = 0,
        Circle = 1,
    }

    public enum BuffAttr
    {
        None = 0,
        AddAtk = 1,//""cfgid,""
        AddMoveSpeed = 2,//""cfgid,""
        AddAtkSpeed = 3,//""cfgid,""
        MinusAtk = 4,//""cfgid,""
        MinusMoveSpeed = 5,//""cfgid,""
        MinusAtkSpeed = 6,//""cfgid,""
        StopAction = 7,//"" ""
        Invincible = 8,//"" ""
        Cloak = 9, //"" ""
        Burn = 10, //Cfgid"",""，""
        Shield = 11, //""
        Bloodthirsty = 12, //""
        AddMaxHp = 13, //"" ""cfgid,""
        MinusMaxHp = 14, //"" ""cfgid,""
        StrengthenAtk = 15, //"" ""
        StrengthenGetHurt = 16, //"" ""
        Smoke = 17, //"" ""
        Cure = 18, //""BUFF ""
        AddFixValueAtk = 19, //"" （AtkAddAtk""） ""cfgid,""
        Sneer = 20, //"" ""
        BounceAtk = 21, //"" ""
        Order = 99, //""buff，""
    }

    public enum BuffType
    {
        None = 0,
        Sole_MaxValue = 1, //""，""cfgid,""
        Sole_MinValue = 2, //""，""cfgid,""
        Sole_Cover = 3, //""，""
        SoleCfgid_MaxValue = 4, //Cfgid"",""，""
        Sole = 5, //""
    }

    public enum Attr
    {
        Atk = 1,
        MoveSpeed = 2,
        AtkSpeed = 3,
        Hp = 4,
        Shield = 5,
        DamageReduction = 6, //""

        Hurt = 99, //""，""
    }

    //""
    public enum AreaType
    {
        All = 0,
        LandArea = 1, //""
        BuildArea = 2, //""
    }
}