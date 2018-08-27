#!/bin/bash

apache_configuration()
{

echo "The available Configurations of apache are"
echo "1. apache2.conf"

apache_path="/etc/apache2/conf-available"
conf_content=$(ls $apache_path)
while true
do
clear
       echo "select configuration you want to edit"
count=2
declare -a conf_files
echo "1.----- apache2.conf"
for i in $conf_content
do
	echo "${count}.----- $i"
	conf_files[$[count-2]]=$i
	$[count++] 2> /dev/null
done
echo "0.----- Go Back"
       read apache_conf_choice

      if [ $apache_conf_choice -eq 0 ]
	then	     
	       	break
       elif [ $apache_conf_choice -eq 1 ]
       then 
	        vim /etc/apache2/apache2.conf
	elif [ $apache_conf_choice -lt $count ] && [ $apache_conf_choice -gt 0 ]
	then  vim $apache_path/${conf_files[$[apache_conf_choice-2]]}
	else echo "Incorrect Option"
fi


done       
}


website_configuration()
{

echo "The available Website and their Configurations are"
web_path="/etc/apache2/sites-available"
conf_content=$(ls $web_path)
while true
do
clear
       echo "select Apache configuration you want to edit"
count=1
declare -a conf_files
for i in $conf_content
do
	echo "${count}.----- $i"
	conf_files[$[count-1]]=$i
	$[count++] 2> /dev/null
done
echo "0.----- Go Back"
       read web_conf_choice      
       if [ $web_conf_choice -eq 0 ]
       then break     
	elif [ $web_conf_choice -gt 0 ] && [ $web_conf_choice -lt $count ]
	then  vim $web_path/${conf_files[$[web_conf_choice-1]]}
	else echo "Incorrect Option"
fi

done       
}




edit_conf()
{
type_of_conf=1
while [ $type_of_conf -ne 0 ]
do
clear
echo -e "What type of configurations you want to edit.\n1. Apache Configurations\n2. Website Configurations\n0. Back"
read type_of_conf

case $type_of_conf in
	1) apache_configuration ;; 

	2)website_configuration ;;
	0)echo "Exiting from configurations Menu";sleep 1;clear;;
	?)echo "Enter Correct option";sleep 2;;
esac
done
}
edit_conf
