#!/bin/bash

echo  "删除所有编译文件"
rm -rf debug release
echo "删除所有可执行文件"
cd ../bin
rm -rf debug release
echo "清理完成"