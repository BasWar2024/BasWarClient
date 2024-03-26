using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Battle
{
    public class AStarSavePath
    {
        public ASPoint StartASPoint;
        public ASPoint TargetASPoint;
        public List<ASPoint> ListMovePath;

        public void Init()
        {
            if (ListMovePath == null)
            {
                ListMovePath = new List<ASPoint>();
            }
        }

        public void Release()
        {
            StartASPoint = null;
            TargetASPoint = null;
            ListMovePath.Clear();
        }
    }
}
