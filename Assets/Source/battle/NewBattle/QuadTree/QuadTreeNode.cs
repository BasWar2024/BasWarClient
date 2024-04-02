
using System.Collections.Generic;
#if _CLIENTLOGIC_
using UnityEngine;
#endif

namespace Battle
{
    public class QuadTreeNode
    {
        public int Depth; //""
        public int MaxDepth = 3;
        public List<QuadTreeNode> ChildNodes; //""
        public int MaxItem = 5;
        public List<QuadTreeItem> QuadTreeItems; //"",""

#if UNITY_EDITOR
        public GameObject Message;
#endif

        public Fix64 Width;
        public Fix64 Length;
        public FixVector3 Center;

        //depth=0 & root=null，""
        public void Init(int depth, FixVector3 center, Fix64 width, Fix64 length)
        {
            Depth = depth;
            Center = center;
            Width = width;
            Length = length;

            if (QuadTreeItems == null)  
                QuadTreeItems = new List<QuadTreeItem>();

#if UNITY_EDITOR
            if (Depth != 0)
            {
                if (Message == null)
                {
                    GG.ResMgr.instance.LoadGameObjectAsync("Hp", (obj) =>
                    {
                        obj.transform.Find("Hp").gameObject.SetActive(false);
                        Message = obj;
                        obj.transform.position = Center.ToVector3();
                        if (obj.GetComponent<LineRenderer>() == null)
                        {
                            obj.AddComponent<LineRenderer>();
                        }
                        obj.transform.localRotation = Quaternion.Euler(45, 45, 0);
                        return true;
                    }, true, null, NewGameData._AssetOriginPos);
                }
            }
#endif
        }

        //""
        public void Split4Node()
        {
            if (ChildNodes == null)
                ChildNodes = new List<QuadTreeNode>();

            for (int i = 0; i < 4; i++)
            {
                var offset = FixVector3.Zero;

                switch (i)
                {
                    case 0:
                        offset = new FixVector3(Width / 4, Fix64.Zero, Length / 4);
                        break;
                    case 1:
                        offset = new FixVector3(Width / 4, Fix64.Zero, -Length / 4);
                        break;
                    case 2:
                        offset = new FixVector3(-Width / 4, Fix64.Zero, Length / 4);
                        break;
                    case 3:
                        offset = new FixVector3(-Width / 4, Fix64.Zero, -Length / 4);
                        break;
                }

                var childNode = NewGameData._PoolManager.Pop<QuadTreeNode>();
                var newCenter = Center + offset;
                childNode.Init(Depth + 1, newCenter, Width / 2, Length / 2);

                ChildNodes.Add(childNode);
            }
        }

        //""，""
        private void PushNode()
        {
            for (int i = QuadTreeItems.Count - 1; i >= 0; i--)
            {
                var item = QuadTreeItems[i];
                QuadTreeItems.Remove(item);
                Insert(item);
            }

            QuadTreeItems.Clear();
        }

        public void Insert(QuadTreeItem item)
        {
            if (Depth < MaxDepth && QuadTreeItems.Count > MaxItem)
            {
                Split4Node();
                foreach (var childNode in ChildNodes)
                {
                    childNode.Insert(item);
                }

                PushNode(); 
            }
            else
            {
                //""
                if (ChildNodes == null || ChildNodes.Count == 0)
                {
                    if (QuadTreeItems == null)
                        QuadTreeItems = new List<QuadTreeItem>();

                    QuadTreeItems.Add(item);
                }
                else
                {
                    foreach (var childNode in ChildNodes)
                    {
                        var intersect =
                            FixMath.Rectangle(item.GetEntity(), childNode.Center, NewGameData._FixForword, childNode.Length / 2, childNode.Width / 2);

                        if (intersect)
                            childNode.Insert(item);
                    }
                }
            }
        }

        public void Release()
        {
            if (ChildNodes != null)
            {
                for (int i = ChildNodes.Count - 1; i >= 0; i--)
                {
                    var childNode = ChildNodes[i];
                    childNode.Release();
                }

                ChildNodes.Clear();
            }

            if (QuadTreeItems != null)
            {
                for (int i = QuadTreeItems.Count - 1; i >= 0; i--)
                {
                    var item = QuadTreeItems[i];
                    if(!item.IsRetrieve)
                        item.Release();
                }

                QuadTreeItems.Clear();
            }

#if UNITY_EDITOR
            if (Message != null && Message.GetComponent<LineRenderer>() != null)
            {
                GG.ResMgr.instance.ReleaseAsset(Message.gameObject);
            }
            Message = null;
#endif

            if (Depth != 0)
                NewGameData._PoolManager.Push(this);
        }
    }
}
