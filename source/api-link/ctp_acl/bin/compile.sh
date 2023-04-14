#clean
rm -rf conf
rm -rf lib
#rm -rf ctpServer*
#rm -rf stpServer*
rm -rf /usr/local/ctp
#rm -rf ../build

#cp
mkdir conf
cp -r ../conf/* conf/

mkdir lib
cp -r ../lib/* lib/

mkdir /usr/local/ctp
mkdir /usr/local/ctp/lib
cp -r lib/* /usr/local/ctp/lib/

#compile
#mkdir ../build
cd ../build
#debug
sh clean.sh
sh debug.sh
#release
#sh clean.sh
#sh release.sh