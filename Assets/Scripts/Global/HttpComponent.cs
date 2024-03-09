using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;
using XLua;

public class HttpComponent : MonoBehaviour
{
    public UnityWebRequest newHttpRequest(string url,string method) {
        return new UnityWebRequest(url,method);
    }

    public void sendHttpRequest(UnityWebRequest request,string data=null,LuaFunction onResponse = null) {
        StartCoroutine(_sendHttpRequest(request,data,onResponse));
    }

    private IEnumerator _sendHttpRequest(UnityWebRequest request,string data,LuaFunction onResponse) {
        if (data != null) {
            byte[] body = Encoding.UTF8.GetBytes(data);
            request.uploadHandler = (UploadHandler) new UploadHandlerRaw(body);
        }
        request.downloadHandler = (DownloadHandler) new DownloadHandlerBuffer();
        yield return request.SendWebRequest();
        if (request.error != null) {
            Debug.LogErrorFormat("uri={0},error={1},responseCode={2}",request.uri,request.error,request.responseCode);
            if (onResponse != null) {
                onResponse.Call(request.responseCode,request.downloadHandler.text);
            }
        } else {
            if (onResponse != null) {
                onResponse.Call(request.responseCode,request.downloadHandler.text);
            }
        }
    }
}
