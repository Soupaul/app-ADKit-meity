import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirestoreForm extends StatefulWidget {
  const FirestoreForm({Key? key}) : super(key: key);

  @override
  _FirestoreFormState createState() => _FirestoreFormState();
}

class _FirestoreFormState extends State<FirestoreForm> {
  @override
  DocumentSnapshot? userData;

  @override
  void initState() {
    print('on init');
    getData();
    super.initState();
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

      list.forEach((element) {
        print(element['question']);
      });
    });
  }

  Widget getQuestionsView(List list) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Which of the following symptoms do you have ?",
            style: TextStyle(
              color: Color(0xFFBF828A),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(children: [
                  Checkbox(
                    activeColor: Colors.green,
                    value: checkList[index],
                    onChanged: (bool? val) {
                      setState(() {
                        checkList[index] = val;
                      });
                    },
                  ),
                  Text(list[index]['question'])
                ]);
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
            "Choose suitable one about ${sym}",
            style: TextStyle(
              color: Color(0xFFBF828A),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: subquestion.length,
              itemBuilder: (BuildContext context, int i) {
                return Row(children: [
                  Radio(
                    value: i,
                    groupValue: v,
                    onChanged: (int? value) {
                      setState(() {
                        wtMap[sym] = value!;
                        v = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                  Text(subquestion[i]['q'])
                ]);
              }),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: list.isEmpty
              ? Center(child: CircularProgressIndicator())
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
                          state>0?
                          RaisedButton(
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
                          ):SizedBox(width: 50,),
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
                                if (state == 0 || state < selectedSym.length) {
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
                )),
    );
  }
}
