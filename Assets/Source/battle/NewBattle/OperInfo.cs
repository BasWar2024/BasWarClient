

namespace Battle
{
    using System;
    [Serializable]
    public class OperInfo
    {
        public int GameFrame;
        public int Order;
        public float X;
        public float Y;
        public float Z;

        public void Init(OperOrder order, FixVector3 v3)
        {
            //GameFrame = NewGameData._UGameLogicFrame;
            Order = (int)order;
            X = (float)v3.x;
            Y = (float)v3.y;
            Z = (float)v3.z;
        }
    }
}

