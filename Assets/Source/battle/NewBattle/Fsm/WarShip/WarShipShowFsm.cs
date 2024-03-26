#if _CLIENTLOGIC_
namespace Battle
{
    using UnityEngine;

    public class WarShipShowFsm : FsmState<LockStepLogicMonoBehaviour>
    {
        private Vector3 m_Pos;
        private Material[] m_Material;
        private float m_Rad;
        private float m_MoveLength;
        private float m_Explicit;
        private float m_Step = 0.7f;
        private Vector3 m_StepLength;
        private float m_EffCreateLength = 32;
        private MeshRenderer[] m_Mr;
        private GameObject[] m_WarShipBody;
        public override void OnInit(LockStepLogicMonoBehaviour owner)
        {
            base.OnInit(owner);
        }

        //""
        public override void OnEnter(LockStepLogicMonoBehaviour owner)
        {
            base.OnEnter(owner);
            //m_Rad = owner.WarShip.rotation.eulerAngles.y * Mathf.PI / 180;
            //m_Pos = owner.WarShip.position + owner.WarShip.forward * m_EffCreateLength;
            //int childCount = owner.WarShip.transform.Find("Body").childCount;
            //m_WarShipBody = new GameObject[childCount];
            //m_Mr = new MeshRenderer[childCount];
            //m_Material = new Material[childCount];
            //for (int i = 0; i < childCount; i++) {
            //    m_WarShipBody[i] = owner.WarShip.transform.Find("Body").GetChild(i).gameObject;
            //    m_Mr[i] = m_WarShipBody[i].GetComponent<MeshRenderer>();
            //    var mat1 = m_WarShipBody[i].GetComponent<GradualChange>().Mat1;
            //    m_Mr[i].material = mat1;
            //    mat1.SetTexture("_MainTex", m_WarShipBody[i].GetComponent<GradualChange>().Mat2.mainTexture);
            //    m_Material[i] = m_Mr[i].material;
            //}
            ////m_Mr = owner.WarShip.GetComponent<MeshRenderer>();
            ////m_Mr.material = owner.WarShip.GetComponent<GradualChange>().Mat1;
            ////m_Material = m_Mr.material;
            //m_StepLength = owner.WarShip.forward * m_Step;
            //m_MoveLength = 0;
            //m_Explicit = 0;

            //""
            owner.Fsm.ChangeFsmState<WarShipOverFsm>();
        }

        //public override void OnUpdate(LockStepLogicMonoBehaviour owner)
        //{
        //    m_MoveLength += m_Step;

        //    base.OnUpdate(owner);
        //    m_Pos -= m_StepLength;

        //    for (int i = 0; i < m_Material.Length; i++) {
        //        m_Material[i].SetVector("_EffectPos", m_Pos);
        //        m_Material[i].SetFloat("_Rad", m_Rad);
        //    }
        //    //m_Material.SetVector("_EffectPos", m_Pos);
        //    //m_Material.SetFloat("_Rad", m_Rad);
        //    if (m_MoveLength >= 2 * m_EffCreateLength)
        //    {
        //        m_Explicit += 0.03f;
        //        for (int i = 0; i < m_Material.Length; i++) {
        //            m_Material[i].SetFloat("_Explicit", m_Explicit);
        //        }
        //        //m_Material.SetFloat("_Explicit", m_Explicit);

        //        if (m_Explicit >= 1)
        //        {
        //            owner.Fsm.ChangeFsmState<WarShipOverFsm>();
        //        }
        //    }
        //}

        public override void OnLeave(LockStepLogicMonoBehaviour owner)
        {
            base.OnLeave(owner);
            
            //for (int i = 0; i < m_Mr.Length; i++) {
            //    m_Mr[i].material = m_WarShipBody[i].GetComponent<GradualChange>().Mat2;
            //    m_WarShipBody[i].GetComponent<GradualChange>().enabled = false;
            //}

            //m_Material = null;
            //m_Mr = null;
            //m_WarShipBody = null;
            //m_Mr.material = owner.WarShip.GetComponent<GradualChange>().Mat2;
            //owner.WarShip.GetComponent<GradualChange>().enabled = false;
        }
    }
}
#endif