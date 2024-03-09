
namespace Battle
{
    public enum OperOrder
    {
        None = 0,
        LaunchSolider1 = 1,
        LaunchSolider2 = 2,
        LaunchSolider3 = 3,
        LaunchSolider4 = 4,
        LaunchSolider5 = 5,
        LaunchSolider6 = 6,
        LaunchSolider7 = 7,
        LaunchSolider8 = 8,

        LaunchHero = 9,
        DoHeroSkill = 10,

        DoSkill1 = 11,
        DoSkill2 = 12,
        DoSkill3 = 13,
        DoSkill4 = 14,
        DoSkill5 = 15,
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
    }

    public enum SoliderType
    {
        None = 0,
        LandSolider = 1,
        AirSolider = 2,
        LandingShip = 3,
        LandHero = 4,
    }

    public enum BuildingType
    {
        None = 0,
        NorEconomy = 1, //
        NorDevelop = 2, //
        DefenseTower = 3, //
        Trap = 4, //
        //DefenseTower = 1,
        //NormalBuilding = 2,
        //Trap = 3,
    }

    public enum BulletType
    {
        None = 0,
        SingleStraight = 1,
        SingleParabola = 2,
        AoeStraight = 3,
        AoeParabola = 4,
    }

    public enum SkillType
    {
        None = 0,
        HeroSkill = 1,
        WarShipMissileSkill = 2,
        WarShipBuffSkill = 3, //
        SignalBomb = 4,
        SmokeBomb = 5,
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
        None = 0, //
        ReachSignal = 1, //
        NoReachSignal = 2, //
    }

    public enum ModelType
    {
        None = 0,
        Model2D = 1,
        Model3D = 2,
    }

    public enum AnimType
    {
        Idle = 0,
        Move = 1,
        Atk = 2,
        Dead = 3,
        FlashIdle = 4,
    }

    public enum Direction8
    {
        None = -1,
        Ang0 = 0,
        Ang45 = 1,
        Ang90 = 2,
        Ang135 = 3,
        Ang180 = 4,
        Ang225 = 5,
        Ang270 = 6,
        Ang315 = 7,
        Ang360 = 8,
    }

    public enum Direction30
    {
        None = -1,
        Ang0 = 0,
        Ang12 = 1,
        Ang24 = 2,
        Ang36 = 3,
        Ang48 = 4,
        Ang60 = 5,
        Ang72 = 6,
        Ang84 = 7,
        Ang96 = 8,
        Ang108 = 9,
        Ang120 = 10,
        Ang132 = 11,
        Ang144 = 12,
        Ang156 = 13,
        Ang168 = 14,
        Ang180 = 15,
        Ang192 = 16,
        Ang204 = 17,
        Ang216 = 18,
        Ang228 = 19,
        Ang240 = 20,
        Ang252 = 21,
        Ang264 = 22,
        Ang276 = 23,
        Ang288 = 24,
        Ang300 = 25,
        Ang312 = 26,
        Ang324 = 27,
        Ang336 = 28,
        Ang348 = 29,
        Ang360 = 30,
    }

    public enum BattleStage
    {
        PreBattle = 0,
        ReadyBattle = 1,
        WarshipSignin = 2,
        InBattle = 3,
        EndBattle = 4,
    }

    public enum AtkType
    {
        AtkBoth = 0,
        AtkLand = 1,
        AtkAir = 2,
    }
}