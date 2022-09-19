import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/routes.dart';

enum MenuAction { logout, backtomap }

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

                case MenuAction.backtomap:
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(backtomap, (route) => false);
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.backtomap, child: Text('Back to Map')),
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Sign Out')),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: getCurUserBio(),
          builder: (context, snapshot) {
            return Container(
              color: Color.fromARGB(255, 220, 220, 220),
              child: SafeArea(
                child: Column(children: [
                  SizedBox(
                    height: 150,
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
                      snapshot.data?['name'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 100, left: 100, bottom: 7),
                    child: Container(
                      child: Text(
                        "Bio",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 96, 96, 96)),
                      ),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(right: 10, left: 10, bottom: 7),
                      child: Container(
                        child: Text(
                          snapshot.data?['bio'] ??
                              'Hey there I am using GEC Connect',
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ],
                    ),
                    height: 22,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () async {
                        //await getCurUserData();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            bioUpdateRoute, (route) => false);
                      },
                      child: Text(
                        'Update',
                        style: GoogleFonts.openSans(
                            color: Color.fromARGB(255, 112, 9, 15),
                            fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 100, left: 100, bottom: 7),
                    child: Container(
                      child: Text(
                        "Mood",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 96, 96, 96)),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5),
                  Padding(
                      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                      child: Container(
                        child: Text(
                          snapshot.data?['mood'] ?? "Please update your mood",
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ],
                    ),
                    height: 22,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            moodUpdate, (route) => false);
                      },
                      child: Text(
                        'Update',
                        style: GoogleFonts.openSans(
                            color: Color.fromARGB(255, 112, 9, 1),
                            fontSize: 12),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 2.5,
                  ),
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 100,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                              )
                            ],
                          ),
                          height: 22,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () async {
                              var db = FirebaseFirestore.instance;

                              final cu =
                                  FirebaseAuth.instance.currentUser?.email;
                              final logoutVal =
                                  await showDialogeLocAcc(context);

                              if (logoutVal) {
                                final data = {'key': 1};
                                db
                                    .collection('users')
                                    .doc(cu)
                                    .set(data, SetOptions(merge: true));
                              } else {
                                final data = {'key': 2};
                                db
                                    .collection('users')
                                    .doc(cu)
                                    .set(data, SetOptions(merge: true));
                              }
                            },
                            child: Text(
                              'Location Access',
                              style: GoogleFonts.openSans(
                                  color: Color.fromARGB(255, 112, 9, 1),
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
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
            );
          }),
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

Future<Map<String, dynamic>> getCurUserBio() async {
  final db = FirebaseFirestore.instance;
  final cu = FirebaseAuth.instance.currentUser?.email;
  final locRef =
      await db.collection('users').where('email', isEqualTo: cu).get();
  final data1 = locRef.docs.map((doc) => doc.data()).toList();
  final data = locRef.docs.map((doc) => doc.data()).toList()[0];
  // final data2 = data['bio'];
  // print(data['bio']);
  return data;
}

Future<bool> showDialogeLocAcc(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Location Access',
        style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
      ),
      content: const Text('Choose location access preference'),
      actions: [
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            highlightColor: Color.fromARGB(255, 137, 10, 1),
            child: const Text('Disable')),
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            highlightColor: Color.fromARGB(255, 137, 10, 1),
            child: const Text('Enable'))
      ],
    ),
  ).then((value) => value ?? false);
}
