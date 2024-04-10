using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TextYouYU : UnityEngine.UI.Text
{
    [SerializeField]
    private string LanguageKey;

    void Awake() {
        LanguageMgr.instance.ChangeLanguageAction += RefreshText;
        RefreshText();
    }

    void OnDestroy()
    {
        LanguageMgr.instance.ChangeLanguageAction -= RefreshText;
    }

    public void SetLanguageKey(string key)
    {
        LanguageKey = key;
        RefreshText();
    }

    void RefreshText()
    {
        if (LanguageKey != "")
        {
            this.text = LanguageMgr.instance.LoadText(LanguageKey);
            //LanguageMgr.instance.LoadText(LanguageKey, (text) =>
            //{
            //    this.text = text;
            //});
        }
    }
}
