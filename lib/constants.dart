import 'package:flutter/material.dart';
import 'package:money/util.dart';

String titleSuccess = "Success";
String subtitleSuccess = "Submitted!";

String kTitleSuccess = "Login/registeration failed";
String kSubtitleSuccess = "Try again with correct username & password";
String kSubTitleEntryAlreadyPresent = "Entry already present, can not add";
String kTitlePresent = "PRESENT";
String kTitleNotPresent = "No Present";
String kSubTitleEmailPresent = "Email not present";
String kTitleSignOut = "SignOut";
String kSubtitleLogOutConfirmation = "Do you want to log out?";
String kTitleYetToApproveByAdmin = "Yet to be approved by Admin";
String kSubTitelYetToApproveByAdmin =
    "Try After sometime Or remind admin to approve.";

//Msgs
String msgOnlyNumber = "Please enter only numbers";
String msgEnterEmail = "Please Enter admin email";
String msgEnterUserMail = "Enter email";
String msgEnterPassword = "Please Enter min 6 char Password";
String msgReEnterPassword = "Please re enter password";
String msgEnterVillageName = 'Please enter village name';
String msgEnterVillagePin = 'Please enter village pin';
String msgEnterVillageAddress = 'Please enter village address';
String msgEnterMobileNumber = "Enter mobile Number";
String msgTenDigitNumber = "Please enter 10 digits!";
String msgEnterFullName = "Enter Full Name";
String msgEnterHouseTax = "Enter House tax";
String msgHouseTaxAmount = 'Please enter house tax amount';
String msgWaterTax = "Enter Water tax";
String msgProcessingData = 'Processing Data';
String msgAlreadyRemoved = "Allready Removed";
String msgToogleToApproveDis = "Toggle to approve/disapprove user";
String msgNoExpense = "There is no expense";
String msgLoading = "loading...";
String msgMoneySpendingReason = "Reason for spending money";
String msgMoneySpent = "Enter Money Spent";
String welcomeString = "Welcome! $userMail\n$access from $village $pin";

String msgNotAdmin = "notAdmin";
String msgInvoidBuildFail = "Something wrong in building INVOICE";
String msgNumberNotFoundInDb =
    "Please enter correct number/Number not found in database";

//button Labels
String bLabelAdminlogin = 'Admin Log In';
String bLabelAdminRegiter = 'Admin Register';
String bLabelSubmit = 'Submit';
String bLabelLogin = 'Log In';
String bLabelRegiter = 'Register';

//Drawer sections
String dAddEntry = 'addEntry';
String dRemoveEntry = 'removeEntry';
String dApprove = 'Approve';
String dHeading = 'Money Management';

String dIn = "In";
String dOut = "Out";
String dPending = "Pending";
String dReport = "Report";

//options pop up
String optCancel = "cancel";
String optOk = "OK";

//appLable
String appLabel = 'Gram Admin';
String appMainLabel = "Grampanchayat";
//activity type
String actPending = "PENDING";
String actIn = "IN";
String actOut = "OUT";
String actReport = "REPORT";

//Table data column heading
String tableHeadingEmail = 'Email';
String tableHeadingStatus = 'Status';
String tableHeadingAccess = 'Access';
String tableHeadingChangeStatus = 'ChangeStatus';
String tableHeadingName = 'Name';
String tableHeadingMobile = 'Mobile';
String tableHeadingAmount = 'Amount';
String tableHeadingDate = 'Date';
String tableHeadingUser = 'User';
String tableHeadingReason = 'Reason';
String tableHeadingExtraInfo = 'ExtraInfo';
String tableHeadingNotify = 'Notify';
String tableHeadingYear = "Year";
String tableHeadingHouse = "House";
String tableHeadingWater = "Water";

//String tableHeading = "";

//Form field Lable
String labelWaterTax = "Water Tax *";
String labelMobile = "Mobile *";
String labelAdminEmail = "AdminEmail *";
String labelEmail = "Mail * ";
String labelPassword = "Password *";
String labelAdminPassword = "AdminPassword *";
String labelVillage = "Village *";
String labelPin = "Pin *";
String labelVillageAddress = "VillageAddress *";
String labelRegister = 'Register';
String labelLogin = 'Log In';
String labelName = "Name *";
String labelAmount = "Amount *";
String labelReason = "Reason *";
String labelHouseTax = "House Tax *";
String labelExtraInfo = "Extra information";

//general Text
String txtSortingType = "Sorting type";
String txtCalculation = "Calculation";
String txtDownloadedByUser = "Downloaded by user";
String txtTaxType = "TaxType";
String equals = " = ";
String endL = "\n";
String txtLtoH = "L to H";
String txtHtoL = "H to L";
String txtSearchToolTip = "Search user tax paid details";
String txtForumlaIn = "InMoney";
String txtForumlaOut = "OutMoney";
String txtForumlaRemain = "RemainingMoney";
String txtDownloadPending = "Download pending";
String txtDownloadReport = "Download Report";
String txtNotifyToPay = "Send notification to Pay";
String txtName = "Name";
String txtFetchFailFromDb = "Fetch Fail From Db";
//collection strings
String collUsers = 'users';
String collFormula = 'formula';

//doc strings
String docVillageInfo = "villageInfo";
String docCalcultion = 'calculation';
String docMainDb = "mainDb";

//app bar heading
String appBarHeadingApproveRemove = "Approve/Remove";
String appBarHeadingInputInfo = "Add New Person to GramDB";
String appBarHeadingRemoveInfo = "Remove Person from GramDB";
String appBarMainAppInfo = 'Admin, Register, approve, make db';

//keys
String keyVillage = 'village';
String keyPin = 'pin';
String keyApproved = 'approved';
String keyAccessLevel = 'accessLevel';
String keyMail = 'mail';
String keyIsAdmin = 'isAdmin';
String keyAccess = "access";
String keyAddress = 'address';
String keyAdminMail = 'adminMail';
String keyHouse = 'house';
String keyHouseGiven = 'houseGiven';
String keyWater = 'water';
String keyWaterGiven = 'waterGiven';
String keyMobile = "mobile";
String keyName = "name";
String keyEmail = "email";
String keyTotalBalance = 'totalBalance';
String keyTotalIn = 'totalIn';
String keyTotalOut = 'totalOut';
String keyAmount = "amount";
String keyDate = "date";
String keyUser = "user";
String keyReason = "reason";
String keyExtraInfo = "extraInfo";

//String key = "";

String scafBeginInfoApproveRemove =
    "Please approve or remove clicking toggle icon";

//From util oldies
String registerSubtitleSuccess = "Register success!";
String registerSuccess = "Admin and village regsitered successfully";
String kTitleFail = "Login/registeration failed";
String kSubtitleFail = "Try again with correct username & password";
String kTitleLoginSuccess = "login success";
String kSubTitleLoginSuccess = "login success";
String kSubTitleOnlyAdmin = "Only Admin allowed";
String titlePasswordMismatch = "Password mismatch";
String subtitlePasswordMismatch =
    "password and re entered password should match";

String kTitleEntryRemoved = "Entry Removed";

String tableHeadingFontFamily = "RobotoMono";
String labelYear = "Year";

//////////////////////////Oring consts.
String kTitleRegisterationSuccess = "Registered";
String kSubTitleRegisterationSuccess =
    "You are registered wait for admin to approve.";

String kTitleRegisterationFailed = "Registeration Fail";

String titlePassMismatch = "Password mismatch";
String subtitlePassMismatch = "passwrod and re entered password should match";

String housePendingType = "houseGiven";
String waterPendingType = "waterGiven";

String paidMsg = "Paid already";

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
