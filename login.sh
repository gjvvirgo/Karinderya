#!/bin/bash
#This is to login page
#FUNCTIONS:
pass_to_ask()
{
stty -echo
unset PROMPT
unset password
char=0
while mask= read -p "$PROMPT" -r -s -n 1 CHAR
do
	if [[ $CHAR == $'\0' ]]
	then
		echo ""
		break
	fi
	if [[ $CHAR == $'\177' ]]
	then
		if [ $char -gt 0 ]
		then
			char=$((char-1))
			PROMPT=$'\b \b'
			password="${pass%?}"
		else
			PROMPT=''
		fi
	else
		char=$((char+1))
		PROMPT='*'
		password+="$CHAR"
	fi
done
stty echo
}
login_func()
{
	while ((loc!=1))
	do	
		echo -n "Username: "
		read username1
		cat userlist|cut -d":" -f1| grep -x "$username1" > tmp
		if (($?==0))
		then
			password_func
			if (($?==0))
			then
				return 0
			fi
		else
			echo "Username does not exist "
		fi
	done
}

password_func()
{
	echo -n "Password: "
	pass_to_ask
	password2="$(cat userlist| grep -w "$username1"| cut -d":" -f3)"
	echo $password2 > tmp
	openssl base64 -d -in tmp -out tmp4
	password2="$(cat tmp4)"
	if [[ $password == $password2 ]]
	then
		cat userlist| grep -w "$username1" > tmp2
		return 0
	else
		echo "Wrong password"
		return 1
	fi
}
loc=0
while ((loc!=1))
do
	toilet "Welcome to Karinderya"
	echo "(a) Login"
	echo "(b) Register"
	echo "(c) Exit"
	echo -n "Enter the number of your choice: "
	read choice
	case $choice in
	A|a)
		login_func
		exit 0
	;; B|b)
		clear
		register_prompt.sh
		exit 1
	;; C|c)
		exit 2
	;; *)
		clear
		echo "Invalid"
	;; esac
done
