#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done


_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> chnage MySQL root password change to ''"
mysql -uroot -e "use mysql; UPDATE user SET authentication_string=password('') WHERE user='root'"

# You can create a /mysql-setup.sh file to intialized the DB
if [ -f /mysql-setup.sh ] ; then
  . /mysql-setup.sh
fi

echo "=> Done!"
mysqladmin -uroot shutdown
