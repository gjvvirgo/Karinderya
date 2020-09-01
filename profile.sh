#!/bin/bash
#This is the profile option in menu
#Logged in user can change any information of the logged in accout except
#username
username="$(cat tmp2| cut -d":" -f1)"
cat userlist| grep -w "$username">tmp2
uid="$(cat tmp2| cut -d":" -f2)"
password="$(cat tmp2| cut -d":" -f3)"
name="$(cat tmp2|cut -d":" -f4)"
address="$(cat tmp2|cut -d":" -f5)"
email="$(cat tmp2|cut -d":" -f6)"
save=1
clear
while ((save!=0))
do
	echo "Please select the field you want to change"
	echo "Username: $username"
	echo "(1) Password"
	echo "(2) Full Name: $name"
	echo "(3) Home Address: $address"
	echo "(4) Email Address: $email"
	echo ""
	echo "(5) Save changes"
	echo "(6) Exit (Do not save changes)"
	echo -n "Option number: "
	read choice
	case $choice in
	"1")
		password.sh
		if(($?==0))
		then
			password="$(cat tmp4)"
			clear
			echo "Password Successfully Changed!"
		fi
	;; "2")
		echo -n "New Full Name: "
		read -r name
		clear
	;; "3")
		echo -n "New Home Address: "
		read -r address
		clear
	;; "4")
		echo -n "New Email Address: "
		read email
		clear
	;; "5") 
		save=0
	;; "6")
		exit 0
	;; *)
		clear
		echo "Invalid"
	;; esac
done
#cat userlist| grep -w "$username" -v > tmp
finder.sh $username userlist 1 tmp 0
cat tmp > userlist
dates="$(date +%D) $(date +%T)"
x=1
set "$username" "$uid" "$password" "$name" "$address" $email "$dates"
for inpt in "$@"
do
	if ((x==7))
	then
		echo -n "$inpt" >> userlist
		echo "" >> userlist
		break
	else
   		echo -n "$inpt" >> userlist	
		echo -n ":" >> userlist
		x=$x+1
	fi
done
sort -t":" -k2 userlist > tmp
cat tmp > userlist
exit
