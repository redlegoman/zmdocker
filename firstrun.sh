if [ ! -f /etc/firstrun ]
then 
	echo "first run..."

	#------------------------------------
	/usr/sbin/mysqld --initialize-insecure --user=mysql
	systemctl start mysql.service
	mysqladmin -u root password root
	mysqladmin -u root -proot reload
	mysqladmin -u root -proot create zm
	echo "grant select,insert,update,delete on zm.* to 'zmuser'@localhost identified by 'zmpass'; flush privileges; " | mysql -u root -proot
	mysql -u root -proot < /usr/share/zoneminder/db/zm_create.sql
	echo "update zm.Config SET Value='/zm/cgi-bin/nph-zms' WHERE Name='ZM_PATH_ZMS'" |mysql -uroot -proot
  echo "update zm.Config SET Value='/usr/bin/ffmpeg' WHERE Name='ZM_PATH_FFMPEG'" |mysql -uroot -proot
	echo "update zm.Config SET Value=1 WHERE Name='ZM_OPT_FFMPEG'" |mysql -uroot -proot
  echo "update zm.Config SET Value=90 WHERE Name='ZM_JPEG_STREAM_QUALITY'" |mysql -uroot -proot
  echo "update zm.Config SET Value=90 WHERE Name='ZM_JPEG_ALARM_FILE_QUALITY'" |mysql -uroot -proot
	echo "update zm.Config SET Value=0 WHERE Name='ZM_CHECK_FOR_UPDATES'" |mysql -uroot -proot
  echo "update zm.Config SET Value='desc' WHERE Name='ZM_WEB_EVENT_SORT_ORDER'" |mysql -uroot -proot
  echo "update zm.Config SET Value=1 WHERE Name='ZM_WEB_LIST_THUMBS'" |mysql -uroot -proot
  echo "update zm.Config SET Value='ZMDocker' WHERE Name='ZM_WEB_TITLE_PREFIX'" |mysql -uroot -proot
	systemctl stop mysql.service
	echo "sql_mode = NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

	#------------------------------------
	if [ ! -d /var/cache/zoneminder/events ]; then
		mkdir -p /var/cache/zoneminder/events
		mkdir -p /var/cache/zoneminder/images
		mkdir -p /var/cache/zoneminder/temp
	fi
	chown -R www-data:www-data /var/cache/zoneminder
	chown -R www-data:www-data /usr/share/zoneminder
	chown -R root:www-data /etc/zm/zm.conf
	chmod 660 /etc/zm/zm.conf
	a2enmod cgi
	a2enmod rewrite
	a2enconf zoneminder
	#------------------------------------
	update-locale

	#------------------------------------
	touch /etc/firstrun
	sed -i 's/\/usr\/local\/sbin\/firstrun.sh/#\/usr\/local\/sbin\/firsrun.sh/g' /etc/rc.local
else
	echo "first run already done.."
fi
