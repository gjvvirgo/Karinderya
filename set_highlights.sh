#!/bin/bash
#This sets the keywords for  highlights
#
get_values() 
{
	unset keywords
	unset itm_num
	if (($1==1))
	then
		phrase="$(head -n1 database3|cut -d: -f2)"
		local tot_itm="$(cat -n keywords|cut -f1|tail -n1)"
		head=0
		for ((i=0;i<tot_itm;i=i+1))
		do
			((head=head+1))
			keywords[i]="$(cat keywords|head -$head|tail -n1)"
		done
	elif (($1==0))
	then
		local tot_itm="$(cat -n tmp|cut -f1|tail -n1)"
		head=0
		for ((i=0;i<tot_itm;i=i+1))
		do
			((head=head+1))
			keywords[i]="$(cat tmp|head -$head|tail -n1)"
		done
	fi
}
show_values()
{
	if (($1==1))
	then
		get_values 1
	else
		get_values 0
	fi
	echo "Current Set Phrase: $phrase"
	echo "Current keywords: ${keywords[*]}"
}
save()
{
	finder.sh 0 database3 1 tmp 0
	echo "0:$phrase" >> tmp
	sort tmp > database3
	echo $key|tr " " "\n" > keywords
}
loc=0
first_time=1
while ((loc==0))
do
	if ((first_time==1))
	then
		get_values 1
		show_values 1
		first_time=0
	else
		get_values 0
		show_values 0
	fi
	echo ""
	echo "(a) Change Phrase"
	echo "(b) Change keywords"
	echo "(c) Save"
	echo "(g) Exit"
	echo -n "Choice: "
	read choi
	case $choi in
	A|a)
		echo -n "Enter new phrase: "
		read -r phrase
		clear
	;; B|b)
		echo -n "Enter new keywords (separated by spaces): "
		read -r key
		echo $key|tr " " "\n" > tmp
		clear
	;; C|c)
		save
		clear
		echo "Highlights Updated"
		exit 0
	;; G|g)
		exit 0
	;; *)
		clear
		echo "Invalid"
	;; esac
done
		
