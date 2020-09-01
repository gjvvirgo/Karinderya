#!/bin/bash
#this script creates the add to cart data
#parameters:
#(1st)	Item Number
while ((loc=1))
do
	echo -n "How Many? (G to exit): "
	read qty
	if [[ $qty =~ [[:digit:]] ]]
	then
		finder.sh $1 database 1 tmp 1
		name="$(cat tmp|cut -d":" -f2)"
		price="$(cat tmp|cut -d":" -f4)"
		orig_qty="$(cat tmp|cut -d":" -f3)"
		if (($qty>$orig_qty))
		then
			echo "Order exceeds stock"
			continue
		else
			break
		fi
	elif [[ $qty == "G" ]] || [[ $qty == "g" ]]
	then
		exit 1
	else
		clear
		echo "Invalid"
	fi
done

for ((i=1;i<=$qty;i=i+1))
do
	echo -n $1 >> cart_data
	echo -n ":" >> cart_data
	echo -n $name >> cart_data
	echo -n ":" >> cart_data
	echo -n $price >> cart_data
	echo "" >> cart_data
done
clear
echo "Item sucessfully added"

exit
