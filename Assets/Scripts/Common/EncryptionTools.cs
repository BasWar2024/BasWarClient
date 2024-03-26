using System;
using System.Linq;
using UnityEngine;

public class EncryptionTools
{
    public static byte[] Encryption(byte[] data)
    {
        byte[] keyData = System.Text.Encoding.UTF8.GetBytes(Appconst.secretKey);
        byte[] newData = new byte[data.Length + keyData.Length];
        Array.Copy(keyData, 0, newData, 0, keyData.Length);
        Array.Copy(data, 0, newData, keyData.Length, data.Length);

        for (int i = 0; i < newData.Length; i++)
        {
            newData[i] = (byte)(newData[i] ^ keyData.Length);
        }
        return newData;
    }

    public static byte[] Decryption(byte[] data)
    {
        byte[] keyData = System.Text.Encoding.UTF8.GetBytes(Appconst.secretKey);
        byte[] newData = data.Skip(keyData.Length).Take(data.Length - keyData.Length).ToArray();

        for (int i = 0; i < newData.Length; i++)
        {
            newData[i] = (byte)(newData[i] ^ keyData.Length);
        }

        return newData;
    }
}
