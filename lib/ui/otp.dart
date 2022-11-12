import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thefirstone/ui/home.dart';
import 'package:thefirstone/ui/login.dart';
import 'package:thefirstone/ui/personal_details.dart';
import 'package:thefirstone/ui/profiles.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  OtpPage(this.phone);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _verificationID;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('OTP Verification Page'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Text(
                  'Verify +91-${widget.phone}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: PinPut(
                fieldsCount: 6,
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
                pinAnimationType: PinAnimationType.fade,
                onSubmit: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(
                      PhoneAuthProvider.credential(
                          verificationId: _verificationID!, smsCode: pin),
                    )
                        .then((value) async {
                      if (value.user != null) {
                        _checkForDetais(value.user!.uid);
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    //  _scaffoldKey.currentState
                    //  .showSnackBar(SnackBar(content: Text('Invalid OTP')));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _checkForDetais(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Profiles()),
                  // value.exists ? HomePage() : PersonalDetails()),
                  (route) => false)
            });
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await FirebaseAuth.instance
              .signInWithCredential(authCredential)
              .then((value) async {
            if (value.user != null) {
              _checkForDetais(value.user!.uid);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verID, int? forceCodeResend) {
          setState(() {
            _verificationID = verID;
          });
        },
        codeAutoRetrievalTimeout: (String verID) {
          setState(() {
            _verificationID = verID;
          });
        },
        timeout: Duration(seconds: 10));
  }

  // TODO initState() method
  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
