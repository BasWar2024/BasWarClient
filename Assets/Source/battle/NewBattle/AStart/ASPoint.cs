

namespace Battle
{

#if _CLIENTLOGIC_
    using UnityEngine;
#endif


    public class ASPoint
    {
#if _CLIENTLOGIC_
        public GameObject PointGameObject;
#endif
        public ASPoint Parent;

        //F = G + H
        public Fix64 F;
        //H "" B "" (H "", "" "")
        public Fix64 H;
        //G "" A "" ("")
        public Fix64 G;

        public Fix64 X;
        public Fix64 Z;

        public bool IsWall = false;

        public ASPoint(Fix64 x, Fix64 z)
        {
            X = x;
            Z = z;
#if _CLIENTLOGIC_
            //PointGameObject = GameObject.CreatePrimitive(PrimitiveType.Capsule);
            ////PointGameObject = GameObject.Instantiate(cubeAssets);
            //PointGameObject.transform.position = new Vector3((int)X, 0, (int)Z);
            //PointGameObject.transform.localScale = Vector3.one * 0.5f;
            ////PointGameObject.transform.SetParent(GameObject.Find("Cube").transform);
            //PointGameObject.name = $"{X},{Z}";
#endif
        }

        public void UpdateParent(ASPoint parent, Fix64 g)
        {
            Parent = parent;
            G = g;
            F = G + H;
        }

        public FixVector3 GetFixLogicPosition()
        {
            return new FixVector3(X, Fix64.Zero, Z); //isInTheSky ? NewGameData.AirHigh : 
        }

        public FixVector2 GetFixLogicPosition2D()
        {
            return new FixVector2(X, Z); //isInTheSky ? NewGameData.AirHigh : 
        }

        public void Release()
        {
            Parent = null;
        }
    }
}
