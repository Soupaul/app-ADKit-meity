import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:thefirstone/ui/home.dart';
import 'package:thefirstone/ui/personal_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../resources/api.dart';

class Profiles extends StatefulWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  // List list = [];
  bool isLoaded = false;
  late List<Map<String, String>> genderList;

  String getGender(String val) {
    for (var item in genderList) {
      if (item['value'] == val) {
        return item['key']!;
      }
    }
    return "";
  }

  // Future _fetchList() async {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("profiles")
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     setState(() {
  //       isLoaded = true;
  //       list = querySnapshot.docs;
  //     });

  //     list.forEach((element) {
  //       print(element.id);
  //     });
  //   });
  // }

  Widget getProfileView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            AppLocalizations.of(context)!.profiles,
            style: TextStyle(
              // color: Color(0xFFBF828A),
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("profiles")
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) => snapshot
                        .connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFBF828A),
                      ),
                    ),
                  )
                : snapshot.hasData && snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var list = snapshot.data!.docs;
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                              API.profileData = list[index];
                              API.current_profile_id = list[index].id;
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 3.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${list[index]['first_name']} ${list[index]['second_name']}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "${AppLocalizations.of(context)!.gender}: ${getGender(list[index]['gender'])}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "${AppLocalizations.of(context)!.dob}: ${list[index]['dob']}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ]),
                                    IconButton(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .deleteProfile),
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .sure),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction((Transaction
                                                            myTransaction) async {
                                                      myTransaction.delete(
                                                          list[index]
                                                              .reference);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color(
                                                                0xFFBF828A)),
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .yes,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color(
                                                                0xFFBF828A)),
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .no,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : const Center(
                        child: Text("No data found"),
                      ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // _fetchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    genderList = [
      <String, String>{
        "key": AppLocalizations.of(context)!.male,
        "value": "Male"
      },
      <String, String>{
        "key": AppLocalizations.of(context)!.female,
        "value": "Female"
      },
      <String, String>{
        "key": AppLocalizations.of(context)!.others,
        "value": "Others"
      }
    ];
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: getProfileView(),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              ),
              backgroundColor: MaterialStateProperty.all(
                const Color(0xFFBF828A),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.addProfile,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalDetails()),
                  // value.exists ? HomePage() : PersonalDetails()),
                  (route) => false);
            },
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.all(8),
        //   child: ElevatedButton(
        //     style: ButtonStyle(
        //       shape: MaterialStateProperty.all(
        //         RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12.0),
        //         ),
        //       ),
        //       padding: MaterialStateProperty.all(
        //         const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        //       ),
        //       backgroundColor: MaterialStateProperty.all(
        //         const Color(0xFFBF828A),
        //       ),
        //     ),
        //     child: Text(
        //       AppLocalizations.of(context)!.deleteProfile,
        //       style: const TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //     onPressed: () async {

        //     },
        //   ),
        // )
      ]),
    ));
  }
}
