#!/bin/sh

usage="Usage:\n
    sh packpatch_android.sh <dstpath> <branch> <add_version>\n
    branch: master/alpha/beta/release\n
    e.g:\n
        sh packpatch_android.sh ~/apps/g3/clientpack master 0     <=> master,\n
        sh packpatch_android.sh ~/apps/g3/clientpack beta 1       <=> beta,1\n"

if [ $# -lt 3 ]; then
    echo -e $usage
    exit 0;
fi

cwd=`pwd`
dstpath=`readlink -f $1`
branch=$2
add_version=$3
os="android"
time=`date +"%Y%m%d%H%M%S"`
version_filename=$path/version.txt
version="0.0.0"
if [ -f $version_filename ]; then
    version=`tail -1 $version_filename`
    if [ $add_version != 0 ]; then
        v1=`echo $version | awk -F. '{print $1}'`
        v2=`echo $version | awk -F. '{print $2}'`
        v3=`echo $version | awk -F. '{print $3}'`
        v2=$((v2+add_version))
        version=$v1.$v2.0
        echo $version > $version_filename
    fi
fi

packname=$dstpath/$os.$branch.$version.$time.patch
pack_state_file=$cwd/Assets/AddressableAssetsData/Android/addressables_content_state.bin
sh makepatch_android.sh $pack_state_file $packname