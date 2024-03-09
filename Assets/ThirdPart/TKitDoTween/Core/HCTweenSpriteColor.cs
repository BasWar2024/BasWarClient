using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class HCTweenSpriteColor : DoTweener {

	public Color StartColor;
	public Color EndColor;
	public float durtion = 1f;

	SpriteRenderer _sprite;
	SpriteRenderer sprite {
		get {
			if (_sprite == null) {
				_sprite = gameObject.GetComponent<SpriteRenderer> ();
			}
			return _sprite;
		}
		set {
			_sprite = value;
		}
	}
	public float GetAlpha {
		get {
			return sprite.color.a;
		}
	}

	bool Forward = true;
	public override void PlayForward () {
		Forward = true;
		StyleFunction (StartColor, EndColor, durtion, style);
	}
	public override void PlayReverse () {
		Forward = false;
		StyleFunction (EndColor, StartColor, durtion, style);
	}

	void StyleFunction (Color fromColor, Color toColor, float animTime, DoTweener.Style style) {
		if (sprite == null) {
			Des ();
			return;
		}
		switch (style) {
			case Style.Once:
				One (fromColor, toColor, animTime);
				break;
			case Style.Loop:
				Loop (fromColor, toColor, animTime);
				break;
			case Style.Repeatedly:
				Repeatedly (fromColor, toColor, animTime);
				break;
			case Style.PingPong:
				PingPong (fromColor, toColor, animTime);
				break;
		}
	}
	void One (Color fromColor, Color toColor, float time) {
		sprite.color = fromColor;
		Tweener tweener = DOTween.To (() => sprite.color, x => sprite.color = x, toColor, time).OnComplete (() => OnComplete ());
		SetingTweener (tweener);
	}
	void Repeatedly (Color fromColor, Color toColor, float time) {
		sprite.color = fromColor;

		Tweener tweener = DOTween.To (() => sprite.color, x => sprite.color = x, toColor, time).OnComplete (() => {
			Tweener tweenerBBC = DOTween.To (() => sprite.color, x => sprite.color = x, fromColor, time);
			SetingTweener (tweenerBBC);
		});
		SetingTweener (tweener);
	}
	void Loop (Color fromColor, Color toColor, float time) {
		sprite.color = fromColor;
		Tweener tweener = DOTween.To (() => sprite.color, x => sprite.color = x, EndColor, time).OnComplete (() => Loop (fromColor, toColor, time));
		SetingTweener (tweener);
	}
	void PingPong (Color fromColor, Color toColor, float time) {
		Tweener tweener = DOTween.To (() => sprite.color, x => sprite.color = x, toColor, time).OnComplete (() => PingPong (toColor, fromColor, time));
		SetingTweener (tweener);
	}

	protected override void StartValue () {
		// if (sprite) {
		// 	StartColor = sprite.color;
		// 	EndColor = sprite.color;
		// 	return;
		// }
	}

	void Des () {
		// Destroy(GetComponent<HCTweenAlpha>(), 1f);
		// HCTweenTextAlpha text = gameObject.AddComponent<HCTweenTextAlpha>();
		// text.StartColor = this.StartColor;
		// text.EndColor = this.EndColor;
		// text.durtion = this.durtion;
		// text.style = this.style;
		// text.IsStartRun = this.IsStartRun;
		// if (Forward)
		//     text.PlayForward();
		// else
		//     text.PlayReverse();

	}
	public override void InitHCTweener () {
		base.InitHCTweener ();

	}

}