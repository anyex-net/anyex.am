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
  ctp_*)
    rm -rf ctpServer-*
    echo "generate ctpServer-md and ctpServer-trade"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=OFF -DOPENCTP=OFF && make
    echo "rename it ctpServer-md"
    cp ../../bin/ctpServer ../../bin/ctpServer-md
    echo "rename it ctpServer-trade"
    cp ../../bin/ctpServer ../../bin/ctpServer-trade
    ;;
  stp_*)
    rm -rf stpServer-*
    echo "generate stpServer-md and ctp2StpServer-trade"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=ON -DOPENCTP=OFF && make
    echo "rename it ctp2StpServer-md"
    cp ../../bin/stpServer ../../bin/sctp2StpServer-md
    echo "rename it ctp2StpServer-trade"
    cp ../../bin/stpServer ../../bin/ctp2StpServer-trade
    ;;
  openctp_*)
    rm -rf openCtpServer-*
    echo "generate openCtpServer-md and openCtpServer-trade"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=OFF -DOPENCTP=ON && make
    echo "rename it openCtpServer-md"
    cp ../../bin/stpServer ../../bin/ctp2StpServer-md
    echo "rename it openCtpServer-trade"
    cp ../../bin/stpServer ../../bin/ctp2StpServer-trade
    ;;
  stp)
    echo "generate ctp2StpServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=ON -DOPENCTP=OFF && make
    ;;
  ctp)
    echo "generate ctpServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=OFF -DOPENCTP=OFF && make
    ;;
  openctp)
    echo "generate openCtpServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=OFF -DOPENCTP=ON && make
    ;;
  *)
    echo "generate ctpServer and stpServer"
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=OFF -DOPENCTP=OFF && make
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=ON -DOPENCTP=OFF && make
    cmake ../.. -DCMAKE_BUILD_TYPE=Release -DSTP=OFF -DOPENCTP=ON && make
    ;;
esac
