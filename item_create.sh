#!/bin/bash
#This is the script for creating item list
#The format of each item is as follows:
#For database:
#	ItemID:ItemShortName:Quantity:Price:DateCreated
#For database2:
#	ItemID:Description
#For database3:
#	ItemID:Keyword(s)
#int item_create (a,b,c,d,e,f) { ... }

#VARIABLES
x=1 #determines argument conditions
y=0 #uid checker
#FUNCTIONS
itemid_checker()
{
        latest_id="$(tail database -n1|cut -d":" -f1)"
	while ((y!=latest_id))
	do
	cat database|grep -w $y > tmp
	local cnd="$(echo $?)"
		if ((cnd==0))
		then
			((y=y+1))
		else
			latest_id=$y
			return 0
		fi
	done
        ((latest_id=$latest_id+1))
}

itemid_checker
for inpt in "$@"
do
	if ((x==1))
	then
		echo -n $latest_id >>database
		echo -n ":" >>database

		echo -n "$inpt" >>database 
		echo -n ":" >> database
		x=$x+1
	else
	if ((x==4))
	then
		echo -n "$inpt" >> database
		echo "" >> database
		break
	else
   		echo -n "$inpt" >> database
		echo -n ":" >> database
		x=$x+1
	fi
	fi
done

echo -n $latest_id >> database2
echo -n ":" >> database2
echo -n $5 >> database2
sort -t":" -k1 database2 > tmp
cat tmp > database2
sort -t":" -k1 database > tmp
cat tmp > database
echo -n $latest_id >> database3
echo -n ":" >> database3
echo -n $6 >> database3
sort -t":" -k1 database3 > tmp
cat tmp > database3
rm tmp
exit
