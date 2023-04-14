if [ ! -f /usr/local/stp ];then
  echo "lib 不存在"
  #clear
  rm -rf /usr/local/stp
  #rm -rf logs
  mkdir /usr/local/stp
  mkdir /usr/local/stp/lib
  #cp
  cp -r lib/* /usr/local/stp/lib/
fi

#start server
#chmod +x stpServer_md
#chmod +x stpServer_trade

#nohup ./stpServer_md &>/dev/null &
#nohup ./stpServer_trade &>/dev/null &


