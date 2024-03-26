


namespace Battle
{
    public class BuffValue
    {
        private Buff Buff;
        private Fix64 Value;
        public BuffType BuffType;

        public void Init(Buff buff, Fix64 value, BuffType buffType)
        {
            Buff = buff;
            Value = value;
            BuffType = buffType;
        }

        public Buff GetBuff()
        {
            return Buff;
        }

        public Fix64 GetValue()
        {
            return Value;
        }

        public void SetValue(Fix64 value)
        {
            Value = value;
        }

        public void Release()
        {
            Buff.Release();
            Buff = null;
            Value = Fix64.Zero;
            BuffType = BuffType.None;
            NewGameData._PoolManager.Push(this);
        }
    }
}
