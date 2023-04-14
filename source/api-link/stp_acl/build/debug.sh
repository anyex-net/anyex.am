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
    echo "generate stpServer-md"
    cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DTRADE_NAME=OFF -DMD_NAME=OFF && make
    echo "rename it stpServer-md"
    cp ../../bin/stpServer ../../bin/stpServer-md
    echo "generate stpServer-trade"
    cp ../../bin/stpServer ../../bin/stpServer-trade
    ;;
  *)
    echo "generate stpServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DTRADE_NAME=OFF -DMD_NAME=OFF && make
    ;;
esac

