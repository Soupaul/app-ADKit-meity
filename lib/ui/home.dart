import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
// run with `flutter run --no-sound-null-safety` for testing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customgauge/customgauge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thefirstone/resources/api.dart';
import 'package:thefirstone/ui/form.dart';
import 'package:thefirstone/ui/login.dart';
import 'package:thefirstone/ui/trend_graph.dart';

import 'firestore_form.dart';
// import '../utils/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _currentVideo;
  var height, width;
  String? downUrl;
  ImagePicker _imagePicker = ImagePicker();
  UploadTask? _uploadTask;
  bool? isPregnant;
  DocumentSnapshot? userData;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        // .doc('jMYSw3V8EIUgQd4bKdMivxO4Zvd2')
        .get()
        .then((value) {
      setState(() {
        userData = value;
      });
    });
    super.initState();
  }

  Future _selectAndUploadVideo() async {
    final result = await _imagePicker.pickVideo(source: ImageSource.gallery);

    if (result == null) {
      // setState(() {
      //   firstButtonText = 'No video was selected.';
      // });
      return;
    }

    setState(() {
      firstButtonText = 'Uploading video...';
      _currentVideo = File(result.path);
    });

    _uploadTask = API.uploadVideo(_currentVideo!);
    setState(() {});

    if (_uploadTask == null) return;

    final snapshot = await _uploadTask!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    print("Download Link: $url");

    if (userData!['gender'] == "Female") {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Pregnancy"),
          content: Text("Are you currently pregnant?"),
          actions: [
            FlatButton(
              onPressed: () {
                setState(() {
                  isPregnant = true;
                });
                Navigator.of(context).pop();
              },
              color: Color(0xFFBF828A),
              child: Text(
                'YES',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  isPregnant = false;
                });
                Navigator.of(context).pop();
              },
              color: Color(0xFFBF828A),
              child: Text(
                'NO',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    }

    setState(() {
      firstButtonText = 'Processing...';
      downUrl = url;
    });

    await _getAPiResponse();

    setState(() {
      firstButtonText = 'Select a Video from Gallery';
    });
  }

  void _showGauge(double val, int age) {
    var verdict;
    var color;
    List<double> hbRanges = [];
    var normalRange = [];

    if (age <= 5) {
      hbRanges.add(7 - 3);
      hbRanges.add(10 - 7);
      hbRanges.add(11 - 10);
      hbRanges.add(16 - 11);
      normalRange.add(11);
      normalRange.add(16);
      if (val < 7) {
        verdict = "Severely Anaemic";
        color = Colors.red;
      } else if (val >= 7 && val < 10) {
        verdict = "Moderately Anaemic";
        color = Colors.orange;
      } else if (val >= 10 && val < 11) {
        verdict = "Mildy Anaemic";
        color = Color(0xFFF6C21A);
      } else {
        verdict = "Non-Anaemic (Safe)";
        color = Colors.green;
      }
    } else if (age > 5 && age <= 11) {
      hbRanges.add(8 - 3);
      hbRanges.add(11 - 8);
      hbRanges.add(11.5 - 11);
      hbRanges.add(16 - 11.5);
      normalRange.add(11.5);
      normalRange.add(16);
      if (val < 8) {
        verdict = "Severely Anaemic";
        color = Colors.red;
      } else if (val >= 8 && val < 11) {
        verdict = "Moderately Anaemic";
        color = Colors.orange;
      } else if (val >= 11 && val < 11.5) {
        verdict = "Mildy Anaemic";
        color = Color(0xFFF6C21A);
      } else {
        verdict = "Non-Anaemic (Safe)";
        color = Colors.green;
      }
    } else if (age > 11 && age < 15) {
      hbRanges.add(8 - 3);
      hbRanges.add(11 - 8);
      hbRanges.add(12 - 11);
      hbRanges.add(16 - 12);
      normalRange.add(12);
      normalRange.add(16);
      if (val < 8) {
        verdict = "Severely Anaemic";
        color = Colors.red;
      } else if (val >= 8 && val < 11) {
        verdict = "Moderately Anaemic";
        color = Colors.orange;
      } else if (val >= 11 && val < 12) {
        verdict = "Mildy Anaemic";
        color = Color(0xFFF6C21A);
      } else {
        verdict = "Non-Anaemic (Safe)";
        color = Colors.green;
      }
    } else {
      if (userData!['gender'] == "Female") {
        if (isPregnant!) {
          hbRanges.add(7 - 3);
          hbRanges.add(10 - 7);
          hbRanges.add(11 - 10);
          hbRanges.add(16 - 11);
          normalRange.add(11);
          normalRange.add(16);
          if (val < 7) {
            verdict = "Severely Anaemic";
            color = Colors.red;
          } else if (val >= 7 && val < 10) {
            verdict = "Moderately Anaemic";
            color = Colors.orange;
          } else if (val >= 10 && val < 11) {
            verdict = "Mildy Anaemic";
            color = Color(0xFFF6C21A);
          } else {
            verdict = "Non-Anaemic (Safe)";
            color = Colors.green;
          }
        } else {
          hbRanges.add(8 - 3);
          hbRanges.add(11 - 8);
          hbRanges.add(12 - 11);
          hbRanges.add(16 - 12);
          normalRange.add(12);
          normalRange.add(16);
          if (val < 8) {
            verdict = "Severely Anaemic";
            color = Colors.red;
          } else if (val >= 8 && val < 11) {
            verdict = "Moderately Anaemic";
            color = Colors.orange;
          } else if (val >= 11 && val < 12) {
            verdict = "Mildly Anaemic";
            color = Color(0xFFF6C21A);
          } else {
            verdict = "Non-Anaemic (Safe)";
            color = Colors.green;
          }
        }
      } else {
        hbRanges.add(8 - 3);
        hbRanges.add(11 - 8);
        hbRanges.add(13 - 11);
        hbRanges.add(16 - 13);
        normalRange.add(13);
        normalRange.add(16);
        if (val < 8) {
          verdict = "Severely Anaemic";
          color = Colors.red;
        } else if (val >= 8 && val < 11) {
          verdict = "Moderately Anaemic";
          color = Colors.orange;
        } else if (val >= 11 && val < 13) {
          verdict = "Mildy Anaemic";
          color = Color(0xFFF6C21A);
        } else {
          verdict = "Non-Anaemic (Safe)";
          color = Colors.green;
        }
      }
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verdict'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  // This widget will be based on Gender.
                  // Haven't factored it in right now for testing.
                  child: CustomGauge(
                    gaugeSize: 200,
                    minValue: 3,
                    maxValue: 16,
                    currentValue: double.parse(val.toStringAsFixed(1)),
                    segments: [
                      GaugeSegment('Severely Anaemic', hbRanges[0], Colors.red),
                      GaugeSegment(
                          'Moderately Anaemic', hbRanges[1], Colors.orange),
                      GaugeSegment(
                          "Mildy Anaemic", hbRanges[2], Color(0xFFF6C21A)),
                      GaugeSegment('Non-Anaemic', hbRanges[3], Colors.green),
                    ],
                    showMarkers: false,
                    displayWidget: Text(
                      'Haemoglobin (gm/dl)',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Normal Range: ${normalRange[0]} - ${normalRange[1]} gm/dl",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    verdict,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                verdict == "Non-Anaemic (Safe)"
                    ? SizedBox()
                    : Text(
                        "Next Steps:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                SizedBox(
                  height: 5,
                ),
                _advise(verdict)
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Color(0xFFBF828A),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _advise(String type) {
    if (type == 'Severely Anaemic') {
      return Text(
        "1. Consult a Doctor to treat the deficiency as soon as possible \n3. Iron supplements should be taken by mouth.\n3. Eat iron-rich foods(chicken, leafy vegetables and beans)",
        style: TextStyle(fontSize: 14),
      );
    } else if (type == 'Moderately Anaemic') {
      return Text(
        "1. Sleep more at night and take naps during the day. \n3. Eat iron-rich foods(chicken, leafy vegetables and beans)\n3. Plan your day to include rest periods.",
        style: TextStyle(fontSize: 14),
      );
    } else if (type == "Mildy Anaemic") {
      return Text(
        "1. Take Dried fruit, such as raisins and apricots. \n3. Sleep more at night and take naps during the day.\n3. Eat iron-rich foods(chicken, leafy vegetables and beans)",
        style: TextStyle(fontSize: 14),
      );
    } else {
      return Text(
        "You are safe. Keep up the good work.",
        style: TextStyle(fontSize: 14),
      );
    }
  }

  int _calcAge(String dob) {
    DateTime dt = DateTime.parse(dob);
    Duration diff = DateTime.now().difference(dt);

    int age = (diff.inDays / 365).floor();

    return age;
  }

  Future _getAPiResponse() async {
    if (downUrl == null) return;

    int age = _calcAge(userData!['dob']);
    String gender = userData!['gender'] == "Male" ? "1" : "0";

    // double? data = await API.processVideo(downUrl!, age.toString(), gender);

    double? data = await API.dummy();

    API.addResult(data!);
    _showGauge(data, age);

    print("API response $data");
  }

  Future _recordVideo() async {
    _imagePicker
        .pickVideo(source: ImageSource.camera)
        .then((XFile? recordedVideo) async {
      if (recordedVideo != null && recordedVideo.path != null) {
        print(recordedVideo.path);
        // setState(() {
        //   secondButtonText = 'Video is being saved...';
        // });
        final result = await ImageGallerySaver.saveFile(recordedVideo.path);
        print(result);
        // setState(() {
        //   secondButtonText = 'Video saved. Record Another?';
        // });
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("Video Saved"),
            content: Text("The video has been saved."),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Color(0xFFBF828A),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      }
    });
  }

  String firstButtonText = 'Select Video from Gallery';
  String secondButtonText = 'Record a New video';
  double textSize = 22;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("Hi,\nWelcome to Adkit",
                            style: TextStyle(
                              fontSize: textSize,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(25),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Card(
                          elevation: 10,
                          color: Theme.of(context).accentColor,
                          child: IconButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (route) => false);
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Color(0xFFBF828A), //Color(0xFFBF828A),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * .08,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _selectAndUploadVideo();
                              // _showGauge(11.2, 5);
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(builder: (context) => TrendGraph()),
                              // );
                            },
                            child: Card(
                              elevation: 10,
                              child: Container(
                                color: Theme.of(context).accentColor,
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  Icons.video_library,
                                  color: Color(0xFFBF828A),
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(firstButtonText),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _recordVideo();
                            },
                            child: Card(
                              elevation: 10,
                              child: Container(
                                color: Theme.of(context).accentColor,
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  Icons.videocam,
                                  color: Color(0xFFBF828A),
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(secondButtonText),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => TrendGraph()),
                              );
                            },
                            child: Card(
                              elevation: 10,
                              child: Container(
                                color: Theme.of(context).accentColor,
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  Icons.auto_graph,
                                  color: Color(0xFFBF828A),
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Show Trend Graph"),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: height * 0.06,
                  // ),

                  SizedBox(
                    height: height * .05,
                  ),
                  _uploadTask != null
                      ? _uploadStatus(_uploadTask!)
                      : Offstage(),
                  // Text(hValue)
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataForm()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: height * .80, left: width - 250),
                  height: 60,
                  width: 240,
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Color(0xFFBF828A),
                    child: Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "CHATBOT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Transform.translate(
                            offset: Offset(15.0, 0.0),
                            child: new Container(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5,
                                right: 25,
                              ),
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                splashColor: Colors.white,
                                color: Colors.white,
                                child: Icon(
                                  Icons.message,
                                  color: Color(0xFFBF828A),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FirestoreForm()),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadStatus(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, AsyncSnapshot<TaskSnapshot> snapshot) {
          if (snapshot.hasData) {
            TaskSnapshot event = snapshot.data!;
            TaskState state = event.state;
            double progressPercent =
                event != null ? event.bytesTransferred / event.totalBytes : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: (state == TaskState.running)
                  ? LinearProgressIndicator(
                      value: progressPercent,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFBF828A)),
                      backgroundColor: Theme.of(context).accentColor,
                    )
                  : Offstage(),
            );
          }
          return Offstage();
        });
  }
}
