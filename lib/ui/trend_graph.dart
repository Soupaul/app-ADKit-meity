import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrendGraph extends StatefulWidget {
  @override
  _TrendGraphState createState() => _TrendGraphState();
}

class _TrendGraphState extends State<TrendGraph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

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
                    "Trend Graph",
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
              Expanded(
                child: Container(
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
                    child: LineChart(
                      mainData(),
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

  LineChartData mainData() {
    return LineChartData(
      axisTitleData: FlAxisTitleData(
        show: true,
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: 'Haemoglobin (gm/dl)',
          textStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: 'Month',
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
          if (value % 2 != 0)
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
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value % 2 == 0) return value.toStringAsFixed(0);
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 24,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(2.6, 12.5),
            FlSpot(4.9, 12.9),
            FlSpot(6.8, 13.2),
            FlSpot(8, 13),
            FlSpot(9.5, 13.3),
          ],
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
        LineChartBarData(
          spots: [
            FlSpot(0, 15.5),
            FlSpot(11, 15.5),
          ],
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
        LineChartBarData(
          spots: [
            FlSpot(0, 12),
            FlSpot(11, 12),
          ],
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
