#!/bin/bash
#This is the registration script
#The format of each user is as follows:
#username:uid:encrypted_password:full_name:home_address:email_address:
#date_when_the_account_was_created
#int register (a,b,c,d,e,f) { ... }

#VARIABLES
x=1 #determines argument conditions
y=0 #uid checker
#FUNCTIONS
uid_checker()
{
        latest_uid="$(tail userlist -n1|cut -d":" -f2)"
	while ((y!=latest_uid))
	do
	cat userlist|grep -w $y > tmp
	local cnd="$(echo $?)"
		if ((cnd==0))
		then
			((y=y+1))
		else
			latest_uid=$y
			return 0
		fi
	done
        ((latest_uid=$latest_uid+1))
}

uid_checker
for inpt in "$@"
do
	if ((x==2))
	then
		echo -n $latest_uid >>userlist
		echo -n ":" >>userlist

		echo -n "$inpt" >> userlist
		echo -n ":" >> userlist
		x=$x+1
	else
	if ((x==6))
	then
		echo -n "$inpt" >> userlist
		echo "" >> userlist
		break
	else
   		echo -n "$inpt" >> userlist	
		echo -n ":" >> userlist
		x=$x+1
	fi
	fi
done
sort -t":" -k2 userlist > tmp
cat tmp > userlist
rm tmp
exit
