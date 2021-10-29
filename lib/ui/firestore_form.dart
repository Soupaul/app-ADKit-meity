import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FirestoreForm extends StatefulWidget {
  const FirestoreForm({Key? key}) : super(key: key);

  @override
  _FirestoreFormState createState() => _FirestoreFormState();
}

enum TtsState { playing, stopped }

class _FirestoreFormState extends State<FirestoreForm> {
  // DocumentSnapshot? userData;
  late FlutterTts _flutterTts;
  String language = "en-IN";
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;
  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  void _initTts() {
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() => _flutterTts.getLanguages;

  Future _speak() async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.setVolume(volume);
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await _flutterTts.awaitSpeakCompletion(true);
        await _flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void initState() {
    print('on init');
    getData();
    super.initState();
    _initTts();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  List list = [];
  List checkList = [];
  List selectedSym = [];
  int state = 0;
  Map<String, int> wtMap = new Map();

  Future<void> getData() async {
    FirebaseFirestore.instance
        .collection('chatbot')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        list = querySnapshot.docs;
        checkList = List.filled(list.length, false);
      });

      // list.forEach((element) {
      //   print(element['question']);
      // });
    });
  }

  Widget getQuestionsView(List list) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Which of the following symptoms do you have?",
            style: TextStyle(
              // color: Color(0xFFBF828A),
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      checkList[index] = !checkList[index];
                    });
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        Checkbox(
                          activeColor: Color(0xFFBF828A),
                          value: checkList[index],
                          onChanged: (bool? val) {
                            setState(() {
                              checkList[index] = val;
                            });
                          },
                        ),
                        Text(
                          list[index]['question'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ]),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  void calculateValue() {
    double total = 0.0;
    for (int i = 0; i < selectedSym.length; i++) {
      double wt = selectedSym[i]["wt"].toDouble();
      String t = selectedSym[i]['question'];
      double subWt = selectedSym[i]['subwts'][wtMap[t]]['w'].toDouble();

      total = total + (wt * subWt);
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Value is"),
        content: Text(total.toStringAsFixed(3)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("okay"),
          ),
        ],
      ),
    );

    print(total);
  }

  Widget getSubQuestionsView(String title, int index) {
    List subquestion = selectedSym[index]['subwts'];
    String sym = selectedSym[index]['question'];
    int? v = wtMap[sym];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Choose a suitable option about ${sym}.",
            style: TextStyle(
              // color: Color(0xFFBF828A),
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: subquestion.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      wtMap[sym] = i;
                      v = i;
                    });
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        Radio(
                          value: i,
                          groupValue: v,
                          onChanged: (int? value) {
                            setState(() {
                              wtMap[sym] = value!;
                              v = value;
                            });
                          },
                          activeColor: Color(0xFFBF828A),
                        ),
                        Text(
                          subquestion[i]['q'],
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ]),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            body: list.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFBF828A),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: state > 0
                              ? getSubQuestionsView("", state - 1)
                              : getQuestionsView(list)),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            state > 0
                                ? RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                    color: Color(0xFFBF828A),
                                    child: Text(
                                      "Previous",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        state = state - 1;
                                      });
                                    },
                                  )
                                : SizedBox(
                                    width: 50,
                                  ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              color: Color(0xFFBF828A),
                              child: Text(
                                (selectedSym.length == 0 ||
                                        selectedSym.length > state)
                                    ? "Next"
                                    : "Finish",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () {
                                if (state == 0) {
                                  selectedSym.clear();
                                  if (checkList
                                          .where((val) => val == true)
                                          .length ==
                                      0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please select atleast one symptom')));
                                    return;
                                  }
                                  for (int i = 0; i < list.length; i++) {
                                    if (checkList[i]) {
                                      selectedSym.add(list[i]);
                                      if (wtMap[list[i]['question']] == null) {
                                        wtMap[list[i]['question']] = 0;
                                      }
                                    }
                                  }
                                  print(selectedSym);
                                }
                                setState(() {
                                  if (state == 0 ||
                                      state < selectedSym.length) {
                                    state = state + 1;
                                  } else {
                                    calculateValue();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned(
            right: 5,
            bottom: 80,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipOval(
                child: Material(
                  color: Theme.of(context).accentColor,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: IconButton(
                      icon: Icon(
                        Icons.volume_up,
                        color: Color(0xFFBF828A),
                      ),
                      onPressed: () {
                        if (state == 0) {
                          setState(() {
                            _newVoiceText =
                                'Which of the following symptoms do you have?';
                          });
                        } else {
                          setState(() {
                            _newVoiceText =
                                'Choose a suitable option about ${selectedSym[state - 1]['question']}';
                          });
                        }

                        _speak();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
