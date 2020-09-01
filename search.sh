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
echo "#	Short Name	Full Description"
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
	echo -e "$num\t${name[i]}$tabs${descri[i]}"
done
unset name
unset descri
echo $ret_val
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
			if ((choi<=hits))
			then
				((index=choi-1))
				itm=${itm_no[$index]}
				buy.sh $itm
				unset itm_no
				first=0
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
