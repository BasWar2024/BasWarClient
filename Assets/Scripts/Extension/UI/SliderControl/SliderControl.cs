using UnityEngine;
using System.Collections;
using UnityEngine.UI;
public class SliderControl : MonoBehaviour
{
    private GameObject _cachedGO;
    public Scrollbar m_Scrollbar;
    public ScrollRect m_ScrollRect;
    public int sliderCnt = 3;
    private float mTargetValue;
    private bool mNeedMove = false;
    private const float MOVE_SPEED = 1F;
    private const float SMOOTH_TIME = 0.2F;
    private float mMoveSpeed = 0f;

    private void Awake()
    {
        _cachedGO = gameObject;
    }
    public void OnPointerDown()
    {
        mNeedMove = false;
    }
    public void OnPointerUp()
    {
        // 
        float singleValue = 1 / (sliderCnt  - 1f);
        for (int i = 0; i < sliderCnt; i++)
        {
            if (m_Scrollbar.value > 0.5f * singleValue + (i - 1) * singleValue && m_Scrollbar.value <= 0.5f * singleValue + i * singleValue)
            {
                mTargetValue = singleValue * i;
                Debug.Log(singleValue + "     " + i + "   " + 0.5f * singleValue + (i - 1) * singleValue + "     " + 0.5f * singleValue + i * singleValue);
            }
        }
        // if (m_Scrollbar.value <= 0.125f)
        // {
        //     mTargetValue = 0;
        // }
        // else if (m_Scrollbar.value <= 0.375f)
        // {
        //     mTargetValue = 0.25f;
        // }
        // else if (m_Scrollbar.value <= 0.625f)
        // {
        //     mTargetValue = 0.5f;
        // }
        // else if (m_Scrollbar.value <= 0.875f)
        // {
        //     mTargetValue = 0.75f;
        // }
        // else
        // {
        //     mTargetValue = 1f;
        // }
        mNeedMove = true;
        mMoveSpeed = 0;
    }
    public void OnButtonClick(int value)
    {
        float singleValue = 1 / (sliderCnt  - 1f);
        mTargetValue = singleValue * (value - 1);

        mNeedMove = true;
    }
    void Update()
    {
        if (mNeedMove && _cachedGO.activeSelf)
        {
            if (Mathf.Abs(m_Scrollbar.value - mTargetValue) < 0.01f)
            {
                m_Scrollbar.value = mTargetValue;
                mNeedMove = false;
                return;
            }
            m_Scrollbar.value = Mathf.SmoothDamp(m_Scrollbar.value, mTargetValue, ref mMoveSpeed, SMOOTH_TIME);
        }
    }
}