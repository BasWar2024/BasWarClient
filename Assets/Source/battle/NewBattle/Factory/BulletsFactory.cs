

namespace Battle
{
    public class BulletsFactory
    {
        public BulletBase CreateBullet(EntityBase origin, EntityBase target, FixVector3 originPos, FixVector3 targetPos)
        {
            BulletBase bullet;
            BulletModel model = NewGameData._OperBulletDict[origin.BulletId];
            var type = (BulletType)model.type;
            switch (type)
            {
                case BulletType.SingleStraight:
                    bullet = new StraightBullet();
                    break;
                case BulletType.SingleParabola:
                    bullet = new ParabolaBullet();
                    break;
                case BulletType.AoeStraight:
                    bullet = new StraightBullet();
                    bullet.IsAoe = true;
                    break;
                case BulletType.AoeParabola:
                    bullet = new ParabolaBullet();
                    bullet.IsAoe = true;
                    break;
                default:
                    bullet = new BulletBase();
                    break;
            }

            bullet.ResPath = model.model;
            bullet.EffectResPath = model.explosionEffect;
            bullet.MoveSpeed = (Fix64)model.moveSpeed / 1000;
            bullet.AtkRange = (Fix64)model.atkRange / 1000;
            bullet.Fixv3LogicPosition = originPos;
            bullet.Init(origin, target, originPos, targetPos);

            NewGameData._BulletList.Add(bullet);
            if (!bullet.IsAoe)
                NewGameData.BulletLaunch2Entiy(bullet, target);

            return bullet;
        }
    }
}
