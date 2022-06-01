import 'package:flutter/material.dart';
import 'package:money/screens/search_pending.dart';
import 'package:money/util.dart';
import 'in.dart';
import 'out.dart';
import 'pending.dart';
import 'report.dart';
import 'package:money/constants.dart';

import 'package:provider/provider.dart';
import 'package:money/l10n/l10n.dart';
import 'package:money/provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    gContext = context;
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 5),
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);

            return DropdownMenuItem(
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (langChanged) async {
          //set language in firebase db to use for next launch of app.
          String userAppLang = "en";
          if (langChanged == Locale('en')) {
            userAppLang = "en";
          }
          if (langChanged == Locale('mr')) {
            userAppLang = "mr";
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(keyUserAppLanguage,
              userAppLang); //write on disk in key value format.
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  static String id = "myappscreen";
  bool drawerOpen = false;
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    gContext = context;
    void handleClick(String value) {
      int caseNum = 0;

      if (AppLocalizations.of(gContext)!.kTitleSignOut == value) {
        caseNum = 1;
      }

      switch (1) {
        case 1:
          popLogOutAlert(
            context,
            AppLocalizations.of(gContext)!.kTitleSignOut,
            AppLocalizations.of(gContext)!.kSubtitleLogOutConfirmation,
            Icon(Icons.power_settings_new),
          );
          break;
      }
    }

    return WillPopScope(
      onWillPop: () {
        if (drawerOpen == true) {
          Navigator.pop(context);
        }

        popLogOutAlert(
          context,
          AppLocalizations.of(gContext)!.kTitleSignOut,
          AppLocalizations.of(gContext)!.kSubtitleLogOutConfirmation,
          Icon(Icons.power_settings_new),
        );
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        onDrawerChanged: (isOpen) {
          drawerOpen = isOpen;
        },
        /*
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.language,
            style: TextStyle(
              fontSize: 45.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        */
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appMainLabel),
          actions: <Widget>[
            LanguagePickerWidget(),
            IconButton(
              splashColor: clrIconSpalsh,
              splashRadius: iconSplashRadius,
              onPressed: () {
                Navigator.pushNamed(context, searchScreen.id);
              },
              tooltip: AppLocalizations.of(gContext)!.txtSearchToolTip,
              icon: Icon(Icons.search),
            ),
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                gContext = context;
                return {AppLocalizations.of(gContext)!.kTitleSignOut}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Stack(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        "assets/success.jpeg",
                      ),
                    ),
                    Text(
                      AppLocalizations.of(gContext)!.dHeading,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.yellow,
                      ),
                    ), //gree
                  ],
                ),
              ),
              ListTile(
                shape: getListTileShapeForDrawer(),
                leading: Icon(Icons.add_box),
                //title: Text(dIn),
                title: Text(
                  AppLocalizations.of(context)!.dIn,
                ),
                tileColor: clrGreen, //green
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  if (onPressedDrawerIn == false) {
                    onPressedDrawerIn = true;
                    int access = await getUserAccessLevel(context, userMail);

                    if ((access == accessLevel.Collector.index ||
                        access == accessLevel.SuperUser.index)) {
                      Navigator.pushNamed(context, inMoney.id);
                    } else {
                      onPressedDrawerIn = false;
                    }
                  }
                },
              ),
              ListTile(
                shape: getListTileShapeForDrawer(),
                leading: Icon(Icons.outbond_outlined),
                title: Text(AppLocalizations.of(context)!.dOut),
                tileColor: clrRed, //red
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  if (onPressedDrawerOut == false) {
                    onPressedDrawerOut = true;
                    int access = await getUserAccessLevel(context, userMail);

                    if ((access == accessLevel.Spender.index ||
                        access == accessLevel.SuperUser.index)) {
                      Navigator.pushNamed(context, outMoney.id);
                    } else {
                      onPressedDrawerOut = false;
                    }
                  }
                },
              ),
              ListTile(
                shape: getListTileShapeForDrawer(),
                leading: Icon(Icons.pending_actions),
                title: Text(AppLocalizations.of(context)!.dPending),
                tileColor: clrAmber, //amber
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  if (onPressedDrawerPending == false) {
                    onPressedDrawerPending = true;
                    int access = await getUserAccessLevel(context, userMail);

                    if ((access == accessLevel.Spender.index ||
                        access == accessLevel.Collector.index ||
                        access == accessLevel.SuperUser.index ||
                        access == accessLevel.Viewer.index)) {
                      Navigator.pushNamed(context, pendingMoney.id);
                    } else {
                      onPressedDrawerPending = false;
                    }
                  }
                },
              ),
              ListTile(
                shape: getListTileShapeForDrawer(),
                leading: Icon(Icons.report),
                title: Text(AppLocalizations.of(context)!.dReport),
                tileColor: clrBlue, //amber
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  if (onPressedDrawerReport == false) {
                    onPressedDrawerReport = true;
                    int access = await getUserAccessLevel(context,
                        userMail); //admin can change access rights for user any time, although logged in.

                    if ((access == accessLevel.Spender.index ||
                        access == accessLevel.Collector.index ||
                        access == accessLevel.SuperUser.index ||
                        access == accessLevel.Viewer.index)) {
                      Navigator.pushNamed(context, reportMoney.id);
                    } else {
                      onPressedDrawerReport = false;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
