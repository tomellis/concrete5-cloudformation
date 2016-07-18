# Script to play through C5 install before Ansible rewrite
yum -y update
yum install -y httpd24 php56 git
yum install -y php56-common.x86_64 php56-gd php56-mysqlnd php56-mbstring php56-mcrypt php56-pdo php56-xml
yum install -y mysql56-server
wget -c https://s3-eu-west-1.amazonaws.com/c5-app/concrete5.7.5.6.zip -O /tmp/concrete5.zip
unzip /tmp/concrete5.zip
mv concrete5.7.5.6/ /var/www/html/c5
chown apache:apache /var/www/html/c5 -R
chkconfig httpd on
service httpd start
chkconfig mysqld on
service mysqld start
# Insecure passwords for testing
/usr/libexec/mysql56/mysqladmin -u root password 'concrete'
mysql -u root -pconcreteadminpw123 -Bse "CREATE DATABASE concrete5db;GRANT ALL PRIVILEGES ON concrete5db.* TO 'concrete5'@'localhost' IDENTIFIED BY 'concrete' WITH GRANT OPTION;FLUSH PRIVILEGES;"
bash /var/www/html/c5/concrete/bin/concrete5 c5:install --db-server=localhost --db-username=concrete5 --db-password=concrete --db-database=concrete5db --site=testytest --starting-point=elemental_full --admin-email=root@localhost --admin-password=concrete --default-locale=en_US
git clone https://github.com/tomellis/concrete5_amazon_s3_filemanager.git /var/www/html/c5/packages/amazon_s3_filemanager
