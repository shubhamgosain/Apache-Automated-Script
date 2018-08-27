#!/bin/bash

HTTP_site()
{
clear
	echo -n "Enter Server name :" 
read ServerName
echo -n "Provide relative location for the directory containing Index.html file :"
read DocumentRoot
ls $DocumentRoot/index.html &>/dev/null
if [ $? -ne 0 ]
then echo "$DocumentRoot/index.html does not exist.... you still want to continue(y/n)...pressing y will create it "
read input
if [ $input = 'n' ]
then exit 1
else mkdir -p $DocumentRoot
	echo "This is $ServerName Website" > $DocumentRoot/index.html
	if [ $? -ne 0 ]
	then	echo "Error Occured";sleep 3
	fi
fi
fi
	
echo "<VirtualHost *:80>
        ServerName $ServerName
	ServerAdmin webmaster@localhost
        DocumentRoot $DocumentRoot


        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
<Directory $DocumentRoot>
AllowOverride None
Require all granted
</Directory>" > /etc/apache2/sites-available/${ServerName}.conf
echo -n "Enable the website(y/n):"
read choice
if [ $choice = 'y' ]
then
	a2ensite $ServerName
fi
if [ $? -eq 0 ]
then	echo "Website Enabled"
else echo "Website not Enabled ...check the logs"
fi

systemctl restart apache2

if [ $? -eq 0 ]
then
       echo "************Virtual Host added****************"	
else echo "A problem occured in adding Virtual Host ....check apache Logs"
fi
sleep 3
}


HTTPS_site()
{
clear
	echo -n "Enter Server name :" 
read ServerName
echo -n "Provide relative location for the directory containing Index.html file :"
read DocumentRoot
ls $DocumentRoot/index.html &>/dev/null
if [ $? -ne 0 ]
then echo "$DocumentRoot/index.html does not exist.... you still want to continue(y/n)...pressing y will create it "
read input
if [ $input = 'n' ]
then exit 1
else mkdir -p $DocumentRoot
	echo "This is $ServerName Website" > $DocumentRoot/index.html
	if [ $? -ne 0 ]
	then	echo "Error Occured";sleep 3
	fi
fi
fi

a2enmod ssl
mkdir -p /etc/apache2/ssl/$ServerName
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/$ServerName/apache.key -out /etc/apache2/ssl/$ServerName/apache.crt
if [ $? -eq 0 ]
then
	echo "SSL Certificate and key created"
fi

chmod 600 /etc/apache2/ssl/$ServerName/*


echo "<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin webmaster@localhost
		ServerName $ServerName
                DocumentRoot $DocumentRoot
		SSLEngine on
                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

		<FilesMatch \"\.(cgi|shtml|phtml|php)$\">
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>
                
		SSLCertificateFile      /etc/apache2/ssl/$ServerName/apache.crt
                SSLCertificateKeyFile /etc/apache2/ssl/$ServerName/apache.key
</VirtualHost>
</IfModule>

<Directory $DocumentRoot>
AllowOverride None
Require all granted
</Directory>" > /etc/apache2/sites-available/${ServerName}.conf
echo -n "Enable the website(y/n):"
read choice
if [ $choice = 'y' ]
then
	a2ensite $ServerName
fi
if [ $? -eq 0 ]
then	echo "Website Enabled"
else echo "Website not Enabled ...check the logs"
fi

systemctl restart apache2

if [ $? -eq 0 ]
then
       echo "************Virtual Host added****************"	
else echo "A problem occured in adding Virtual Host ....check apache Logs"
fi
sleep 3


}



add_site()
{
type_of_conf=1
while [ $type_of_conf -ne 0 ]
do
clear
echo -e "What type of Virtual Host You want to add\n1. HTTP\n2. HTTPS\n0. Back"
read type_of_conf

case $type_of_conf in
	1) HTTP_site ;; 

	2) HTTPS_site;;
	0)echo "Exiting from Virtual Host Menu";sleep 1;clear;;
	?)echo "Enter Correct option";sleep 2;;
esac
done
}
add_site
