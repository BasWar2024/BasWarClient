
#if UNITY_EDITOR
using UnityEngine;
#endif

namespace Battle
{
    public class QuadTreeManager
    {
        public QuadTreeNode RootNode;
        public void Init()
        {
            RootNode = NewGameData._PoolManager.Pop<QuadTreeNode>();
            RootNode.Init(0, new FixVector3((Fix64)26, Fix64.Zero, (Fix64)26), NewGameData._MapBoundaryWidth, NewGameData._MapBoundaryLength);
        }


        //""
        public void UpdateQuadTree()
        {
            if (RootNode != null)
                RootNode.Release();

            foreach (var entity in NewGameData._SoldierList)
            {
                var item = NewGameData._PoolManager.Pop<QuadTreeItem>();
                item.Init(entity, RootNode);
                RootNode.Insert(item);
            }
        }

#if UNITY_EDITOR

        public void ShowBound(QuadTreeNode node)
        {
            if (node != null)
            {
                CreateBound(node);
                if (node.Message != null)
                {
                    node.Message.transform.Find("TxtMessage").GetComponent<TextMesh>().text =
                        node.QuadTreeItems.Count == 0 ? "" : node.QuadTreeItems.Count.ToString();
                }

                if (node.ChildNodes != null)
                {
                    foreach (var childNode in node.ChildNodes)
                    {
                        ShowBound(childNode);
                    }
                }
            }
        }

        private void CreateBound(QuadTreeNode node)
        {
            if (node.Message != null)
            {
                var offset1 = new Vector3((float)node.Width / 2, 0, (float)node.Length / 2) + node.Center.ToVector3();
                var offset2 = new Vector3((float)node.Width / 2, 0, -(float)node.Length / 2) + node.Center.ToVector3();
                var offset3 = new Vector3(-(float)node.Width / 2, 0, (float)node.Length / 2) + node.Center.ToVector3();
                var offset4 = new Vector3(-(float)node.Width / 2, 0, -(float)node.Length / 2) + node.Center.ToVector3();
                DrawTool.DrawRectangle(node.Message.transform, offset1, offset2, offset4, offset3);
            }
        }
#endif

        public void Release()
        {
            if (RootNode != null)
                RootNode.Release();

            RootNode = null;
        }
    }
}
