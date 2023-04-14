if [ ! -f /usr/local/ctp ];then
  #clear
  rm -rf /usr/local/ctp
  #create
  mkdir /usr/local/ctp
  mkdir /usr/local/ctp/lib
  #cp
  cp -r lib/* /usr/local/ctp/lib/
fi
#start server
#ctp
#chmod +x ctpServer-md
#chmod +x ctpServer-trade
#nohup ./ctpServer-md >/dev/null 2>stderr.log &
#nohup ./ctpServer-trade >/dev/null 2>stderr.log &
#ctp2Stp
#chmod +x stpServer-md
#chmod +x stpServer-trade
#nohup ./ctpServer-md >/dev/null 2>stderr.log &
#nohup ./ctpServer-trade >/dev/null 2>stderr.log &
#openctp
#chmod +x openCtpServer-md
chmod +x openCtpServer-trade
#nohup ./openCtpServer-md >/dev/null 2>stderr.log &
nohup ./openCtpServer-trade >/dev/null 2>stderr.log &
#./ctpServer

