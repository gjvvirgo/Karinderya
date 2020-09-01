#!/bin/bash
#This is the main menu
uid="$(cat tmp2|cut -d: -f2)"
if ((uid!=0))
then
loc=1
while ((loc!=0))
do
	echo "Welcome to the main menu"
	echo "Enter the letter of the action you want to do"
	echo "(a) Search"
	echo "(b) Highlights"
	echo "(c) New!"
	echo "(d) Cart"
	echo "(e) Profile"
	echo "(f) About Us"
	echo "(g) Customer Care"
	echo "(h) Logout"
	echo -n "Choice: "
	read number
	case $number in
		a|A)
			search.sh 
			clear
		;; B|b)
			highlights.sh
			clear
		;; C|c)
			new.sh
			clear
		;; D|d)
			cart.sh
			clear
		;; E|e)
			profile.sh
			clear
		;; F|f)
			about_us.sh
			clear
		;; G|g)
			custo_care.sh
			clear
		;; H|h)
			exit 2
			loc=0
		;; *)
			clear
			echo "Invalid"
	;; esac
done
fi

if ((uid==0))
then
loc=1
while ((loc!=0))
do
	echo "Welcome Back Admin!"
	echo "Enter the letter of the action you want to do"
	echo "(a) Add Item"
	echo "(b) View/ Edit/ Delete Item"
	echo "(c) Set Highlights"
	echo "(d) Change password"
	echo "(e) Logout"
	echo -n "Choice: "
	read number
	case $number in
		a|A)
			add_item.sh
			clear
		;; B|b)
			item_control.sh
			clear
		;; C|c)
			set_highligts.sh
			clear
		;; D|d)
			password.sh
			clear	
		;; E|e)
			exit 2
			loc=0
		;; *)
			clear
			echo "Invalid"
	;; esac
done
fi
exit
	
