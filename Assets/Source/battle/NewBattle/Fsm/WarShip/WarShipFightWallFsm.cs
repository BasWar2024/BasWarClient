#if _CLIENTLOGIC_
namespace Battle
{
    using System.Collections.Generic;

    using Spine.Unity;
    using UnityEngine;


    public class WarShipFightWallFsm : FsmState<LockStepLogicMonoBehaviour>
    {
        private Transform m_Wall1;
        private Transform m_Wall2;
        private int m_WarShipAtkNum;
        private int m_TotalAtkNum;
        private int m_TotalKillWallNum;
        private float m_AtkCD = 0.2f;
        private float m_Time;
        private List<Transform> m_WallList;
        private Transform m_WarShip;
        private List<Bullet2Wall> m_Bullet2WallList;
        public override void OnInit(LockStepLogicMonoBehaviour owner)
        {
            base.OnInit(owner);
        }

        public override void OnEnter(LockStepLogicMonoBehaviour owner)
        {
            base.OnEnter(owner);
            var allWall = GameObject.Find("Wall").transform;
            m_WarShip = owner.WarShip;
            allWall.Find($"Wall1_Tower{owner.SigninId}").gameObject.SetActive(false);

            switch (owner.SigninId)
            {
                case 1:
                    m_Wall1 = allWall.Find($"Wall1");
                    m_Wall2 = allWall.Find($"Wall4");
                    break;
                case 2:
                    m_Wall1 = allWall.Find($"Wall1");
                    m_Wall2 = allWall.Find($"Wall2");
                    break;
                case 3:
                    m_Wall1 = allWall.Find($"Wall2");
                    m_Wall2 = allWall.Find($"Wall3");
                    break;
                default:
                    m_Wall1 = allWall.Find($"Wall3");
                    m_Wall2 = allWall.Find($"Wall4");
                    break;
            }

            m_WarShipAtkNum = 0;
            m_TotalKillWallNum = 0;
            m_Time = 0;

            m_WallList = new List<Transform>();
            m_Bullet2WallList = new List<Bullet2Wall>();

            for (int i = 0; i < m_Wall1.childCount; i++)
            {
                m_WallList.Add(m_Wall1.GetChild(i));
                m_WallList.Add(m_Wall2.GetChild(i));
            }

            m_TotalAtkNum = m_WallList.Count;
        }

        public override void OnUpdate(LockStepLogicMonoBehaviour owner)
        {
            base.OnUpdate(owner);

            if (m_WarShipAtkNum < m_TotalAtkNum)
            {
                m_Time += Time.deltaTime;

                if (m_Time >= m_AtkCD)
                {
                    GG.ResMgr.instance.LoadGameObjectAsync("Bullet_Missile", CreateMissile);
                    m_Time -= m_AtkCD;
                }
            }

            foreach (var value in m_Bullet2WallList)
            {
                if (value.CanRelease)
                    continue;

                value.Bullet.position = value.Bullet.position + value.Bullet2WallDir * 1f;

                if (Vector3.Distance(value.Bullet.position, value.Wall.position) <= 1)
                {
                    value.CanRelease = true;
                    value.Bullet.gameObject.SetActive(false);
                    value.Wall.gameObject.SetActive(false);
                    NewGameData._EffectFactory.CreateEffect("Missile_spine", new FixVector3((Fix64)value.Wall.position.x, (Fix64)value.Wall.position.y, (Fix64)value.Wall.position.z));
                    m_TotalKillWallNum++;
                }
            }

            if (m_TotalKillWallNum >= m_TotalAtkNum)
            {
                owner.Fsm.ChangeFsmState<WarShipOverFsm>();
            }
        }


        private bool CreateMissile(GameObject arg)
        {
            arg.transform.position = m_WarShip.position;
            arg.transform.SetParent(NewGameData.BattleMono);
            arg.transform.LookAt(m_WallList[m_WarShipAtkNum]);
            m_Bullet2WallList.Add(new Bullet2Wall(arg.transform, m_WallList[m_WarShipAtkNum], (m_WallList[m_WarShipAtkNum].position - arg.transform.position).normalized));
            m_WarShipAtkNum++;
            return true;
        }

        public override void OnLeave(LockStepLogicMonoBehaviour owner)
        {
            base.OnLeave(owner);
            m_WallList.Clear();
            m_Bullet2WallList.Clear();
            m_WallList = null;
            m_Bullet2WallList = null;
            m_Wall1 = null;
            m_Wall2 = null;
            m_WarShip = null;
        }
    }
}
#endif