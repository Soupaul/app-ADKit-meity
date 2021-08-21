import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
// run with `flutter run --no-sound-null-safety` for testing
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
// import '../utils/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _currentVideo;
  var height, weidth;
  String? downUrl;
  ImagePicker _imagePicker = ImagePicker();
  UploadTask? _uploadTask;

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
    setState(() {
      firstButtonText = 'Processing...';
      downUrl = url;
    });

    await _getAPiResponse();

    setState(() {
      firstButtonText = 'Video processed. Upload another?';
    });
  }

  void _showGauge(double val) {
    var verdict;
    var color;

    if ((val >= 5 && val <= 9.6) || (val >= 18.6 && val <= 20)) {
      verdict = "High Risk!";
      color = Colors.red;
    } else if ((val > 9.6 && val < 12) || (val > 15.5 && val < 18.6)) {
      verdict = "Moderate Risk";
      color = Color(0xFFF6C21A);
    } else {
      verdict = "No Risk";
      color = Colors.green;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Risk Factor'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  // This widget will be based on Gender.
                  // Haven't factored it in right now for testing.
                  child: CustomGauge(
                    gaugeSize: 200,
                    minValue: 5,
                    maxValue: 20,
                    currentValue: double.parse(val.toStringAsFixed(1)),
                    segments: [
                      GaugeSegment('Severely Anaemic', 4.6, Colors.red),
                      GaugeSegment('Moderate Risk', 2.4, Color(0xFFF6C21A)),
                      GaugeSegment('Healthy', 3.5, Colors.green),
                      GaugeSegment('Moderate Risk', 3.1, Color(0xFFF6C21A)),
                      GaugeSegment('Severely Anaemic', 1.4, Colors.red),
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
                    "Normal Range: 12 - 15.5 gm/dl",
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
                Text(
                  "Next Steps:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "1. Consult a Doctor to treat the deficiency",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "2. Eat iron-rich foods(chicken, leafy vegetables and beans)",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "3. Eat and drink foods that help absorb iron(broccoli, fruits rich in Vitamin C)",
                  style: TextStyle(fontSize: 14),
                ),
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

  // String hValue = "";

  Future _getAPiResponse() async {
    if (downUrl == null) return;

    double? data = await API.processVideo(downUrl!);

    // setState(() {
    //   hValue = "";
    //   hValue = "hemoglobin value is $data";
    // });

    _showGauge(data!);

    print("API response $data");
  }

  Future _recordVideo() async {
    _imagePicker
        .pickVideo(source: ImageSource.camera)
        .then((XFile? recordedVideo) async {
      if (recordedVideo != null && recordedVideo.path != null) {
        print(recordedVideo.path);
        setState(() {
          secondButtonText = 'Video is being saved...';
        });
        final result = await ImageGallerySaver.saveFile(recordedVideo.path);
        print(result);
        setState(() {
          secondButtonText = 'Video saved. Record Another?';
        });
      }
    });
  }

  String firstButtonText = 'Select Video from Gallery';
  String secondButtonText = 'Record a new video';
  double textSize = 22;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    weidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
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
                              // _showGauge(10);
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

                  // SizedBox(
                  //   height: height * .05,
                  // ),
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
                  margin:
                      EdgeInsets.only(top: height * .80, left: weidth - 250),
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
                                        builder: (context) => DataForm()),
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
