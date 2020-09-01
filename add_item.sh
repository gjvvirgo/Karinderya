#!/bin/bash
save=1
while ((save!=0))	
do
	clear
	echo ""
	echo -n "Enter Item Short Name: "
	read -r name
	echo -n "Enter Full Description: "
	read -r description
	echo -n "Enter Initial Quantity: "
	read qty
	echo -n "Enter Price: "
	read price
	echo -n "Keywords (separate by space): "
	read -r keywords
	clear
	echo "Item Name: $name"
	echo "Quantity: $qty"
	echo "Price: $price"
	echo "Description: $description"
	echo "Keywords: $keywords"
	echo ""
	echo -n "Are the information correct? Y/N: "
	read save
	case $save in
	"Y"|"y")
		dates="$(date +%D) $(date +%T)"
item_create.sh "$name" "$qty" "$price" "$dates" "$description" "$keywords"
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
