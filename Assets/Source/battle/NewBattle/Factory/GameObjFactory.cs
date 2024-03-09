


namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
    using Spine.Unity;
    using System.Collections.Generic;

    //
    public class GameObjFactory
    {
        public List<GameObject> GameObjList = new List<GameObject>();
        public void CreateGameObj(string path, FixVector3 pos)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                GameObjList.Add(obj);
                obj.transform.position = pos.ToVector3();

                return true;
            });
        }

        public void ReleaseGameObj(GameObject GameObj)
        {
            if (GameObj != null)
            {
                GG.ResMgr.instance.ReleaseAsset(GameObj);
                GameObjList.Remove(GameObj);
            }
        }

        public void ReleaseAllObj()
        {
            for (int i = GameObjList.Count - 1; i >= 0; i--)
            {
                ReleaseGameObj(GameObjList[i]);
            }
            GameObjList.Clear();
        }
    }
#endif
}