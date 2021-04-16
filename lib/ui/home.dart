import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thefirstone/ui/form.dart';
import '../utils/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentImage;
  var currentVideo;
  var height, weidth;

  Future _takePhoto() async {
    ImagePicker.pickVideo(source: ImageSource.gallery)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          firstButtonText = 'Video Uploaded, Add another from Gallery';
          currentImage = recordedImage;
        });
        GallerySaver.saveImage(recordedImage.path).then((path) {
          setState(() {
            firstButtonText = 'Video Uploaded, Add another from Gallery';
          });
        });
      }
    });
  }

  Future _recordVideo() async {
    ImagePicker.pickVideo(source: ImageSource.camera)
        .then((File recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
          secondButtonText = 'Video Saved!, Record another?';
          currentVideo = recordedVideo;
        });
        GallerySaver.saveVideo(recordedVideo.path).then((path) {
          setState(() {
            secondButtonText = 'Video Saved!, Record another?';
          });
        });
      }
    });
  }

  Future _uploadPhoto() async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('VideoG' + new DateTime.now().millisecondsSinceEpoch.toString());
    StorageUploadTask task = firebaseStorageRef.putFile(currentImage);
    var dowurl = await (await task.onComplete).ref.getDownloadURL();
  }

  Future _uploadVideo() async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('VideoR' + new DateTime.now().millisecondsSinceEpoch.toString());
    StorageUploadTask task = firebaseStorageRef.putFile(currentVideo);

    var dowurl = await (await task.onComplete).ref.getDownloadURL();
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
                child: Stack(children: [
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
                                fontWeight: FontWeight.w400)),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(25),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Card(
                          elevation: 10,
                          child: IconButton(
                            onPressed: () {
                              AuthProvider.logOut();
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.redAccent,//Color(0xFFBF828A),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * .08,
                  ),
                  GestureDetector(
                    onTap: () {
                      _takePhoto();
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.video_library,
                          color: Colors.redAccent,//Color(0xFFBF828A),
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(firstButtonText),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  GestureDetector(
                    onTap: () {
                      _recordVideo();
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.videocam,
                          color: Colors.redAccent,//Color(0xFFBF828A),
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(secondButtonText)
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
                    color: Colors.redAccent,//Color(0xFFBF828A),
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
                                  color: Colors.redAccent///Color(0xFFBF828A),
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
            ]))));
  }

  Widget enableUploadImage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload Video'),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              _uploadPhoto();
            },
          )
        ],
      ),
    );
  }

  Widget enableUploadVideo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload Video'),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              _uploadVideo();
            },
          )
        ],
      ),
    );
  }
}
