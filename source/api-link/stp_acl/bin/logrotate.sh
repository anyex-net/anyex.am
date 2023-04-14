#以下配置皆需 root 权限
#写入配置文件
cur_dir=$(cd $(dirname $0); pwd)
stp_d="${cur_dir}/logs/md/mdServer.log\n${cur_dir}/logs/trade/tradeServer.log\n{\n
\tsize=200M\n\trotate 5\n\tcompress\n\tdelaycompress\n\tmissingok\n
\tnotifempty\n\tdateext\n\tdateformat %Y%m%d%H.%s\n\tcreate 644 root root\n}"

echo -e ${stp_d} > /etc/logrotate.d/stp



#设置定时任务，每分钟执行一次
grep -c "/etc/logrotate.d/stp" /var/spool/cron/root >> /dev/null
if [ $? -ne 0 ];then
    echo "*/1 * * * * /usr/sbin/logrotate /etc/logrotate.d/stp" >> /var/spool/cron/root
fi