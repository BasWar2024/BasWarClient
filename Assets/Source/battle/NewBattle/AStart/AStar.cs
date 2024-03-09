
namespace Battle
{
    using System;
    using System.Collections.Generic;
#if _CLIENTLOGIC_
    using UnityEngine;
#endif


    public class AStar
    {
        private static int width = 58;
        private static int height = 58;

        private int maxStepFindPathCount = 10; //

        public ASPoint[,] asPoint2DMap = new ASPoint[width, height];

        //
        private Dictionary<EntityBase, BuildingAroundPoint> buildAroundPointDict = new Dictionary<EntityBase, BuildingAroundPoint>();

        private List<ASPoint> openList = new List<ASPoint>();
        private List<ASPoint> closeList = new List<ASPoint>();

        private Queue<FindPathComd> findPathQueue = new Queue<FindPathComd>();


#if _CLIENTLOGIC_
        Color normalColor = Color.white;
        Color wallColor = Color.black;
        Color startPosColor = Color.green;
        Color targetPosColor = Color.red;
        Color pathPosColor = Color.yellow;
        Color closeColor = Color.blue;
        Color openColor = Color.cyan;
#endif

        // Start is called before the first frame update
        public void Init()
        {
            CreateAStartMap();
            ReSetNoWall();

            openList.Clear();
            closeList.Clear();
            buildAroundPointDict.Clear();
        }

        public void UpdateLogic()
        {
            if (findPathQueue.Count > 0)
            {
                int i = 0;
                while (i < maxStepFindPathCount)
                {
                    var comd = findPathQueue.Dequeue();
                    if (comd.Entity.BKilled)
                    {
                        comd.Release();
                        continue;
                    }

                    FindMovePath(comd.Entity, comd.FindPathType, comd.CallBack);
                    comd.Release();
                    i++;

                    if (findPathQueue.Count == 0)
                        return;
                }
            }
        }

        public void PushFindMovePathComd(EntityBase entity, FindPathType findPathType, Action<List<ASPoint>> callBack)
        {
            if (callBack == null)
                return;

            FindPathComd comd = new FindPathComd(entity, findPathType, callBack);
            findPathQueue.Enqueue(comd);
        }

        private void FindMovePath(EntityBase entity, FindPathType findPathType, Action<List<ASPoint>> callBack)
        {
            FixVector2 fixV2 = new FixVector2(entity.Fixv3LogicPosition.x, entity.Fixv3LogicPosition.z);

            EntityBase nearestObj = null;

            if (findPathType == FindPathType.FindSignal)
            {
                nearestObj = NewGameData._SignalBomb;
            }
            else if (findPathType == FindPathType.FindSignalLockBuilding)
            {
                nearestObj = NewGameData._SignalLockBuilding;
            }

            if (nearestObj == null)
                return;

            entity.LockedAttackEntity = nearestObj;

            FixVector2 pathFindStartPot = FindNearestPathFindPot(new FixVector2(fixV2.x, fixV2.y));

            FixVector2 pathFindTargetPot =
                findPathType == FindPathType.FindSignal ?
                FindNearestPathFindPot(new FixVector2(nearestObj.Fixv3LogicPosition.x, nearestObj.Fixv3LogicPosition.z)):
                FindNearestPathFindPot(NewGameData._BuildingPathFindPointDict[nearestObj]);

            var listMovePath = entity.ListMovePath;

            if (listMovePath == null)
                listMovePath = new List<ASPoint>();

            listMovePath.Clear();

            ASPoint startPoint = asPoint2DMap[(int)pathFindStartPot.x, (int)pathFindStartPot.y];
            ASPoint targetPoint = asPoint2DMap[(int)pathFindTargetPot.x, (int)pathFindTargetPot.y];

            if (startPoint == targetPoint)
            {
                //UnityTools.Log("" + startPoint.X + "," + startPoint.Z);
                callBack?.Invoke(listMovePath);
                return;
            }


            if (FindPath(startPoint, targetPoint))
            {
                ShowPath(startPoint, targetPoint, listMovePath);

                listMovePath.Reverse();

                if (!startPoint.IsWall)
                    listMovePath.Add(targetPoint);
            }

            callBack?.Invoke(listMovePath);
        }

        private FixVector2 FindNearstEndPoint(FixVector3 startPoint, FixVector3 targetPoint)
        {
            var x = targetPoint.x;
            var z = targetPoint.z;

            var minX = targetPoint.x - 2;
            var maxX = targetPoint.x + 2;

            if (startPoint.x < minX || startPoint.x > maxX)
            {
                var nearminX = Fix64.Abs(startPoint.x - minX);
                var nearmaxX = Fix64.Abs(startPoint.x - maxX);

                x = nearminX > nearmaxX ? maxX : minX;
            }

            var minZ = targetPoint.z - 2;
            var maxZ = targetPoint.z + 2;

            if (startPoint.z < minZ || startPoint.z > maxZ)
            {
                var nearminZ = Fix64.Abs(startPoint.z - minZ);
                var nearmaxZ = Fix64.Abs(startPoint.z - maxZ);

                z = nearminZ > nearmaxZ ? maxZ : minZ;
            }

            return new FixVector2(x, z);
        }

        public FixVector2 FindNearestPathFindPot(FixVector2 fixOrginV2)
        {
            int centerX = (int)Math.Round((float)fixOrginV2.x);
            int centerY = (int)Math.Round((float)fixOrginV2.y);
            centerX = centerX % 2 == 0 ? centerX : centerX - 1;
            centerY = centerY % 2 == 0 ? centerY : centerY - 1;
            var v2 = new FixVector2(centerX, centerY);

            if (asPoint2DMap[centerX, centerY].IsWall)
            {
                for (int i = -1; i < 2; i++)
                {
                    for (int j = 0; j < 2; j++)
                    {
                        if (!asPoint2DMap[centerX + i * 2, centerY + j * 2].IsWall)
                        {
                            v2 = new FixVector2(centerX + i * 2, centerY + j * 2);
                            return v2;
                        }
                    }
                }
            }


            return v2;
        }

        /// <summary>
        /// apoint!iswall
        /// </summary>
        public void ReSetNoWall()
        {
            for (int x = 0; x < width; x += 2)
            {
                for (int z = 0; z < width; z += 2)
                {
                    asPoint2DMap[x, z].IsWall = false;
                }
            }
        }

        public void SetWallPoint(EntityBase building, FixVector2 center, Fix64 size)
        {
            int newSize = 0;//size <= (Fix64)1.5 ? 0 : 2;
            //var floorSize = (int)Fix64.Floor(size);
            int centerX = (int)center.x;
            int centerY = (int)center.y;
            centerX = centerX % 2 == 0 ? centerX : centerX - 1;
            centerY = centerY % 2 == 0 ? centerY : centerY - 1;
            int minX = centerX - newSize;
            int maxX = centerX + newSize;
            int minY = centerY - newSize;
            int maxY = centerY + newSize;

            NewGameData._BuildingPathFindPointDict.Add(building, new FixVector2(centerX, centerY));

            for (int i = minX; i <= maxX; i += 2)
            {
                for (int j = minY; j <= maxY; j += 2)
                {
                    var absX = Fix64.Abs((Fix64)i - (Fix64)centerX);
                    var absY = Fix64.Abs((Fix64)j - (Fix64)centerY);
                    if (Fix64.Sqrt(absX * absX + absY * absY) > size)
                        continue;

                    if (asPoint2DMap[i, j] != null)
                    {
                        asPoint2DMap[i, j].IsWall = true;
#if _CLIENTLOGIC_
                        //SetCubeColor(i, j, wallColor);
#endif
                    }
                }
            }
#if _CLIENTLOGIC_
            //SetCubeColor(centerX, centerY, Color.blue);
#endif
        }

        //-------------------------------newbattle-----------------------------------------------------------------------

        private void RefreshMap()
        {

        }

        /// <summary>
        /// list
        /// </summary>
        /// <param name="startPoint"></param>
        /// <param name="targetPoint"></param>
        /// <param name="newPath"></param>
        /// <returns></returns>

        private List<ASPoint> ShowPath(ASPoint startPoint, ASPoint targetPoint, List<ASPoint> newPath)
        {
            if (newPath == null)
                newPath = new List<ASPoint>();

            ASPoint temp = targetPoint.Parent;
            while (true)
            {
                if (temp == null)
                    break;

                if (temp == startPoint)
                {
                    break;
                }

#if _CLIENTLOGIC_
                //SetCubeColor((int)temp.X, (int)temp.Z, Color.red);
#endif
                newPath.Add(temp);
                temp = temp.Parent;
            }

            return newPath;
        }

        /// <summary>
        /// A
        /// </summary>
        /// <param name="startPoint"></param>
        /// <param name="targetPoint"></param>
        /// <returns></returns>

        private bool FindPath(ASPoint startPoint, ASPoint targetPoint)
        {
            openList.Clear();
            closeList.Clear();

            openList.Add(startPoint);

            int i = 0;
            while (openList.Count > 0)
            {
                var minFPot = FindMinFPoint(openList);
                closeList.Add(minFPot);
                openList.Remove(minFPot);

                var surroundPoints = GetSurroundPoints(minFPot, asPoint2DMap, width, height);
                PointFilter(surroundPoints, closeList);

                foreach (ASPoint surroundPos in surroundPoints)
                {
                    //openListFF
                    if (openList.IndexOf(surroundPos) > -1)
                    {
                        Fix64 g = CalcG(surroundPos, minFPot);

                        if (g < surroundPos.G)
                        {
                            surroundPos.UpdateParent(minFPot, g);
                        }
                    }
                    else
                    {
                        surroundPos.Parent = minFPot;
                        CalcF(targetPoint, surroundPos);
                        openList.Add(surroundPos);
                    }
                }
                i++;

                if (i >= 100)
                {
                    //UnityTools.Log("" + i + ", " + startPoint.X + "," + startPoint.Z);
                    //UnityTools.Log("" + i + ", " + targetPoint.X + "," + targetPoint.Z);
                    return true;
                }

                //  end  
                if (openList.IndexOf(targetPoint) > -1)
                {
                    //UnityTools.Log(i + ", " + targetPoint.X + "," + targetPoint.Z);
                    return true;
                }
            }

            //UnityTools.Log("--------:" + i + "," + ","+ "" + targetPoint.X + "," + targetPoint.Z);
            return false;
        }

        private void CalcF(ASPoint end, ASPoint currPot)
        {
            Fix64 h = Fix64.Abs(end.X - currPot.X) + Fix64.Abs(end.Z - currPot.Z);
            Fix64 g = (Fix64)0;
            if (currPot.Parent == null)
            {
                g = (Fix64)0;
            }
            else
            {
                // 
                g = FixVector3.Distance(new FixVector3(currPot.X, (Fix64)0, currPot.Z), new FixVector3(currPot.Parent.X, (Fix64)0, currPot.Parent.Z)) + currPot.Parent.G;
            }

            // FGH
            Fix64 f = g + h;
            currPot.F = f;
            currPot.G = g;
            currPot.H = h;
        }

        private Fix64 CalcG(ASPoint currPot, ASPoint parent)
        {
            return FixVector3.Distance(new FixVector3(currPot.X, (Fix64)0, currPot.Z), new FixVector3(parent.X, (Fix64)0, parent.Z))
                + parent.G;
        }

        /// <summary>
        /// openListF
        /// </summary>
        /// <param name="openList"></param>
        /// <returns></returns>
        private ASPoint FindMinFPoint(List<ASPoint> openList)
        {
            Fix64 f = (Fix64)9999999999;//float.MaxValue;
            ASPoint temp = null;

            foreach (var pot in openList)
            {

                if (pot.F < f)
                {
                    temp = pot;
                    f = pot.F;
                }
            }

            return temp;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="src"></param>
        /// <param name="closeList"></param>
        private void PointFilter(List<ASPoint> src, List<ASPoint> closeList)
        {
            // 
            foreach (ASPoint item in closeList)
            {
                if (src.IndexOf(item) > -1)
                {
                    src.Remove(item);
                }

            }
        }

#if _CLIENTLOGIC_
        //public void SetCubeColor(int x, int z, Color targetColor)
        //{
        //    asPoint2DMap[x, z].PointGameObject.gameObject.GetComponent<Renderer>().material.color = targetColor;
        //}
#endif
        private void CreateAStartMap()
        {
            for (int x = 0; x < width; x += 2)
            {
                for (int z = 0; z < height; z += 2)
                {
                    if (asPoint2DMap[x, z] == null)
                    {
                        ASPoint point = new ASPoint((Fix64)x, (Fix64)z);
                        asPoint2DMap[x, z] = point;
                    }
                }
            }
        }

        /// <summary>
        ///  F 
        /// </summary>
        /// <param name="point"> F </param>
        /// <param name="map"></param>
        /// <param name="mapWidth"></param>
        /// <param name="mapHeight"></param>
        /// <returns></returns>
        private List<ASPoint> GetSurroundPoints(ASPoint point, ASPoint[,] map, int mapWidth, int mapHeight)
        {
            //  
            ASPoint up = null, down = null, left = null, right = null;
            ASPoint lu = null, ru = null, ld = null, rd = null;

            //   Y  mapHeight - 1
            if (point.Z < mapHeight - 2)
            {
                up = map[(int)point.X, (int)point.Z + 2];
            }
            //   Y  0
            if (point.Z > 0)
            {
                down = map[(int)point.X, (int)point.Z - 2];
            }
            //   X  mapWidth - 1
            if (point.X < mapWidth - 2)
            {
                right = map[(int)point.X + 2, (int)point.Z];
            }
            //   X  0
            if (point.X > 0)
            {
                left = map[(int)point.X - 2, (int)point.Z];
            }

            // 
            // 
            if (up != null && left != null)
            {
                lu = map[(int)point.X - 2, (int)point.Z + 2];
            }
            // 
            if (up != null && right != null)
            {
                ru = map[(int)point.X + 2, (int)point.Z + 2];
            }
            // 
            if (down != null && left != null)
            {
                ld = map[(int)point.X - 2, (int)point.Z - 2];
            }
            // 
            if (down != null && right != null)
            {
                rd = map[(int)point.X + 2, (int)point.Z - 2];
            }

            // 
            List<ASPoint> list = new List<ASPoint>();
            // 
            // 
            if (up != null && up.IsWall == false)
            {
                list.Add(up);
            }
            if (down != null && down.IsWall == false)
            {
                list.Add(down);
            }
            if (left != null && left.IsWall == false)
            {
                list.Add(left);
            }
            if (right != null && right.IsWall == false)
            {
                list.Add(right);
            }

            // 
            //  
            if (lu != null && lu.IsWall == false && left.IsWall == false && up.IsWall == false)
            {
                list.Add(lu);
            }
            if (ru != null && ru.IsWall == false && right.IsWall == false && up.IsWall == false)
            {
                list.Add(ru);
            }
            if (ld != null && ld.IsWall == false && left.IsWall == false && down.IsWall == false)
            {
                list.Add(ld);
            }
            if (rd != null && rd.IsWall == false && right.IsWall == false && down.IsWall == false)
            {
                list.Add(rd);
            }

            // 
            return list;

        }
    }
}

