if [ ! -f /usr/local/stp ];then
  #clean
  rm -rf /usr/local/esunny
  #create
  mkdir /usr/local/esunny
  mkdir /usr/local/esunny/lib
  #cp
  cp -r lib/* /usr/local/esunny/lib/
fi

#start server
#chmod +x esunnyServer-quote
chmod +x esunnyServer-trade
#./esunnyServer
#nohup ./esunnyServer-quote &>/dev/null &
nohup ./esunnyServer-trade &>/dev/null &
