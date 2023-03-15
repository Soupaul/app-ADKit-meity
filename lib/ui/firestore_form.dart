import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:thefirstone/resources/api.dart';
import 'package:thefirstone/ui/home.dart';

class FirestoreForm extends StatefulWidget {
  const FirestoreForm({Key? key}) : super(key: key);

  @override
  _FirestoreFormState createState() => _FirestoreFormState();
}

enum TtsState { playing, stopped }

class _FirestoreFormState extends State<FirestoreForm> {
  // DocumentSnapshot? userData;
  late FlutterTts _flutterTts;
  List<Map<String, String>> languageList = [
    {'key': 'English', 'value': 'en'},
    {'key': 'Hindi', 'value': 'hi'},
    {'key': 'Bengali', 'value': 'bn'},
  ];
  late String dropdownValue;
  late String language;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;
  String? _newVoiceText;
  String prevText = "No symptom";
  String nextText = "Next";

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  void _initTts() {
    _flutterTts = FlutterTts();

    language = '$dropdownValue-IN';

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

  BuildContext? _context = null;

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void initState() {
    print('on init');
    getData();
    super.initState();
    dropdownValue = languageList[0]['value']!;
    _initTts();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  List list = [];
  List subQuestions = [];
  List checkList = [];
  List selectedSymToTravarse = [];
  List allSelectedSym = [];
  int state = 0;
  int subState = 0;
  bool isEnded = false;
  bool isAtStart = true;
  Map ansMap = new Map();
  var wtMap;

  Future<void> getData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("profiles")
        .doc(API.current_profile_id)
        .get()
        .then((value) {
      print(value['gender']);

      FirebaseFirestore.instance
          .collection('symptoms')
          .get()
          .then((QuerySnapshot querySnapshot) {
        setState(() {
          List temp = querySnapshot.docs;
          temp.forEach((element) {
            try {
              if (element['sex'] == value['gender']) {
                list.add(element);
              }
            } catch (e) {
              list.add(element);
            }
          });

          checkList = List.filled(list.length, false);
        });
      });
    });

    FirebaseFirestore.instance
        .collection('chatbot_subquestions')
        .get()
        .then((QuerySnapshot querySnapshot) {
      subQuestions = querySnapshot.docs;
    });

    FirebaseFirestore.instance
        .collection('weights')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List m = querySnapshot.docs;
      wtMap = m[0]['wt_map'];
      print(wtMap);
    });
  }

  Widget getQuestionsView(List list) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: API.translate(
                "Which of the following symptoms do you have?",
                'en',
                dropdownValue),
            builder: (context, snapshot) => Text(
              dropdownValue != 'en'
                  ? snapshot.data.toString()
                  : "Which of the following symptoms do you have?",
              style: TextStyle(
                // color: Color(0xFFBF828A),
                fontSize: 28.0,
                fontWeight: FontWeight.w900,
              ),
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
                        FutureBuilder(
                            future: API.translate(
                                list[index]['name'], 'en', dropdownValue),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFBF828A),
                                    ),
                                  ),
                                );
                              }

                              return Text(
                                dropdownValue != 'en'
                                    ? snapshot.data.toString()
                                    : list[index]['name'],
                                style: TextStyle(fontSize: 16),
                              );
                            }),
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
    double total = 0;
    print(ansMap);
    allSelectedSym.forEach((element) {
      List grs = [];
      try {
        grs = element['groups'];
        String q = element['name'];
        double wt = element['wt'].toDouble();
        String s = "";
        grs.forEach((e) {
          s = "$s$e";
          s = "$s-${ansMap["$q-$e"]},";
        });
        print(s);

        s = s.substring(0, s.length - 1);

        total = total + (wtMap[s].toDouble() * wt);
      } catch (e) {
        double wt = element['wt'].toDouble();
        total = total + wt;
      }
    });

    API.addChatbotResponse(total);
    Navigator.of(context).pop();

    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     title: Text("Value is"),
    //     content: Text(total.toStringAsFixed(3)),
    //     actions: <Widget>[
    //       FlatButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //         child: Text("okay"),
    //       ),
    //     ],
    //   ),
    // );
  }

  int v = 0;

  Widget getSubQuestionsView() {
    int id = selectedSymToTravarse[state - 1]['groups'][subState];
    var subQuestion;
    String question = selectedSymToTravarse[state - 1]['name'];

    for (int i = 0; i < subQuestions.length; i++) {
      if (subQuestions[i]['id'] == id) {
        subQuestion = subQuestions[i];
        break;
      }
    }
    v = ansMap["$question-$id"];
    print(v);
    v == null ? v = 0 : v = ansMap["$question-$id"];
    ansMap["$question-$id"] = v;

    List options = subQuestion['options'];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: API.translate("Choose a suitable option about $question",
                'en', dropdownValue),
            builder: (context, snapshot) => Text(
              dropdownValue != 'en'
                  ? snapshot.data.toString()
                  : "Choose a suitable option about $question",
              style: TextStyle(
                // color: Color(0xFFBF828A),
                fontSize: 28.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: FutureBuilder(
                future: API.translate(subQuestion['name'], 'en', dropdownValue),
                builder: (context, snapshot) => Text(
                  dropdownValue != 'en'
                      ? snapshot.data.toString()
                      : subQuestion['name'],
                  style: TextStyle(
                    // color: Color(0xFFBF828A),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        v = i;
                        ansMap["$question-$id"] = i;
                        print('$question-$id');
                        print(ansMap["$question-$id"]);
                        print(ansMap);
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Radio(
                            value: i,
                            groupValue: v,
                            onChanged: (int? value) {
                              setState(() {
                                ansMap["$question-$id"] = value;
                                v = value!;
                              });
                            },
                            activeColor: Color(0xFFBF828A),
                          ),
                          FutureBuilder(
                            future:
                                API.translate(options[i], 'en', dropdownValue),
                            builder: (context, snapshot) => Text(
                              dropdownValue != 'en'
                                  ? snapshot.data.toString()
                                  : options[i],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ],
    );
  }

  void goNext() {
    if (state == 0) {
      setState(() {
        state++;
        isAtStart = false;
        prevText = "Previous";
      });
    } else {
      int noOfQuestions = selectedSymToTravarse.length;
      List groups = selectedSymToTravarse[state - 1]['groups'];
      int maxGroups = groups.length;

      setState(() {
        isAtStart = false;
        prevText = "Previous";
        if (subState < maxGroups - 1) {
          subState++;
        } else {
          if (state < noOfQuestions) {
            subState = 0;
            state++;
          } else {
            isEnded = true;
            nextText = "Finish";
          }
        }
      });
    }
  }

  void goPre() {
    if (state == 1 && subState == 0) {
      setState(() {
        state = 0;
        isAtStart = true;
        prevText = "No symptom";
        isEnded = false;
        nextText = "Next";
      });
    } else {
      int noOfQuestions = selectedSymToTravarse.length;
      List groups = selectedSymToTravarse[state - 1]['groups'];
      int maxGroups = groups.length;

      setState(() {
        isEnded = false;
        nextText = "Next";
        if (subState > 0) {
          subState--;
        } else {
          if (state > 0) {
            state--;
            List groups = selectedSymToTravarse[state - 1]['groups'];
            int maxGroups = groups.length;

            subState = maxGroups - 1;
          } else {
            isAtStart = true;
            prevText = "No symptom";
          }
        }
      });
    }
  }

  Widget build(BuildContext context) {
    _context = context;

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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Display Language"),
                            DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(
                                  color: const Color(0xFFBF828A)),
                              underline: Container(
                                height: 2,
                                color: const Color(0xFFBF828A),
                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                  language = '$dropdownValue-IN';
                                });
                              },
                              items: languageList.map<DropdownMenuItem<String>>(
                                  (Map<String, String> mp) {
                                return DropdownMenuItem<String>(
                                  value: mp['value'],
                                  child: Text(mp['key']!),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: state > 0
                              ? getSubQuestionsView()
                              : getQuestionsView(list)),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 15.0),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFBF828A),
                                ),
                              ),
                              child: FutureBuilder(
                                  future: API.translate(
                                      prevText, "en", dropdownValue),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    );
                                  }),
                              onPressed: () {
                                if (isAtStart) {
                                  Navigator.pop(context);
                                } else {
                                  goPre();
                                }
                              },
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 15.0),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFBF828A),
                                ),
                              ),
                              child: FutureBuilder(
                                  future: API.translate(
                                      nextText, "en", dropdownValue),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    );
                                  }),
                              onPressed: () {
                                if (state == 0) {
                                  allSelectedSym.clear();
                                  selectedSymToTravarse.clear();
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
                                      allSelectedSym.add(list[i]);
                                      try {
                                        list[i]['groups'];
                                        selectedSymToTravarse.add(list[i]);
                                      } catch (e) {}
                                    }
                                  }
                                }
                                if (selectedSymToTravarse.length == 0 &&
                                    allSelectedSym.length > 0) {
                                  calculateValue();
                                } else {
                                  setState(() {
                                    if (!isEnded) {
                                      goNext();
                                    } else {
                                      calculateValue();
                                    }
                                  });
                                }
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
                      onPressed: () async {
                        var whichSymptom = dropdownValue != 'en'
                            ? await API.translate(
                                'Which of the following symptoms do you have?',
                                'en',
                                dropdownValue)
                            : 'Which of the following symptoms do you have?';

                        var chooseOption = state != 0
                            ? dropdownValue != 'en'
                                ? await API.translate(
                                    'Choose a suitable option about ${selectedSymToTravarse[state - 1]['name']}',
                                    'en',
                                    dropdownValue)
                                : 'Choose a suitable option about ${selectedSymToTravarse[state - 1]['name']}'
                            : "";

                        if (state == 0) {
                          setState(() {
                            _newVoiceText = whichSymptom;
                          });
                        } else {
                          setState(() {
                            _newVoiceText = chooseOption;
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
