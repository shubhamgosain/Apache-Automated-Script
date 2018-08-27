#!/bin/bash
clear
dpkg -l apache2 > /dev/null

if [ $? -ne 0 ]
then 
	echo -e "Apache is not installed in your system , you want to download it now(y/n) :"
	read status
	if [ $status = 'Y' ] || [ $status = 'y' ]
	then 
		apt-get install apache2 -y
	if [ $? -eq 0 ]
	then	
		echo "********************Successfully Installed**************************"
	else echo "*****************There is a Issue in installation...check you logs****************"
	fi
else 
	echo "There is no purpose of you being here ....BByee" 
	exit 1
fi
fi

echo -e "\n\n###########Apache Is Installed############\n\n"

echo -e "***************Welcome*******************\n\nIt is a Script to Configure apache and create new Named Based Hosting\n\n"


#source configuration.sh
choice=1
while [ $choice -ne 0 ] 
do
echo -e "Enter choice \n1. Edit configuration\n2. Add a Virtual Host\n3. Delete A Virtual Host\n0. Exit from Script" 
read choice

case $choice in
	1) bash scripts/configuration.sh ;;
	2) bash scripts/create_virtualhost.sh ;;
	3) bash scripts/delete_virtual.sh ;;
	0) clear;exit 1;;
esac
clear
done



