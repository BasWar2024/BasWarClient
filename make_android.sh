#!/bin/sh

# android 

#unity
#unityLibrary/libs/unity-classes.jar
#unityLibrary/src/main/assets
#unityLibrary/src/main/jniLibs


# android apk 
#/launcher/build/outputs/apk
#debug
#/launcher/build/outputs/apk/debug
#release
#/launcher/build/outputs/apk/release
#aab release
#/launcher/build/outputs/bundle/release
#aab debug
#/launcher/build/outputs/bundle/debug

# android   androidstudio  unityandroid
# macox ./gradlew XXX
# window gradlew.bat XXX

# debug  release 
#/gradlew.bat assemble
# release
#/gradlew.bat assembleRelease
# bundle aab
#/gradlew.bat bundle
#/gradlew.bat bundleRelease

TEMP_PATH="./project/project.android.temp"
PROJECT_PATH="./project/project.android"

increase=$1
packType=$2

#copy
echo "===============  ================="
if [ -d "$PROJECT_PATH/unityLibrary/src/main/assets/aa" ]; then
    rm -rf $PROJECT_PATH/unityLibrary/src/main/assets/aa
fi
if [ -d "$PROJECT_PATH/unityLibrary/src/main/assets/bin" ]; then
    rm -rf $PROJECT_PATH/unityLibrary/src/main/assets/bin
fi
if [ -d "$PROJECT_PATH/unityLibrary/src/main/jniLibs" ]; then
    rm -rf $PROJECT_PATH/unityLibrary/src/main/jniLibs
fi
cp -rf $TEMP_PATH/unityLibrary/src/main/assets/aa $PROJECT_PATH/unityLibrary/src/main/assets/
cp -rf $TEMP_PATH/unityLibrary/src/main/assets/bin $PROJECT_PATH/unityLibrary/src/main/assets/
cp -rf $TEMP_PATH/unityLibrary/src/main/jniLibs $PROJECT_PATH/unityLibrary/src/main/
echo "===============   ================="

if [ $increase ] && [ $increase -eq 1 ]; then
    #
    GRADLE_PATH=$PROJECT_PATH/launcher/build.gradle

    VERSION=`grep "versionCode" $GRADLE_PATH | awk '{print $2}' `
    BUILD_NUMBER_1=`grep "versionName" $GRADLE_PATH | cut -d \' -f 2  | cut -d \. -f 1`
    BUILD_NUMBER_2=`grep "versionName" $GRADLE_PATH | cut -d \' -f 2  | cut -d \. -f 2`
    BUILD_NUMBER_3=`grep "versionName" $GRADLE_PATH | cut -d \' -f 2  | cut -d \. -f 3`

    # 
    NEW_VERSION=`expr $VERSION + 1 `
    NEW_BUILD_NUMBER=`expr $BUILD_NUMBER_3 + 1 `
    NEW_BUILD_NUMBER=$BUILD_NUMBER_1.$BUILD_NUMBER_2.$NEW_BUILD_NUMBER

    sed -i "s/versionCode [0-9]*/versionCode $NEW_VERSION/g" $GRADLE_PATH
    sed -i "s/versionName '[0-9]*\.[0-9]*\.[0-9]*'/versionName '$NEW_BUILD_NUMBER'/g" $GRADLE_PATH
    
    echo "versionCode  $NEW_VERSION"
    echo "versionName  '$NEW_BUILD_NUMBER'"
    echo "=========  ============"
fi

#
cd $PROJECT_PATH
sh ./gradlew $packType

