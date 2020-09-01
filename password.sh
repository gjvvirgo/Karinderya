#!/bin/bash
#This is the same as the function password in register
char_counter()
{
	if [[ $1 == min ]]
	then
		if (($2<=$3))
		then
			return 0
		else
			return 1
		fi
	elif [[ $1 == max ]]
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
			echo -n "Plese enter NEW password: "
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
password
if (($?==0))
then
	password="$(echo password|openssl enc -base64)"
	echo $password > tmp4
fi
exit
