#clean
rm -rf config
rm -rf lib
rm -rf esunnyServer
rm -rf /usr/local/esunny
rm -rf ../build

#cp
mkdir config
cp -r ../config/* config/

mkdir lib
cp -r ../lib/* lib/

mkdir /usr/local/esunny
mkdir /usr/local/esunny/lib
cp -r lib/* /usr/local/esunny/lib/

#compile
mkdir ../build
cd ../build
cmake ..
make