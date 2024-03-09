using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class TKitBaseSprite : MonoBehaviour {
	public Color color;
	void Awake()
	{
		color = this.GetComponent<Image>().color;
	}
}
