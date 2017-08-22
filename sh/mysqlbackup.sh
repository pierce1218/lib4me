#!/bin/sh

# 需要备份的数据库
dbs="CIBTC_PRS_10 CIBTC_EBS_30 CIBTC_OSPOL_V20"
# 备份存储目前
back_dir=$(cd "$(dirname "$0")"; pwd)
file_dir=$back_dir/backups
# MySQL服务器地址,用户及密码
db_host="192.168.10.213"
db_user="hwlm"
db_pass="dev@hwlm"

if [ ! -d $file_dir ]; then
  mkdir $file_dir
fi

function log() {
  echo "`date '+%Y%m%d %H:%M:%S'` $1" >> ${back_dir}/backups.log
}

for db in $dbs
do
  log "Duming [$db] ..."
  mysqldump -h$db_host -u$db_user -p$db_pass $db | gzip > ${file_dir}/${db}_`date '+%Y%m%d'`.sql.gz
  log "The [$db] dumping is finished!"
  log "clean [${db}_*] files older than 7 days"
  find $file_dir -name "${db}_*.sql.gz" -type f -mtime +7 -exec rm -rf {} \;
done

