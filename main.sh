#!/bin/bash
#main program
PATH=$PATH:$(pwd)
test=1
while ((loc!=1))
do
	case $test in
	"1")
		clear
		login.sh
		ret_val=$?
		if ((ret_val==0))
		then
			test=2
		elif ((ret_val==1))
		then
			test=1
		elif ((ret_val==2))
		then
			exit
		fi
	;; "2")
		clear
		menu.sh
		if (($?==2))
		then
			test=1
			rm cart_data
			rm tmp
			rm tmp2
			rm tmp3
			rm tmp4
			rm tmp5
		fi
	;; esac
done
exit
