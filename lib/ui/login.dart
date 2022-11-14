import 'package:flutter/material.dart';
import 'package:thefirstone/ui/home.dart';
import 'package:thefirstone/ui/personal_details.dart';
import 'package:thefirstone/widgets/custom_clipper.dart';
import '../utils/firebase_auth.dart';
import 'otp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _controller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                    ),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      image: AssetImage("assets/login.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFFBF828A),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                /*Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 30.0,
                        width: 1.0,
                        color: Colors.grey.withOpacity(0.5),
                        margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                      ),
                      new Expanded(
                        child: TextField(
                          controller: _emailController,
                          cursorColor: Color(0xFFBF828A),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Password",
                    style: TextStyle(
                      color: Color(0xFFBF828A),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextField(
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    decoration: InputDecoration(
                      fillColor: Colors.orange.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      labelText: 'Phone Number',
                      labelStyle:
                          TextStyle(fontSize: 16.0, color: Colors.black),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.black,
                      ),
                      prefix: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('+91'),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                            overlayColor: MaterialStateProperty.all(
                              const Color(0xFFBF828A),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFBF828A),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Transform.translate(
                                offset: Offset(15.0, 0.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 5.0,
                                    right: 10.0,
                                  ),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28.0)),
                                      ),
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFFBF828A),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtpPage(_controller!.text)),
                                      );
                                      /*bool res =
                                          await AuthProvider.signInWithEmail(
                                              _emailController.text,
                                              _passwordController.text);
                                      if (!res) {
                                        print("Login failed");
                                      }*/
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    OtpPage(_controller!.text)));
                            // HomePage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                /* Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          splashColor: Colors.redAccent,
                          color: Colors.redAccent,
                          // splashColor: Color(0xFFBF828A),
                          // color: Color(0xFFBF828A),
                          child: new Row(
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "LOGIN WITH GOOGLE",
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
                                    child: Image(
                                      image: AssetImage("assets/google-plus.png"),
                                      height: 28.0,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () async {
                                      bool res =
                                          await AuthProvider.loginWithGoogle();
                                      if (!res)
                                        print("error logging in with google");
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          onPressed: () async {
                            bool res = await AuthProvider.loginWithGoogle();
                            if (!res) print("error logging in with google");
                          },
                        ),
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
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            alignment: Alignment.center,
                            child: Text(
                              "DON'T HAVE AN ACCOUNT?",
                              style: TextStyle(color: Color(0xFFBF828A)),
                            ),
                          ),
                          onPressed: () => {
                           
                          },
                        ),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
