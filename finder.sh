#!/bin/bash
#This finds things in the database or userlist
#finder (a,b,c,d,e) { ... }
#a = string to locate
#b = where to find (database,databas2,userlist)
#c = field #
#d = where to save (eg. tmp)
#e = (0) for inverse, (1) not inverse
if (($5==1))
then
	cat $2|cut -d":" -f$3|grep -xn $1 > /dev/null
	condi=$?
	if ((condi==0))
	then
		line_num="$(cat $2|cut -d":" -f$3| grep -xn $1|cut -d":" -f1)"
		cat $2| head -n"$line_num"|tail -n1 > $4 
	elif ((condi==1))
	then
		exit 1
	fi

elif (($5==0))
then
	cat $2|cut -d":" -f$3|grep -xn $1 > /dev/null
	condi=$?
	if ((condi==0))
	then
	       line_num="$(cat $2|cut -d":" -f$3| grep -xn $1|cut -d":" -f1)"
		value="$(cat $2| head -n"$line_num"|tail -n1)" 
		cat $2|grep -wv "$value" > $4
	elif ((condi==1))
	then
		exit 1
	fi
else 
	exit 1
fi
exit 0
