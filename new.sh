#!/bin/bash
#This is the "New!" option in the menu
#This shows the latest added items from the last 7 days
get_values()
{ 
	unset itm_no
	total_itm="$(cat -n tmp3|tail -n1|cut -f1)"
	local head=0
	for ((i=0;i<total_itm;i=i+1))
	do
		((head=head+1))
		itm_no[i]="$(cat tmp3|head -n$head|tail -n1)"		
		finder.sh "${itm_no[i]}" database 1 tmp 1
		names[i]="$(cat tmp|cut -d: -f2)"
		finder.sh "${itm_no[i]}" database2 1 tmp 1	
		descrip[i]="$(cat tmp|cut -d: -f2)"
	done

}
seven_days()
{
	unset month
	unset day
	unset itm_no

	local total_itm="$(cat -n database|tail -n1|cut -f1)"
	((total_itm=total_itm-1))
	finder.sh "0" database 1 tmp3 0
	sort -t":" -k5 -r tmp3 > tmp	
	head=0
	for ((i=0;i<total_itm;i=i+1))
	do
		((head=head+1))
	  month[i]="$(cat tmp|cut -d: -f5|head -n"$head"|tail -n1|cut -d/ -f1)"
	  day[i]="$(cat tmp|cut -d: -f5|head -n"$head"|tail -n1|cut -d/ -f2)"
		itm_no[i]="$(cat tmp|cut -d: -f1|head -n"$head"|tail -n1)"
	done

	today="$(date +%D) $(date +%T)"
	tdy_month="$(echo $today|cut -d/ -f1)"
	tdy_month="$(echo $tdy_month| bc)"
	tdy_day="$(echo $today|cut -d/ -f2)"
	tdy_day="$(echo $tdy_day| bc)"
	rm tmp3
	for ((y=0;y<total_itm;y=y+1))
	do
		converted_month="$(echo ${month[y]}|bc)"
		converted_day="$(echo ${day[y]}|bc)"
		if ((tdy_month==converted_month+1))
		then
			if ((tdy_day+30-converted_day<=7))
			then
				echo ${itm_no[y]} >> tmp3
			fi
		elif ((tdy_month==converted_month))
		then
			if ((tdy_day-converted_day<=7))
			then
				echo ${itm_no[y]} >> tmp3
			fi
		fi
	done
}
show_values()
{
	get_values
	toilet "New!"	
	echo "in tagalog"
	toilet "Bago!"
	echo "Item No.  Name		Description"
	for ((x=0;x<total_itm;x=x+1))
	do

		if ((${#names[x]}>=8))
		then
			tabs="\t"
		else	
			tabs="\t\t"
		fi
		echo -e "${itm_no[x]}\t  ${names[x]}$tabs${descrip[x]}"
	done
}
checker()
{
	for ((i=0;i<total_itm;i=i+1))
	do
		if (($1==${itm_no[i]}))
		then
			return $((i+1))
		elif ((i==total_itm))
		then
			return 0
		fi
	done
}
clear
seven_days
loc=1
while ((loc==1))
do
	show_values
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
			fi
		else	
			clear
			echo "Invalid"
		fi
	;; esac
done
exit
