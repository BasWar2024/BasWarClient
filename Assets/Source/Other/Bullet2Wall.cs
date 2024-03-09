
using UnityEngine;

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif
    public class Bullet2Wall
    {
        public Transform Bullet;
        public Transform Wall;
        public Vector3 Bullet2WallDir;
        public bool CanRelease = false;

        public Bullet2Wall(Transform bullet, Transform wall, Vector3 bullet2WallDir)
        {
            Bullet = bullet;
            Wall = wall;
            Bullet2WallDir = bullet2WallDir;
        }
    }
}
