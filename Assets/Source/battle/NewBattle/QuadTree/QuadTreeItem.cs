

namespace Battle
{
    public class QuadTreeItem 
    {
        private EntityBase m_EntityBase;
        private QuadTreeNode m_QuadTreeNode;
        //""item，""
        public bool IsRetrieve;

        public void Init(EntityBase entity, QuadTreeNode node)
        {
            m_EntityBase = entity;
            m_QuadTreeNode = node;
            IsRetrieve = false;
        }

        public EntityBase GetEntity()
        {
            return m_EntityBase;
        }

        public QuadTreeNode GetNode()
        {
            return m_QuadTreeNode;
        }

        public void SetNode(QuadTreeNode node)
        {
            m_QuadTreeNode = node;
        }

        public void Release()
        {
            m_EntityBase = null;
            m_QuadTreeNode = null;
            if (!IsRetrieve)
            {
                NewGameData._PoolManager.Push(this);
                IsRetrieve = true;
            }
        }
    }
}
