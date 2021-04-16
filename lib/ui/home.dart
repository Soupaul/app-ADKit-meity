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
  double textSize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Flexible(
                    child: Container(
                        child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DataForm()),
                    );
                  },
                  color: Colors.blue,
                ))),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: SizedBox.expand(
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: _takePhoto,
                        child: currentImage == null
                            ? Text(firstButtonText,
                                style: TextStyle(
                                    fontSize: textSize, color: Colors.white))
                            : enableUploadImage(),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                      child: SizedBox.expand(
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: _recordVideo,
                      child: currentVideo == null
                          ? Text(secondButtonText,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.blueGrey))
                          : enableUploadVideo(),
                    ),
                  )),
                  flex: 1,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Log out"),
                        onPressed: () {
                          AuthProvider.logOut();
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
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
