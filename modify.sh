#!/bin/bash
#This script searches an item from the databas
#based on the inputed keyword
get_input=0
searcher ()
{
for ((i=1;i<=3;i=i+1))
do
	if ((get_input==0))
	then
		clear
		echo -n "Enter the keyword (G to exit): "
		read keyword
		if [[ $keyword == "G" ]] || [[ $keyword == "g" ]]
		then
			exit 1
		fi
		word="$(echo $keyword| tr [A-Z] [a-z])"
		i=1
		get_input=1
	fi
	case $i in
	"1")
		cat database|tr [A-Z] [a-z]|grep -w $word > /dev/null
		if (($?==0))
		then
			cat database|tr [A-Z] [a-z]|grep -w $word|cut -d":" -f1 > tmp
			x=0
			while read num
			do
				finder.sh $num database 1 tmp3 1 	
				name[$x]="$(cat tmp3|cut -d":" -f2)"
				itm_no[$x]="$(cat tmp3|cut -d":" -f1)"
				qty[x]="$(cat tmp3|cut -d: -f3)"
				price[x]="$(cat tmp3|cut -d: -f4)"
				finder.sh $num database2 1 tmp3 1
				descri[$x]="$(cat tmp3|cut -d":" -f2)"
				((x=x+1))
			done < tmp
			get_input=0
			return 1
		else
			get_input=1
		fi
		
		
	;; "2")
		cat database2|tr [A-Z] [a-z]|grep -w $word > /dev/null
		if (($?==0))
		then
			cat database2|tr [A-Z] [a-z]|grep -w $word|cut -d":" -f1 > tmp
			x=0
			while read num
			do
				finder.sh $num database 1 tmp3 1 	
				name[$x]="$(cat tmp3|cut -d":" -f2)"
				itm_no[$x]="$(cat tmp3|cut -d":" -f1)"
				qty[x]="$(cat tmp3|cut -d: -f3)"
				price[x]="$(cat tmp3|cut -d: -f4)"
				finder.sh $num database2 1 tmp3 1
				descri[$x]="$(cat tmp3|cut -d":" -f2)"
				((x=x+1))
			done < tmp
			get_input=0
			return
		else
			clear
			get_input=0
			return 1
		fi
	;; esac
done
}
output ()
{
clear
hits=${#name[*]}
echo "#	Short Name	Quantity	Retail Price"
num=0
for ((i=0;i<$hits;i=i+1))
do
	if ((${#name[i]}>=8))
	then
		tabs="\t"
	else
		tabs="\t\t"
	fi
	((num=num+1))
	echo -e "${itm_no[i]}\t${name[i]}$tabs${qty[i]}\t\t\t${price[i]}"
done
unset name
unset descri
unset qty
unset price
echo $ret_val
}
delete()
{
save=1
while ((save!=0))
do
	clear
	echo "Name: ${name[$1]}" 
	echo "Quantity: ${qty[$1]}"
	echo "Price: ${qty[$1]}"
	echo -n "Do you want to delete this item? Y/N: "
	read choice
	case $choice in
	"y"|"Y")
		finder.sh ${itm_no[$1]} database 1 tmp3 0
		cat tmp3 > database
		finder.sh ${itm_no[$1]}i database2 1 tmp3 0
		cat tmp3 > database2
		save=0
	;; "n"|"N")
		return 0
	;; *)
		echo "Invalid"
	;; esac
done
}
modify()
{
loc=0
while ((loc==0))
do
	echo "(e) Edit (d) Delete (c) cancel" 	
	read choice
	case $choice in
	E|e)
		edit $1
	;; D|d)
		delete $1
	;; C|c)
		return	
	;; *)
		clear
		echo "Invalid"
	;; esac
done
}
checker()
{
	for ((i=0;i<hits;i=i+1))
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
first=0
loc=0
while ((loc!=1))
do
	if ((first==0))
	then
		searcher
		output
		if ((ret_val==1))
		then
			echo "Keyword Invalid"
		fi
		first=1
	fi
	echo "(G) Exit to menu"
	echo "(R) Search Again"
	echo "(item number) Choose item to add in your cart"
	echo -n "Choice: "
	read choi
	case $choi in
	"G"|"g")
		loc=1
		exit
	;; "R"|"r")
		searcher
		output
	;; *)
		if [[ $choi =~ [[:digit:]] ]]
		then
			checker $choi
			if (($?!=0))
			then
				modify $choi
			else	
				echo "invalid"
			fi
		else
			clear
			echo "invalid"
		fi
	;; esac
done
exit
