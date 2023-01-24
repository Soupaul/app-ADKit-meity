import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../resources/api.dart';

class TrendGraph extends StatefulWidget {
  @override
  _TrendGraphState createState() => _TrendGraphState();
}

class _TrendGraphState extends State<TrendGraph> {
  // List<Color> gradientColors = [
  //   const Color(0xff23b6e6),
  //   const Color(0xff02d39a),
  // ];
  DocumentSnapshot? userData;

  @override
  void initState() {
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get()
    //     .then((value) {
    //   setState(() {
    //     userData = value;
    //   });
    // });
    userData = API.profileData;
    super.initState();
  }

  int _calcAge(String dob) {
    DateTime dt = DateTime.parse(dob);
    Duration diff = DateTime.now().difference(dt);

    int age = (diff.inDays / 365).floor();

    return age;
  }

  List<FlSpot> _normalRange(int age) {
    double normalVal;
    if (age <= 5) {
      normalVal = 11;
    } else if (age > 5 && age <= 11) {
      normalVal = 11.5;
    } else if (age > 11 && age < 15) {
      normalVal = 12;
    } else {
      if (userData!['gender'] == "Female") {
        normalVal = 12;
      } else {
        normalVal = 13;
      }
    }

    return [FlSpot(1, normalVal), FlSpot(12, normalVal)];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Card(
                    elevation: 10,
                    color: Theme.of(context).accentColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xFFBF828A), //Color(0xFFBF828A),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.trendGraph,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 30,
              // ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  // color: Color(0xff232d37),
                  color: Theme.of(context).accentColor,
                  // color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("profiles")
                        .doc(API.current_profile_id)
                        .collection('results')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
                        snapshot.hasData && userData != null
                            ? LineChart(
                                mainData(snapshot.data!.docs),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFBF828A)),
                              )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData mainData(List<dynamic> plotData) {
    return LineChartData(
      axisTitleData: FlAxisTitleData(
        show: true,
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: '${AppLocalizations.of(context)!.haemoglobin} (gm/dl)',
          textStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: AppLocalizations.of(context)!.month,
          textStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        // topTitle: AxisTitle(
        //   showTitle: true,
        //   titleText: 'Alice',
        //   textStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        // ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          if (value % 2 == 0)
            return FlLine(
              strokeWidth: 0,
            );
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'J';
              case 2:
                return 'F';
              case 3:
                return 'M';
              case 4:
                return 'A';
              case 5:
                return 'M';
              case 6:
                return 'J';
              case 7:
                return 'J';
              case 8:
                return 'A';
              case 9:
                return 'S';
              case 10:
                return 'O';
              case 11:
                return 'N';
              case 12:
                return 'D';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value % 2 != 0) return value.toStringAsFixed(0);
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 1,
      maxX: 12,
      minY: 3,
      maxY: 16,
      lineBarsData: [
        LineChartBarData(
          // spots: [
          //   FlSpot(2.6, 12.5),
          //   FlSpot(4.9, 12.9),
          //   FlSpot(6.8, 13.2),
          //   FlSpot(8, 13),
          //   FlSpot(9.5, 13.3),
          // ],
          spots: plotData.map((data) {
            double hb_val = data['hb_val'].toDouble();
            int month = DateTime.fromMicrosecondsSinceEpoch(
                    data['time'].microsecondsSinceEpoch)
                .toLocal()
                .month;
            return FlSpot(month.toDouble(), hb_val);
          }).toList(),
          // isCurved: true,
          colors: [Color(0xFFBF828A)],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          // belowBarData: BarAreaData(
          //   show: true,
          //   colors:
          //       gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          // ),
        ),
        // LineChartBarData(
        //   spots: [
        //     FlSpot(1, 15.5),
        //     FlSpot(12, 15.5),
        //   ],
        //   // isCurved: true,
        //   colors: [Colors.green],
        //   barWidth: 3,
        //   isStrokeCapRound: true,
        //   dotData: FlDotData(
        //     show: true,
        //   ),
        //   // belowBarData: BarAreaData(
        //   //   show: true,
        //   //   colors:
        //   //       gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        //   // ),
        // ),
        LineChartBarData(
          spots: _normalRange(_calcAge(userData!['dob'])),
          // isCurved: true,
          colors: [Colors.green],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          // belowBarData: BarAreaData(
          //   show: true,
          //   colors:
          //       gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          // ),
        ),
      ],
    );
  }
}
