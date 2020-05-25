import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/models/basal_time.dart';

class BasalPlanChart extends StatelessWidget {
  final BasalPlan plan;
  final Color lineColor;
  final Color gridColor;
  final TextStyle titleStyle;

  const BasalPlanChart({
    @required this.plan,
    this.lineColor = Colors.white,
    this.gridColor = Colors.white30,
    this.titleStyle,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxHorizontalRange = BasalTime.latest.asEncoded;

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
              spots: plan.segments.expand((segment) {
                return [
                  FlSpot(segment.start.asEncoded.toDouble(), segment.basalRate),
                  FlSpot(segment.end.asEncoded.toDouble(), segment.basalRate),
                ];
              }).toList(),
              colors: [
                lineColor,
              ])
        ],
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 12,
            getTitles: (value) => value.toString(),
            textStyle: titleStyle,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            interval: (maxHorizontalRange / 2.0).toDouble(),
            getTitles: (value) => BasalTime.decode(value.toInt()).format(),
            textStyle: titleStyle,
          ),
          rightTitles: SideTitles(
            showTitles: true,
            reservedSize: 8,
            interval: double.infinity,
            getTitles: (value) => null,
          ),
        ),
        gridData: FlGridData(
          horizontalInterval: 0.5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: gridColor,
            strokeWidth: 1,
          ),
        ),
        lineTouchData: LineTouchData(enabled: false),
        minX: 0,
        maxX: maxHorizontalRange.toDouble(),
        minY: 0,
        maxY: 3.0,
      ),
    );
  }
}
