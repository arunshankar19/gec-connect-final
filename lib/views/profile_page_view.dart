import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  'Bored'
];

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String holder = '';
  void getDropDownItem() {
    setState(() {
      holder = dropdownval;
    });
  }

  late final TextEditingController _bio;

  late final TextEditingController _mood;
  @override
  void initState() {
    _bio = TextEditingController();
    _mood = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _bio.dispose();
    _mood.dispose();
    super.dispose();
  }

  String dropdownval = item.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 112, 9, 1),
        title: const Text(
          'PROFILE',
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
      body: Container(
        color: Color.fromARGB(255, 156, 156, 156),
        child: SafeArea(
          child: Column(children: [
            SizedBox(
              height: 160,
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  "assets/user.png",
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Name",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(right: 300, left: 10),
              child: Container(
                height: 40,
                child: Text(
                  "Bio",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 2.5),
            Padding(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: Container(
                  height: 40,
                  child: Text("Hey there I am using GEC-CONNECT"),
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              onPressed: () {
                
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                height: 40,
                child: TextField(
                  controller: _mood,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your mood',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
                ),
              ),
            ),
            SizedBox(height: 2.5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              onPressed: () async {
                final mood = _mood.text;

                var db = FirebaseFirestore.instance;
                final user = FirebaseAuth.instance.currentUser;
                final email = user?.email;
                final userData = <String, dynamic>{'mood': mood};
                db.collection('user').doc(email).set(userData, SetOptions(merge: true));
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
            ),
            // Row(
            //   children: [
            //     // Padding(
            //     //   padding: const EdgeInsets.symmetric(horizontal: 100.0),
            //     //   child: Text(
            //     //     'Select your current mood',
            //     //     style: TextStyle(fontSize: 16.0),
            //     //   ),
            //     // ),
            //   ],
            // ),
            SizedBox(
              height: 2.5,
            ),
            // Container(
            //   height: 35,
            //   decoration: BoxDecoration(
            //       color: Colors.white, borderRadius: BorderRadius.circular(0)),
            //   child: DropdownButton<String>(
            //     value: dropdownval,
            //     items: item
            //         .map<DropdownMenuItem<String>>(
            //           (String value) => DropdownMenuItem(
            //             child: Text(
            //               value,
            //               style: TextStyle(fontSize: 15),
            //             ),
            //             value: value,
            //           ),
            //         )
            //         .toList(),
            //     onChanged: (String? value) {
            //       setState(() {
            //         dropdownval = value ?? dropdownval;
            //       });
            //     },
            //   ),
            // )
          ]),
        ),
      ),
    );
  }
}

// Dialog Bo print('$holder'); print('$holder');x

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
