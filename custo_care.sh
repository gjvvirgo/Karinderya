#! /bin/bash 
#This is the customer care section 
page1() 
{
echo -n "we care," 
toilet "customer" 
toilet "care"
echo "Frequently Ask Questions (FAQs)" 
echo "FAQ 1: 30 What is Karinderya? " 
echo -e "\t-- Please go to About Us section. Thanks fam! \n" 
echo "FAQ 2: How can I join?" 
echo -e "\t-- First successfully register in the system. But I guess you already had since you're already logged in! \n" 
} 
page2() 
{ 
echo "FAQ 3: What types of food do you have?" 
echo -e "\t-- We offer a wide range of food that are freshly prepared in every order. Our ever growing menu is created by chefs from around the globe. \n" 
echo "FAQ 4: What are your methods of payment?" 
echo -e "\t-- As of right now, we accept credit and debit cards but rest assured that we are working our best to offer cash on delivery. \n" 
echo -e "\n\n\n" 
echo "FAQ 5: What time do you open?" 
echo -e "\t-- We are open from 9am to 11pm Mondays to Saturday and Holidays \n" 
echo "FAQ 6: What time will my food arrive?" 
echo -e "\t-- It depends on the quantity of the order and your distance from physical store. Fam naman \n"  
echo "FAQ 7: How do I exit the program?" 
echo -e "\t-- It is advisable to logout first and then choose exit but ctrl + C will also do that trick lodi \n" 
echo "FAQ 8: What vehicle do you use?" 
echo -e "\t-- We use different methods of transpo fam, don't worry your food will sure be delivered to you clean and safely. \n" 
} 
contact() 
{ 
toilet "Contact Us. Pls." 
echo -e "\n\n\n\n" 
echo -e "If you need further assistance you can contact us at:" 
echo -e "\t\t-- +639123456789 (Globe/ TM)" 
echo -e "\t\t-- karinderya@lamon.ph (Email) " 
} 
clear
page1 
loc=0 
while ((loc==0)) 
do 
	echo -e "(1) Proceed to first page \t (2) Proceed to second page \n(3) Contact Details \t\t (4) Go BacK"
	read choi
	case $choi in
	1)
		clear
		page1
	;; 2)
		clear
		page2
	;; 3)
		clear
		contact
	;; 4)
		exit
	;; esac
done
