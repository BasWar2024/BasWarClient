//
// @brief: unity
// @version: 1.0.0
// @author helin
// @date: 03/7/2018
// 
// 
//

namespace Battle
{
#if _CLIENTLOGIC_
    using UnityEngine;
#endif

    public class UnityTools
    {
        public static string PlayerPrefsGetString(string key)
        {
#if _CLIENTLOGIC_
            return PlayerPrefs.GetString(key);
#else
        return "";
#endif
        }

        public static void PlayerPrefsSetString(string key, string value)
        {
#if _CLIENTLOGIC_
            PlayerPrefs.SetString(key, value);
#endif
        }

        public static void SetTimeScale(float value)
        {
#if _CLIENTLOGIC_
            Time.timeScale = value;
#endif
        }

        public static void Log(object message)
        {
#if _CLIENTLOGIC_
            UnityEngine.Debug.Log(message);
#else
		System.Console.WriteLine (message);
#endif
        }

        public static void LogError(object message)
        {
#if _CLIENTLOGIC_
            Debug.LogError(message);
#endif
        }

    }
}

