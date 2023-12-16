import 'package:finance_fate/company_data_tile.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ChipSelection { closing, opening, adjacentClosing, high, low, volume }

class ActualDataTabView extends StatefulWidget {
  const ActualDataTabView({
    super.key,
    required this.company,
    required this.showChart,
  });

  final Company company;
  final bool showChart;

  @override
  State<ActualDataTabView> createState() => _ActualDataTabViewState();
}

class _ActualDataTabViewState extends State<ActualDataTabView> {
  double getY(CompanyData data) {
    late double y;

    if (selection == ChipSelection.adjacentClosing) {
      y = data.adjClose;
    } else if (selection == ChipSelection.closing) {
      y = data.close;
    } else if (selection == ChipSelection.opening) {
      y = data.open;
    } else if (selection == ChipSelection.high) {
      y = data.high;
    } else if (selection == ChipSelection.low) {
      y = data.low;
    } else if (selection == ChipSelection.volume) {
      y = data.volume.toDouble();
    }

    return y;
  }

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: List<FlSpot>.generate(
        widget.company.data.length,
        (index) {
          CompanyData data = widget.company.data[index];
          int x = data.date.millisecondsSinceEpoch;
          double y = getY(data);

          return FlSpot(x.toDouble(), y);
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

  ChipSelection selection = ChipSelection.closing;

  @override
  Widget build(BuildContext context) {
    return widget.showChart == true
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
                Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(
                        onSelected: (value) => setState(() {
                              selection = ChipSelection.opening;
                            }),
                        label: const Text('Open'),
                        selected: selection == ChipSelection.opening),
                    ChoiceChip(
                        onSelected: (value) => setState(() {
                              selection = ChipSelection.closing;
                            }),
                        label: const Text('Close'),
                        selected: selection == ChipSelection.closing),
                    ChoiceChip(
                        onSelected: (value) => setState(() {
                              selection = ChipSelection.adjacentClosing;
                            }),
                        label: const Text('Adjacent Close'),
                        selected: selection == ChipSelection.adjacentClosing),
                    ChoiceChip(
                        onSelected: (value) => setState(() {
                              selection = ChipSelection.high;
                            }),
                        label: const Text('High'),
                        selected: selection == ChipSelection.high),
                    ChoiceChip(
                        onSelected: (value) => setState(() {
                              selection = ChipSelection.low;
                            }),
                        label: const Text('Low'),
                        selected: selection == ChipSelection.low),
                    ChoiceChip(
                        onSelected: (value) => setState(() {
                              selection = ChipSelection.volume;
                            }),
                        label: const Text('Volume'),
                        selected: selection == ChipSelection.volume),
                  ],
                ),
              ],
            ),
          )
        : Scrollbar(
            interactive: true,
            child: ListView.builder(
              itemCount: widget.company.data.length,
              itemBuilder: (context, index) {
                CompanyData data = widget.company.data[index];
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
