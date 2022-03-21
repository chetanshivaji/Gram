# Grampanchyt
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
1. access and try false approval make it to one, only access dropdowns.
9. Make language independent add Marathi
1. save pdf locally/dont open, CC to admin also.
1. two times click on drawer.
1. Disable button after click
3. why search slow
7. sort as per collector sender.
1. admin app, no need of all details every year to fill, only
2. who wil notify
4. recyler tile
5. ternary operator Recycler list
6. First transcation no cc bug
8. forgot password implementation
9. if no entry in db no error.
10. change access level smartly
11. Check in registeration from main app, if village and pin exist.
2. Auto disapprove all users except admin. admin should approve users after certain period.
3. Subscrption implementation. stopping process at end of subscription period.
4. Detailed report at end of year.
2. security rules.
3. create indeices from firebase index tab.Half Done
3. Push upload receipt button for out transcation.
3. Bug fixes eg. return on mismatch password from registeration screen, corner cases, wrong input. no internet connectivity messages. pop messages correction .
5. Upload icon with proof of transcation for "in, out" pages. May be download icon in report page against each transcation. May need to use storage from firebase.
6. Section wise formula.
8. ios app testing on real ios device.
10. App version after clicking on info
17. Addtion of section health tax, & electricity maintaince tax etc.

# DONE
15. Date window for generating report for defined period by user.
7. Date wise display of records report.
1. After back button press clear search result
6. sort as per date. start end date.
5. search back clear search. reload page.
4. main app regsiteration error.
2. name of regsiterd user
2. date start and end selection
1. Pdf/excel downloading for pending and report page.
4. Multi year support.
11. Pending send notifcation.18. Notice send button for Pending entries 
12. Message support on both platforms - Normal msg & Whatsapp msg.
13. Receipts of payment.sendig pdf bill.
16. serach - single user all years display
1. organinze database, collection -> doc-> innerCollection.
2. Admin profile.
2. Seperate admin and main app.  Installing one should not uninstall other. 
3. Access control from admin to allow entry of getting involved in users of app.
1. Registeration of user for perticular grampanchayat.

Plan-

# TEST
1. Test correct functionality works.
2. Try with wrong inputs, empty inputs, try to put some inputs which will chagne functionality and behaviour of app.
3. Try using big numbers.
4. Think of Efficient UI(tables, button, ease of use, minimum clicks to do some functionality), 
5. multiple types of devices after rotating devices screen orientation.
6. Play, Tinker, Play, Tinker.
7. Ask why this why that while using app.





















DOCUMENTATION and BEHAVIOUR of app
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
	
