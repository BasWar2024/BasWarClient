using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections.Generic;

namespace GG.Net {
    public class ClientTcpSocket {
        public delegate void OnConnectCallback (ClientTcpSocket socket);
        public delegate void OnCloseCallback (ClientTcpSocket socket);
        public delegate void OnMessageCallback (byte[] message);
        public delegate void OnConnectFailCallback(ClientTcpSocket socket);

        public OnConnectCallback onConnect = null;
        public OnCloseCallback onClose = null;
        public OnMessageCallback onMessage = null;
        public OnConnectFailCallback onConnectFail = null;

        private TcpClient client = null;
        private NetworkStream netStream = null;
        private MemoryStream memStream;
        private BinaryReader reader;
        private string id = null;

        private const int MESSAGE_MAX_SIZE = 64*1024;
        private byte[] readBuffer = new byte[2 + MESSAGE_MAX_SIZE];

        // Use this for initialization
        public ClientTcpSocket(string id=null) {
            this.id = id;
        }

        /// <summary>
        /// 
        /// </summary>
        public void Connect(string host, int port) {
            if (this.Connected) {
                return;
            }
            if (this.id == null) {
                this.id = string.Format("{0}:{1}",host,port);
            }
            try {
                IPAddress[] address = Dns.GetHostAddresses(host);
                if (address.Length == 0) {
                    Debug.LogError("host invalid");
                    return;
                }
                if (address[0].AddressFamily == AddressFamily.InterNetworkV6) {
                    this.client = new TcpClient(AddressFamily.InterNetworkV6);
                }
                else {
                    this.client = new TcpClient(AddressFamily.InterNetwork);
                }
                //this.client.SendTimeout = 1000;
                //this.client.ReceiveTimeout = 1000;
                this.client.NoDelay = true;
                this.client.BeginConnect(host, port, new AsyncCallback(this.OnConnectBack), client);
                Debug.Log(string.Format("BeginConnect to{0}:{1}", host, port));
            } catch (Exception ex) {
                Debug.LogErrorFormat("op=Connect,Message={0},StackTrace={1}",ex.Message,ex.StackTrace);
                this.Close();
            }
        }

        public bool Connected {
            get {
                return this.client != null && this.client.Connected;
            }
        }

        public string Id {
            get {
                return this.id;
            }
            set {
                this.id = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public void Close() {
            if (!this.Connected) {
                return;
            }
            this.client.Close();
            this.client = null;
            if (this.onClose != null) {
                this.onClose(this);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public void Send(byte[] message) {
            if (!this.Connected) {
                Debug.LogError("Send to a unconnected socket");
                return;
            }
            ByteStream stream = ByteStream.Allocate();
            ushort msglen = (ushort)message.Length;
            msglen = this.toBigEndian(msglen);
            stream.WriteUInt16(msglen);
            stream.Write(message,0,message.Length);
            this.netStream.BeginWrite(stream.Buffer, 0, stream.Position, new AsyncCallback(this.OnWrite), stream);
        }

        /// <summary>
        /// 
        /// </summary>
        private void OnConnectBack(IAsyncResult asr) {
            try{
                TcpClient tcpclient = asr.AsyncState as TcpClient;

                tcpclient.EndConnect(asr);

                this.netStream = this.client.GetStream();
                this.memStream = new MemoryStream();
                this.reader = new BinaryReader(memStream);
                this.client.GetStream().BeginRead(this.readBuffer, 0, MESSAGE_MAX_SIZE, new AsyncCallback(this.OnRead), null);
                //Debug.Log("connect success");
                if (this.onConnect != null)
                {
                    this.onConnect(this);
                }
            }
            catch (Exception ex)
            {
                //Debug.Log("connect fail");
                Debug.Log(ex.ToString());
                if (this.onConnectFail != null)
                {
                    this.onConnectFail(this);
                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="message"></param>
        private void OnMessage(byte[] message) {
            if (this.onMessage != null) {
                this.onMessage(message);
            }
        }

        /// <summary>
        /// 
        /// <param name="msg"></param>
        /// </summary>
        private void OnClose(string msg) {
            Debug.LogErrorFormat("id={0},Connection was closed by the server: ",this.id,msg);
            this.Close();   //
        }

        /// <summary>
        /// 
        /// </summary>
        private void OnRead(IAsyncResult asr) {
            int bytesRead = 0;
            try {
                if (!this.Connected) {
                    return;
                }
                lock (this.client.GetStream()) {         //
                    bytesRead = this.client.GetStream().EndRead(asr);
                }
                if (bytesRead < 1) {                //
                    this.OnClose("server close");
                    return;
                }
                this.OnReceive(this.readBuffer, bytesRead);   //
                if (this.client != null) {
                    lock (this.client.GetStream()) {         //
                        Array.Clear(this.readBuffer, 0, this.readBuffer.Length);   //
                        this.client.GetStream().BeginRead(this.readBuffer, 0, MESSAGE_MAX_SIZE, new AsyncCallback(this.OnRead), null);
                    }
                }
            } catch (Exception ex) {
                Debug.LogErrorFormat("op=OnRead,Message={0},StackTrace={1}",ex.Message,ex.StackTrace);
                this.OnClose(ex.Message);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void OnWrite(IAsyncResult r) {
            try {
                ByteStream stream = (ByteStream)r.AsyncState;
                ByteStream.Free(stream);
                this.netStream.EndWrite(r);
            } catch (Exception ex) {
                Debug.LogErrorFormat("op=OnWrite,Message={0},StackTrace={1}",ex.Message,ex.StackTrace);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void OnReceive(byte[] bytes, int length) {
            this.memStream.Seek(0, SeekOrigin.End);
            this.memStream.Write(bytes, 0, length);
            //Reset to beginning
            this.memStream.Seek(0, SeekOrigin.Begin);
            while (this.RemainingBytes() > 2) {
                ushort messageLen = this.reader.ReadUInt16();
                messageLen = this.toBigEndian(messageLen);
                if (this.RemainingBytes() >= messageLen) {
                    this.OnMessage(reader.ReadBytes(messageLen));
                } else {
                    //Back up the position two bytes
                    this.memStream.Position = this.memStream.Position - 2;
                    break;
                }
            }
            //Create a new stream with any leftover bytes
            byte[] leftover = this.reader.ReadBytes((int)this.RemainingBytes());
            this.memStream.SetLength(0);     //Clear
            this.memStream.Write(leftover, 0, leftover.Length);
        }

        /// <summary>
        /// 
        /// </summary>
        private long RemainingBytes() {
            return this.memStream.Length - this.memStream.Position;
        }
        private UInt16 toBigEndian(UInt16 value) {
            if (BitConverter.IsLittleEndian) {
                value = (UInt16)((0x00FF & (value >> 8))
                    | (0xFF00 & (value << 8)));
            }
            return value;
        }
    }
}