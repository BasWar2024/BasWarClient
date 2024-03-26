using System;
using System.Text;
using System.Security.Cryptography;

public class CryptUtil{

    /// <summary>
    /// 16 MD5
    /// </summary>
    /// <param name="text"></param>
    /// <returns></returns>
    public static string MD5Encrypt16(string text){
        var md5 = new MD5CryptoServiceProvider();
        string t2 = BitConverter.ToString(md5.ComputeHash(Encoding.Default.GetBytes(text)), 4, 8);
        t2 = t2.Replace("-", "");
        return t2;
    }

    /// <summary>
    /// 32 MD5
    /// </summary>
    /// <param name="text"></param>
    /// <returns></returns>
    public static string MD5Encrypt32(string text){
        string cl = text;
        string md5Text = "";
        MD5 md5 = MD5.Create();

        byte[] s = md5.ComputeHash(Encoding.UTF8.GetBytes(cl));

        for (int i = 0; i < s.Length; i++){
            md5Text = md5Text + s[i].ToString("X2");
        }
        return md5Text;
    }

}
