#clean
rm -rf conf
rm -rf lib
rm -rf esunnyServer*
rm -rf /usr/local/esunny

#cp
mkdir conf
cp -r ../conf/* conf/

mkdir lib
cp -r ../lib/* lib/

mkdir /usr/local/esunny
mkdir /usr/local/esunny/lib
cp -r lib/* /usr/local/esunny/lib/

#compile
#mkdir ../build
#cd ../build
#cmake ..
#make

#debug
cd ../build
sh clean.sh
sh debug.sh

#release
sh clean.sh
sh release.sh