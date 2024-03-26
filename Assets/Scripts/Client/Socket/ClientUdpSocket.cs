using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections.Generic;

namespace GG.Net {
    public class ClientUdpSocket {
        public delegate void OnConnectCallback (ClientUdpSocket socket);
        public delegate void OnCloseCallback (ClientUdpSocket socket);
        public delegate void OnMessageCallback (byte[] message);

        public OnConnectCallback onConnect = null;
        public OnCloseCallback onClose = null;
        public OnMessageCallback onMessage = null;

        private UdpClient client = null;
        private string id = null;

        IPEndPoint localEndPoint = null;

        // Use this for initialization
        public ClientUdpSocket(string id=null) {
            this.id = id;
        }

        /// <summary>
        /// ""
        /// </summary>
        public void Connect(string host, int port) {
            if (this.Connected) {
                return;
            }
            if (this.id == null) {
                this.id = string.Format("{0}:{1}",host,port);
            }
            try {
                this.localEndPoint = new IPEndPoint(IPAddress.Any,0);
                this.client = new UdpClient(this.localEndPoint);
                this.client.Connect(host,port);
                this.OnConnect();
            } catch (Exception ex) {
                Debug.LogErrorFormat("op=Connect,Message={0},StackTrace={1}",ex.Message,ex.StackTrace);
                this.Close();
            }
        }

        public bool Connected {
            get {
                return this.client != null;
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
        /// ""
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
        /// ""
        /// </summary>
        public void Send(byte[] message) {
            if (!this.Connected) {
                Debug.LogError("Send to a unconnected socket");
                return;
            }
            ByteStream stream = ByteStream.Allocate();
            stream.Write(message,0,message.Length);
            this.client.BeginSend(stream.Buffer,stream.Position,new AsyncCallback(this.OnWrite), stream);
        }

        /// <summary>
        /// ""
        /// </summary>
        private void OnConnect() {
            this.client.BeginReceive(new AsyncCallback(this.OnRead), null);
            if (this.onConnect != null) {
                this.onConnect(this);
            }
        }

        /// <summary>
        /// ""
        /// </summary>
        /// <param name="message">""</param>
        private void OnMessage(byte[] message) {
            if (this.onMessage != null) {
                this.onMessage(message);
            }
        }

        /// <summary>
        /// ""
        /// <param name="msg">""</param>
        /// </summary>
        private void OnClose(string msg) {
            Debug.LogErrorFormat("id={0},Connection was closed by the server: ",this.id,msg);
            this.Close();   //""
        }

        /// <summary>
        /// ""
        /// </summary>
        private void OnRead(IAsyncResult asr) {
            byte[] receiveBytes = null;
            try {
                if (this.client == null) {
                    return;
                }
                lock(this.client) {
                    receiveBytes = this.client.EndReceive(asr,ref this.localEndPoint);
                }
                if (receiveBytes.Length < 1) {                //""，""
                    this.OnClose("server close");
                    return;
                }
                this.OnMessage(receiveBytes);
                if (this.client != null) {
                    lock(this.client) {
                        this.client.BeginReceive(new AsyncCallback(this.OnRead), null);
                    }
                }
            } catch (Exception ex) {
                Debug.LogErrorFormat("op=OnRead,Message={0},StackTrace={1}",ex.Message,ex.StackTrace);
                this.OnClose(ex.Message);
            }
        }

        /// <summary>
        /// ""
        /// </summary>
        private void OnWrite(IAsyncResult r) {
            try {
                ByteStream stream = (ByteStream)r.AsyncState;
                ByteStream.Free(stream);
                if (this.client != null) {
                    this.client.EndSend(r);
                }
            } catch (Exception ex) {
                Debug.LogErrorFormat("op=OnWrite,Message={0},StackTrace={1}",ex.Message,ex.StackTrace);
            }
        }
    }
}