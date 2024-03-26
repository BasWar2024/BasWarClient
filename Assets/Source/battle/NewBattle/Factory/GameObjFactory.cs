


namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
    using System.Collections.Generic;
    using System;

    //""
    public class GameObjFactory
    {
        public List<GameObject> GameObjList = new List<GameObject>();
        public void CreateGameObj(string path, FixVector3 pos, Action<GameObject> callBack = null)
        {
            if (string.IsNullOrEmpty(path))
                return;

            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                GameObjList.Add(obj);
                obj.transform.position = pos.ToVector3();
                callBack?.Invoke(obj);
                return true;
            }, true, null, NewGameData._AssetOriginPos);
        }

        //""
        public void CreateGameObj(string path, Vector3 pos, Action<GameObject> callBack = null)
        {
            GG.ResMgr.instance.LoadGameObjectAsync(path, (obj) =>
            {
                GameObjList.Add(obj);
                obj.transform.position = pos;
                callBack?.Invoke(obj);
                return true;
            }, true, null, NewGameData._AssetOriginPos);
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