#!/bin/bash
#This show cart_data and payment via credit/debit card
#Options:
#(C) chekout
#(G) go back to menu/ exit w/o save
#(item no.):
#   - (R) remove from cart
#   - (M) modify value
get_values()
{
	total_itm="$(sort cart_data|uniq|cat -n|tail -n1|cut -f1)"
	sum=0
	unset itm_no
	unset qty
	unset names
	unset price
	unset tot_price
	for ((i=0;i<total_itm;i=i+1))
	do
	((head_num=i+1))
	itm_no[i]=$(sort cart_data|uniq|cut -d":" -f1|head -n$head_num|tail -n1)
	qty[i]=$(sort cart_data|uniq -c|tr -s " "|tr " " ":"|cut -d":" -f2|head -n$head_num|tail -n1)
	finder.sh ${itm_no[i]} database 1 tmp 1
	names[i]="$(cat tmp|cut -d":" -f2)"
	price[i]="$(cat tmp|cut -d":" -f4)"
	((tot_price[i]=${qty[i]}*${price[i]}))
	((sum=sum+${tot_price[i]}))
	done
	
}
show_det()
{
get_values
echo "Item No. Short Name    Quantity    Individual Price    Total Item Price"	
for ((x=0;x<total_itm;x=x+1))
do
 if ((${#names[x]}>=8))
 then
	tabs="\t"
 else
	tabs="\t\t"
 fi
 echo -e "${itm_no[x]}        ${names[x]}$tabs   ${qty[x]}\t\t  ${price[x]}\t\t      ${tot_price[x]}"
done
echo -e "\t\t\t\t\t\t        _________________"
echo -e "\t\t\t\t\t\t GRAND TOTAL: $sum"
}
checkout()
{
	echo -n "Please enter your card number: "
	read card
	echo -n "Please enter the expiration date (MM/DD/YY): "
	read expire
	echo -n "Please enter your CCV/CVV: "
	read ccv
	echo "" > cart_data
}
checker()
{
	for ((i=0;i<=total_itm;i=i+1))
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
remove()
{
	checker $1
	local index=$?
	if ((index==0))
	then
		return 1
	fi
	((new_index=$index-1))
	local loc=1
	while ((loc==1))
	do
	echo -n "Are you sure you want to remove ${names[new_index]} from the cart? Y/N: "
	read ans
	case $ans in
	Y|y)
		grep -wiv "${names[new_index]}" cart_data > tmp3
		cat tmp3 > cart_data
		clear
		echo "Item removed from cart!"
		loc=0
		return 0
	;; N|n)
		return 0	
	;; *)
		echo "Invalid"
	;; esac
	done

}
modify()
{
	checker $1
	index=$?
	local loc=1
	if ((index==0))
	then
		return 1
	fi
	buy.sh ${itm_no[new_index]}
	if (($?==1))
	then
		return 0
	fi
	((new_index=$index-1))
	grep -wiv ${names[new_index]} cart_data > tmp3
	cat tmp3 > cart_data
	if (($?==1))
	then
		return 1
	fi
}
clear
loc=1
while ((loc==1))
do
	show_det
	echo "(C) Check Out"
	echo "(G) Exit"
	echo "(Item No.) Modify Quantity/ Remove From Cart"
	echo -n "Choice: "
	read choi
	case $choi in
	G|g)
		exit 0
	;; C|c)
		checkout
		echo "Checkout Successful! THANK YOU! "
		exit 0
	;; *)
		if [[ $choi =~ [[:digit:]] ]] 
		then 
			checker $choi
			if (($?!=0))
			then
				echo "(M) Modify"
				echo "(R) Remove"
				echo "(G) Exit"
				echo -n "Choice: "
				read choi1
				case $choi1 in
				G|g) 
					clear
				;; M|m)
					modify $choi
				;; R|r)
					remove $choi
				;; *)
					clear
					echo "Invalid"
				;; esac
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
