using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
[SerializeField]
public class HCTweenRectTranPosition : DoTweener {
	public Vector2 Form;
	public Vector2 To;
	public float MoveTime = 1f;
	RectTransform my;
	RectTransform myTransform {
		get {
			if (my == null)
				my = transform.GetComponent<RectTransform> ();
			return my;
		}
	}
	Vector2 position {
		get {
			return myTransform.anchoredPosition;
		}
	}
	public override void PlayForward () {
		StyleFunction (this.Form, this.To);
	}
	public override void PlayReverse () {
		StyleFunction (this.To, this.Form);
	}
    public void reStartPos() {
        transform.GetComponent<RectTransform>().SetLocalPosY(Form.y);
        IsStartRun = true;
        gameObject.SetActive(false);
    }
	void StyleFunction (Vector2 From, Vector2 To) {
		switch (style) {
			case Style.Once:
				One (From, To);
				break;
			case Style.Loop:
				Loop (From, To);
				break;
			case Style.Repeatedly:
				Repeatedly (From, To);
				break;
			case Style.PingPong:
				PingPong (From, To);
				break;
		}
	}
	void One (Vector2 From, Vector2 To) {
		myTransform.anchoredPosition = From;

		Tweener tweener = DOTween.To (() => myTransform.anchoredPosition, x => myTransform.anchoredPosition = x, To, MoveTime).OnComplete (() => OnComplete ());
		SetingTweener (tweener);
		tweener.SetUpdate (true);
	}
	void Repeatedly (Vector2 From, Vector2 To) {
		myTransform.anchoredPosition = From;
		Tweener tweener = DOTween.To (() => myTransform.anchoredPosition, x => myTransform.anchoredPosition = x, To, MoveTime).OnComplete (() => {
			Tweener tweenerBBC = DOTween.To (() => myTransform.anchoredPosition, x => myTransform.anchoredPosition = x, To, MoveTime);
			SetingTweener (tweenerBBC);
		});
		SetingTweener (tweener);
		tweener.SetUpdate (true);
	}
	void Loop (Vector2 From, Vector2 To) {
		myTransform.anchoredPosition = From;
		Tweener tweener = DOTween.To (() => myTransform.anchoredPosition, x => myTransform.anchoredPosition = x, To, MoveTime).OnComplete (() => Loop (Form, To));
		SetingTweener (tweener);
		tweener.SetUpdate (true);
	}
	void PingPong (Vector2 From, Vector2 To) {
		Tweener tweener = DOTween.To (() => myTransform.anchoredPosition, x => myTransform.anchoredPosition = x, To, MoveTime).OnComplete (() => PingPong (To, From));
		SetingTweener (tweener);
		tweener.SetUpdate (true);
	}
	protected override void StartValue () {
		Form = this.position;
	}
	protected override void EndValue () {
		To = this.position;
	}
}