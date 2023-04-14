#cp
rm -rf /usr/local/esunny

mkdir /usr/local/esunny
mkdir /usr/local/esunny/lib

cp -r lib/* /usr/local/esunny/lib/

#start server
chmod +x esunnyServer
./esunnyServer
