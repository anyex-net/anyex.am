#esunnyServer ������װ
����ϵͳ: Centos7  
IDE: CLion-2020.1.3

Ϊ�˷��㣬һ�²���������rootȨ���½���
##��װϵͳ����
###��װ��������
��װgcc  
    yum install -y gcc gcc-c++  

����:
Cannot load supported formats: Cannot run program "svn" (in directory "/root/Downloads/clion2020.3.4"): CreateProcess error=2, ϵͳ�Ҳ���ָ�����ļ�
ִ�м���:
yum install subversion

����:
Server SSL certificate verification failed: certificate issued for a different hostname, issuer is not trusted
ִ�м���:
svn ls https://127.0.0.1/svn/XXXXXXXX

###��װcmake
��װssl������  
�鿴ssl���������Ϊ����������������ָ��  
    yum list installed | grep ssl

    yum install openssl.x86_64                                            
    yum install openssl-devel.x86_64 һ��ȱ�����  
    yum install openssl-libs.x86_64
    wget https://cmake.org/files/v3.16/cmake-3.16.6.tar.gz
    tar -zxvf cmake-3.16.6.tar.gz  
    cd cmake-3.16.6  
    ./configure --prefix=/usr/local/cmake
    make && make install
    ln -s /usr/local/cmake/bin/cmake /usr/bin/cmake
    cmake -version
