import 'package:flutter/material.dart';
import 'package:money/screens/search_pending.dart';
import 'package:money/util.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'in.dart';
import 'out.dart';
import 'pending.dart';
import 'report.dart';

class MyApp extends StatelessWidget {
  static String id = "myappscreen";
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grampanchyat'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchScreen.id);
            },
            tooltip: "Search user tax paid details",
            icon: Icon(Icons.search),
          ),
          IconButton(
            tooltip: "Log out",
            onPressed: () {
              popLogOutAlert(context, "SignOut", "Do you want to log out?",
                  Icon(Icons.power_settings_new));
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: Center(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            width: 20.0,
            height: 100.0,
          ),
          const Text(
            '',
            style: TextStyle(fontSize: 43.0),
          ),
          const SizedBox(
            width: 20.0,
            height: 100.0,
          ),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 40.0,
              fontFamily: 'Canterbury',
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                ScaleAnimatedText('TRUST'),
                ScaleAnimatedText('TRUTH'),
              ],
            ),
          ),
        ],
      )),
      drawer: Drawer(
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
                    'Money Management',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.yellow,
                    ),
                  ), //gree
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('In'),
              tileColor: clrGreen, //green
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                String access = await getUserAccessLevel(context, userMail);
                if (access == accessItems[accessLevel.Collector.index] ||
                    access == accessItems[accessLevel.SuperUser.index])
                  Navigator.pushNamed(context, inMoney.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.outbond_outlined),
              title: Text('Out'),
              tileColor: clrRed, //red
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                String access = await getUserAccessLevel(context, userMail);
                if (access == accessItems[accessLevel.Spender.index] ||
                    access == accessItems[accessLevel.SuperUser.index])
                  Navigator.pushNamed(context, outMoney.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.pending_actions),
              title: Text('Pending'),
              tileColor: clrAmber, //amber
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                String access = await getUserAccessLevel(context, userMail);
                if (access == accessItems[accessLevel.Spender.index] ||
                    access == accessItems[accessLevel.Collector.index] ||
                    access == accessItems[accessLevel.SuperUser.index] ||
                    access == accessItems[accessLevel.Viewer.index])
                  Navigator.pushNamed(context, pendingMoney.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Report'),
              tileColor: clrBlue, //amber
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                String access = await getUserAccessLevel(context,
                    userMail); //admin can change access rights for user any time, although logged in.
                if (access == accessItems[accessLevel.Spender.index] ||
                    access == accessItems[accessLevel.Collector.index] ||
                    access == accessItems[accessLevel.SuperUser.index] ||
                    access == accessItems[accessLevel.Viewer.index])
                  Navigator.pushNamed(context, reportMoney.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
