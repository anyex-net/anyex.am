#!/bin/bash

# 获取当前目录 .../debug.sh
cur_path=$(pwd);
echo ${cur_path}
# 获取当前执行的脚本文件的父目录
path=$(cd $(dirname $0); pwd)
echo ${path}

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
    echo "generate esunnyServer-quote"
    cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DQUOTE_NAME=OFF -DTRADE_NAME=OFF && make
    cp ../../bin/esunnyServer ../../bin/esunnyServer-quote
    echo "generate esunnyServer-trade"
    cp ../../bin/esunnyServer ../../bin/esunnyServer-trade
    ;;
  *)
    echo "generate esunnyServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DQUOTE_NAME=OFF -DTRADE_NAME=OFF && make
    ;;
esac

