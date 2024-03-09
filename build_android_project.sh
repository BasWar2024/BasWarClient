#!/bin/sh

#
if [ "$UNITY_ENGINE" = "" ]; then
    UNITY_ENGINE="D:/Unity/Editor/Unity.exe"
fi

echo $UNITY_ENGINE

#
UNITY_BUILD_METHOD="ProjectBuildPipeLine.BuildAllAndroid"

UNITY_PROJECT_OUTPUT_PATH="project/project.android.temp"
logFile=$UNITY_PROJECT_OUTPUT_PATH/output.log

echo "============== unity build Begin =================="
# $UNITY_ENGINE -projectPath "" -executeMethod $UNITY_BUILD_METHOD project-"../clientpack/beta" -logFile $logFile -quit
$UNITY_ENGINE -quit -batchmode -executeMethod $UNITY_BUILD_METHOD -outputpath:$UNITY_PROJECT_OUTPUT_PATH -projectPath "" -logFile $logFile -quit
echo "============== unity build Finish =================="
