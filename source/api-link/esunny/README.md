#esunnyServer 环境安装
操作系统: Centos7  
IDE: CLion-2020.1.3

为了方便，一下操作都是在root权限下进行
##安装系统依赖
###安装基本工具
安装gcc  
    yum install -y gcc gcc-c++  

错误:
Cannot load supported formats: Cannot run program "svn" (in directory "/root/Downloads/clion2020.3.4"): CreateProcess error=2, 系统找不到指定的文件
执行即可:
yum install subversion

错误:
Server SSL certificate verification failed: certificate issued for a different hostname, issuer is not trusted
执行即可:
svn ls https://127.0.0.1/svn/XXXXXXXX

###安装cmake
安装ssl依赖包  
查看ssl依赖包如果为空则运行下面三个指令  
    yum list installed | grep ssl

    yum install openssl.x86_64                                            
    yum install openssl-devel.x86_64 一般缺少这个  
    yum install openssl-libs.x86_64
    wget https://cmake.org/files/v3.16/cmake-3.16.6.tar.gz
    tar -zxvf cmake-3.16.6.tar.gz  
    cd cmake-3.16.6  
    ./configure --prefix=/usr/local/cmake
    make && make install
    ln -s /usr/local/cmake/bin/cmake /usr/bin/cmake
    cmake -version
