#!/bin/bash
#This script is to add/delete or edit item option in the menu
#This script should only be availabe for admin accounts
#FUNCTIONS
load_item()
{
loc=0
while ((loc==0))
do
	echo -n "Enter name of item: "
	read name
	local name_tr="$(echo $name|tr [A-Z] [a-z])"
	#cat database|tr [A-Z] [a-z]|cut -d":" -f2| grep -w $name_tr > /dev/null
	cat database|cut -d":" -f2| grep -wi $name > /dev/null
	if (($?!=0))
	then
		clear
		echo "Item does not exist"
	else
		cat database|tr [A-Z] [a-z]|grep -w $name_tr > tmp3
		item_id="$(cat tmp3|cut -d":" -f1)"
		finder.sh $item_id database 1 tmp3 1
		item_name="$(cat tmp3|cut -d":" -f2)"
		qty="$(cat tmp3|cut -d":" -f3)"
		price="$(cat tmp3|cut -d":" -f4)"
		finder.sh $item_id database2 1 tmp3 1
		#cat database2|grep -w "$item_id" > tmp3
		description="$(cat tmp3|cut -d":" -f2)"
		echo "Name: $item_name"
		echo "Qty: $qty"
		echo "Price: $price"
		echo "Description: $description"
		echo ""
		return
	fi
done
}
del_item()
{
save=1
while ((save!=0))
do
	clear
	load_item
	echo -n "Do you want to delete this item? Y/N: "
	read choice
	case $choice in
	"y"|"Y")
		finder.sh $item_id database 1 tmp3 0
		#cat database|grep -w :"$item_id": -v > tmp3
		cat tmp3 > database
		finder.sh $item_id database2 1 tmp3 0
		#cat database2|grep -2 "$item_id": -v > tmp3
		cat tmp3 > database2
		save=0
	;; "n"|"N")
		return 0
	;; *)
		echo "Invalid"
	;; esac
done
return 0
}
add_item()
{
save=1
while ((save!=0))	
do
	clear
	echo ""
	echo -n "Enter Item Short Name: "
	read -r name
	echo -n "Enter Initial Quantity: "
	read qty
	echo -n "Enter Price: "
	read price
	echo -n "Enter Full Description: "
	read -r description
	clear
	echo "Item Name: $name"
	echo "Quantity: $qty"
	echo "Price: $price"
	echo "Description: $description"
	echo ""
	echo -n "Are the information correct? Y/N: "
	read save
	case $save in
	"Y"|"y")
		dates="$(date +%D) $(date +%T)"
		item_create.sh "$name" "$qty" "$price" "$dates" "$description"
		echo "Item added!"
		break
	;; "N"|"n")
		echo -n "Do you want to try again? Y/N: "
		read save
		case $save in
		"Y"|"y")
			save=1
		;; "N"|"n")
			save=0
			return 0
		;; *)
			"Invalid"
		;; esac
	;; *)
		echo "Invalid" 
	;; esac
done
return
}
clear
loc=0
while ((loc==0))
do
	echo "Please choose an option: "
	echo "(2) Delete Item"
	echo "(3) Edit Item"
	echo "(4) Exit"
	echo ""
	echo -n "Choice: "
	read choice
	case $choice in
	"2")
		del_item
	;; "3")
		edit_item
	;; "4") 
		loc=1
		exit 0
	;; *)
		echo "Invalid"
	;; esac
done
exit
