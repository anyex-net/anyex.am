#clean
rm -rf conf
rm -rf lib
rm -rf /usr/local/stp

#cp
mkdir conf
cp -r ../conf/* conf/

mkdir lib
cp -r ../lib/* lib/

mkdir -p /usr/local/stp/lib
cp -r lib/* /usr/local/stp/lib/

#compile
cd ../build
#debug
sh clean.sh
sh debug.sh

#release
#sh clean.sh
#sh release.sh