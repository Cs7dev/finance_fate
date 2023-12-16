import 'package:finance_fate/company_data_tile.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActualDataTabView extends StatelessWidget {
  const ActualDataTabView({
    super.key,
    required this.company,
    required this.showChart,
  });

  final Company company;
  final bool showChart;

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: List<FlSpot>.generate(
        company.data.length,
        (index) {
          int x = company.data[index].date.millisecondsSinceEpoch;
          return FlSpot(x.toDouble(), company.data[index].close);
        },
      ),
      gradient: LinearGradient(
        colors: _gradientColors,
        stops: const [0.25, 0.5, 0.75],
        begin: const Alignment(0.5, 0),
        end: const Alignment(0.5, 1),
      ),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          stops: const [0.25, 0.5, 0.75],
        ),
      ),
    );
  }

  final List<Color> _gradientColors = const [
    Color(0xFF6FFF7C),
    Color(0xFF0087FF),
    Color(0xFF5620FF),
  ];

  AxisTitles _bottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final DateTime date =
              DateTime.fromMillisecondsSinceEpoch(value.toInt());

          return Text(
            DateFormat.MMM().format(date),
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          );
        },

        // getTitles: (value) {},
        // margin: 8,
        // interval: (_maxX - _minX) / 6,
        //
      ),
    );
  }

  AxisTitles _leftTitles() {
    return AxisTitles(
        sideTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        return Text(
          NumberFormat.compactCurrency(symbol: '\$').format(value),
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        );
      },
      reservedSize: 28,
      // margin: 12,
      // interval: _leftTitlesInterval,
    ));
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      // checkToShowHorizontalLine: (value) {
      //   return (value - _minY) % _leftTitlesInterval == 0;
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    return showChart == true
        ? Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width - 20,
                  child: LineChart(
                    LineChartData(
                      gridData: _gridData(),
                      titlesData: FlTitlesData(
                        bottomTitles: _bottomTitles(),
                        leftTitles: _leftTitles(),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      lineBarsData: [_lineBarData()],
                    ),
                  ),
                ),
                const Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(label: Text('Open'), selected: false),
                    ChoiceChip(label: Text('Close'), selected: true),
                    ChoiceChip(label: Text('Adjacent Close'), selected: false),
                    ChoiceChip(label: Text('High'), selected: false),
                    ChoiceChip(label: Text('Low'), selected: false),
                    ChoiceChip(label: Text('Volume'), selected: false),
                  ],
                ),
              ],
            ),
          )
        : Scrollbar(
            interactive: true,
            child: ListView.builder(
              itemCount: company.data.length,
              itemBuilder: (context, index) {
                CompanyData data = company.data[index];
                return CompanyDataTile(
                  adjClose: data.adjClose,
                  close: data.close,
                  high: data.high,
                  low: data.low,
                  open: data.open,
                  volume: data.volume,
                  date: data.date,
                );
              },
            ),
          );
  }
}
