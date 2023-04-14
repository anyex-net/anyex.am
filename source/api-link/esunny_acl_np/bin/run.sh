if [ ! -f /usr/local/stp ];then
  #clean
  rm -rf /usr/local/esunny_np
  #rm -rf logs
  #create
  mkdir -p /usr/local/esunny_np/lib
  #mkdir logs
  mkdir -p logs
  #cp
  cp -r lib/* /usr/local/esunny_np/lib/
fi
#start server
chmod +x ./release/esunnyServer_np_quote
./esunnyServer_np
#nohup ./release/esunnyServer_np_quote &>/dev/null &