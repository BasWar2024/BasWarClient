@echo off
echo =======================================================
echo Unity
echo       C#BuildFromCLI.cs
echo.
echo 1
echo        UNITY_PATHunity.exe
echo        PROJECT_PATH
echo        LOG_PATH
echo 2Unity
echo =======================================================

set UNITY_PATH="D:\Program Files (x86)\Unity 2017.4.3f1\Editor\Unity.exe"
set PROJECT_PATH="D:\work\xLua_forsakenyang"
set LOG_PATH="D:\work\xLua_forsakenyang\output\log.txt"

echo start...

rem 
for %%a in (%LOG_PATH%) do (
    set log_root=%%~dpa
)    
if not exist %log_root% mkdir %log_root%

%UNITY_PATH% -batchmode -quit -projectPath %PROJECT_PATH% -logFile %LOG_PATH% -executeMethod XLuaTest.BuildFromCLI.Build

echo done.
pause