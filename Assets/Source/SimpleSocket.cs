using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Battle
{
    public class SimpleSocket
    {

        private Socket socketClient;

        // Use this for initialization
        public void Init()
        {
            Console.WriteLine("Hello World!");
            //
            socketClient = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            IPAddress ip = IPAddress.Parse("127.0.0.1");
            IPEndPoint point = new IPEndPoint(ip, 2333);
            //
            socketClient.Connect(point);

            //
            Thread thread = new Thread(Recive);
            thread.IsBackground = true;
            thread.Start(socketClient);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        static void Recive(object o)
        {
            var send = o as Socket;
            //while (true)
            {
                //
                byte[] buffer = new byte[1024 * 1024 * 2];
                var effective = send.Receive(buffer);
                if (effective == 0)
                {
                    //break;
                }
                var str = Encoding.UTF8.GetString(buffer, 0, effective);
                Debug.Log("receive from server: " + str);
                //BattleUI.m_scServerInfo = str;
            }
        }

        public void SendBattleRecordToServer(string record)
        {
            var buffter = Encoding.UTF8.GetBytes(record);
            var temp = socketClient.Send(buffter);
            Thread.Sleep(1000);
        }

    }
}