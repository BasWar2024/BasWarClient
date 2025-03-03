using GG;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;

enum LOG_TYPE {
    ALL,
    LOG,
    WARNING,
    ERROE,
}

public class LogData {
    public string msg;
    public string stackTrace;
    public LogType logType;
    public string time;

    public LogData(string newMsg, string newStackTrace, LogType newLogType, string newTime) {
        msg = newMsg;
        stackTrace = newStackTrace;
        logType = newLogType;
        time = newTime;
    }
}


public class BoxLog {
    public GameObject go;
    public int objIndex;
    public int dataIndex;
    public bool isAct;

    public BoxLog(GameObject obj, int goI, int dataI) {
        go = obj;
        objIndex = goI;
        dataIndex = -1;
        isAct = false;
        go.SetActive(false);
    }

    public void SetData(LogData logData, int dataI) {
        dataIndex = dataI;
        Toggle logToggle = go.transform.Find("ToggleGroup/Log").GetComponent<Toggle>();
        Toggle errorToggle = go.transform.Find("ToggleGroup/Error").GetComponent<Toggle>();
        Toggle warningToggle = go.transform.Find("ToggleGroup/Warning").GetComponent<Toggle>();
        string type = "Error";

        switch (logData.logType) {
            case LogType.Log:
                type = "Log";
                logToggle.isOn = true;
                break;
            case LogType.Warning:
                type = "Warning";
                warningToggle.isOn = true;
                break;
            case LogType.Error:
                type = "Error";
                errorToggle.isOn = true;
                break;
            case LogType.Exception:
                type = "Exception";
                errorToggle.isOn = true;
                break;
            case LogType.Assert:
                type = "Assert";
                warningToggle.isOn = true;
                break;
        }
        float y = -200 * dataI;
        go.transform.localPosition = new Vector3(0, y, 0);

        go.transform.Find("TxtLogType").transform.GetComponent<Text>().text = type;
        go.transform.Find("TxtLog").transform.GetComponent<Text>().text = logData.msg;
        go.transform.Find("TxtTime").transform.GetComponent<Text>().text = logData.time;

        go.SetActive(true);
    }

    public void CloseBox() {
        dataIndex = -1;
        go.SetActive(false);
    }
}


public class ShowDebugLog : MonoBehaviour {
    GameObject pnlDebugLogObj;

    GameObject logBg;

    GameObject msgObj;

    GameObject btnCopy;

    GameObject bntAll;

    GameObject bntLog;

    GameObject bntError;

    GameObject bntWarning;

    Text txtAll;

    Text txtLog;

    Text txtError;

    Text txtWarning;

    ScrollRect scrollRect;

    Transform scrollViewContent;

    List<BoxLog> boxLogList = new List<BoxLog>();

    List<LogData> allLogDataList = new List<LogData>();

    List<LogData> logLogDataList = new List<LogData>();

    List<LogData> warningLogDataList = new List<LogData>();

    List<LogData> errorLogDataList = new List<LogData>();

    

    LOG_TYPE curLogType;

    int allCount = 0;

    int logCount = 0;

    int errorCount = 0;

    int warningCount = 0;

    int lastIndex = -1;

    bool isActive = false;
    Transform boxLog;


    private void Start() {
        isActive = true;
        curLogType = LOG_TYPE.ALL;
        Transform go = GameObject.Find("UIRoot/DebugNode/PnlDebugLog").transform;
        go.SetActiveEx(true);
        pnlDebugLogObj = go.gameObject;

        logBg = pnlDebugLogObj.transform.Find("Bg").gameObject;
        scrollRect = pnlDebugLogObj.transform.Find("Bg/ScrollView").transform.GetComponent<ScrollRect>();
        scrollViewContent = pnlDebugLogObj.transform.Find("Bg/ScrollView/Viewport/Content").transform;
        msgObj = pnlDebugLogObj.transform.Find("Bg/Msg").gameObject;

        btnCopy = pnlDebugLogObj.transform.Find("Bg/Msg/BtnCopy").gameObject;

        bntAll = pnlDebugLogObj.transform.Find("Bg/All").gameObject;
        bntLog = pnlDebugLogObj.transform.Find("Bg/Log").gameObject;
        bntError = pnlDebugLogObj.transform.Find("Bg/Error").gameObject;
        bntWarning = pnlDebugLogObj.transform.Find("Bg/Warning").gameObject;

        txtAll = bntAll.transform.Find("Txt").GetComponent<Text>();
        txtLog = bntLog.transform.Find("Txt").GetComponent<Text>();
        txtError = bntError.transform.Find("Txt").GetComponent<Text>();
        txtWarning = bntWarning.transform.Find("Txt").GetComponent<Text>();
        boxLog = pnlDebugLogObj.transform.Find("Bg/ScrollView/Viewport/Content/BoxLog");

        logBg.SetActiveEx(false);
        msgObj.SetActiveEx(false);


        for (int i = 0; i < 6; i++) {
            int index = i;
            GameObject obj = GameObject.Instantiate(boxLog.gameObject);
            obj.transform.SetParentEx(scrollViewContent, false);
            BoxLog box = new BoxLog(obj, i, 0);
            UIEventHandler.Get(obj).SetOnClick(() => { onBtnLog(index); }, null);

            boxLogList.Add(box);
        }

        Debug.unityLogger.logEnabled = true;

        BindEvent();
        //return true;
        //}, true);
    }

    void BindEvent() {
        Application.logMessageReceived += onDebugLog;

        UIEventHandler.Get(bntAll).SetOnClick(() => { onBtnLogType(LOG_TYPE.ALL); }, null);

        UIEventHandler.Get(bntLog).SetOnClick(() => { onBtnLogType(LOG_TYPE.LOG); }, null);

        UIEventHandler.Get(bntError).SetOnClick(() => { onBtnLogType(LOG_TYPE.ERROE); }, null);

        UIEventHandler.Get(bntWarning).SetOnClick(() => { onBtnLogType(LOG_TYPE.WARNING); }, null);

        UIEventHandler.Get(pnlDebugLogObj.transform.Find("BtnShowLog").gameObject).SetOnClick(onBtnShowLog, null);

        UIEventHandler.Get(pnlDebugLogObj.transform.Find("Bg/BtnClose").gameObject).SetOnClick(onBtnClose, null);

        UIEventHandler.Get(pnlDebugLogObj.transform.Find("Bg/BtnClear").gameObject).SetOnClick(onBtnClear, null);

        UIEventHandler.Get(pnlDebugLogObj.transform.Find("Bg/Msg").gameObject).SetOnClick(onBtnCloseMsg, null);

        UIEventHandler.Get(btnCopy).SetOnClick(onBtnCopy, null);

        scrollRect.onValueChanged.AddListener(onRefreshBoxLogData);
    }

    void ReleaseEvent() {

        UIEventHandler.Clear(bntAll);
        UIEventHandler.Clear(bntLog);
        UIEventHandler.Clear(bntError);
        UIEventHandler.Clear(bntWarning);
        UIEventHandler.Clear(pnlDebugLogObj.transform.Find("BtnShowLog").gameObject);
        UIEventHandler.Clear(pnlDebugLogObj.transform.Find("Bg/BtnClose").gameObject);
        UIEventHandler.Clear(pnlDebugLogObj.transform.Find("Bg/BtnClear").gameObject);
        UIEventHandler.Clear(pnlDebugLogObj.transform.Find("Bg/Msg").gameObject);
    }

    // Update is called once per frame
    void Update() {

    }

    void OnDisable() {
        if (isActive) {
            Application.logMessageReceived -= onDebugLog;

            ReleaseAllBox();
        }
    }
    void OnDestroy() {

    }

    private void ReleaseAllBox() {
        foreach (var data in boxLogList) {
            UIEventHandler.Clear(data.go);
            GameObject.Destroy(data.go);
        }
        boxLogList.Clear();
        allLogDataList.Clear();
        logLogDataList.Clear();
        warningLogDataList.Clear();
        errorLogDataList.Clear();

    }

    private List<LogData> getCurLogData() {
        if (curLogType == LOG_TYPE.ALL) {
            return allLogDataList;
        }
        else if (curLogType == LOG_TYPE.LOG) {
            return logLogDataList;
        }
        else if (curLogType == LOG_TYPE.WARNING) {
            return warningLogDataList;
        }
        else if (curLogType == LOG_TYPE.ERROE) {
            return errorLogDataList;
        }
        return allLogDataList;
    }

    private void onBtnLogType(LOG_TYPE lt) {
        curLogType = lt;
        onBtnShowLog();
    }

    private void onBtnShowLog() {
        lastIndex = -1;
        logBg.SetActiveEx(true);
        RectTransform rectTransform = scrollViewContent.GetComponentInChildren<RectTransform>();
        refreshContentSizeDelta();
        float y = rectTransform.rect.height - 1000;
        y = y > 0 ? y : 0;
        rectTransform.SetLocalPosY(rectTransform.rect.height - 1000);

        refreshBoxLogData();
    }

    private void onBtnClose() {
        logBg.SetActiveEx(false);
    }

    private void onBtnClear() {
        allLogDataList.Clear();
        logLogDataList.Clear();
        warningLogDataList.Clear();
        errorLogDataList.Clear();

        allCount = 0;
        logCount = 0;
        errorCount = 0;
        warningCount = 0;

        txtAll.text = allCount.ToString();
        txtLog.text = logCount.ToString();
        txtWarning.text = warningCount.ToString();
        txtError.text = errorCount.ToString();

        foreach(var boxLog in boxLogList) {
            boxLog.CloseBox();
        }
    }

    private void onBtnCloseMsg() {
        msgObj.SetActiveEx(false);
    }

    private void onDebugLog(string msg, string stackTrace, LogType logType) {
        string time = DateTime.Now.ToString("T");
        allCount++;
        allLogDataList.Add(new LogData(msg, stackTrace, logType, time));
        switch (logType) {
            case LogType.Log:
                logCount++;
                logLogDataList.Add(new LogData(msg, stackTrace, logType, time));
                break;
            case LogType.Warning:
                warningLogDataList.Add(new LogData(msg, stackTrace, logType, time));
                warningCount++;
                break;
            case LogType.Error:
                errorLogDataList.Add(new LogData(msg, stackTrace, logType, time));
                errorCount++;
                break;
            case LogType.Exception:
                errorLogDataList.Add(new LogData(msg, stackTrace, logType, time));
                errorCount++;
                break;
            case LogType.Assert:
                warningLogDataList.Add(new LogData(msg, stackTrace, logType, time));
                warningCount++;
                break;
        }


        txtAll.text = allCount.ToString();
        txtLog.text = logCount.ToString();

        txtWarning.text = warningCount.ToString();
        txtError.text = errorCount.ToString();

        refreshContentSizeDelta();
    }

    private void refreshContentSizeDelta() {
        List<LogData> logDatas = getCurLogData();
        float sizeY = logDatas.Count * 200;
        scrollViewContent.GetComponent<RectTransform>().sizeDelta = new Vector2(0, sizeY);
    }

    private void onRefreshBoxLogData(Vector2 vector2) {
        refreshBoxLogData();
    }
    
    private void refreshBoxLogData() {
        List<LogData> logDatas = getCurLogData();
        int y = (int)scrollViewContent.localPosition.y;

        int index = y / 200;

        if(lastIndex != index) {
            lastIndex = index;
            int boxI = 0;
            for (int i = index; i < index + 6; i++) {
                if (i >= 0 && i < logDatas.Count) {
                    boxLogList[boxI].SetData(logDatas[i], i);
                }
                else {
                    boxLogList[boxI].CloseBox();
                }
                boxI++;
            }
        }

    }

    string showingMsg;

    private void onBtnLog(int index) {
        int dataIndex = boxLogList[index].dataIndex;
        List<LogData> logDatas = getCurLogData();
        if (dataIndex >= 0 && dataIndex < logDatas.Count) {
            string msg = logDatas[dataIndex].msg;
            showingMsg = msg;
            msgObj.SetActiveEx(true);
            msgObj.transform.Find("OutPutView/Viewport/OutPutText").transform.GetComponent<Text>().text = msg;
        }

    }

    void onBtnCopy() {
        GUIUtility.systemCopyBuffer = showingMsg;
    }


}
