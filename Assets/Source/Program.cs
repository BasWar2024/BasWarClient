
namespace Battle
{
    using System;
    using System.Net;
    using System.Net.Sockets;
    using System.Text;
    using System.Threading;

    class Program
	{
		static void Main(string[] args)
		{
			Socket serverSocket = new Socket(SocketType.Stream, ProtocolType.Tcp);
            IPAddress ip = IPAddress.Parse("127.0.0.1");
            IPEndPoint point = new IPEndPoint(ip, 2333);
			//socket
			serverSocket.Bind(point);
			Console.WriteLine("Listen Success");
			//
			serverSocket.Listen(10);

			//,
			Thread thread = new Thread(Listen);
			thread.IsBackground = true;
			thread.Start(serverSocket);

			Console.Read();
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="o"></param>
		static void Listen(object o)
		{
			var serverSocket = o as Socket;
			while (true)
			{
				//socket
				var send = serverSocket.Accept();
				//IP
				var sendIpoint = send.RemoteEndPoint.ToString();
				Console.WriteLine($"{sendIpoint}Connection");
				//
				Thread thread = new Thread(Recive);
				thread.IsBackground = true;
				thread.Start(send);
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="o"></param>
		static void Recive(object o)
		{
			var send = o as Socket;
			while (true)
			{
				//
				byte[] buffer = new byte[1024 * 1024 * 2];
				var effective = send.Receive(buffer);

				Console.WriteLine("effective: " + effective);

				//0
				if (effective == 0)
				{
					break;
				}
				var str = Encoding.UTF8.GetString(buffer,0, effective);
				Console.WriteLine("from client: " + str);

				NewBattleLogic battleLogic = new NewBattleLogic();
				NewGameData.IsRePlay = true;
				battleLogic.Init(str);
				battleLogic.StartBattle();

				while (true) {
					battleLogic.UpdateLogic();
					if (battleLogic.IsBattlePause) {
						break;
					}
				}
				Console.WriteLine("m_uGameLogicFrame: " + NewGameData._UGameLogicFrame);
				string replyContent = NewGameData._UGameLogicFrame.ToString ();
				var buffers = Encoding.UTF8.GetBytes(replyContent);
				send.Send(buffers);
				Console.WriteLine("send info to client");
			}
		}
	}
}