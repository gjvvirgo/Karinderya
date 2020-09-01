#!/bin/bash
#This "highlight" option in the menu
#It displays the items containing keywords that are added by the admin
#It is related to search
#
find_keywords()
{
	local itm_no="$(wc -l < keywords)"	
	local head=0
	for ((i=0;i<itm_no;i=i+1))
	do
		((head=head+1))
		keyword[i]="$(head -n"$head" keywords|tail -n1)"
	done
	rm tmp
	for ((x=0;x<itm_no;x=x+1))
	do
		cat database3|grep -i ${keyword[x]} > /dev/null
		if (($?==0))
		then
			cat database3|grep -i ${keyword[x]}|cut -d: -f1 >> tmp
		fi
	done
	sort tmp|uniq > tmp3
	test_zero="$(head -n1 tmp3)"
	if ((test_zero==0))
	then
		cat tmp3|grep -v 0 > tmp
		cat tmp > tmp3
	fi
}
get_values ()
{
	phrase="$(head -n1 database3|cut -d: -f2|tr " " "\n")"
	find_keywords
	total_itm="$(wc -l < tmp3)"
	local head=0
	for ((i=0;i<total_itm;i=i+1))
	do
		((head=head+1))
		itm_num[i]="$(head -n$head tmp3|tail -n1)"
		finder.sh ${itm_num[i]} database 1 tmp 1
		names[i]="$(cut -d: -f2 tmp)"
		finder.sh ${itm_num[i]} database2 1 tmp 1
		descrip[i]="$(cut -d: -f2 tmp)"
	done
}
show_values()
{
	get_values
	echo ""
	toilet "$phrase"
	echo ""
	echo "Item No.  Name		Description"
	for ((x=0;x<total_itm;x=x+1))
	do

		if ((${#names[x]}>=8))
		then
			tabs="\t"
		else	
			tabs="\t\t"
		fi
		echo -e "${itm_num[x]}\t  ${names[x]}$tabs${descrip[x]}"
	done
}
checker()
{
	for ((i=0;i<=total_itm;i=i+1))
	do
		if (($1==${itm_num[i]}))
		then
			return $((i+1))
		elif ((i==total_itm))
		then
			return 0
		fi
	done
}
clear
loc=1
while ((loc==1))
do
	show_values
	echo ""
	echo "Select an item to add to cart"
	echo "(G) to exit"
	echo -n "Item No: "
	read choi
	case $choi in
	G|g)
		exit 0
	;; *)
		if [[ $choi =~ [[:digit:]] ]]
		then
			checker $choi
			if (($?!=0))
			then
				buy.sh $choi
			else
				clear
				echo "Invalid"
				continue
			fi
		else	
			clear
			echo "Invalid"
			continue
		fi
	;; esac
done
exit
