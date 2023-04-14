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
    echo "generate esunnyServer-quote"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DQUOTE_NAME=OFF -DTRADE_NAME=OFF && make
    cp ../../bin/esunnyServer ../../bin/esunnyServer-quote
    echo "generate esunnyServer-trade"
    cp ../../bin/esunnyServer ../../bin/esunnyServer-trade
    ;;
  *)
    echo "generate esunnyServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DQUOTE_NAME=OFF -DTRADE_NAME=OFF && make
    ;;
esac
