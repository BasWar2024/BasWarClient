


using Battle;
using System;
using System.Collections.Generic;

public class EndBattle
{
    //Int64, string, int, int, string, string
    public Int64 battleId;
    public string bVersion;
    public int ret; //, 0, 1
    public int signinPosId;
    public List<OperInfo> operate;
    public List<BattleDamage> result;

    public EndBattle(Int64 battleId, string bVersion, int ret, int signinPosId, List<OperInfo> operInfoList, Dictionary<Int64, int> deadEntityDict)
    {
        this.battleId = battleId;
        this.bVersion = bVersion;
        this.ret = ret;
        this.signinPosId = signinPosId;
        this.operate = operInfoList;
        this.result = new List<BattleDamage>();
        foreach (KeyValuePair<Int64, int> kv in deadEntityDict)
        {
            BattleDamage bd = new BattleDamage();
            bd.uuid = kv.Key;
            bd.amount = kv.Value;
            result.Add(bd);
        }
    }
}

