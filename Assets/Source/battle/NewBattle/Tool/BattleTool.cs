using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
#if _CLIENTLOGIC_
using UnityEngine;
using DG.Tweening;

#endif

namespace Battle
{
    public static class BattleTool {
        // isField"" field"" "" 
        public static void CamreaLookAtEntity(EntityBase entity, bool isField = false, float field = 0, float delay = 0)
        {
#if _CLIENTLOGIC_
            Camera camera = Camera.main;
            Vector3 entityPos = entity.Fixv3LogicPosition.ToVector3();
            Plane plane = new Plane(camera.transform.position, camera.transform.position + camera.transform.right, camera.transform.position + camera.transform.up);
            float distance = plane.GetDistanceToPoint(entityPos);
            Vector3 pos = entityPos - camera.transform.forward * distance;

            Sequence seq = DOTween.Sequence();
            seq.AppendInterval(delay);
            seq.Append(camera.transform.DOMove(pos, 2f));
            //""
            //if (isField) {
            //seq.Append(camera.DOFieldOfView(field, 0.1f));
            //seq.Join(camera.transform.Find("TiltCamera").GetComponent<Camera>().DOFieldOfView(field, 0.1f));
            // }


            //camera.transform.position = pos;
            //camera.fieldOfView = 7;
            //camera.transform.Find("TiltCamera").GetComponent<Camera>().fieldOfView = 7;
#endif
        }

        public static void CameraShake(float duration, Vector3 strength, int vibrato = 10, float randomness = 90f, bool fadeOut = true)
        {
#if _CLIENTLOGIC_
            Camera.main.DOShakePosition(duration, strength, vibrato, randomness, fadeOut);
            
#endif
        }
    }

}
