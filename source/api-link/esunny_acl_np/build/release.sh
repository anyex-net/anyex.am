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
    echo "generate esunnyServer_np_quote"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DTRADE_NAME=OFF -DQUOTE_NAME=OFF && make
    cp ../../bin/esunnyServer_np ../../bin/esunnyServer_np_quote
    echo "generate esunnyServer_np_trade"
    cp ../../bin/esunnyServer_np ../../bin/esunnyServer_np_trade
    ;;
  *)
    echo "generate esunnyServer_np"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DTRADE_NAME=OFF -DQUOTE_NAME=OFF && make
    ;;
esac
