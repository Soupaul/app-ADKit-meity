import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thefirstone/ui/login.dart';
import 'package:thefirstone/widgets/custom_clipper.dart';

class SelectLan extends StatefulWidget {
  const SelectLan({Key? key}) : super(key: key);

  @override
  _SelectLanState createState() => _SelectLanState();
}

class _SelectLanState extends State<SelectLan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: AssetImage("assets/login.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "Select Language",
                  style: TextStyle(
                    color: Color(0xFFBF828A),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFc9adab)),
                child: Center(
                  child: Text(
                    "English",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFBF828A)),
                child: Center(
                  child: Text(
                    "हिंदी",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
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
                                "GO TO LOGIN PAGE",
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
                                      Colors.white,
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.white,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFFBF828A),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
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
                              builder: (context) => LoginPage()));
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
