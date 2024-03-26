using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public enum SkillEffectType
    {
        //--10000~14999 atk （""）
        Atk_10001 = 10001, //""
        Atk_10002 = 10002, //""1""
        Atk_10003 = 10003, //""
        PercentageDamage_10004 = 10004, //""
        BurnSkillEffect_10005 = 10005, //""
        Bloodthirsty_10006 = 10006, //""
        Atk_10007 = 10007, //"" * ""
        BurnSkillEffect_10008 = 10008, //""

        //--15000~19999 heal
        Heal_15000 = 15000,
        HealBuff_15001 = 15001,

        //--20000~20999 add atkSpeed
        AtkSpeed_20000 = 20000,
        AtkSpeedAndMoveSpeed_20001,
        AtkSpeedTimes_20002, //""，""。
        MinusAtkSpeed_20003, //""。

        //--21000~21999 add moveSpeed
        MoveSpeed_21000 = 21000,
        MinusMoveSpeed_21001 = 21001,

        //--22000~22999 atk（""）
        AddAtk_22000 = 22000,
        AddAtkAndAtkSpeed_22001,
        AddAtkAndMoveSpeed_22002,
        MinusAtk_22003,
        AtkAddAtk_22004, //""

        //23000~23999 ""
        Summon_23000 = 23000,


        //24000 ""

  		Shield_24000 = 24000,
        Cloak_24002 = 24002, //"" ""，""，""，""
        MaxHp_24003 = 24003, //""
        StrengthenAtk_24004 = 24004, //""
        StrengthenGetHurt_24005 = 24005, //""
        StopAction_24006 = 24006, //""
        SmokeCloak_24007 = 24007, //"" ""
        Invincible_24008 = 24008, //""
        StopAction_Cloak_24009 = 24009, //""+"" ""
        Sneer_24010 = 24010, //"" ""
        BreakAtkcd_24011 = 24011, //""CD("")
        ShieldMaxHp_24012 = 24012, //""
        ReBuild_24013 = 24013, //""
        BounceAtk_24014 = 24014, //""
        LowHpAction_24015 = 24015, //""

        //25000 ""
        CreateBuff_25000 = 25000, //""BUFF
        CreateSkill_25001 = 25001, //""skill
        ChangeAtkSkillId_25002 = 25002, //""
        AroundAttr_25003 = 25003, //""（""）
    }
}
