#!/bin/sh

# echo makepatch_android
if [ "$UNITY_ENGINE" = "" ]; then
    UNITY_ENGINE="D:/Unity/Editor/Unity.exe"
fi

echo $UNITY_ENGINE

#
UNITY_BUILD_METHOD="ProjectBuildPipeLine.BuildPatchAndroid"
UNITY_PROJECT_OUTPUT_PATH="../clientpack/"
logFile=$UNITY_PROJECT_OUTPUT_PATH/output.log
VERSION="1.0.0"
BUILDTARGET="Android"

echo "============== unity build patch Begin =================="
$UNITY_ENGINE -quit -batchmode -executeMethod $UNITY_BUILD_METHOD -version:$VERSION -buildtarget:$BUILDTARGET -projectPath "" -logFile $logFile -quit
echo "============== unity build patch finish =================="