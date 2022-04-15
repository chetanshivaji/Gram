import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/myApp.dart';
import 'screens/registration_screen.dart';

import 'screens/in.dart';
import 'screens/out.dart';
import 'screens/pending.dart';
import 'screens/report.dart';
import 'screens/search_pending.dart';
import 'package:money/constants.dart';

import 'package:firebase_core/firebase_core.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:money/readFontsAssests.dart';
import 'screens/forgotPassword.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      // Replace with actual values
      options: FirebaseOptions(
        apiKey: "AIzaSyAxXZsweakuYy5HBQnsU5tmlUVq7rp4gzk",
        appId: "1:221118467263:android:93a0115c427c05eca94a0a",
        messagingSenderId: "221118467263",
        projectId: "gramtry-7a07a",
      ),
    );
    readFontsFromAssets();
  } catch (e) {
    print(e);
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appMainLabel,
      initialRoute: WelcomeScreen.id,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      routes: {
        MyApp.id: (context) => MyApp(),
        inMoney.id: (context) => inMoney(),
        outMoney.id: (context) => outMoney(),
        pendingMoney.id: (context) => pendingMoney(),
        reportMoney.id: (context) => reportMoney(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        searchScreen.id: (context) => searchScreen(),
        forgotPasswordScreen.id: (context) => forgotPasswordScreen(),
      },
    ),
  );
}
