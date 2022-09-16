import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/routes.dart';

enum MenuAction { logout }

enum MoodDropDown {
  happy,
  sad,
  depressed,
  angry,
  gloomy,
  excited,
  borred,
  smileInPain
}

List<String> item = [
  'Happy',
  'Sad',
  'Depressed',
  'Angry',
  'Gloomy',
  'Excited',
  'Borred'
];

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String dropdownval = item.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 112, 9, 1),
        title: const Text(
          'GEC CONNECT',
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final logoutVal = await showDialogeLogout(context);
                  // devtools.log(logoutVal.toString());
                  if (logoutVal) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Sign Out')),
              ];
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Profile',
              style: GoogleFonts.openSans(),
            ),
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: 100,
              height: 60,
              child: ClipOval(
                child: Image.asset(
                  "assets/user.png",
                ),
              ),
            ),
          ),
          Center(
            child: Text("Name"),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                'Mood',
              ),
            ],
          ),
          DropdownButton<String>(
            value: dropdownval,
            elevation: 0,
            items: item
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              setState(() {
                dropdownval = value ?? dropdownval;
              });
            },
          )
        ]),
      ),
    );
  }
}

// Dialog Box

Future<bool> showDialogeLogout(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'SIGN OUT',
        style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
      ),
      content: const Text('Are you sure you want to Sign Out?'),
      actions: [
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            highlightColor: Color.fromARGB(255, 137, 10, 1),
            child: const Text('Cancel')),
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            highlightColor: Color.fromARGB(255, 137, 10, 1),
            child: const Text('Sign Out'))
      ],
    ),
  ).then((value) => value ?? false);
}
