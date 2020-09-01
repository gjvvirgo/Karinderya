#!/bin/bash
#Thi is the promt for registering
#
#SCRIPT VARIABLES
#FUNCTIONS
char_counter()
{
#1st arg minimum or maximum? 2nd arg value 3rd arg variable in question
	if [[ $1 == min ]]
	then
		if (($2<=$3))
		then
			return 0
		else
			return 1
		fi
	else if [[ $1 == max ]]
	then
		if (($2>=$3))
		then
			return 0
		else
			return 1
		fi
	else
		return 1
	fi
	fi
}

home_address()
{
	local x=1
	while ((x!=0))
	do
		echo -n "Home Address: "
		read -r address
		char_counter max 100 ${#address}
		if (($?==0))
		then
			x=0			
		else
			echo "Exceeded 100 characters, please enter again"
		fi
	done
	
}

username()
{
	local get_input=0
	for ((test=1;test<=4;test=test+1))
	do
		if ((get_input==0))
		then
			echo -n "Username: "
			read username
			test=1
		fi
		case $test in
		"1") #Minumum of 8 characters
			char_counter min 8 ${#username}
			if (($?==0))
			then
				get_input=1
			else
				echo "The username is too short"
				get_input=0
			fi
		;;
		"2") #first letter should not be digit
			letter="$(echo $username| cut -c1)"
			if [[ $letter =~ [^[:digit:]] ]]
			then
				get_input=1
			else
				echo "The first character should not be a digit"
				get_input=0
			fi
		;;
		"3") #Username should not be existing
			local user="$(echo $username|tr [A-Z] [a-z])"
			cat userlist|tr [A-Z] [a-z] > tmp3
			finder.sh $user tmp3 1 tmp 1
			if (($?!=0))
			then
				get_input=1
			else
				echo "Username already exists"
				get_input=0
			fi
		;;
		"4") #testing successful
			return 0
		;; esac
	done
}
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
password()
{
	local get_input=0	
	for ((test=1;test<=9;test=test+1))
	do
		if ((get_input==0))
		then
			echo -n "Please enter password: "
			pass_to_ask
			test=1
		fi
		case $test in
		"1") #Minumum of 8 characters
			char_counter min 8 ${#password}
			if (($?==0))
			then
				get_input=1
			else
				echo "The password is too short"
				get_input=0
			fi
		;; "2") #Must have upper case
			for ((x=1;x<=${#password};x=x+1))
			do
				letter="$(echo $password| cut -c$x)"
				if [[ $letter =~ [^[:upper:]] ]]
				then if ((x==${#password}))
				   	then
					   echo "Password must have an upper case letter"
					   get_input=0
					else
					   get_input=0
					fi
				else
					get_input=1
					break
				fi
			done
		;; "3") #Must have lower case
			for ((x=1;x<=${#password};x=x+1))
			do
				letter="$(echo $password| cut -c$x)"
				if [[ $letter =~ [^[:lower:]] ]]
				then if ((x==${#password}))
				   	then
					   echo "Passworld must have an lower case letter"
					   get_input=0
					else
					   get_input=0
					fi
				else
					get_input=1
					break
				fi
			done
		;; "4") #Must have a number
			for ((x=1;x<=${#password};x=x+1))
			do
				letter="$(echo $password| cut -c$x)"
				if [[ $letter =~ [^[:digit:]] ]]
				then if ((x==${#password}))
				   	then
					   echo "Password must have a number"
					   get_input=0
					else
					   get_input=0
					fi
				else
					get_input=1
					break
				fi
			done
		;; "5") #Must have punctuation
			for ((x=1;x<=${#password};x=x+1))
			do
				letter="$(echo $password| cut -c$x)"
				if [[ $letter =~ [^[:punct:]] ]]
				then if ((x==${#password}))
				   	then
					   echo "Password must have a punctuation mark"
					   get_input=0
					else
					   get_input=0
					fi
				else
					get_input=1
					break
				fi
			done
		;; "7") #user and pass should not be the same
			if [[ $password == $username ]]
			then
				echo "Username and password should not be the same"
				get_input=0
			else
				get_input=1
			fi
			
		;; "8") #Confirm Password
			echo -n "Please confirm your password: "
			password2="$(echo $password)"
			pass_to_ask
			if [[ $password != $password2 ]]
			then
				echo "Password did not match"
				get_input=0
			else
				get_input=1
			fi
				
		;; "9") #Testing successful
			return 0
		;; esac
	done                 
}                            
echo "WELCOME! "             
echo "Please observe the following rules:"
echo "  - Username must be at least be 8 characters in length"
echo "  - Username must begin with an alphabetic character"
echo "  - Password must be at least be 8 characters in length"
echo "  - Password must contain:" 
echo "      - 1 lower case character"
echo "      - 1 upper case character"
echo "      - 1 digit"       
echo "      - 1 punctuation mark"
echo "  - A maximum of 100 characters are allowed for home address" 
echo " "
echo "Please enter the following information "
username
password
if (($?==0))
then
	echo $password > tmp
	openssl base64 -in tmp -out tmp4
	password="$(cat tmp4)"
fi
echo -n "Full Name (First Name Middle Name Last Name): "
read -r name
home_address
echo -n "Email Address: "
read -r email
date_created="$(date +%D) $(date +%T)"
clear
echo "Username: $username"
echo "Password: $password"
echo "Full Name: $name"
echo "Home Address: $address"
echo "Email Address: $email"
loc=0
while (($loc!=1))
do
	echo "Do you wish to submit these information? Y/N"
	read ans
	if [[ $ans == "Y" ]] || [[ $ans == "y" ]]
	then
		register.sh $username $password "$name" "$address" $email "$date_created"
		echo "Registration Successful!"
		loc=1
		exit 0	
	else if [[ $ans == "N" ]] || [[ $ans == "n" ]]
	then
		echo "Registration canceled"
		loc=1
		exit 0
	else
		echo "Invalid"
		loc=0
	fi
	fi
done
