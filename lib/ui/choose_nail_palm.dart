import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              child: Text(AppLocalizations.of(context)!.appType,
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
                  child: Text(AppLocalizations.of(context)!.appTypeQ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      )),
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
                          onTap: () {
                            Navigator.of(context).pop('nail');
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              color: Theme.of(context).accentColor,
                              padding: EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/nail-clipper.png',
                                height: 60,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(AppLocalizations.of(context)!.nail,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop('palm');
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              color: Theme.of(context).accentColor,
                              padding: EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/hello.png',
                                height: 60,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(AppLocalizations.of(context)!.palm,
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
