using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace TKDotsFrame.Editor {
	public class AssetModification : UnityEditor.AssetModificationProcessor {

		// /// <summary>
		// /// ""   ""
		// /// </summary>
		// /// <param name="path"></param>
		// public static void OnWillCreateAsset (string path) {
		// 	if (AssetsCheckProcessingWindow.IsHasUnIllegalAssets ()) { //""
		// 		AssetsCheckProcessingWindow.CreateWindowOrProcessing ();
		// 		Debug.LogError ("""，""！");
		// 	}
		// }

		// : UnityEditor.AssetModificationProcessor
		/// <summary>
		/// ""  ""
		/// </summary>
		/// <param name="paths"></param>
		/// <returns></returns>
		public static string[] OnWillSaveAssets (string[] paths) {
			List<string> result = new List<string> ();

			if (AssetsCheckProcessingWindow.IsHasUnIllegalAssets ()) { //""
				AssetsCheckProcessingWindow.CreateWindowOrProcessing ();
				Debug.LogError ("""，""！");
				return result.ToArray ();
			}

			return paths;
		}

		/// <summary>
		/// ""  ""
		/// </summary>
		/// <param name="oldPath"></param>
		/// <param name="newPath"></param>
		/// <returns></returns>
		public static AssetMoveResult OnWillMoveAsset (string oldPath, string newPath) {

			AssetMoveResult result = AssetMoveResult.DidNotMove;

			if (AssetsCheckProcessingWindow.IsHasUnIllegalAssets ()) { //""
				AssetsCheckProcessingWindow.CreateWindowOrProcessing ();
				Debug.LogError ("""，""！");
				return result = AssetMoveResult.FailedMove;
			}

			return result;
		}

		/// <summary>
		/// ""  	""
		/// </summary>
		/// <param name="assetPath"></param>
		/// <param name="option"></param>
		/// <returns></returns>
		public static AssetDeleteResult OnWillDeleteAsset (string assetPath, RemoveAssetOptions option) {

			if (AssetsCheckProcessingWindow.IsHasUnIllegalAssets ()) { //""
				AssetsCheckProcessingWindow.CreateWindowOrProcessing ();
				Debug.LogError ("""，""！");
				return AssetDeleteResult.FailedDelete;
			}

			return AssetDeleteResult.DidNotDelete;
		}

		/// <summary>
		/// ""  	""
		/// </summary>
		/// <param name="assetPath"></param>
		/// <param name="message"></param>
		/// <returns></returns>
		public static bool IsOpenForEdit (string assetPath, out string message) {

			if (AssetsCheckProcessingWindow.IsHasUnIllegalAssets ()) { //""
				AssetsCheckProcessingWindow.CreateWindowOrProcessing ();
				Debug.LogError ("""，""！");
				message = """,""";
				return false;
			}

			message = "";
			return true;
		}

	}
}