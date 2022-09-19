import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/routes.dart';

enum MenuAction { logout }

class MoodUpdate extends StatefulWidget {
  const MoodUpdate({Key? key}) : super(key: key);

  @override
  State<MoodUpdate> createState() => _MoodUpdateState();
}

class _MoodUpdateState extends State<MoodUpdate> {
  late final TextEditingController moodField;
  @override
  void initState() {
    moodField = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    moodField.dispose();
    super.dispose();
  }

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
        child: Column(
          children: [
            TextField(
              controller: moodField,
            ),
            ElevatedButton(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;
                  final db = FirebaseFirestore.instance;
                  final mood = moodField.text;
                  final data = {'mood':mood};
                  db.collection('users').doc(user?.email).set(data, SetOptions(merge: true));
                  
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    profileRoute,
                    (route) => false,
                  );
                },
                child: const Text("Update"))
          ],
        ),
      ),
    );;
  }
}



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
