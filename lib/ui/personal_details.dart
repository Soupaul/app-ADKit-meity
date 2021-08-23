import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thefirstone/widgets/custom_clipper.dart';

import 'home.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController? _firstnameController;
  TextEditingController? _secondnameController;
  // TextEditingController? _ageController;
  DateTime? _selectedDate;
  String dropdownValue = 'Male';

  @override
  void initState() {
    _firstnameController = TextEditingController(text: "");
    _secondnameController = TextEditingController(text: "");
    // _ageController = TextEditingController(text: "");

    super.initState();
  }

  void createRecord(String fn, String sn, String dob) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'first_name': fn,
      'second_name': sn,
      'dob': dob,
      'gender': dropdownValue
    }).then((value) => {after()});
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year - 1, 12, 31),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  void after() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Data saved')));
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: AssetImage("assets/login.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: TextField(
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  keyboardType: TextInputType.name,
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    fillColor: Colors.orange.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    labelText: 'First name',
                    labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  keyboardType: TextInputType.name,
                  controller: _secondnameController,
                  decoration: InputDecoration(
                    fillColor: Colors.orange.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    labelText: 'Last name',
                    labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? "Select your Date of Birth"
                        : "${_selectedDate!.toLocal()}".split(' ')[0]),
                    // Expanded(
                    //   child: TextField(
                    //     maxLength: 3,
                    //     cursorColor: Colors.black,
                    //     style: TextStyle(fontSize: 18.0, color: Colors.black),
                    //     keyboardType: TextInputType.number,
                    //     controller: _ageController,
                    //     decoration: InputDecoration(
                    //       fillColor: Colors.orange.withOpacity(0.1),
                    //       filled: true,
                    //       border: OutlineInputBorder(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(20.0))),
                    //       labelText: 'Age',
                    //       labelStyle:
                    //           TextStyle(fontSize: 16.0, color: Colors.black),
                    //       prefixIcon: Icon(
                    //         Icons.date_range,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    FlatButton(
                      minWidth: 0,
                      onPressed: () => _selectDate(context),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Theme.of(context).accentColor,
                      splashColor: Theme.of(context).accentColor,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.date_range,
                          size: 30.0,
                          color: Color(0xFFBF828A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Select your gender"),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(
                        color: Color(0xFFBF828A),
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xFFBF828A),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female', 'Others']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        splashColor: Color(0xFFBF828A),
                        color: Color(0xFFBF828A),
                        child: new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            new Expanded(
                              child: Container(),
                            ),
                            new Transform.translate(
                              offset: Offset(15.0, 0.0),
                              child: new Container(
                                padding: const EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 5.0,
                                  right: 10.0,
                                ),
                                child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(28.0)),
                                    splashColor: Colors.white,
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFFBF828A),
                                    ),
                                    onPressed: () async {
                                      if (_selectedDate == null ||
                                          _firstnameController!.text.isEmpty ||
                                          _secondnameController!.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Fill your information correctly')));
                                      } else {
                                        createRecord(
                                            _firstnameController!.text,
                                            _secondnameController!.text,
                                            _selectedDate!
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]);
                                      }
                                    }),
                              ),
                            )
                          ],
                        ),
                        onPressed: () async {
                          if (_selectedDate == null ||
                              _firstnameController!.text.isEmpty ||
                              _secondnameController!.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Fill your information correctly')));
                          } else {
                            createRecord(
                                _firstnameController!.text,
                                _secondnameController!.text,
                                _selectedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
