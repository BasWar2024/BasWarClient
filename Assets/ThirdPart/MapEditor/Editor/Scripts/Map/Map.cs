using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace MapLib
{
#if true    // TestMapfalse
    using UnityEngine;
#else
    public class Vector3
    {
        public float x;
        public float y;
        public float z;

        public Vector3(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public static Vector3 Normalize(Vector3 v)
        {
            Vector3 clone = new Vector3(v.x, v.y, v.z);
            float length = (float)Math.Sqrt(clone.x * clone.x + clone.y * clone.y + clone.z * clone.z);
            if (length == 1)
            {
            } else if (length > 1e-6) {
                clone.x /= length;
                clone.y /= length;
                clone.z /= length;
            } else
            {
                clone.x = 0;
                clone.y = 0;
                clone.z = 0;
            }
            return clone;
        }

        public string ToString() {
            return string.Format("[{0},{1},{2}]",this.x,this.y,this.z);
        }
    }
#endif

    public struct Hit2D {
        public UInt64 id;
        public double distance;
        public Vector3 point;
        public Vector3 normal;
    }

    public class Grid
    {
        public int x;                     // x
        public int y;                     // y
        public double height;                // 
        public int terrian;               // 
        public int type;                  // 
        public int barrierTerrian = 0;    // 
        public int camp = 0;              // 
        public ulong eventId;               // id

        public Grid()
        {

        }

        public Grid(int x, int y, double height, int terrian, int type,int camp,ulong eventId)
        {
            this.x = x;
            this.y = y;
            this.height = height;
            this.terrian = terrian;
            this.type = type;
            this.barrierTerrian = this.terrian;
            this.camp = camp;
            this.eventId = eventId;
        }
    }

    public class Entity
    {
        public UInt64 id;          // ID
        public int tag;            // (//npc/)
        public int type;           // 
        public int modeAOI;        // aoi(MODE_WATCHERMODE_MARKER)
        public double radiusAOI;      // aoi
        public Vector3 pos;         // 
        public int terrian;        // ()
        public int affectGridTerrian;   // 0=,1=,2=
        public Vector3 lookAt;     // 

        public int shapeType;     // 
        public double radius;        // 
        public double length;        // 
        public double width;         // 
        public double angle;         // 
        public int camp;             // 
        public int groupId;         // id

        public Entity()
        {

        }

        public Entity(UInt64 id,int tag,int type,int modeAOI,double radiusAOI,Vector3 pos,int terrian,int affectGridTerrian,Vector3 lookAt,
            int shapeType,double radius,double length,double width,double angle,int camp,int groupId)
        {
            this.id = id;
            this.tag = tag;
            this.type = type;
            this.modeAOI = modeAOI;
            this.radiusAOI = radiusAOI;
            this.pos = pos;
            this.terrian = terrian;
            this.affectGridTerrian = affectGridTerrian;
            this.lookAt = lookAt;
            this.shapeType = shapeType;
            this.radius = radius;
            this.length = length;
            this.width = width;
            this.angle = angle;
            this.camp = camp;
            this.groupId = groupId;
        }
    }

    public class Map
    {
        public const int TERRIAN_ANY = -1;               // 
        public const int TERRIAN_NONE = (1 << 0);               // 

        public const int SHAPE_TYPE_RECTANGLE = 1;                // #
        public const int SHAPE_TYPE_CIRCLE = 2;                   // #
        public const int SHAPE_TYPE_SECTOR = 3;                   // #
        public const int SHAPE_TYPE_RECTANGLE_BOUNDARY = 4;       // #()
        public const int SHAPE_TYPE_CIRCLE_BOUNDARY = 5;          // #()
        public const int SHAPE_TYPE_SECTOR_BOUNDARY = 6;          // #()

        public const int AFFECT_TERRIAN_TYPE_NONE = 0;                    // #
        public const int AFFECT_TERRIAN_TYPE_POINT = 1;                   // #
        public const int AFFECT_TERRIAN_TYPE_SHAPE = 2;                   // #

        public const int ENTITY_TAG_ANY = -1;                  // 

        public const int MAX_ENTITY_RADIUS = 6;                // 
        public const int MAX_ENTITY_LENGTH = 512;              // 
        public const int MAX_PATH_LENGTH = 256;                // 

        public IntPtr pMap;
        public Dictionary<UInt64, Entity> entities = new Dictionary<ulong, Entity>();
        public Grid[,] grids;
        public int minX,minY,maxX,maxY;
        public double gridSize;
        public int backgroundType;
        public string name = "Map";    // 

        public static double[] doubleArr1 = new double[3] ;
        public static double[] doubleArr2 = new double[3] ;
        public static double[] doubleArr3 = new double[3] ;
        public static double[] doubleArr4 = new double[3] ;
        public static double[] doubleArr5 = new double[3] ;
        public static double[] doubleArr6 = new double[3] ;
        public static double[] doubleArr7 = new double[3] ;
        public static double[] doubleArr8 = new double[3] ;

        public static double[] rectDouble = new double[12] ;

        public static UInt64[] uInt64Arr1 = new UInt64[MAX_ENTITY_LENGTH] ;
        public static UInt64[] uInt64Arr2 = new UInt64[MAX_ENTITY_LENGTH*10] ;

        public static double[] posArr1 = new double[MAX_PATH_LENGTH*3] ;


        public CppRaycastHit [] cppHitArr = new CppRaycastHit[MAX_PATH_LENGTH];
        public Hit2D hit2d = new Hit2D();
        public Vector3 vzero = new Vector3(0,0,0);

        public static double[] packPos(Vector3 pos,ref double[] doubleArr) {
            /*
            double x = pos.x * 10000;
            double y = pos.y * 10000;
            double z = pos.z * 10000;
            */
            double x = (double)pos.x;
            double y = 0;
            double z = (double)pos.z;
            double temp = y;
            y = z;
            z = temp;
            doubleArr[0] = x;
            doubleArr[1] = y;
            doubleArr[2] = z;
            return doubleArr;
        }

        public static Vector3 unpackPos(double[] pos) {
            /*
            double x = pos[0] / 10000;
            double y = pos[1] / 10000;
            double z = pos[2] / 10000;
            */
            double x = pos[0];
            double y = pos[1];
            double z = pos[2];
            double temp = y;
            y = z;
            z = temp;
            y = 0;
            return new Vector3((float)x,(float)y,(float)z);
        }

        public static double[] packLookAt(Vector3 lookAt,ref double[] doubleArr) {
            lookAt.y = 0;
            lookAt = Vector3.Normalize(lookAt);
            double x = lookAt.x;
            double y = lookAt.y;
            double z = lookAt.z;
            double temp = y;
            y = z;
            z = temp;
            doubleArr[0] = x;
            doubleArr[1] = y;
            doubleArr[2] = z;
            return doubleArr;
        }

        public static Vector3 unpackLookAt(double[] lookAt) {
            double x = lookAt[0];
            double y = lookAt[1];
            double z = lookAt[2];
            double temp = y;
            y = z;
            z = temp;
            y = 0;
            return new Vector3((float)x,(float)y,(float)z);
        }

        public static double packFloat(double number) {
            //return number * 10000;
            return number;
        }

        public static double unpackFloat(double number) {
            return number;
            //return number / 10000;
        }

        public Map()
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="minX">x</param>
        /// <param name="minY">y</param>
        /// <param name="maxX">x</param>
        /// <param name="maxY">y</param>
        /// <param name="gridSize"></param>
        /// <param name="backGroundType">id</param>
        public Map(int minX, int minY, int maxX, int maxY, double gridSize, int backgroundType,int towerSize = 4)
        {
            this.pMap = CMap.createMap(minX, minY, maxX, maxY, packFloat(gridSize), backgroundType,towerSize);
            this.minX = minX;
            this.minY = minY;
            this.maxX = maxX;
            this.maxY = maxY;
            this.gridSize = gridSize;
            this.backgroundType = backgroundType;
            for (int i = 0; i < MAX_PATH_LENGTH; i++) {
                cppHitArr[i].point = new double[3];
                cppHitArr[i].normal = new double[3];
            }
            this.initGrids();
        }

        ~Map() {
            if (this.pMap == null)
            {
                return;
            }
            CMap.destroyMap(this.pMap);
        }

        private void initGrids() {
            int xLength = this.maxX - this.minX;
            int yLength = this.maxY - this.minY;
            this.grids = new Grid[xLength,yLength];
            for (int x = this.minX; x < this.maxX; x++) {
                for (int y = this.minY; y < this.maxY; y++) {
                    int i = x - this.minX;
                    int j = y - this.minY;
                    this.grids[i,j] = new Grid(x,y,0,Map.TERRIAN_NONE,0,0,0);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns>true=,false=,</returns>
        public bool addEntity(Entity entity)
        {
            bool ok = CMap.addEntity(this.pMap, entity.id, entity.tag, entity.type, entity.modeAOI, packFloat(entity.radiusAOI), packPos(entity.pos,ref doubleArr1), entity.terrian, entity.affectGridTerrian, packLookAt(entity.lookAt,ref doubleArr2),
                entity.shapeType, packFloat(entity.radius), packFloat(entity.length), packFloat(entity.width), entity.angle,entity.camp,entity.groupId);
            if (!ok)
            {
                return false;
            }
            this.entities.Add(entity.id, entity);
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        public void delEntity(UInt64 id)
        {
            this.entities.Remove(id);
            CMap.delEntity(this.pMap, id);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>null=,=</returns>
        public Entity getEntity(UInt64 id)
        {
            Entity entity = new Entity();
            if(!this.entities.TryGetValue(id,out entity))
            {
                return null;
            }
            return entity;
        }

        private Entity _getEntity(UInt64 id)
        {
            Entity entity = new Entity();
            double[] pos = doubleArr1;
            double[] lookAt = doubleArr2;
            bool ok = CMap.getEntity(this.pMap, id, out entity.tag, out entity.type, out entity.modeAOI, out entity.radiusAOI, pos, out entity.terrian, out entity.affectGridTerrian, lookAt,
                out entity.shapeType, out entity.radius, out entity.length, out entity.width, out entity.angle,out entity.camp,out entity.groupId);
            if (!ok)
            {
                return null;
            }
            entity.id = id;
            entity.radiusAOI = unpackFloat(entity.radiusAOI);
            entity.radius = unpackFloat(entity.radius);
            entity.length = unpackFloat(entity.length);
            entity.width = unpackFloat(entity.width);
            entity.pos = unpackPos(pos);
            entity.lookAt = unpackLookAt(lookAt);
            return entity;
        }

        public bool isValidGrid(int gridX,int gridY)
        {
            if (!(this.minX <= gridX && gridX < this.maxX))
            {
                return false;
            }
            if (!(this.minY <= gridY && gridY < this.maxY))
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="gridX">X</param>
        /// <param name="gridY">Y</param>
        /// <param name="height">,!!!</param>
        /// <param name="terrian">,16</param>
        /// <param name="type"></param>
        /// <param name="camp"></param>
        /// <param name="eventId">id</param>
        /// <returns>true=,false=,</returns>
        public bool setGrid(int gridX,int gridY,double height,int terrian,int type,int camp,ulong eventId)
        {
            Grid grid = this.getGrid(gridX,gridY);
            if (grid == null) {
                return false;
            }
            bool ok = CMap.setGrid(this.pMap, gridX, gridY,packFloat(height), terrian, type,camp,eventId);
            //Debug.Log(string.Format("op=setGrid,gridX={0},gridY={1},height={2},terrian={3},type={4},ok={5}",gridX,gridY,height,terrian,type,ok));
            if (!ok)
            {
                return false;
            }
            grid.height = height;
            grid.terrian = terrian;
            grid.type = type;
            grid.camp = camp;
            grid.eventId = eventId;
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="gridX">X</param>
        /// <param name="gridY">Y</param>
        /// <param name="camp"></param>
        /// <returns>true=,false=,</returns>
        public bool setGridCamp(int gridX,int gridY,int camp) {
            Grid grid = this.getGrid(gridX,gridY);
            if (grid == null) {
                return false;
            }
            return this.setGrid(gridX,gridY,grid.height,grid.terrian,grid.type,camp,grid.eventId);
        }

        /// <summary>
        /// id
        /// </summary>
        /// <param name="gridX">X</param>
        /// <param name="gridY">Y</param>
        /// <param name="eventId">id</param>
        /// <returns>true=,false=,</returns>
        public bool setGridEventId(int gridX,int gridY,ulong eventId) {
            Grid grid = this.getGrid(gridX,gridY);
            if (grid == null) {
                return false;
            }
            return this.setGrid(gridX,gridY,grid.height,grid.terrian,grid.type,grid.camp,eventId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="gridX">x</param>
        /// <param name="gridY">y</param>
        /// <returns>null=,=</returns>
        public Grid getGrid(int gridX,int gridY)
        {
            if (!this.isValidGrid(gridX,gridY)) {
                return null;
            }
            Grid grid = this.grids[gridX-this.minX,gridY-this.minY];
            // ,barrierTerrian
            double height;
            int terrian,type,barrierTerrian,camp;
            ulong eventId;
            this._getGrid(gridX,gridY,out height,out terrian,out type,out barrierTerrian,out camp,out eventId);
            grid.height = height;
            grid.terrian = terrian;
            grid.type = type;
            grid.barrierTerrian = barrierTerrian;
            grid.camp = camp;
            grid.eventId = eventId;
            return grid;
        }

        private bool _getGrid(int gridX,int gridY,out double height,out int terrian,out int type,out int barrierTerrian,out int camp,out ulong eventId)
        {
            bool ok = CMap.getGrid(this.pMap, gridX, gridY, out height, out terrian, out type,out barrierTerrian,out camp,out eventId);
            if (!ok)
            {
                return false;
            }
            height = unpackFloat(height);
            return true;
        }

        /// <summary>
        ///  
        /// </summary>
        /// <param name="x">x</param>
        /// <param name="y">y</param>
        /// <param name="gridX">X</param>
        /// <param name="gridY">Y</param>
        public void toGridPos(float x,float y,out int gridX,out int gridY) {
            CMap.toGridPos(this.pMap,(double)x,(double)y,out gridX,out gridY);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="gridX">X</param>
        /// <param name="gridY">Y</param>
        /// <param name="x">x</param>
        /// <param name="y">y</param>
        public void toPos(int gridX,int gridY,out float x,out float y) {
            double dx,dy;
            CMap.toPos(this.pMap,gridX,gridY,out dx,out dy);
            x = (float)dx;
            y = (float)dy;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fromGridX">x</param>
        /// <param name="fromGridY">y</param>
        /// <param name="toGridX">x</param>
        /// <param name="toGridY">y</param>
        /// <param name="canPassTerrian"></param>
        /// <param name="checkMask">-1=0=1=2=4=</param>
        public bool canPass(int fromGridX,int fromGridY,int toGridX,int toGridY,int canPassTerrian ,int checkMask = 5) {
            return CMap.canPass(this.pMap,fromGridX,fromGridY,toGridX,toGridY,canPassTerrian,checkMask);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public byte[] serialize()
        {
            byte[] output = new byte[16 * 1024 * 1024];
            int length = output.Length;
            CMap.serialize(this.pMap,output, out length);
            byte[] result = new byte[length];
            for (int i = 0; i < length; i++)
            {
                result[i] = output[i];
            }
            return result;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="input"></param>
        /// <param name="length"></param>
        /// <returns></returns>
        public static Map deserialize(byte []input,int length,int towerSize=2)
        {
            Map map = new Map();
            map.pMap = CMap.deserialize(input, length,towerSize);
            CMap.info(map.pMap, out map.minX, out map.minY, out map.maxX, out map.maxY, out map.gridSize, out map.backgroundType);
            map.gridSize = unpackFloat(map.gridSize);
            UInt64[] ids = map.allEntityId();
            length = ids.Length;
            for (int i=0; i < length; i++)
            {
                UInt64 id = ids[i];
                Entity entity = map._getEntity(id);
                if (entity == null) {
                    throw new Exception(string.Format("op=entityNotFound,id={0}",id));
                }
                map.entities.Add(id, entity);
            }
            map.initGrids();
            Grid grid;
            for (int x = map.minX; x < map.maxX; x++)
            {
                for (int y = map.minY; y < map.maxY; y++)
                {
                    map.getGrid(x,y);
                }
            }
            return map;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="filename"></param>
        public void serializeToFile(string filename)
        {
            byte[] buffer = this.serialize();
            FileStream fs = new FileStream(filename, FileMode.OpenOrCreate, FileAccess.Write);
            fs.Write(buffer,0,buffer.Length);
            fs.Close();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static Map deserializeFromFile(string filename)
        {
            FileStream fs = new FileStream(filename, FileMode.Open, FileAccess.Read);
            int length = (int)fs.Length;
            byte[] buffer = new byte[length];
            fs.Read(buffer, 0, length);
            fs.Close();
            Map map = Map.deserialize(buffer, length);
            map.name = filename;
            return map;
        }

        /// <summary>
        /// id
        /// </summary>
        /// <param name="nodeId">id0</param>
        /// <returns>id</returns>
        public static UInt64 uuid(int nodeId=0)
        {
            return CMap.uuid(nodeId);
        }

        /// <summary>
        /// dump
        /// </summary>
        /// <param name="filename"></param>
        public void dump(string filename)
        {
            CMap.dump(this.pMap, filename);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pos"></param>
        /// <param name="radius"></param>
        /// <param name="entityTagMask"></param>
        /// <returns>id</returns>
        public void findEntitiesInCircle(Vector3 pos,double radius,int entityTagMask,ref UInt64[] ids,ref int count) {
            int length = doubleArr1.Length;
            CMap.findEntitiesInCircle(this.pMap,packPos(pos,ref doubleArr1),packFloat(radius),entityTagMask,uInt64Arr1,out length);
            count = Math.Min(count,length);
            for (int i=0; i < count; i++) {
                ids[i] = uInt64Arr1[i];
            }
        }

        /// <summary>
        /// id
        /// </summary>
        /// <returns>id</returns>
        public UInt64[] allEntityId() {
            int length = uInt64Arr2.Length;
            UInt64[] list = uInt64Arr2;
            CMap.allEntityId(this.pMap, list, out length);
            UInt64[] ids = new UInt64[length];
            for (int i=0; i < length; i++) {
                ids[i] = list[i];
            }
            return ids;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="startPos"></param>
        /// <param name="stopPos"></param>
        /// <param name="path"></param>
        /// <param name="canPassTerrian"></param>
        /// <param name="inflectionLevel">0,1=2</param>
        /// <returns>true=,false=</returns>
        public bool findPath(Vector3 startPos,Vector3 stopPos,out Vector3[] path,int canPassTerrian,int inflectionLevel) {
            int maxLength = posArr1.Length;
            double[] posList = posArr1;
            bool ok = CMap.findPath(this.pMap,packPos(startPos,ref doubleArr1),packPos(stopPos,ref doubleArr2),posList,ref maxLength,canPassTerrian,inflectionLevel);
            int pathLength = maxLength / 3;
            path = new Vector3[pathLength];
            for (int i = 0; i < pathLength; i++) {
                doubleArr3[0] = posList[i*3+0];
                doubleArr3[1] = posList[i*3+1];
                doubleArr3[2] = posList[i*3+2];
                path[i] = unpackPos(doubleArr3);
            }
            return ok;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entityId">id</param>
        /// <param name="rayStartPos"></param>
        /// <param name="rayLookAt"></param>
        /// <param name="rayLength"></param>
        /// <param name="hitDistance"></param>
        /// <param name="canPassTerrian"></param>
        /// <param name="hit"></param>
        /// <param name="filter"></param>
        /// <returns>true=,false=</returns>
        public bool moveHit(UInt64 entityId,Vector3 rayStartPos,Vector3 rayLookAt,double rayLength,double hitDistance,int canPassTerrian,ref Hit2D hit,entityFilterCallback filter) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.moveHit(this.pMap,entityId,packPos(rayStartPos,ref doubleArr1),packLookAt(rayLookAt,ref doubleArr2),packFloat(rayLength),packFloat(hitDistance),canPassTerrian,ref cppHit,filter,IntPtr.Zero);
            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entityId">id</param>
        /// <param name="rayStartPos"></param>
        /// <param name="rayStopPos"></param>
        /// <param name="hitDistance"></param>
        /// <param name="canPassTerrian"></param>
        /// <param name="hit"></param>
        /// <param name="filter"></param>
        /// <returns>true=,false=</returns>
        public bool moveHitTo(UInt64 entityId,Vector3 rayStartPos,Vector3 rayStopPos,double hitDistance,int canPassTerrian,ref Hit2D hit,entityFilterCallback filter) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.moveHitTo(this.pMap,entityId,packPos(rayStartPos,ref doubleArr1),packPos(rayStopPos,ref doubleArr2),packFloat(hitDistance),canPassTerrian,ref cppHit,filter,IntPtr.Zero);

            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rayStartPos"></param>
        /// <param name="rayLookAt"></param>
        /// <param name="rayLength"></param>
        /// <param name="hitDistance"></param>
        /// <param name="hit"></param>
        /// <returns>true=,false=</returns>
        public bool raycastHitBoundary(Vector3 rayStartPos,Vector3 rayLookAt,double rayLength,double hitDistance,ref Hit2D hit) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.raycastHitBoundary(this.pMap,packPos(rayStartPos,ref doubleArr1),packLookAt(rayLookAt,ref doubleArr2),packFloat(rayLength),packFloat(hitDistance),ref cppHit);

            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rectCenter"></param>
        /// <param name="rectLookAt"></param>
        /// <param name="rectLength"></param>
        /// <param name="rectWidth"></param>
        /// <param name="entityId">id</param>
        /// <param name="hit"></param>
        /// <returns>true=,false=</returns>
        public bool isCollideRectangleWithEntity(Vector3 rectCenter,Vector3 rectLookAt,double rectLength,double rectWidth,UInt64 entityId,ref Hit2D hit) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.isCollideRectangleWithEntity(this.pMap,packPos(rectCenter,ref doubleArr1),packLookAt(rectLookAt,ref doubleArr2),packFloat(rectLength),packFloat(rectWidth),entityId,ref cppHit);

            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="circleCenter"></param>
        /// <param name="circleRadius"></param>
        /// <param name="entityId">id</param>
        /// <param name="hit"></param>
        /// <returns>true=,false=</returns>
        public bool isCollideCircleWithEntity(Vector3 circleCenter,double circleRadius,UInt64 entityId,ref Hit2D hit) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.isCollideCircleWithEntity(this.pMap,packPos(circleCenter,ref doubleArr1),packFloat(circleRadius),entityId,ref cppHit);

            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sectorCenter"></param>
        /// <param name="sectorLookAt"></param>
        /// <param name="sectorRadius"></param>
        /// <param name="sectorAngle"></param>
        /// <param name="entityId">id</param>
        /// <param name="hit"></param>
        /// <returns>true=,false=</returns>
        public bool isCollideSectorWithEntity(Vector3 sectorCenter,Vector3 sectorLookAt,double sectorRadius,double sectorAngle,UInt64 entityId,ref Hit2D hit) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.isCollideSectorWithEntity(this.pMap,packPos(sectorCenter,ref doubleArr1),packLookAt(sectorLookAt,ref doubleArr2),packFloat(sectorRadius),sectorAngle,entityId,ref cppHit);

            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rayStartPos"></param>
        /// <param name="rayLookAt"></param>
        /// <param name="rayLength"></param>
        /// <param name="hitDistance"></param>
        /// <param name="entityIds"></param>
        /// <param name="entityCount"></param>
        /// <param name="hits"></param>
        /// <returns>true=,false=</returns>
        public bool raycastHitEntities(Vector3 rayStartPos,Vector3 rayLookAt,double rayLength,double hitDistance,UInt64[] entityIds,int entityCount,ref Hit2D[] hits, ref int count) {
            int hitMaxLength = entityCount + 1;
            CppRaycastHit[] cppHits;
            if(hitMaxLength<= cppHitArr.Length){
                cppHits = cppHitArr;
            } else {
              cppHits = new CppRaycastHit[hitMaxLength];
                for (int i = 0; i < hitMaxLength; i++) {
                    cppHits[i].point = new double[3];
                    cppHits[i].normal = new double[3];
                }
            }
            bool collide = CMap.raycastHitEntities(this.pMap,packPos(rayStartPos,ref doubleArr1),packLookAt(rayLookAt,ref doubleArr2),packFloat(rayLength),packFloat(hitDistance),entityIds,entityCount,cppHits,ref hitMaxLength);

            count = Math.Min(count,hitMaxLength);
            for (int i = 0; i < count; i++) {
                hits[i].id = cppHits[i].id;
                hits[i].distance = unpackFloat(cppHits[i].distance);
                hits[i].point = unpackPos(cppHits[i].point);
                hits[i].normal = unpackPos(cppHits[i].normal);
            }
            return collide;
        }

        public static void fReOpenStdOut(string filename) {
            CMap.fReOpenStdOut(filename);
        }

        /// <summary>
        /// ,[0,180]
        /// </summary>
        /// <param name="from">1</param>
        /// <param name="to">2</param>
        /// <returns></returns>
        public static double getAngle(Vector3 from,Vector3 to) {
            return CMap.getAngle(packPos(from,ref doubleArr1),packPos(to,ref doubleArr2));
        }

        /// <summary>
        /// ,[-180,180],,
        /// </summary>
        /// <param name="from">1</param>
        /// <param name="to">2</param>
        /// <returns></returns>
        public static double getSignAngle(Vector3 from,Vector3 to) {
            return CMap.getSignAngle(packPos(from,ref doubleArr1),packPos(to,ref doubleArr2));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="p0"></param>
        /// <param name="p1"></param>
        /// <param name="p2"></param>
        /// <param name="closestPoint"></param>
        /// <returns></returns>
        public static double distancePointToLine(Vector3 p0,Vector3 p1,Vector3 p2,out Vector3 closestPoint) {
            double[] result = doubleArr4;
            double distance = CMap.distancePointToLine(packPos(p0,ref doubleArr1),packPos(p1,ref doubleArr2),packPos(p2,ref doubleArr3),result);
            closestPoint = unpackPos(result);
            return distance;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="p0"></param>
        /// <param name="p1"></param>
        /// <param name="p2"></param>
        /// <returns>true=,false=</returns>
        public static bool isPointInLine(Vector3 p0,Vector3 p1,Vector3 p2) {
            return CMap.isPointInLine(packPos(p0,ref doubleArr1),packPos(p1,ref doubleArr2),packPos(p2,ref doubleArr3));
        }

        public static bool isPointInRectangle(Vector3 p0,Vector3 rectCenter,Vector3 rectLookAt,double rectLength,double rectWidth,out bool boundary) {
            return CMap.isPointInRectangle(packPos(p0,ref doubleArr1),packPos(rectCenter,ref doubleArr2),packLookAt(rectLookAt,ref doubleArr3),packFloat(rectLength),packFloat(rectWidth),out boundary);
        }

        public static bool isPointInCircle(Vector3 p0,Vector3 circleCenter,double circleRadius,out bool boundary) {
            return CMap.isPointInCircle(packPos(p0,ref doubleArr1),packPos(circleCenter,ref doubleArr2),packFloat(circleRadius),out boundary);
        }

        /// <summary>
        /// ,rect4
        /// </summary>
        /// <param name="rect">4</param>
        /// <param name="center"></param>
        /// <param name="lookAt"></param>
        /// <param name="length"></param>
        /// <param name="width"></param>
        public static void toNormalRectangle(Vector3[] rect,Vector3 center,Vector3 lookAt,double length,double width) {
            double[] r = rectDouble;
            CMap.toNormalRectangle(r,packPos(center,ref doubleArr1),packLookAt(lookAt,ref doubleArr2),packFloat(length),packFloat(width));
            for (int i = 0; i < 4; i++)
            {
                double[] temp = doubleArr3;
                for (int j = 0; j < 3; j++)
                {
                    temp[j] = r[i * 4 + j];
                }
                rect[i] = unpackPos(temp);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="p1">1</param>
        /// <param name="p2">1</param>
        /// <param name="p3">2</param>
        /// <param name="p4">2</param>
        /// <param name="intersection"></param>
        /// <param name="normal"></param>
        /// <param name="intersectionCount">(-1=)</param>
        /// <returns>true=,false=</returns>
        public static bool isCollideLineWithLine(Vector3 p1,Vector3 p2,Vector3 p3,Vector3 p4,out Vector3 intersection,out Vector3 normal,out int intersectionCount)  {
            double[] result1 = doubleArr5;
            double[] result2 = doubleArr6;
            bool ok = CMap.isCollideLineWithLine(packPos(p1,ref doubleArr1),packPos(p2,ref doubleArr2),packPos(p3,ref doubleArr3),packPos(p4,ref doubleArr4),result1,result2,out intersectionCount);
            intersection = unpackPos(result1);
            normal = unpackPos(result2);
            return ok;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="p1"></param>
        /// <param name="p2"></param>
        /// <param name="rect"></param>
        /// <param name="intersection1">1</param>
        /// <param name="intersection2">2</param>
        /// <param name="normal"></param>
        /// <param name="intersectionCount">(-1=)</param>
        /// <returns>true=,false=</returns>
        public static bool isCollideLineWithRectangle(Vector3 p1,Vector3 p2,Vector3 rectCenter,Vector3 rectLookAt,double rectLength,double rectWidth,out Vector3 intersection1,out Vector3 intersection2,out Vector3 normal,out int intersectionCount)  {
            double[] result1 = doubleArr5;
            double[] result2 = doubleArr6;
            double[] result3 = doubleArr7;
            bool ok = CMap.isCollideLineWithRectangle(packPos(p1,ref doubleArr1),packPos(p2,ref doubleArr2),packPos(rectCenter,ref doubleArr3),packLookAt(rectLookAt,ref doubleArr4),packFloat(rectLength),packFloat(rectWidth),result1,result2,result3,out intersectionCount);
            intersection1 = unpackPos(result1);
            intersection2 = unpackPos(result2);
            normal = unpackPos(result3);
            return ok;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="p1"></param>
        /// <param name="p2"></param>
        /// <param name="circleCenter"></param>
        /// <param name="circleRadius"></param>
        /// <param name="intersection1">1</param>
        /// <param name="intersection2">2</param>
        /// <param name="normal"></param>
        /// <param name="intersectionCount">(-1=)</param>
        /// <returns>true=,false=</returns>
        public static bool isCollideLineWithCircle(Vector3 p1,Vector3 p2,Vector3 circleCenter,double circleRadius,out Vector3 intersection1,out Vector3 intersection2,out Vector3 normal,out int intersectionCount)  {
            double[] result1 = doubleArr5;
            double[] result2 = doubleArr6;
            double[] result3 = doubleArr7;
            bool ok = CMap.isCollideLineWithCircle(packPos(p1,ref doubleArr1),packPos(p2,ref doubleArr2),packPos(circleCenter,ref doubleArr3),packFloat(circleRadius),result1,result2,result3,out intersectionCount);
            intersection1 = unpackPos(result1);
            intersection2 = unpackPos(result2);
            normal = unpackPos(result3);
            return ok;
        }

        /// <summary>
        /// p01p02
        /// p01p02p1
        /// p01p02p0
        /// p020p1
        /// </summary>
        /// <param name="p0">0</param>
        /// <param name="p1">1</param>
        /// <param name="p2">2</param>
        /// <returns></returns>
        public static Vector3 getProjectPoint(Vector3 p0,Vector3 p1,Vector3 p2) {
            double[] result = doubleArr5;
            CMap.getProjectPoint(result, packPos(p0,ref doubleArr1), packPos(p1,ref doubleArr2), packPos(p2,ref doubleArr3));
            return unpackPos(result);
        }

        /// <summary>
        /// p01p02
        /// p01p02p0
        /// p01p02p1
        /// p020p1
        /// </summary>
        /// <param name="p0">0</param>
        /// <param name="p1">1</param>
        /// <param name="p2">2</param>
        /// <returns></returns>
        public static Vector3 getTangentPoint(Vector3 p0,Vector3 p1,Vector3 p2) {
            double[] result = doubleArr5;
            CMap.getTangentPoint(result,packPos(p0,ref doubleArr1),packPos(p1,ref doubleArr2),packPos(p2,ref doubleArr3));
            return unpackPos(result);
        }

        /// <summary>
        /// (v2,v1)
        /// </summary>
        /// <param name="v1">1</param>
        /// <param name="v2">2</param>
        /// <returns></returns>
        public static Vector3 getNormal(Vector3 v1,Vector3 v2) {
            double[] result = doubleArr5;
            CMap.getNormal(result,packPos(v1,ref doubleArr1),packPos(v2,ref doubleArr2));
            return unpackPos(result);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pos"></param>
        /// <param name="centerPos"></param>
        /// <param name="gridRadius"></param>
        /// <param name="excludeCorner">true=</param>
        /// <returns>true=</returns>
        public bool isPosInArea(Vector3 pos,Vector3 centerPos,int gridRadius,bool excludeCorner) {
            return CMap.isPosInArea(this.pMap,packPos(pos,ref doubleArr1),packPos(centerPos,ref doubleArr2),gridRadius,excludeCorner);
        }

        /// <summary>
        /// id
        /// </summary>
        /// <param name="pos"></param>
        /// <param name="gridRadius"></param>
        /// <param name="entityTagMask"></param>
        /// <param name="excludeCorner">true=</param>
        /// <returns></returns>
        public void getEntitiesInArea(Vector3 pos,int gridRadius,int entityTagMask,bool excludeCorner,ref UInt64[] ids,ref int count) {
            int length = uInt64Arr1.Length;
            UInt64[] list = uInt64Arr1;
            CMap.getEntitiesInArea(this.pMap,packPos(pos,ref doubleArr1),gridRadius,entityTagMask,excludeCorner,list,out length);
            count = Math.Min(count,length);
            for (int i=0; i < count; i++) {
                ids[i] = list[i];
            }
        }

        /// <summary>
        /// id
        /// </summary>
        /// <param name="gridX">X</param>
        /// <param name="gridY">Y</param>
        /// <param name="entityTagMask"></param>
        /// <returns></returns>
        public void getEntitiesInGrid(int gridX,int gridY,int entityTagMask,ref UInt64[] ids,ref int count) {
            int length = uInt64Arr1.Length;
            UInt64[] list = uInt64Arr1;
            CMap.getEntitiesInGrid(this.pMap,gridX,gridY,entityTagMask,list,out length);
            count = Math.Min(count,length);
            for (int i=0; i < count; i++) {
                ids[i] = list[i];
            }
        }

        /// <summary>
        /// id
        /// </summary>
        /// <param name="pos"></param>
        /// <param name="entityTagMask"></param>
        /// <returns></returns>
        public void getEntitiesInPos(Vector3 pos,int entityTagMask,ref UInt64[] ids,ref int count) {
            int gridX,gridY;
            this.toGridPos(pos.x,pos.z,out gridX,out gridY);
            this.getEntitiesInGrid(gridX,gridY,entityTagMask,ref ids,ref count);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="startPos"></param>
        /// <param name="stopPos"></param>
        /// <param name="canPassTerrian"></param>
        /// <returns>true=</returns>
        public bool canLineMove(Vector3 startPos,Vector3 stopPos,int canPassTerrian) {
            return CMap.canLineMove(this.pMap,packPos(startPos,ref doubleArr1),packPos(stopPos,ref doubleArr2),canPassTerrian);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rayStartPos"></param>
        /// <param name="rayLookAt"></param>
        /// <param name="rayLength"></param>
        /// <param name="entityId">id</param>
        /// <param name="hit"></param>
        /// <returns>true=</returns>
        public bool isCollideRayWithEntity(Vector3 rayStartPos,Vector3 rayLookAt,double rayLength,UInt64 entityId,ref Hit2D hit) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.isCollideRayWithEntity(this.pMap,packPos(rayStartPos,ref doubleArr1),packLookAt(rayLookAt,ref doubleArr2),packFloat(rayLength),entityId,ref cppHit);
            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// /
        /// </summary>
        /// <param name="rayStartPos"></param>
        /// <param name="rayLookAt"></param>
        /// <param name="rayLength"></param>
        /// <param name="hitDistance"></param>
        /// <param name="canPassTerrian"></param>
        /// <param name="hit"></param>
        /// <returns>true=/</returns>
        public bool raycastHitGrid(Vector3 rayStartPos,Vector3 rayLookAt,double rayLength,double hitDistance,int canPassTerrian,ref Hit2D hit ) {
            CppRaycastHit cppHit = cppHitArr[0];
            bool collide = CMap.raycastHitGrid(this.pMap,packPos(rayStartPos,ref doubleArr1),packLookAt(rayLookAt,ref doubleArr2),packFloat(rayLength),packFloat(hitDistance),canPassTerrian,ref cppHit);
            if (collide) {
                hit.id = cppHit.id;
                hit.distance = unpackFloat(cppHit.distance);
                hit.point = unpackPos(cppHit.point);
                hit.normal = unpackPos(cppHit.normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="circleCenter"></param>
        /// <param name="circleRadius"></param>
        /// <param name="entityIds">id</param>
        /// <param name="entityCount"></param>
        /// <param name="hits"></param>
        /// <returns>true=</returns>
        public bool circleHitEntities(Vector3 circleCenter,double circleRadius,UInt64[] entityIds, int entityCount,ref Hit2D[] hits,ref int count) {
            int hitMaxLength = entityCount + 1;
            CppRaycastHit[] cppHits;
            if(hitMaxLength<= cppHitArr.Length){
                cppHits = cppHitArr;
            } else {
              cppHits = new CppRaycastHit[hitMaxLength];
                for (int i = 0; i < hitMaxLength; i++) {
                    cppHits[i].point = new double[3];
                    cppHits[i].normal = new double[3];
                }
            }
            bool collide = CMap.circleHitEntities(this.pMap,packPos(circleCenter,ref doubleArr1),packFloat(circleRadius),entityIds,entityCount,cppHits,ref hitMaxLength);
            count = Math.Min(count,hitMaxLength);
            for (int i = 0; i < count; i++) {
                hits[i].id = cppHits[i].id;
                hits[i].distance = unpackFloat(cppHits[i].distance);
                hits[i].point = unpackPos(cppHits[i].point);
                hits[i].normal = unpackPos(cppHits[i].normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sectorCenter"></param>
        /// <param name="sectorLookAt"></param>
        /// <param name="sectorRadius"></param>
        /// <param name="sectorAngle"></param>
        /// <param name="entityIds">id</param>
        /// <param name="entityCount"></param>
        /// <param name="hits"></param>
        /// <returns>true=</returns>
        public bool sectorHitEntities(Vector3 sectorCenter,Vector3 sectorLookAt,double sectorRadius,double sectorAngle,UInt64[] entityIds, int entityCount,ref Hit2D[] hits,ref int count) {
            int hitMaxLength = entityCount + 1;
            CppRaycastHit[] cppHits;
            if(hitMaxLength<= cppHitArr.Length){
                cppHits = cppHitArr;
            } else {
              cppHits = new CppRaycastHit[hitMaxLength];
                for (int i = 0; i < hitMaxLength; i++) {
                    cppHits[i].point = new double[3];
                    cppHits[i].normal = new double[3];
                }
            }
            bool collide = CMap.sectorHitEntities(this.pMap,packPos(sectorCenter,ref doubleArr1),packLookAt(sectorLookAt,ref doubleArr2),packFloat(sectorRadius),sectorAngle,entityIds,entityCount,cppHits,ref hitMaxLength);
            count = Math.Min(count,hitMaxLength);
            for (int i = 0; i < count; i++) {
                hits[i].id = cppHits[i].id;
                hits[i].distance = unpackFloat(cppHits[i].distance);
                hits[i].point = unpackPos(cppHits[i].point);
                hits[i].normal = unpackPos(cppHits[i].normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rectCenter"></param>
        /// <param name="rectLookAt"></param>
        /// <param name="rectLength"></param>
        /// <param name="rectWidth"></param>
        /// <param name="entityIds">id</param>
        /// <param name="entityCount"></param>
        /// <param name="hits"></param>
        /// <returns>true=</returns>
        public bool rectangleHitEntities(Vector3 rectCenter,Vector3 rectLookAt,double rectLength,double rectWidth,UInt64[] entityIds, int entityCount,ref Hit2D[] hits,ref int count) {
            int hitMaxLength = entityCount + 1;
            CppRaycastHit[] cppHits;
            if(hitMaxLength<= cppHitArr.Length){
                cppHits = cppHitArr;
            } else {
              cppHits = new CppRaycastHit[hitMaxLength];
                for (int i = 0; i < hitMaxLength; i++) {
                    cppHits[i].point = new double[3];
                    cppHits[i].normal = new double[3];
                }
            }
            bool collide = CMap.rectangleHitEntities(this.pMap,packPos(rectCenter,ref doubleArr1),packLookAt(rectLookAt,ref doubleArr2),packFloat(rectLength),packFloat(rectWidth),entityIds,entityCount,cppHits,ref hitMaxLength);
            count = Math.Min(count,hitMaxLength);
            for (int i = 0; i < count; i++) {
                hits[i].id = cppHits[i].id;
                hits[i].distance = unpackFloat(cppHits[i].distance);
                hits[i].point = unpackPos(cppHits[i].point);
                hits[i].normal = unpackPos(cppHits[i].normal);
            }
            return collide;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rayStartPos"></param>
        /// <param name="rayStopPos"></param>
        /// <param name="hitDistance"></param>
        /// <param name="reflectCount"></param>
        /// <param name="canPassTerrian"></param>
        /// <param name="entityTagMask"></param>
        /// <param name="hits"></param>
        public void raycastReflectPath(Vector3 rayStartPos,Vector3 rayStopPos,double hitDistance,int reflectCount,int canPassTerrian,int entityTagMask,ref Hit2D[] hits,ref int count) {
            int hitMaxLength = reflectCount + 1;
            CppRaycastHit[] cppHits;
            if(hitMaxLength<= cppHitArr.Length){
                cppHits = cppHitArr;
            } else {
              cppHits = new CppRaycastHit[hitMaxLength];
                for (int i = 0; i < hitMaxLength; i++) {
                    cppHits[i].point = new double[3];
                    cppHits[i].normal = new double[3];
                }
            }
            CMap.raycastReflectPath(this.pMap,packPos(rayStartPos,ref doubleArr1),packPos(rayStopPos,ref doubleArr2),packFloat(hitDistance),reflectCount,canPassTerrian,entityTagMask,cppHits,ref hitMaxLength);
            count = Math.Min(count,hitMaxLength);
            for (int i = 0; i < count; i++) {
                hits[i].id = cppHits[i].id;
                hits[i].distance = unpackFloat(cppHits[i].distance);
                hits[i].point = unpackPos(cppHits[i].point);
                hits[i].normal = unpackPos(cppHits[i].normal);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rayStartPos"></param>
        /// <param name="rayLookAt"></param>
        /// <param name="rayLength"></param>
        /// <param name="hitDistance"></param>
        /// <param name="reflectCount"></param>
        /// <param name="canPassTerrian"></param>
        /// <param name="entityTagMask"></param>
        /// <param name="path"></param>
        public void getReflectPath(Vector3 rayStartPos,Vector3 rayLookAt,double rayLength,double hitDistance,int reflectCount,int canPassTerrian,int entityTagMask,out Vector3[] path) {
            Vector3 rayStopPos = rayStartPos + rayLookAt * (float)rayLength;
            Hit2D []hits = new Hit2D[reflectCount+1];
            int count = reflectCount+1;
            this.raycastReflectPath(rayStartPos,rayStopPos,packFloat(hitDistance),reflectCount,canPassTerrian,entityTagMask,ref hits,ref count);
            path = new Vector3[count];
            for (int i=0; i < count; i++) {
                path[i] = hits[i].point;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dt">()</param>
        public void update(double dt) {
            CMap.update(this.pMap,dt);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="moveToPos"></param>
        public void moveTo(UInt64 id,Vector3 moveToPos) {
            CMap.moveTo(this.pMap,id,packPos(moveToPos,ref doubleArr1));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="path"></param>
        public void pathMove(UInt64 id,Vector3[] path) {
            int pathLength = path.Length;
            double[,] posList = new double[pathLength,3];
            for(int i=0;i<pathLength;i++){
                packPos(path[i],ref doubleArr8);
                posList[i,0] = doubleArr8[0];
                posList[i,1] = doubleArr8[1];
                posList[i,2] = doubleArr8[2];
            }
            CMap.pathMove(this.pMap,id,posList,pathLength);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="moveToPos">(,sumMoveTime>0)</param>
        /// <param name="sumMoveTime">(,+,)</param>
        /// <param name="parabolaHeight"></param>
        /// <param name="parabolaTopHeight"></param>
        public void parabolaMoveTo(UInt64 id,Vector3 moveToPos,double sumMoveTime,double parabolaHeight,double parabolaTopHeight) {
            CMap.parabolaMoveTo(this.pMap,id,packPos(moveToPos,ref doubleArr1),sumMoveTime,packFloat(parabolaHeight),packFloat(parabolaTopHeight));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="centerPos"></param>
        /// <param name="clockwise">true=,false=</param>
        /// <param name="circleT">()</param>
        /// <param name="sumMoveTime">()</param>
        public void circleMove(UInt64 id,Vector3 centerPos,bool clockwise,double circleT,double sumMoveTime) {
            CMap.circleMove(this.pMap,id,packPos(centerPos,ref doubleArr1),clockwise,circleT,sumMoveTime);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        public void continueMove(UInt64 id) {
            CMap.continueMove(this.pMap,id);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        public void stopMove(UInt64 id) {
            CMap.stopMove(this.pMap,id);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>h
        /// <param name="moveSpeed">(m/s)</param>
        public void setMoveSpeed(UInt64 id,double moveSpeed) {
            CMap.setMoveSpeed(this.pMap,id,moveSpeed);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="accelerateSpeed"></param>
        public void setAccelerateSpeed(UInt64 id,double accelerateSpeed) {
            CMap.setAccelerateSpeed(this.pMap,id,accelerateSpeed);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="traceTargetId">id</param>
        /// <param name="coordinateType">coordinateType (1=,2=)</param>
        /// <param name="offsetPos"></param>
        public void lineTrace(UInt64 id,UInt64 traceTargetId,int coordinateType,Vector3 offsetPos) {
            CMap.lineTrace(this.pMap,id,traceTargetId,coordinateType,packPos(offsetPos,ref doubleArr1));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="traceTargetId">id</param>
        /// <param name="clockwise">true=,false=</param>
        /// <param name="circleT">()</param>
        /// <param name="sumMoveTime">()</param>
        /// <param name="coordinateType">coordinateType (1=,2=)</param>
        /// <param name="offsetPos"></param>
        public void circleTrace(UInt64 id,UInt64 traceTargetId,bool clockwise,double circleT,double sumMoveTime,int coordinateType,Vector3 offsetPos) {
            CMap.circleTrace(this.pMap,id,traceTargetId,clockwise,circleT,sumMoveTime,coordinateType,packPos(offsetPos,ref doubleArr1));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id">id</param>
        public void stopTrace(UInt64 id) {
            CMap.stopTrace(this.pMap,id);
        }

        /// <summary>
        /// id
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="followerList">id</param>
        public void getFollowEntityList(UInt64 id,out UInt64[] followerList) {
            int length = uInt64Arr1.Length;
            UInt64[] list = uInt64Arr1;
            CMap.getFollowEntityList(this.pMap,id,list,ref length);
            followerList = new UInt64[length];
            for (int i=0; i<length; i++) {
                followerList[i] = list[i];
            }
        }

        /// <summary>
        /// id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>0=,>0=id</returns>
        public UInt64 getTraceTarget(UInt64 id) {
            return CMap.getTraceTarget(this.pMap,id);
        }
    }

    public class Prefab
    {
        public IntPtr pPrefab;
        public Grid[,] grids;
        public int maxX,maxY;
        public string name = "Prefab";         // 

        public Prefab() {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="maxX">x</param>
        /// <param name="maxY">y</param>
        public Prefab(int maxX, int maxY)
        {
            this.pPrefab = CMap.createPrefab(maxX, maxY);
            this.maxX = maxX;
            this.maxY = maxY;
            this.initGrids();
        }

        ~Prefab() {
            if (this.pPrefab == null)
            {
                return;
            }
            CMap.destroyPrefab(this.pPrefab);
        }

        private void initGrids() {
            int xLength = this.maxX;
            int yLength = this.maxY;
            this.grids = new Grid[xLength,yLength];
            for (int x = 0; x < this.maxX; x++) {
                for (int y = 0; y < this.maxY; y++) {
                    int i = x;
                    int j = y;
                    this.grids[i,j] = new Grid(x,y,0,Map.TERRIAN_NONE,0,0,0);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="input"></param>
        /// <param name="length"></param>
        /// <returns></returns>
        static public Prefab deserialize(byte []input,int length)
        {
            Prefab prefab = new Prefab();
            prefab.pPrefab = CMap.deserializePrefab(input, length);
            CMap.infoPrefab(prefab.pPrefab, out prefab.maxX, out prefab.maxY);
            prefab.initGrids();
            Grid grid;
            for (int x = 0; x < prefab.maxX; x++)
            {
                for (int y = 0; y < prefab.maxY; y++)
                {
                    prefab.getGrid(x,y);
                }
            }
            return prefab;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public byte[] serialize()
        {
            byte[] output = new byte[8 * 1024];
            int length = output.Length;
            CMap.serializePrefab(this.pPrefab,output, out length);
            byte[] result = new byte[length];
            for (int i = 0; i < length; i++)
            {
                result[i] = output[i];
            }
            return result;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="filename"></param>
        public void serializeToFile(string filename)
        {
            byte[] buffer = this.serialize();
            FileStream fs = new FileStream(filename, FileMode.OpenOrCreate, FileAccess.Write);
            fs.Write(buffer,0,buffer.Length);
            fs.Close();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static Prefab deserializeFromFile(string filename)
        {
            FileStream fs = new FileStream(filename, FileMode.Open, FileAccess.Read);
            int length = (int)fs.Length;
            byte[] buffer = new byte[length];
            fs.Read(buffer, 0, length);
            fs.Close();
            Prefab prefab = Prefab.deserialize(buffer, length);
            prefab.name = filename;
            return prefab;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="gridX">X</param>
        /// <param name="gridY">Y</param>
        /// <param name="height">,!!!</param>
        /// <param name="terrian">,16</param>
        /// <param name="type"></param>
        /// <returns>true=,false=,</returns>
        public bool setGrid(int gridX,int gridY,double height,int terrian,int type=0)
        {
            Grid grid = this.getGrid(gridX,gridY);
            if (grid == null) {
                return false;
            }
            bool ok = CMap.setGridToPrefab(this.pPrefab, gridX, gridY,Map.packFloat(height), terrian, type);
            //Debug.Log(string.Format("op=setGrid,gridX={0},gridY={1},height={2},terrian={3},type={4},ok={5}",gridX,gridY,height,terrian,type,ok));
            if (!ok)
            {
                return false;
            }
            grid.height = height;
            grid.terrian = terrian;
            grid.type = type;
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="gridX">x</param>
        /// <param name="gridY">y</param>
        /// <returns>null=,=</returns>
        public Grid getGrid(int gridX,int gridY)
        {
            if (!this.isValidGrid(gridX,gridY)) {
                return null;
            }
            Grid grid = this.grids[gridX,gridY];
            // ,barrierTerrian
            double height;
            int terrian,type;
            this._getGrid(gridX,gridY,out height,out terrian,out type);
            grid.height = height;
            grid.terrian = terrian;
            grid.type = type;
            return grid;
        }

        private bool _getGrid(int gridX,int gridY,out double height,out int terrian,out int type)
        {
            bool ok = CMap.getGridFromPrefab(this.pPrefab, gridX, gridY, out height, out terrian, out type);
            if (!ok)
            {
                return false;
            }
            height = Map.unpackFloat(height);
            return true;
        }

        public bool isValidGrid(int gridX,int gridY)
        {
            if (!(0 <= gridX && gridX < this.maxX))
            {
                return false;
            }
            if (!(0 <= gridY && gridY < this.maxY))
            {
                return false;
            }
            return true;
        }
    }
}