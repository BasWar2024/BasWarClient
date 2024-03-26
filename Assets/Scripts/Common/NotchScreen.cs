using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public enum PhoneType
{
    None = 0,
    NoNotched = 1, //pc, mac, pad...
    Iphone = 2,
    AndroidO = 3,
    AndroidP = 4,
}
public class NotchScreen : Singleton<NotchScreen>
{
    private bool _isNotch = false;
    private float _topValue = 0;
    private float _bottomValue = 0;
    private float _leftValue = 0;
    private float _rightValue = 0;

    private PhoneType _phoneType;

    private ScreenOrientation _lastDirection = ScreenOrientation.LandscapeLeft;

    public Camera _uiCamera;
    private CanvasScaler _uiScaler;
    public float leftValue
    {
        get { return _leftValue; }
    }

    public bool isAndroidO
    {
        get { return _phoneType == PhoneType.AndroidO; }
    }

    public ScreenOrientation lastDirection
    {
        get { return _lastDirection; }
        set { _lastDirection = value; }
    }

    public void Init()
    {
        if (SystemInfo.deviceType != DeviceType.Handheld)
        {
            _phoneType = PhoneType.NoNotched;
        }
        else
        {
            //string type = SystemInfo.deviceModel.ToLower().Trim();
#if UNITY_IPHONE
            string deviceModel = SystemInfo.deviceModel.ToLower().Trim();
            if(deviceModel.StartsWith("ipad"))
            {
                _phoneType = PhoneType.NoNotched;
            }
            else
            {
                _phoneType = PhoneType.Iphone;
            }

#elif UNITY_ANDROID
            //""AndroidO,""
            _phoneType = PhoneType.AndroidO;

            //SDKManager.GetInstance().CallNotchParam();
#else
            _phoneType = PhoneType.NoNotched;
#endif
        }


        _uiCamera = GameObject.Find("UIRoot/UICamera").GetComponent<Camera>();
        _uiScaler = GameObject.Find("UIRoot/NormalNode").transform.GetComponent<CanvasScaler>();
        if (_phoneType == PhoneType.None || _phoneType == PhoneType.NoNotched)
        {
            UpdateParam(false, 0, 0, 0, 0);
        }
        else if (_phoneType == PhoneType.Iphone)
        {
            Camera camera = _uiCamera;
            if (camera.pixelWidth == Screen.safeArea.width && camera.pixelHeight == Screen.safeArea.height)
            {
                UpdateParam(false, 0, 0, 0, 0);
            }
            else
            {
                UpdateParam(true, camera.pixelHeight - Screen.safeArea.y - Screen.safeArea.height, Screen.safeArea.y, Screen.safeArea.x
                    , camera.pixelWidth - Screen.safeArea.y - Screen.safeArea.width);
            }
        }
    }

    public void UpdateAndroidType(bool isAndroidP)
    {
        if (isAndroidP)
        {
            _phoneType = PhoneType.AndroidP;
        }
        else
        {
            _phoneType = PhoneType.AndroidO;
            UpdateParam(false, 0f, 0f, 0f, 0f);
        }
    }

    public void UpdateParam(bool isNotch, float top, float bottom, float left, float right)
    {
        _isNotch = isNotch;
        Vector2 screenSize = new Vector2(1280f, 720f);

        CanvasScaler scaler = _uiScaler;
        Camera camera = _uiCamera;
        if (scaler.screenMatchMode == CanvasScaler.ScreenMatchMode.Expand)
        {
            float scaleFactor = Mathf.Min(screenSize.x / camera.pixelWidth, screenSize.y / camera.pixelHeight);

            _topValue = top * scaleFactor;
            _bottomValue = bottom * scaleFactor;
            if (Screen.orientation == ScreenOrientation.LandscapeLeft || Screen.orientation == ScreenOrientation.Landscape)
            {
                _leftValue = left * scaleFactor;
                _rightValue = right * scaleFactor;
            }
            else
            {
                _leftValue = right * scaleFactor;
                _rightValue = left * scaleFactor;
            }
        }
        else //""expand""
        {
            float scaleFactor = Mathf.Min(screenSize.x / camera.pixelWidth, screenSize.y / camera.pixelHeight);

            _topValue = top * scaleFactor;
            _bottomValue = bottom * scaleFactor;
            _leftValue = left * scaleFactor;
            _rightValue = right * scaleFactor;
        }
    }

    public void Release()
    {
    }
}
