using UnityEngine;
using System.Collections.Generic;
using UnityEngine.EventSystems;


public struct ScreenRaycastData
{
    public bool Is2D;
    public RaycastHit Hit3D;

	public GameObject UIGameObject;

#if !UNITY_3_5
    public RaycastHit2D Hit2D;
#endif

    public GameObject GameObject
    {
        get
        {
#if !UNITY_3_5
            if( Is2D )
				return Hit2D.collider ? Hit2D.collider.gameObject : UIGameObject;
#endif
            return Hit3D.collider ? Hit3D.collider.gameObject : null;
        }
    }
}

public class LuaScreenRaycastData {
    public bool isTrue;

    public float posX;
    public float posY;
    public float posZ;
    public GameObject gameObject;
    public LuaScreenRaycastData (bool b, float x, float y, float z, GameObject g) {
        isTrue = b;
        posX = x;
        posY = y;
        posZ = z;
        gameObject = g;
    }

}

[AddComponentMenu( "FingerGestures/Components/Screen Raycaster" )]
public class ScreenRaycaster : MonoBehaviour
{
    /// <summary>
    /// List of cameras to use for each raycast. Each camera will be considered in the order specified in this list,
    /// and the Raycast method will continue until a hit is detected.
    /// </summary>
    public Camera[] Cameras;

    /// <summary>
    /// Layers to ignore when raycasting
    /// </summary>
    public LayerMask IgnoreLayerMask;

    /// <summary>
    /// Thickness of the ray. 
    /// Setting rayThickness to 0 will use a normal Physics.Raycast()
    /// Setting rayThickness to > 0 will use Physics.SphereCast() of radius equal to half rayThickness
    ///  ** IMPORTANT NOTE ** According to Unity's documentation, Physics.SphereCast() doesn't work on colliders setup as triggers
    /// </summary>
    public float RayThickness = 0;

    /// <summary>
    /// Property used while in the editor only. 
    /// Toggles the visualization of the raycasts as red lines for misses, and green lines for hits (visible in scene view only)
    /// </summary>
    public bool VisualizeRaycasts = true;

    /// <summary>
    /// Raycast using Physics2D on orthographic cameras (Unity 4.X+ only)
    /// </summary>
    public bool UsePhysics2D = true;
    
	public bool IncludeUIEvent = false;

    void Start()
    {
        // if no cameras were explicitely provided, use the current main camera
        if( Cameras == null || Cameras.Length == 0 )
            Cameras = new Camera[] { Camera.main };
    }

    public bool Raycast( Vector2 screenPos, out ScreenRaycastData hitData )
    {
        for( int i = 0; i < Cameras.Length; ++i )
        {
            Camera cam = Cameras[i];

            // dont raycast from disabled cams
            if( !cam || !cam.enabled )
                continue;

#if UNITY_3_5
            if( !cam.gameObject.active )
                continue;
#else
            if( !cam.gameObject.activeInHierarchy )
                continue;
#endif

            if( Raycast( cam, screenPos, out hitData ) )
                return true;
        }

        hitData = new ScreenRaycastData();
		hitData.UIGameObject = null;
        return false;
    }

    public LuaScreenRaycastData luaRaycast(Vector2 screenPos) {
        ScreenRaycastData hitData;
        for (int i = 0; i < Cameras.Length; ++i) {
            Camera cam = Cameras[i];

            // dont raycast from disabled cams
            if (!cam || !cam.enabled)
                continue;

#if UNITY_3_5
            if( !cam.gameObject.active )
                continue;
#else
            if (!cam.gameObject.activeInHierarchy)
                continue;
#endif

            if (Raycast(cam, screenPos, out hitData)) { }
                return new LuaScreenRaycastData(true, hitData.Hit3D.point.x, hitData.Hit3D.point.y, hitData.Hit3D.point.z, hitData.GameObject);
        }

        hitData = new ScreenRaycastData();
        hitData.UIGameObject = null;
        return new LuaScreenRaycastData(false, 0, 0, 0, null);
    }

    bool Raycast( Camera cam, Vector2 screenPos, out ScreenRaycastData hitData )
    {
        Ray ray = cam.ScreenPointToRay( screenPos );
//		Debugger.Log("ray origin z = " + ray.origin.z);
//		Debugger.Log("ray origin x = " + ray.origin.x);
//		Debugger.Log("ray origin y = " + ray.origin.y);
//		Debugger.Log("ray direction z = " + ray.direction.z);
        bool didHit = false;

        hitData = new ScreenRaycastData();
		hitData.UIGameObject = null;

#if !UNITY_3_5
        // try to raycast 2D first - this only makes sense on orthographic cameras (physics2D doesnt work with perspective cameras)
        if( UsePhysics2D && cam.orthographic )
        {
            hitData.Hit2D = Physics2D.Raycast( ray.origin, Vector2.zero, Mathf.Infinity, ~IgnoreLayerMask );

            if( hitData.Hit2D.collider )
            {
                hitData.Is2D = true;
                didHit = true;
            }
        }
#endif

        // regular 3D raycast
        if( !didHit )
        {
            hitData.Is2D = false;   // ensure this is false

            if( RayThickness > 0 )
                didHit = Physics.SphereCast( ray, 0.5f * RayThickness, out hitData.Hit3D, Mathf.Infinity, ~IgnoreLayerMask );
            else
                didHit = Physics.Raycast( ray, out hitData.Hit3D, Mathf.Infinity, ~IgnoreLayerMask );
        }

        // vizualise ray
    #if UNITY_EDITOR
        if( VisualizeRaycasts )
        {
            if( didHit )
            {
                Vector3 hitPos = hitData.Hit3D.point;

#if !UNITY_3_5
                if( hitData.Is2D )
                {
                    hitPos = hitData.Hit2D.point;
                    hitPos.z = hitData.GameObject.transform.position.z;
                }
#endif
                //Debug.Log(hitPos);
                Debug.DrawLine( ray.origin, hitPos, Color.green, 0.5f );
            }
            else
            {
                Debug.DrawLine( ray.origin, ray.origin + ray.direction * 9999.0f, Color.red, 0.5f );
            }
        }
    #endif

		if( !didHit && IncludeUIEvent){
			if(EventSystem.current != null){
				if(EventSystem.current.currentSelectedGameObject != null){
					//didHit = true;
					//hitData.Is2D = true;
					//hitData.UIGameObject = EventSystem.current.currentSelectedGameObject;
				}
			}
		}

        return didHit;
    }
}
