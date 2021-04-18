import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class DataForm extends StatefulWidget {
  @override
  _DataFormState createState() => _DataFormState();
}

class FormState {
  int stateNumber;
  String text;
  List<String> options;
  bool isMcq;
  bool isInt;
  bool isDropdown;
  dynamic answer;
  FormState(int x) {
    stateNumber = x;
    isMcq = false;
    isInt = false;
    isDropdown = false;
    answer = Null;
    options = new List<String>();
  }
}

class FormStateList {
  List<FormState> states = new List<FormState>(80);
  int currState;
  int s = 0;
  int age;
  String sex;
  List<Tuple2<FormState, int>> formStack = new List<Tuple2<FormState, int>>();
  FormStateList() {
    currState = 0;
    for (int i = 0; i < 80; i++) {
      states[i] = new FormState(i);
    }
    //Define text of each state and type of question
    //STATE 0
    states[0].text =
        "Hello, this is ADKit Analysis bot. Please confirm you are ready for the analysis";
    states[0].isMcq = true;
    //State 1
    //Present History Module
    states[1].text =
        "Do you have the symptoms of Weakness /Fatigue /Dizziness /Lightheadness?";
    states[1].isMcq = true;
    //state 2
    states[2].text = "Did you feel the symptoms recently?";
    states[2].isMcq = true;
    //states 3
    states[3].text = "Is the condition deteriorating?";
    states[3].isMcq = true;
    //state 4
    states[4].text = "Are you taking rest?";
    states[4].isMcq = true;
    //state 5
    states[5].text = "On exertion";
    states[5].isMcq = true;
    //state 6
    states[6].text = "Do you have Palpitation with/without irregular pulse?";
    states[6].isMcq = true;
    states[7].text = "Recent onset?";
    states[7].isMcq = true;
    //state 8
    states[8].text = "Is it deteriorating?";
    states[8].isMcq = true;
    //state 9
    states[9].text = "At rest?";
    states[9].isMcq = true;
    //state 10
    states[10].text = "On exerstion?";
    states[10].isMcq = true;
    //state 11
    states[11].text = "Do you have symptom of breathlessness?";
    states[11].isMcq = true;
    //state 12
    states[12].text = "Recent onset?";
    states[12].isMcq = true;
    //state 13
    states[13].text = "Wheeze or cough?";
    states[13].isMcq = true;
    //state 14
    states[14].text = "Relieved with medicine for asthma?";
    states[14].isMcq = true;
    //state 15
    states[15].text = "At rest?";
    states[15].isMcq = true;
    //state 16
    states[16].text = "On exertion?";
    states[16].isMcq = true;
    //state 17
    states[17].text = "Do you feel sleepness?";
    states[17].isMcq = true;
    //state 18
    states[18].text = "Is it long standing?";
    states[18].isMcq = true;
    //state 19
    states[19].text = "Consult Doctor for diagnosis";
    states[19].isMcq = false;
    //state 20
    states[20].text = "Anaemica Detected?";
    states[20].isMcq = true;
    //state21 //This state was in between 13 14//Consult doctor/
    states[21].text = "Consult doctor for respiratory problem";
    states[21].isMcq = false;
    //Past History Module
    //state22
    states[22].text = "Suffered from these symptoms in last three months?";
    states[22].isMcq = true;
    //state23
    states[23].text = "How many? Enter no. C";
    states[23].isInt = true;
    //state24
    states[24].text = "Did any symptom improve?";
    states[24].isMcq = true;
    //state25
    states[25].text = "Did any symptom worsened?";
    states[25].isMcq = true;
    //state26
    states[26].text = "How Many? Enter no. E";
    states[26].isInt = true;
    //state27
    states[27].text = "Any of the symptoms reoccured?";
    states[27].isMcq = true;
    //state28
    states[28].text = "How many reccured? enter no. F";
    states[28].isInt = true;
    //state29
    states[29].text = "Are you under treatment of doctor?";
    states[29].isMcq = true;
    //state30
    states[30].text = "How many? enter no. D";
    states[30].isInt = true;
    //state31
    states[31].text =
        "Inform Doctor that old record are available in your folder";
    states[31].isMcq = false;
    //state33
    states[33].text = "CONSULT A DOCTOR URGENTLY";
    states[33].isMcq = false;
    //state34
    states[34].text = "Serious Acute infection?";
    states[34].isMcq = true;
    //state35
    states[35].text = "Chronic infection like TB,UTI?";
    states[35].isMcq = true;
    //state36
    states[36].text = "Debilating disease like cancer, kidney failure?";
    states[36].isMcq = true;
    //state37
    states[37].text = "Bleeding Ulcer";
    states[37].isMcq = true;
    //state38
    states[38].text = "Systemic bleeding, viz in intestine,lungs,uterus,etc.?";
    states[38].isMcq = true;
    //state39
    states[39].text = "Excess menses?";
    states[39].isMcq = true;
    //state40
    states[40].text = "Pregnancy/child birth?";
    states[40].isMcq = true;
    //state41
    states[41].text = "Pregnancy/child birth > 3 ?";
    states[41].isMcq = true;
    //state42
    states[42].text = "Pregnancy/child birth>4 & gap < 2?";
    states[42].isMcq = true;
    //state43
    states[43].text = "Diagnosed for congential defects in RCBs or Hb?";
    states[43].isMcq = true;
    //Personal/Social History Module
    //state44
    states[44].text = "Approx. monthly family income(I) in Rs.";
    states[44].isInt = true;
    //state45
    states[45].text = "No. of adults in family(A)";
    states[45].isInt = true;
    //state46
    states[46].text = "No. of family members between 5 and 18 yrs (B)";
    states[46].isInt = true;
    //state47
    states[47].text = "No. of childrens<5yr(C)";
    states[47].isInt = true;
    //state48
    states[48].text =
        "How many(D) in family do not take 1 egge/ 100 gm fish / 500 ml milk or its product daily?";
    states[48].isInt = true;
    //state49
    states[49].text =
        "If age<5 yrs, at what age (F in yrs) started homemade solid diet?";
    states[49].isInt = true;
    //state50
    states[50].text = "History of alcholism?";
    states[50].isMcq = true;
    //Family History Module
    //state51
    states[51].text = "Can the user state diseases suffered by relatives?";
    states[51].isMcq = true;
    //state52
    states[52].text =
        "Has any blood relation suffered/suffer from Vitamin B12 Deficiency?";
    states[52].isMcq = true;
    //state53
    states[53].text = "Has any blood relation suffered/suffer from Thaassemia?";
    states[53].isMcq = true;
    //state54
    states[54].text =
        "Has any blood relation suffered/suffer from Congential Pernicious Anemia";
    states[54].isMcq = true;
    //state55
    states[55].text =
        "Has any blood relation suffered/suffer from Sickle Cell Anaemia";
    states[55].isMcq = true;
    //state56
    states[56].text = "Did anyone require repeated blood transfusion?";
    states[56].isMcq = true;
    //state57
    states[57].text =
        "Did anyone suffer from gross weakness from early childhood?";
    states[57].isMcq = true;
    //state58
    states[58].text =
        "Did anyone suffer from childhood, what doctor called lack of blood?";
    states[58].isMcq = true;
    //state59
    states[59].text =
        "Did anyone suffer from gross weakness from early childhood?";
    states[59].isMcq = true;
    //Treatent History Module
    //state60
    states[60].text = "Old medical notes/prescription available?";
    states[60].isMcq = true;
    //state61
    states[61].text = "Diagnosed as chronic anaemia?";
    states[61].isMcq = true;
    //state62
    states[62].text = "Treated with drugs only?";
    states[62].isMcq = true;
    //state63
    states[63].text = "Blood transfused?";
    states[63].isMcq = true;
    //state64
    states[64].text = "Enter number(T) of transfusions?";
    states[64].isInt = true;
    //state65
    states[65].text = "Hereditary anaemia?";
    states[65].isMcq = true;
    //state66
    states[66].text = "Any acute blood loss?";
    states[66].isMcq = true;
    //state67
    states[67].text = "Resulting into anaemia?";
    states[67].isMcq = true;
    //state68
    states[68].text = "Requiring hospitalization?";
    states[68].isMcq = true;
    //state69
    states[69].text = "Treated at home?";
    states[69].isMcq = true;
    //state70
    states[70].text = "Drug continued for more than one month after normal Hb?";
    states[70].isMcq = true;
    //state71
    states[71].text = "Diagnosed for bloodlessness?";
    states[71].isMcq = true;
    //state72
    states[72].text = "Treated with drugs for bloodlessness?";
    states[72].isMcq = true;
    //state73
    states[73].text = "Blood transfused?";
    states[73].isMcq = true;
    //state74 //BLoodlessness wala
    states[74].text = "Enter number of transfusions(T)?";
    states[74].isInt = true;
    //state75
    states[75].text = "Diagnosed as familial anaemia?";
    states[75].isMcq = true;
    //state76
    states[76].text = "Had massive bleeding from wound or ulcer?";
    states[76].isMcq = true;
    //state77
    states[77].text =
        "Had massive &/or prolonged bleeding from internal organs?";
    states[77].isMcq = true;
    //state78
    states[78].text = "Resulted into bloodlessness?";
    states[78].isMcq = true;
    //state79
    states[79].text = "START THE FINAL MODULE";
    states[79].isMcq = false;
  }
  int NextState(int curr, dynamic answer) {
    if (answer == "back") {
      Tuple2<FormState, int> f = formStack.last;
      this.currState = f.item1.stateNumber;
      formStack.removeLast();
      s = formStack.last.item2;
      return this.currState;
    }
    print(answer);
    states[curr].answer = answer;
    if (curr == 0) {
      if (answer == "yes") this.currState++;
    } else if (curr == 1) {
      if (answer == "yes") {
        this.currState++;
      } else {
        this.currState = 6;
      }
    } else if (curr == 2) {
      if (answer == "yes") {
        this.currState++;
      }
      if (answer == "no") {
        this.currState++;
        s++;
      }
    } else if (curr == 3) {
      if (answer == "yes") {
        this.currState++;
        s++;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 4) {
      if (answer == "yes") {
        this.currState = 6;
        s += 2;
      }
      if (answer == "no") this.currState++;
    } else if (curr == 5) {
      if (answer == "yes") {
        this.currState++;
        s++;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 6) {
      if (answer == "yes") {
        this.currState++;
      }
      if (answer == "no") {
        this.currState = 11;
      }
    } else if (curr == 7) {
      if (answer == "yes") {
        this.currState++;
        s++;
      }
      if (answer == "no") {
        this.currState++;
        s++;
      }
    } else if (curr == 8) {
      if (answer == "yes") {
        this.currState++;
        s += 2;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 9) {
      if (answer == "yes") {
        this.currState += 2;
        s += 2;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 10) {
      if (answer == "yes") {
        this.currState++;
        s += 1;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 11) {
      if (answer == "yes") {
        this.currState++;
      }
      if (answer == "no") {
        this.currState = 17;
      }
    } else if (curr == 12) {
      if (answer == "yes") {
        this.currState++;
      }
      if (answer == "no") {
        this.currState = 15;
        s++;
      }
    } else if (curr == 13) {
      if (answer == "yes") {
        this.currState = 21;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 14) {
      if (answer == "yes") {
        this.currState = 21;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 15) {
      if (answer == "yes") {
        this.currState += 2;
        s += 2;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 16) {
      if (answer == "yes") {
        this.currState++;
        s += 1;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 17) {
      if (answer == "yes") {
        this.currState++;
      }
      if (answer == "no") {
        this.currState = 22;
      }
    } else if (curr == 18) {
      if (answer == "yes") {
        this.currState++;
      }
      if (answer == "no") {
        this.currState += 2;
      }
    } else if (curr == 19) {
      this.currState = 20;
    } else if (curr == 20) {
      this.currState = 22;
    } else if (curr == 21) {
      this.currState++;
    } else if (curr == 22) {
      if (answer == "yes") {
        this.currState++;
      }
      if (answer == "no") {
        this.currState = 34;
      }
    } else if (curr == 23) {
      this.currState++;
    } else if (curr == 24) {
      if (answer == "yes") {
        this.currState = 26;
      }
      if (answer == "no") {
        this.currState = 25;
      }
    } else if (curr == 25) {
      if (answer == "yes") {
        this.currState = 30;
      }
      if (answer == "no") {
        s = s + states[23].answer;
        this.currState = 44;
      }
    } else if (curr == 26) {
      this.currState++;
    } else if (curr == 27) {
      if (answer == "yes") {
        this.currState = 28;
      }
      if (answer == "no") {
        this.currState = 44;
        s = s - (states[26].answer * 2);
      }
    } else if (curr == 28) {
      this.currState++;
      int e = states[26].answer;
      int f = states[28].answer;
      print("Reached here");
      print(f);

      s = s - ((e - f) * 2) + (f * 2);
    } else if (curr == 29) {
      if (answer == "yes") {
        this.currState = 31;
      }
      if (answer == "no") {
        this.currState = 33;
      }
    } else if (curr == 30) {
      this.currState = 29;
      int c = states[23].answer;
      int d = states[30].answer;
      s = s + (c - d) + (d * 3);
    } else if (curr == 31) {
      this.currState = 44;
    } else if (curr == 33) {
      this.currState = 44;
    } else if (curr == 34) {
      if (answer == "yes") {
        this.currState = 44;
        s = s + 1;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 35) {
      if (answer == "yes") {
        this.currState = 44;
        s += 2;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 36) {
      if (answer == "yes") {
        this.currState = 44;
        s += 2;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 37) {
      if (answer == "yes") {
        this.currState = 44;
        s += 1;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 38) {
      if (answer == "yes") {
        this.currState = 44;
        s += 1;
      }
      if (answer == "no") {
        if (age > 12 && sex == "female")
          this.currState = 39;
        else if (age > 16 && age < 20 && sex == "female")
          this.currState = 40;
        else if (age > 16 && age < 25 && sex == "female")
          this.currState = 41;
        else if (age > 16 && sex == "female")
          this.currState = 42;
        else if (age < 10 && sex == "female") this.currState = 43;
      }
    } else if (curr == 39) {
      if (answer == "yes") {
        this.currState = 44;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 40) {
      if (answer == "yes") {
        this.currState = 44;
        s += 1;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 41) {
      if (answer == "yes") {
        this.currState = 44;
        s += 1;
      }
      if (answer == "no") {
        this.currState++;
      }
    } else if (curr == 42) {
      if (answer == "yes") {
        this.currState = 44;
        s += 1;
      }
      if (answer == "no") {
        this.currState = 44;
      }
    } else if (curr == 43) {
      if (answer == "yes") {
        this.currState = 44;
        s += 1;
      }
      if (answer == "no") {
        this.currState = 44;
      }
    } else if (curr == 44) {
      this.currState++;
    } else if (curr == 45) {
      this.currState++;
    } else if (curr == 46) {
      this.currState++;
    } else if (curr == 47) {
      this.currState++;
    } else if (curr == 48) {
      this.currState++;
    } else if (curr == 49) {
      this.currState++;
    } else if (curr == 50) {
      this.currState++;
      //S UPDATE LOGIC HERE ADD //PENDING
    } else if (curr == 51) {
      if (answer == "yes") {
        this.currState = 52;
      }
      if (answer == "no") {
        this.currState = 56;
      }
    } else if (curr == 52) {
      if (answer == "yes") {
        this.currState = 53;
        s += 1;
      }
      if (answer == "no") {
        this.currState = 53;
      }
    } else if (curr == 53) {
      if (answer == "yes") {
        this.currState = 54;
        s += 3;
      }
      if (answer == "no") {
        this.currState = 54;
      }
    } else if (curr == 54) {
      if (answer == "yes") {
        this.currState = 55;
        s += 1;
      }
      if (answer == "no") {
        this.currState = 55;
      }
    } else if (curr == 55) {
      if (answer == "yes") {
        this.currState = 56;
        s += 3;
      }
      if (answer == "no") {
        this.currState = 60;
      }
    } else if (curr == 56) {
      if (answer == "yes") {
        this.currState += 1;
        s += 1;
      }
      if (answer == "no") {
        this.currState += 1;
      }
    } else if (curr == 57) {
      if (answer == "yes") {
        this.currState += 1;
        s += 1;
      }
      if (answer == "no") {
        this.currState += 1;
      }
    } else if (curr == 58) {
      if (answer == "yes") {
        this.currState += 1;
        s += 1;
      }
      if (answer == "no") {
        this.currState += 1;
      }
    } else if (curr == 59) {
      if (answer == "yes") {
        this.currState += 1;
        s += 1;
      }
      if (answer == "no") {
        this.currState += 1;
      }
    } else if (curr == 60) {
      if (answer == "yes") {
        this.currState = 61;
      }
      if (answer == "no") {
        this.currState = 71;
      }
    } else if (curr == 61) {
      if (answer == "yes") {
        this.currState = 62;
      }
      if (answer == "no") {
        this.currState = 66;
      }
    } else if (curr == 62) {
      if (answer == "yes") {
        this.currState = 70;
        s -= 1;
      }
      if (answer == "no") {
        this.currState = 63;
      }
    } else if (curr == 63) {
      if (answer == "yes") {
        this.currState = 64;
      }
      if (answer == "no") {
        this.currState = 64;
      }
    } else if (curr == 64) {
      int t = states[64].answer;
      s = s + (t * 2);
      this.currState = 65;
    } else if (curr == 65) {
      if (answer == "yes") {
        this.currState = 66;
        s += 5;
      }
      if (answer == "no") {
        this.currState = 66;
      }
    } else if (curr == 65) {
      if (answer == "yes") {
        this.currState = 79;
        s += 5;
      }
      if (answer == "no") {
        this.currState = 66;
      }
    } else if (curr == 66) {
      if (answer == "yes") {
        this.currState = 67;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 67) {
      if (answer == "yes") {
        this.currState = 67;
        s += 1;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 68) {
      if (answer == "yes") {
        this.currState = 67;
        s += 3;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 69) {
      if (answer == "yes") {
        this.currState = 67;
        s += 1;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 70) {
      if (answer == "yes") {
        this.currState = 65;
        s -= 5;
      }
      if (answer == "no") {
        this.currState = 65;
      }
    } else if (curr == 71) {
      if (answer == "yes") {
        this.currState = 72;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 72) {
      if (answer == "yes") {
        this.currState = 73;
        s -= 1;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 73) {
      if (answer == "yes") {
        this.currState = 74;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 74) {
      this.currState = 75;
      int t = states[74].answer;
      s += (t * 2);
    } else if (curr == 75) {
      if (answer == "yes") {
        this.currState = 76;
        s += 5;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 76) {
      if (answer == "yes") {
        this.currState = 77;
      }
      if (answer == "no") {
        this.currState = 77;
      }
    } else if (curr == 77) {
      if (answer == "yes") {
        this.currState = 78;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    } else if (curr == 78) {
      if (answer == "yes") {
        this.currState = 79;
        s = s + 1;
      }
      if (answer == "no") {
        this.currState = 79;
      }
    }
    formStack.add(Tuple2(states[curr], s));
    return this.currState;
  }
}

enum TtsState { playing, stopped }

class _DataFormState extends State<DataForm> {
  FormStateList stateList = new FormStateList();
  int currState = 0;
  String dropdownValue;
  String mcqValue;
  String textValue;

  //Flutter TTS
  FlutterTts flutterTts;
  dynamic languages;
  String language = "hi-IN";
  double pitch = 1.0;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  initState() {
    super.initState();
    initTts();
    initStt();
  }

  TextEditingController _textEditingController = TextEditingController();
  initStt() {
    _speech = stt.SpeechToText();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print("$_text");
            if (_text == "yes") {
              if (stateList.states[currState].isMcq) {
                setState(() {
                  mcqValue = "yes";
                });
              }
            } else if (_text == "no") {
              if (stateList.states[currState].isMcq) {
                setState(() {
                  mcqValue = "no";
                });
              }
            } else if (isNumeric(_text)) {
              print("Reached here");
              setState(() {
                _textEditingController.text = _text;
                textValue = _text;
              });
            }
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    print("pritty print ${languages}");
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts.setPitch(pitch);
    await flutterTts.setVoice("hi-in-x-hic-network");
    await flutterTts.setSpeechRate(1);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Help'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text(
                    'This is a Anaemia Detection Bot. It will ask you question related to your problem and give directions on basis of your response.'),
                new Text(
                    'You can go back and forward using the blue and green button provided'),
                new Text(
                  'Answers the questions carefully.',
                  style: TextStyle(color: Colors.redAccent),
                )
              ],
            ),
          ),
          actions: [
            new FlatButton(
              color: Color(0xFFBF828A),
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(stateList.states[currState].text);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: GestureDetector(
            onLongPressStart: (_) => _listen(),
            onLongPressUp: () {
              setState(() => _isListening = false);
              _speech.stop();
              print("lstening   : $_isListening");
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              height: 60,
              width: 60,
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Color(0xFFBF828A),
              ),
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: ClipOval(
                          child: Material(
                            color: Theme.of(context).accentColor,
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: IconButton(
                                icon: Icon(
                                  Icons.help,
                                  color: Color(0xFFBF828A),
                                ),
                                onPressed: () {
                                  this._showcontent();
                                },
                              ),
                            ),
                          ),
                        )),
                    Padding(
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
                                  setState(() {
                                    _newVoiceText =
                                        stateList.states[currState].text;
                                  });
                                  _speak();
                                },
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width,
                  backgroundColor: Theme.of(context).accentColor,
                  animation: true,
                  lineHeight: 3.0,
                  animationDuration: 20,
                  percent: currState / 80,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Color(0xFFBF828A),
                  // center: Text("Progress"),
                ),
              ),
              (stateList.states[currState].isMcq)
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              stateList.states[currState].text,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 5.0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  mcqValue = "yes";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: mcqValue == "yes"
                                      ? Theme.of(context).accentColor
                                      : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Color(0xFFBF828A),
                                      value: "yes",
                                      groupValue: mcqValue,
                                      onChanged: (String value) {
                                        setState(() {
                                          mcqValue = value;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: mcqValue == "yes"
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 5.0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  mcqValue = "no";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: mcqValue == "no"
                                      ? Theme.of(context).accentColor
                                      : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Color(0xFFBF828A),
                                      value: "no",
                                      groupValue: mcqValue,
                                      onChanged: (String value) {
                                        setState(() {
                                          mcqValue = value;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: mcqValue == "no"
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
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
                                  int newState =
                                      stateList.NextState(currState, "back");
                                  setState(() {
                                    currState = newState;
                                  });
                                },
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15.0),
                                color: Color(0xFFBF828A),
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onPressed: () {
                                  int newState =
                                      stateList.NextState(currState, mcqValue);

                                  setState(() {
                                    mcqValue = "";
                                    currState = newState;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : (stateList.states[currState].isDropdown)
                      ? Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(
                                        width: 2.0, color: Colors.blue)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        stateList.states[currState].text,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 30),
                                      ),
                                      const SizedBox(height: 20),
                                      Divider(
                                        color: Colors.blue,
                                      ),
                                      DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.blueAccent,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                        },
                                        items: stateList
                                            .states[currState].options
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.blue, // button color
                                          child: InkWell(
                                            splashColor:
                                                Colors.red, // inkwell color
                                            child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child: Icon(
                                                    Icons.navigate_before)),
                                            onTap: () {
                                              int newState =
                                                  stateList.NextState(
                                                      currState, "back");
                                              setState(() {
                                                currState = newState;
                                              });
                                            },
                                          ),
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors
                                              .greenAccent, // button color
                                          child: InkWell(
                                            splashColor:
                                                Colors.red, // inkwell color
                                            child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child:
                                                    Icon(Icons.navigate_next)),
                                            onTap: () {
                                              int newState =
                                                  stateList.NextState(
                                                      currState, dropdownValue);
                                              setState(() {
                                                currState = newState;
                                              });
                                            },
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                      : (stateList.states[currState].isInt)
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            stateList.states[currState].text,
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          elevation: 5.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 5.0),
                                            child: TextFormField(
                                              cursorColor: Color(0xFFBF828A),
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _textEditingController,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Your Answer'),
                                              onChanged: (text) {
                                                textValue = text;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
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
                                          int newState = stateList.NextState(
                                              currState, "back");
                                          setState(() {
                                            currState = newState;
                                          });
                                        },
                                      ),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 15.0),
                                        color: Color(0xFFBF828A),
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          try {
                                            print(" text value is $textValue");
                                            int newState = stateList.NextState(
                                                currState,
                                                int.parse(textValue));

                                            setState(() {
                                              currState = newState;
                                              textValue = "";
                                            });
                                          } catch (e) {
                                            print("Reached here");
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    SafeArea(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 40, horizontal: 10),
                                        child: Text(
                                          stateList.states[currState].text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: ClipOval(
                                              child: Material(
                                                color:
                                                    Colors.blue, // button color
                                                child: InkWell(
                                                  splashColor: Colors
                                                      .red, // inkwell color
                                                  child: SizedBox(
                                                      width: 56,
                                                      height: 56,
                                                      child: Icon(Icons
                                                          .navigate_before)),
                                                  onTap: () {
                                                    int newState =
                                                        stateList.NextState(
                                                            currState, "back");
                                                    setState(() {
                                                      currState = newState;
                                                    });
                                                  },
                                                ),
                                              ),
                                            )),
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: ClipOval(
                                              child: Material(
                                                color: Colors
                                                    .greenAccent, // button color
                                                child: InkWell(
                                                  splashColor: Colors
                                                      .red, // inkwell color
                                                  child: SizedBox(
                                                      width: 56,
                                                      height: 56,
                                                      child: Icon(
                                                          Icons.navigate_next)),
                                                  onTap: () {
                                                    int newState =
                                                        stateList.NextState(
                                                            currState,
                                                            dropdownValue);
                                                    setState(() {
                                                      currState = newState;
                                                    });
                                                  },
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
