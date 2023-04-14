#!/bin/bash
quote_esunnyServer="#server type(quoteServer tradeServer)
server_type = quoteServer
#server mode(singleAccount multiAccount)
server_mode = multiAccount
single_account = Q578432149

#日志是否输出至控制台(true false)
stdout_open =

#调试日志，格式：tag:level; tag:level, 如：all:1; 103:1
#101:1 打印主进程日志
#102:2 打印http传入参数值
#103:2 打印异步返回数据
server_debug = 103:2

#quote list, 如：
quote_list =

#redis config
redis_addr = 127.0.0.1:6379
redis_password = XpVFvpTuo4T0q8P8JQWnRdTz2EymvnU08WAWvwbw

#kafka config
kafka_broker = 192.168.31.46:9092
#kafka enable(true false)
kafka_enable = true

#mysql config
mysql_addr = 192.168.31.42:3306
mysql_dbname = amwpfutures
mysql_username = root
mysql_password = Bcbc963852"

quote_logrotate="

"

quote_run="#clean
rm -rf /usr/local/esunny_np
#rm -rf logs

#create
mkdir -p /usr/local/esunny_np/lib
#mkdir logs
mkdir -p logs

#cp
cp -r lib/* /usr/local/esunny_np/lib/

#start server
chmod +x ./release/esunnyServer_np_quote
./esunnyServer_np
#nohup ./release/esunnyServer_np_quote &>/dev/null &"

trade_esunnyServer="#server type(quoteServer tradeServer)
server_type = tradeServer
#server mode(singleAccount multiAccount)
server_mode = multiAccount
single_account = Q578432149

#日志是否输出至控制台(true false)
stdout_open =

#调试日志，格式：tag:level; tag:level, 如：all:1; 103:1
#101:1 打印主进程日志
#102:2 打印http传入参数值
#103:2 打印异步返回数据
server_debug = 103:2

#redis config
redis_addr = 127.0.0.1:6379
redis_password = XpVFvpTuo4T0q8P8JQWnRdTz2EymvnU08WAWvwbw

#kafka config
kafka_broker = 192.168.31.46:9092
#kafka enable(true false)
kafka_enable = true

#mysql config
mysql_addr = 192.168.31.42:3306
mysql_dbname = amwpfutures
mysql_username = root
mysql_password = Bcbc963852"

trade_run="#clean
rm -rf /usr/local/esunny_np
#rm -rf logs

#create
mkdir -p /usr/local/esunny_np/lib
#mkdir logs
mkdir -p logs

#cp
cp -r lib/* /usr/local/esunny_np/lib/

#start server
chmod +x ./release/esunnyServer_np_trade
./esunnyServer_np
#nohup ./release/esunnyServer_np_trade &>/dev/null &"

cd ../bin
if [ $1 = "quote" ]
then
  echo "行情"
  echo "${quote_esunnyServer}" > conf/esunnyServer.conf
  echo "${quote_run}" > run.sh
elif [ $1 = "trade" ]; then
  echo "交易"
  echo "${trade_esunnyServer}" > conf/esunnyServer.conf
  echo "${trade_run}" > run.sh
fi