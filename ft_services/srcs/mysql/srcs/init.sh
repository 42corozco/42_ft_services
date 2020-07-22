#! /bin/bash
mysql_install_db --user=root
cat > sql << eof
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
eof
/usr/bin/mysqld --user=root --bootstrap --verbose=0 < sql

