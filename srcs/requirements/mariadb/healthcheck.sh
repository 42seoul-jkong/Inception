#!/bin/sh

# Connect
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -hlocalhost --protocol tcp -e 'select 1'
if [ $? -ne 0 ]
then
	exit 1
fi

# InnoDB Initialized
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -B --skip-column-names -e 'select 1 from information_schema.ENGINES WHERE engine="innodb" AND support in ("YES", "DEFAULT", "ENABLED")'
if [ $? -ne 0 ]
then
	exit 2
fi
