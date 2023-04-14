#clean
rm -rf conf
rm -rf lib
rm -rf esunnyServer_np
rm -rf /usr/local/esunny_np

#cp
mkdir conf
cp -r ../conf/* conf/

mkdir lib
cp -r ../lib/* lib/

mkdir -p /usr/local/esunny_np/lib
cp -r lib/* /usr/local/esunny_np/lib/

#compile
cd ../build
sh clean.sh


#debug
sh debug.sh

#release
# sh release.sh
