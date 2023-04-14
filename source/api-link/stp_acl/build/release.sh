#!/bin/bash

# 获取当前目录
cur_path=$(pwd);

if [ -e ${cur_path}/release ]; then
  echo "cmake & make"
  cd release
else
  echo "mkdir release"
  mkdir release
  cd release
fi

case $1 in
   _*)
    echo "generate stpServer-md"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DTRADE_NAME=OFF -DMD_NAME=OFF && make
    echo "rename it stpServer-md"
    cp ../../bin/stpServer ../../bin/stpServer-md
    echo "generate stpServer-trade"
    cp ../../bin/stpServer ../../bin/stpServer-trade
    ;;
  *)
    echo "generate stpServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DTRADE_NAME=OFF -DMD_NAME=OFF && make
    ;;
esac
