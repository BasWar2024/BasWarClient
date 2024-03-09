using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace MapLib {

    [StructLayout(LayoutKind.Sequential)]
    public struct CppRaycastHit {
            [MarshalAs(UnmanagedType.U8)]
            public UInt64 id;
            [MarshalAs(UnmanagedType.R8)]
            public double distance;
            [MarshalAs(UnmanagedType.ByValArray,SizeConst=3)]
            public double[] point;
            [MarshalAs(UnmanagedType.ByValArray,SizeConst=3)]
            public double[] normal;
    }

    public delegate void onEnterAOICallback(IntPtr ud, UInt64 id,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids,int length);
    public delegate void onLeaveAOICallback(IntPtr ud, UInt64 id,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids,int length);
    public delegate bool entityFilterCallback(IntPtr ud,UInt64 id);

    public class CMap {
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern IntPtr createMap(int minX,int minY,int maxX,int maxY, double gridSize,int backgroundType,int towerSize);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void destroyMap(IntPtr pMap);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void serialize(IntPtr pMap, [MarshalAs(UnmanagedType.LPArray)] byte[] output, out int length);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern IntPtr deserialize([MarshalAs(UnmanagedType.LPArray)] byte[] input, int length,int towerSize);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void info(IntPtr pMap, out int minX,out int minY,out int maxX,out int maxY,out double gridSize,out int backgroundType);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void registerOnEnterAOI(IntPtr pMap, onEnterAOICallback func);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void registerOnLeaveAOI(IntPtr pMap, onLeaveAOICallback func);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        // [MarshalAs(UnmanagedType.LPArray)]!
        public static extern void allEntityId(IntPtr pMap, [MarshalAs(UnmanagedType.LPArray)] UInt64[] ids, out int length);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool getEntity(IntPtr pMap,UInt64 id,out int tag,out int type,out int modeAOI,out double radiusAOI, [MarshalAs(UnmanagedType.LPArray)] double[] pos, out int terrian,out int affectGridTerrian,
                        [MarshalAs(UnmanagedType.LPArray)] double[] lookAt, out int shapeType,out double radius,out double length,out double width,out double angle,out int camp,out int groupId);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool addEntity(IntPtr pMap,UInt64 id,int tag,int type,int modeAOI,double radiusAOI, double[] pos, int terrian,int affectGridTerrian,
                        double[] lookAt,int shapeType,double radius,double length,double width,double angle,int camp,int groupId);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void delEntity(IntPtr pMap,UInt64 id);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void jumpTo(IntPtr pMap,UInt64 id, double[] pos);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void findEntitiesInCircle(IntPtr pMap, double[] pos, double radius,int entityTagMask,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids,out int length);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isValidPos(IntPtr pMap, double[] pos);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void entitySetModeAOI(IntPtr pMap,UInt64 id,int modeAOI);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void entitySetRadiusAOI(IntPtr pMap,UInt64 id,double radiusAOI);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool getGrid(IntPtr pMap,int gridX,int gridY,out double height,out int terrian,out int type,out int barrierTerrian,out int camp,out ulong eventId);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool setGrid(IntPtr pMap,int gridX,int gridY,double height,int terrian,int type,int camp,ulong eventId);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool findPath(IntPtr pMap, double[] startPos, double[] stopPos, [MarshalAs(UnmanagedType.LPArray)] double[] path , ref int length,int canPassTerrian,int inflectionLevel);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void toGridPos(IntPtr pMap,double x,double y,out int gridX,out int gridY);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void toPos(IntPtr pMap,int gridX,int gridY,out double x,out double y);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool isTerrian(IntPtr pMap,int gridX,int gridY,int terrian);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool canPass(IntPtr pMap,int fromGridX,int fromGridY,int toGridX,int toGridY,int canPassTerrian,int checkMask);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void dump(IntPtr pMap,string filename);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern UInt64 uuid(int nodeId);
// math2d

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void fReOpenStdOut(string filename);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern double getAngle(double[] from,double[] to);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern double getSignAngle(double[] from,double[] to);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern double distancePointToLine(double[] p0,double[] p1,double[] p2,double[] closestPoint);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void toNormalRectangle([MarshalAs(UnmanagedType.LPArray)] double[] rect,double[] center,double[] lookAt,double length,double width);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isPointInLine(double[] p0,double[] p1,double[] p2);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isPointInRectangle(double[] p0,double[] rectCenter,double[] rectLookAt,double rectLength,double rectWidth,out bool boundary);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isPointInCircle(double[] p0,double[] circleCenter,double circleRadius,out bool boundary);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isCollideLineWithLine(double[] p1,double[] p2,double[] p3,double[] p4,[MarshalAs(UnmanagedType.LPArray)] double[] intersection,[MarshalAs(UnmanagedType.LPArray)] double[] normal,out int intersectionCount);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isCollideLineWithRectangle(double[] p1,double[] p2,double[] rectCenter,double[] rectLookAt,double rectLength,double rectWidth,[MarshalAs(UnmanagedType.LPArray)] double[] intersection1,[MarshalAs(UnmanagedType.LPArray)] double[] intersection2,[MarshalAs(UnmanagedType.LPArray)] double[] normal,out int intersectionCount);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isCollideLineWithCircle(double[] p1,double[] p2,double[] circleCenter,double circleRadius,[MarshalAs(UnmanagedType.LPArray)] double[] intersection1,[MarshalAs(UnmanagedType.LPArray)] double[] intersection2,[MarshalAs(UnmanagedType.LPArray)] double[] normal,out int intersectionCount);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void getProjectPoint([MarshalAs(UnmanagedType.LPArray)] double[] result,double[] p0,double[] p1,double[] p2);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void getTangentPoint([MarshalAs(UnmanagedType.LPArray)] double[] result,double[] p0,double[] p1,double[] p2);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void getNormal([MarshalAs(UnmanagedType.LPArray)] double[] result,double[] v1,double[] v2);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void isBlockByRectangle(double[] rayStartPos,double[] rayLookAt,double rayLength,double[] rectCenter,double[] rectLookAt,double rectLength,double rectWidth,double[] intersection1,double[] normal,out bool moveToTangent);


#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool moveHit(IntPtr pMap,UInt64 entityId,double[] rayStartPos,double[] rayLookAt,double rayLength,double hitDistance,int canPassTerrian,ref CppRaycastHit hit,entityFilterCallback filter,IntPtr ud);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool moveHitTo(IntPtr pMap,UInt64 entityId,double[] rayStartPos,double[] rayStopPos,double hitDistance,int canPassTerrian,ref CppRaycastHit hit,entityFilterCallback filter,IntPtr ud);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool raycastHitBoundary(IntPtr pMap,double[] rayStartPos,double[] rayLookAt,double rayLength,double hitDistance,ref CppRaycastHit hit);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isCollideRectangleWithEntity(IntPtr pMap,double[] rectCenter,double[] rectLookAt,double rectLength,double rectWidth,UInt64 entityId, ref CppRaycastHit hit);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isCollideCircleWithEntity(IntPtr pMap,double[] circleCenter,double circleRadius,UInt64 entityId, ref CppRaycastHit hit);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isCollideSectorWithEntity(IntPtr pMap,double[] sectorCenter,double[] sectorLookAt,double sectorRadius,double sectorAngle,UInt64 entityId, ref CppRaycastHit hit);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool raycastHitEntities(IntPtr pMap,double[] rayStartPos,double[] rayLookAt,double rayLength,double hitDistance,UInt64[] entityIds,int entityCount,[In,Out] CppRaycastHit[] hits,ref int hitMaxLength);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern bool isPosInArea(IntPtr pMap,double[] pos,double[] targetPos,int gridRadius,bool excludeCorner);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void getEntitiesInArea(IntPtr pMap, double[] pos, int gridRadius,int entityTagMask,bool excludeCorner,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids,out int length);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void getEntitiesInGrid(IntPtr pMap, int gridX,int gridY,int entityTagMask,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids,out int length);


#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool canLineMove(IntPtr pMap, double[] startPos,double[] stopPos,int canPassTerrian);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool isCollideRayWithEntity(IntPtr pMap, double[] rayStartPos,double[] rayLookAt,double rayLength, UInt64 entityId,ref CppRaycastHit hit);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool raycastHitGrid(IntPtr pMap, double[] rayStartPos,double[] rayLookAt,double rayLength, double hitDistance,int canPassTerrian,ref CppRaycastHit hit);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool circleHitEntities(IntPtr pMap, double[] circleCenter,double circleRadius,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids, int entityCount,[In,Out] CppRaycastHit[] hits,ref int hitMaxLength);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool sectorHitEntities(IntPtr pMap, double[] sectorCenter, double[] sectorLookAt,double sectorRadius,double sectorAngle,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids, int entityCount,[In,Out] CppRaycastHit[] hits,ref int hitMaxLength);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool rectangleHitEntities(IntPtr pMap, double[] rectCenter, double[] rectLookAt,double rectLength,double rectWidth,[MarshalAs(UnmanagedType.LPArray)] UInt64[] ids, int entityCount,[In,Out] CppRaycastHit[] hits,ref int hitMaxLength);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void raycastReflectPath(IntPtr pMap, double[] rayStartPos, double[] rayStopPos,double hitDistance,int reflectCount,int canPassTerrian,int entityTagMask,[In,Out] CppRaycastHit[] hits,ref int hitMaxLength);

        // 
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void update(IntPtr pMap,double dt);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void moveTo(IntPtr pMap,UInt64 id,double[] moveToPos);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void pathMove(IntPtr pMap,UInt64 id,double[,] path,int pathLength);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void parabolaMoveTo(IntPtr pMap,UInt64 id,double[] moveToPos,double sumMoveTime,double parabolaHeight,double parabolaTopHeight);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern void circleMove(IntPtr pMap,UInt64 id,double[] centerPos,bool clockwise,double circleT,double sumMoveTime);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void continueMove(IntPtr pMap,UInt64 id);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void stopMove(IntPtr pMap,UInt64 id);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void setMoveSpeed(IntPtr pMap,UInt64 id,double moveSpeed);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void setAccelerateSpeed(IntPtr pMap,UInt64 id,double accelerateSpeed);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void lineTrace(IntPtr pMap,UInt64 id,UInt64 traceTargetId,int coordinateType,double[] offsetPos);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void circleTrace(IntPtr pMap,UInt64 id,UInt64 traceTargetId,bool clockwise,double circleT,double sumMoveTime,int coordinateType,double[] offsetPos);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void stopTrace(IntPtr pMap,UInt64 id);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void stopTrace(IntPtr pMap,UInt64 id,[MarshalAs(UnmanagedType.LPArray)] UInt64[] followerList, out int length);
 #if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern UInt64 getFollowEntityList(IntPtr pMap,UInt64 id,[MarshalAs(UnmanagedType.LPArray)] UInt64[] list, ref int length);

 #if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern UInt64 getTraceTarget(IntPtr pMap,UInt64 id);


// #
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern IntPtr createPrefab(int maxX,int maxY);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void destroyPrefab(IntPtr pPrebab);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void serializePrefab(IntPtr pPrefab, [MarshalAs(UnmanagedType.LPArray)] byte[] output, out int length);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern IntPtr deserializePrefab([MarshalAs(UnmanagedType.LPArray)] byte[] input, int length);

#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public static extern void infoPrefab(IntPtr pPrefab, out int maxX,out int maxY);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool getGridFromPrefab(IntPtr pPrefab,int gridX,int gridY,out double height,out int terrian,out int type);
#if UNITY_IPHONE
        [DllImport("__Internal")]
#else
        [DllImport("MapLib", CallingConvention = CallingConvention.Cdecl)]
#endif
        public  static extern bool setGridToPrefab(IntPtr pPrefab,int gridX,int gridY,double height,int terrian,int type);

// #END
    }
}
