import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
          return BarTooltipItem(
            rod.toY.toString(),
            const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
          );
        },
      ),
    );

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mn';
      break;
    case 1:
      text = 'Te';
      break;
    case 2:
      text = 'Wd';
      break;
    case 3:
      text = 'Tu';
      break;
    case 4:
      text = 'Fr';
      break;
    case 5:
      text = 'St';
      break;
    case 6:
      text = 'Sn';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, space: 4, child: Text(text, style: style));
}

FlTitlesData get titlesData => const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

FlBorderData get borderData => FlBorderData(show: false);

LinearGradient get _barsGradient => const LinearGradient(
      colors: [
        Colors.blueAccent,
        Colors.redAccent,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

List<BarChartGroupData> barGroups = [];

void updateBarGroups(List<double> toYValues) {
  barGroups = List.generate(
    toYValues.length,
    (index) => BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: toYValues[index],
          gradient: _barsGradient,
        ),
      ],
      showingTooltipIndicators: [0],
    ),
  );
}
