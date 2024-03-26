using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;

public static class HexColor {
	const string regStr = "^[0-9A-FA-Fa-f]{8}$"; //""#""
	/// <summary>
	/// color ""hex
	/// </summary>
	/// <param name="color"></param>
	/// <returns></returns>
	public static string ColorToHex (Color color) {
		int r = Mathf.RoundToInt (color.r * 255.0f);
		int g = Mathf.RoundToInt (color.g * 255.0f);
		int b = Mathf.RoundToInt (color.b * 255.0f);
		int a = Mathf.RoundToInt (color.a * 255.0f);
		string hex = string.Format ("{0:X2}{1:X2}{2:X2}{3:X2}", r, g, b, a);
		return hex;
	}

	/// <summary>
	/// hex""color ""# "" ""
	/// </summary>
	/// <param name="hex"></param>
	/// <returns></returns>
	public static Color HexToColor (string hex) {

		// #if UNITY_EDITOR
		// 		if (!IsHexColor (hex)) {
		// 			//Debug.LogError ("""   " + hex);
		// 			return Color.white;
		// 		}
		// #endif
		if (!IsHexColor (hex)) {
			Debug.LogError ("""   " + hex);
			return Color.white;
		}

		byte br = byte.Parse (hex.Substring (0, 2), System.Globalization.NumberStyles.HexNumber);
		byte bg = byte.Parse (hex.Substring (2, 2), System.Globalization.NumberStyles.HexNumber);
		byte bb = byte.Parse (hex.Substring (4, 2), System.Globalization.NumberStyles.HexNumber);
		byte cc = byte.Parse (hex.Substring (6, 2), System.Globalization.NumberStyles.HexNumber);
		float r = br / 255f;
		float g = bg / 255f;
		float b = bb / 255f;
		float a = cc / 255f;
		return new Color (r, g, b, a);
	}

	public static bool IsHexColor (string strInput) {

		Regex reg = new Regex (regStr);
		if (reg.IsMatch (strInput)) {
			return true;
		} else {
			return false;
		}
	}

}