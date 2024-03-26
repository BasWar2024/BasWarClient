using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class Troops
    {
        public Action<int, int> AllSoliderReturnCallBack;

        //""：""
        public Dictionary<EntityBase, bool> SoliderDict;
        public int Oper;
        public int Amount;

        public Troops(int oper, int amount)
        {
            Oper = oper;
            Amount = amount;
            SoliderDict = new Dictionary<EntityBase, bool>();
        }

        public void CheckAllSoliderReturn()
        {
            bool allReturn = true;
            foreach (var kv in SoliderDict)
            {
                if (kv.Value == false)
                {
                    allReturn = false;
                    break;
                }
            }

            if (allReturn)
            {
                SoliderDict.Clear();
                AllSoliderReturnCallBack?.Invoke(Oper, Amount);
            }
        }

        public void Release()
        {
            SoliderDict.Clear();
            SoliderDict = null;
            AllSoliderReturnCallBack = null;
        }
    }
}
