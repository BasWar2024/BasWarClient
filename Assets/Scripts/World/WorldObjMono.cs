using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using GG;
using UnityEditor;
using UnityEngine;
using XLua;

public class WorldObjMono : MonoBehaviour {
    Animator animator;
    // public string ObjTag;
    [HideInInspector]
    public Transform body;
    MeshRenderer healthBar;
    MaterialPropertyBlock Block, Block2;
    Color blue, red, grey;
    public Material matRed, matBlue;
    private Material matGrey;
    bool isNeutral; //
    MeshRenderer BodyMesh;
    void Awake () {
        body = this.transform.Find ("Body");
        // animator = body.Find ("sprite").GetComponent<Animator> ();
        healthBar = this.transform.Find ("HUD/HealthBar").GetComponent<MeshRenderer> ();
        healthBar.sortingLayerName = "HUD";
        Block = new MaterialPropertyBlock ();
        Block2 = new MaterialPropertyBlock ();
        blue = HexColor.HexToColor ("00B3FFFF");
        red = HexColor.HexToColor ("FF2820FF");
        grey = HexColor.HexToColor ("7E7E7EFF");
        matGrey = new Material (Shader.Find ("WorldCommon/UnitBodyShader"));
        matGrey.SetColor ("_Color", grey);

        BodyMesh = body.GetComponentInChildren<MeshRenderer> ();
    }
    public void PlayAnimation (int key) {
        switch (key) {
            case 0: //"run":

                break;
            case 1: //"idle":

                break;
            case 2: //"atk":
                attackTween (Vector3.one, new Vector3 (1f, 1f, 0.4f), 0.2f);
                break;
            case 3: //"hit":
                // animator.Play (ObjTag + "_right_atk");
                // StopCoroutine ("waitForExitFlash");
                StartCoroutine ("waitForExitFlash");
                break;
        }
    }
    IEnumerator waitForExitFlash () {
        SetBodyByHit (true);
        yield return new WaitForSeconds (0.2f);
        SetBodyByHit (false);
    }
    void attackTween (Vector3 from, Vector3 to, float animTime) {
        body.transform.localScale = from;
        Tweener tweener = body.transform.DOScale (to, animTime * 0.5f).OnComplete (() => {
            Tweener tweenerBBC = body.transform.DOScale (from, animTime * 0.5f);
        });
    }
    void SetBodyByHit (bool isOn) {
        BodyMesh.GetPropertyBlock (Block2);
        Block2.SetInt ("_Flash", isOn?1 : 0);
        BodyMesh.SetPropertyBlock (Block2);
    }
    public void SetIsNeutral (bool neutral) {
        isNeutral = neutral;
    }
    public void SetBodyMaterial (bool isEnemy) {
        if (isNeutral) {
            BodyMesh.material = matGrey;
        } else {
            BodyMesh.material = isEnemy?matRed : matBlue;
        }
    }

    public void SetHealthBar (float percent, bool isEnemy) {
        healthBar.GetPropertyBlock (Block);
        Block.SetFloat ("_Percent", percent);
        Block.SetColor ("_MainColor", isEnemy?red : blue);
        healthBar.SetPropertyBlock (Block);
    }
}