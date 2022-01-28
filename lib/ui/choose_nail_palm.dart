import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NailOrPalm extends StatefulWidget {
  const NailOrPalm({Key? key}) : super(key: key);

  @override
  _NailOrPalmState createState() => _NailOrPalmState();
}

class _NailOrPalmState extends State<NailOrPalm> {
  var height;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Text("Hi,\nWelcome to Adkit",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(25),
            ),
            Column(
              children: [
                SizedBox(
                  height: height * 0.15,
                ),
                Container(
                  child: Text("Which app type do you want to use?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      )),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(25),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Card(
                            elevation: 10,
                            child: Container(
                              color: Theme.of(context).accentColor,
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.videocam,
                                color: Color(0xFFBF828A),
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Nail",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Card(
                            elevation: 10,
                            child: Container(
                              color: Theme.of(context).accentColor,
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.videocam,
                                color: Color(0xFFBF828A),
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Palm",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
