#!/bin/bash

# 获取当前目录
cur_path=$(pwd);
echo ${cur_path}
# 获取当前执行的脚本文件的父目录
#path=$(cd $(dirname $0); pwd)
#echo ${path}

if [ -e ${cur_path}/debug ]; then
  echo "cmake & make"
  cd debug
else
  echo "build debug"
  mkdir debug
  cd debug
fi

case $1 in
  _*)
    echo "generate esunnyServer_np_quote"
    cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DTRADE_NAME=OFF -DQUOTE_NAME=OFF && make
    cp ../../bin/esunnyServer_np ../../bin/esunnyServer_np_quote
    echo "generate esunnyServer_np_trade"
    cp ../../bin/esunnyServer_np ../../bin/esunnyServer_np_trade
    ;;
  *)
    echo "generate esunnyServer_np"
    cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DTRADE_NAME=OFF -DQUOTE_NAME=OFF && make
    ;;
esac

