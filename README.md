# Grampanchayat
##########################################################
This is android app flutter project for use case of multiusers of small governing organization like Grampanchyat, school, NGO, hospital etc. includes.
1. Finance, money management.
     - to Keep track of money in out, report generation, tracking pending money.
 
 
In future developement.
1. Notice board.
2. Discussion forum and poll.
3. Anonymous complain box system.
4. Closed group buy sale system.




# TODO
0. create videos for B 
2. send upi reqest link to Cu, if they want to send money through UPI.
3. create log file with time who what details. for debug purpose when problem arrise.
4. give db dump to GP, perodically.
5. what could stop and whats plan B.
6. Think of places, to not give all rights to one person as he/she can misuse it.
1. year wise formula per village - formula2021 formula2022 formula2023. Already, Super Total on Top. Each Formula2021  Total / Pending / In / Out / Remain / Percent collected.
3. email failures on Siddhaths samsung mobile model.
4. Make status in approve seciton only one dropdown.
9. why search slow
10. sort as per collector sender.
12. who wil notify
13. recyler tile
14. ternary operator Recycler list
17. if no entry in db no error.

20. Auto disapprove all users except admin. admin should approve users after certain period.
21. Subscrption implementation. stopping process at end of subscription period.
22. Detailed report at end of year.
23. security rules.
24. create indeices from firebase index tab.Half Done
25. Push upload receipt button for out transcation.
26. Bug fixes eg. return on mismatch password from registeration screen, corner cases, wrong input. no internet connectivity messages. pop messages correction .
27. Upload icon with proof of transcation for "in, out" pages. May be download icon in report page against each transcation. May need to use storage from firebase.
28. Section wise formula.
29. ios app testing on real ios device.
40. App version after clicking on info
31. horizontal scrolling feature, Addtion of section health tax, & electricity maintaince tax etc.

# DONE
19. Check in registeration from main app, if village and pin exist.
5. Make language independent add Marathi, make all words in app Marathi, then make change language option.
1. send videos link to C when added person in inputGram admin app or with pending msg.
1. make video for C(Emphasize getting ack message), type letter of approval from Grampanchayat, 
18. change access level smartly
16. forgot password implementation
15. First transcation no cc bug
11. admin app, no need of all details every year to fill, only
8. Disable button after click
7. two times click on drawer.
6. save pdf locally/dont open, CC to admin also.
1. pending Magani Pawati. after clicking on alram pending button.
2. update mail & Phone.
3. email bug. / first  transcation then email.
4. locally downlaod receipts.
5. Auto email and name in add person.
6. Date window for generating report for defined period by user.
7. Date wise display of records report.
8. After back button press clear search result
9. sort as per date. start end date.
10. search back clear search. reload page.
11. main app regsiteration error.
12. name of regsiterd user
13. date start and end selection
14. Pdf/excel downloading for pending and report page.
15. Multi year support.
16. Pending send notifcation.18. Notice send button for Pending entries 
17. Message support on both platforms - Normal msg & Whatsapp msg.
18. Receipts of payment.sendig pdf bill.
19. serach - single user all years display
20. organinze database, collection -> doc-> innerCollection.
21. Admin profile.
22. Seperate admin and main app.  Installing one should not uninstall other. 
23. Access control from admin to allow entry of getting involved in users of app.
24. Registeration of user for perticular grampanchayat.


# TEST
1. Test correct functionality works.
2. check if any functionality can be misused to trick people.
3. Try with wrong inputs, empty inputs, try to put some inputs which will chagne functionality and behaviour of app.
4. Try using big numbers.
5. Think of Efficient UI(tables, button, ease of use, minimum clicks to do some functionality), 
6. multiple types of devices after rotating devices screen orientation.
6. Play, Tinker, Play, Tinker.
7. Ask why this why that while using app.






# ON FIELD EFOORTS
1. collect phone and mail ID, Grampanchyat mail id as admin mail ID.
1. Enter 2021 register to see behaviour	



# DOCUMENTATION and BEHAVIOUR of app
Please tets basic functionality
two apps admin, mainGram.
1. admin.apk -> register-> admin onboards village with pin his own info.
	a. admin can add person from village to db and remove. admin created database by entering entire village people info.
	b. admin can select years.
	c. approve section in drawer -> admin can approve by giving access rights like, collector, spender, viewer, superuser from dropdown. 
	d. Or admin keeps away users by selecting "NO"
	e. admin can change reigstered users access right in real time.
	
2. mainGram.apk
	a. all users(helpers) to admin register by their info, and admin village and pin, case insensetive, and spelling has to be same as admin village. to join group.
	b. after admin approves from admin app, user can login.
	c. as per access rights from admin, user can click functionality.
	d. In - take tax, Out - spend money. pending- you can see list of pending tax people. option like years, High to Low, low TO High 
	e. Report - check report, formula IN ouT remaining money, who collected money and time, who spent, select date range to filter entries.
	f. You can download pending list and report list from download down arrow button.
	g. Peding page, by clicking alarm symbol, you can send reminder notification to people to pay pending tax amount.
	h. In page, after submit text message and received recipt is sent on mail to payer, and carbon copy to admin.
	






*********-------------------*******---------****---*----------------************
# TECHNICAL PENDING.
1. mobile number should not start with zero.
2. marathi multi language in pdf.
1. make super admin app. to view In Out Remaining of all villages
2. Main app changes to support super admin app
3. Test extensively.
4. Language Multi - Marathi addition
5. UI improvement
6. auto email send
7. add and test 200 names.
8. Try to refactor code and reduce apk size.
9. take input from admin for google pay num and send in pending message.
10. Multi mobile tests.
11. Password change provision.
12. Change icons for both apps.
13. Upload on google play, let it go through security checks of google
14. Create controller poratl(app). to view all analytics, numbers for control/monitor/payment purpose.
15. Suggesting village names depending on taluka and districts.
16. Check on IOs phone.


*********-------------------*******---------****---*----------------************
# MARKETING AND EXECUTION
1. company formation ->? to get money. 10 days 10k rs.
2. Make video.? for educating people and Gram employes.
3. revenue model.
4. presentation preperation.
5. Give presentation.
6. Growth and app distribution model.
7. Training/communication/ feedback model.
8. Launching steps.
9. Filed study and data collection.
	a. Collect phone and mail. Hire two people Or ask people to message by requesting on  Whats app group.
	b. Make entry in app. 2020, 2021.
	c. With 2020-21 data in hand To random people -> 
		1. Send pending message/Pending receipt, 
		2. Send make IN entries, simulate taking Home tax/water tax. Go to field for 20 entries.
	d. Have Report ready from this experiement.
	e. Find platfrom and way to marketing, and way to distribute.
*********-------------------*******---------****---*----------------************

