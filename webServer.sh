#!/bin/bash
# aws bootstrap script

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4 2> /dev/null  || hostname -i`

os_type () {
	case `uname` in
	Linux )
		LINUX=1
		which yum > /dev/null && { echo centos; return; }
		which zypper > /dev/null  && { echo opensuse; return; }
		which apt-get > /dev/null  && { echo debian; return; }
		;;
	Darwin )
		DARWIN=1
		;;
	* )
		# Handle AmgiaOS, CPM, and modified cable modems here.
		;;
	esac
}

load_web_page () {
	sudo  curl -s https://raw.githubusercontent.com/pitonic/pitonic.github.io/master/test/$1 > /var/www/html/index.html
	echo "<br><br><h2>WebServer with IP: $myip </h2><br>Build by External Script!"  >>  /var/www/html/index.html
}

if [ $# -gt 0 ]; then
    index="$1.html"
else
    index="1.html"
fi

if [ $(os_type) == "debian" ]; then

	#echo "ubuntu found"
	sudo apt-get -y update
	sudo apt -y install apache2
	sudo ufw allow 'Apache'
	sudo systemctl enable apache2
	load_web_page $index
	sudo systemctl restart apache2
	
fi

if [ $(os_type) == "centos" ]; then
    #echo "CentOS found"
	yum -y update
	yum -y install httpd
	sudo systemctl enable httpd
	load_web_page $index
	sudo systemctl restart httpd
fi 

exit
