using UnityEngine;
using System.Collections;

public class DrawFps : MonoBehaviour {

	private float updateInterval = 1.0f;
	private double lastInterval; // Last interval end time
	private int frames = 0; // Frames over current interval
	private float fps;
	private float ms;
	
	// Use this for initialization
	void Start () {
	    lastInterval = Time.realtimeSinceStartup;
    	frames = 0;
	}
	
	// Update is called once per frame
	void Update () {
		
	    ++frames;
	    float timeNow = Time.realtimeSinceStartup;
	    if (timeNow > lastInterval + updateInterval)
	    {
			float f = float.Parse(lastInterval.ToString());
			fps = frames / (timeNow - f);
			ms = 1000.0f / Mathf.Max (fps, 0.00001f);
			
			frames = 0;
        	lastInterval = timeNow;
		}
	}
	
	void OnGUI()
	{
		GUI.color = Color.white;
		
		GUI.backgroundColor = Color.black;
		
		GUI.Box(new Rect (5, 3, 150, 25), ""); 
		
		string f =  ms.ToString("f1") + "ms " + fps.ToString("f2") + "FPS";
		GUI.Label(new Rect (25, 3, 150, 25), f);
	}
}
