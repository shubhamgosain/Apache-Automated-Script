#!/bin/bash


delete_website()
{

echo "The available Website Configurations are"
web_path="/etc/apache2/sites-available"
while true
do

conf_content=$(ls $web_path)

clear
       echo "select Website you want to Delete"
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
	then  echo "Are You Sure You want to delete ${conf_files[$[web_conf_choice-1]]}  (y/n)"
	  read y_n_choice
     if [ $y_n_choice = 'y' ]
     then	     
	rm $web_path/${conf_files[$[web_conf_choice-1]]}
	if [ $? -eq 0 ]
	then 
		echo "Deleted Successfully"
		sudo systemctl reload apache2
	else echo "Not Deleted"
	fi
fi
sleep 3
	else echo "Incorrect Option, No such website exist"
fi

done       
}




delete_website
