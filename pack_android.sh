#!/bin/sh

# usage="Usage:\n
#     sh pack_android.sh <dstpath> <branch> <platform> <mode> <add_version>\n
#     branch: master/alpha/beta/release\n
#     platform: local\n
#     mode: debug/release/aab\n
#     e.g:\n
#         sh pack_android.sh ~/apps/g3/clientpack master local debug 0     <=> master,\n
#         sh pack_android.sh ~/apps/g3/clientpack beta local debug 1       <=> beta,1\n"

# if [ $# -lt 5 ]; then
#     echo -e $usage
#     exit 0;
# fi

# cwd=`pwd`
# dstpath=`readlink -f $1`
# branch=$2
# platform=$3
# mode=$4
# add_version=$5
# os="android"
# time=`date +"%Y%m%d%H%M%S"`
# version_filename=$path/version.txt
# version="0.0.0"
# if [ -f $version_filename ]; then
#     version=`tail -1 $version_filename`
#     if [ $add_version != 0 ]; then
#         v1=`echo $version | awk -F. '{print $1}'`
#         v2=`echo $version | awk -F. '{print $2}'`
#         v3=`echo $version | awk -F. '{print $3}'`
#         v2=$((v2+add_version))
#         version=$v1.$v2.0
#         echo $version > $version_filename
#     fi
# fi

# packname=$dstpath/$os.$branch.$platform.$mode.$version.$time.bin.apk
# project_path=$cwd/project.android
# project_custom_config_path=$cwd/project.android.custom_config
# sh build_android_project.sh $project_path
# if ! [ -d $project_path ]; then
#     echo "project not exists!"
#     exit 0;
# fi
# if [ -d $project_custom_config_path ]; then
#     cp -r $project_custom_config_path/* $project_path
# fi
# sh make_android.sh $packname

#  

sh build_android_project.sh
sh make_android.sh 0 assembleDebug