import 'package:finance_fate/company_data_tile.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PricingSelection { closing, opening, adjacentClosing, high, low, volume }

enum DateRangeSelection { fiveDays, oneMonth, threeMonths, oneYear }

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

    if (pricingSelection == PricingSelection.adjacentClosing) {
      y = data.adjClose;
    } else if (pricingSelection == PricingSelection.closing) {
      y = data.close;
    } else if (pricingSelection == PricingSelection.opening) {
      y = data.open;
    } else if (pricingSelection == PricingSelection.high) {
      y = data.high;
    } else if (pricingSelection == PricingSelection.low) {
      y = data.low;
    } else if (pricingSelection == PricingSelection.volume) {
      y = data.volume.toDouble();
    }

    return y;
  }

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: chartData(),
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

  List<FlSpot> chartData() {
    List<FlSpot> data = List<FlSpot>.generate(
      widget.company.data.length,
      (index) {
        CompanyData data = widget.company.data[index];
        int x = data.date.millisecondsSinceEpoch;
        double y = getY(data);

        return FlSpot(x.toDouble(), y);
      },
    );

    if (dateRangeSelection == DateRangeSelection.oneYear) return data;
    if (dateRangeSelection == DateRangeSelection.oneMonth) {
      return data
          .where((element) =>
              DateTime.now()
                  .difference(
                      DateTime.fromMillisecondsSinceEpoch(element.x.toInt()))
                  .inDays <=
              30)
          .toList();
    }
    if (dateRangeSelection == DateRangeSelection.fiveDays) {
      return data
          .where((element) =>
              DateTime.now()
                  .difference(
                      DateTime.fromMillisecondsSinceEpoch(element.x.toInt()))
                  .inDays <=
              5)
          .toList();
    }
    if (dateRangeSelection == DateRangeSelection.threeMonths) {
      return data
          .where((element) =>
              DateTime.now()
                  .difference(
                      DateTime.fromMillisecondsSinceEpoch(element.x.toInt()))
                  .inDays <=
              30 * 3)
          .toList();
    }

    return data;
  }

  final List<Color> _gradientColors = const [
    Color(0xFF6FFF7C),
    Color(0xFF0087FF),
    Color(0xFF5620FF),
  ];

//TodO: add proper x-axis legends according to chip selection
  AxisTitles _bottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final DateTime date =
              DateTime.fromMillisecondsSinceEpoch(value.toInt());

          const TextStyle style = TextStyle(
            color: Colors.white54,
            fontSize: 14,
          );

          return Text(
            DateFormat.MMM().format(date),
            style: style,
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

  PricingSelection pricingSelection = PricingSelection.closing;
  DateRangeSelection dateRangeSelection = DateRangeSelection.oneYear;

  void setPricingSelection(PricingSelection selected) {
    setState(() {
      pricingSelection = selected;
    });
  }

  void setDateRangeSelection(DateRangeSelection selected) {
    setState(() {
      dateRangeSelection = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.showChart == true
        ? Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: Text('Stock pricing'),
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(
                        onSelected: (value) =>
                            setPricingSelection(PricingSelection.opening),
                        label: const Text('Open'),
                        selected: pricingSelection == PricingSelection.opening),
                    ChoiceChip(
                        onSelected: (value) =>
                            setPricingSelection(PricingSelection.closing),
                        label: const Text('Close'),
                        selected: pricingSelection == PricingSelection.closing),
                    ChoiceChip(
                        onSelected: (value) => setPricingSelection(
                            PricingSelection.adjacentClosing),
                        label: const Text('Adjacent Close'),
                        selected: pricingSelection ==
                            PricingSelection.adjacentClosing),
                    ChoiceChip(
                        onSelected: (value) =>
                            setPricingSelection(PricingSelection.high),
                        label: const Text('High'),
                        selected: pricingSelection == PricingSelection.high),
                    ChoiceChip(
                        onSelected: (value) =>
                            setPricingSelection(PricingSelection.low),
                        label: const Text('Low'),
                        selected: pricingSelection == PricingSelection.low),
                    ChoiceChip(
                        onSelected: (value) =>
                            setPricingSelection(PricingSelection.volume),
                        label: const Text('Volume'),
                        selected: pricingSelection == PricingSelection.volume),
                  ],
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, top: 4.0),
                  child: Text("Date range"),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text("5 days"),
                      selected:
                          dateRangeSelection == DateRangeSelection.fiveDays,
                      onSelected: (value) =>
                          setDateRangeSelection(DateRangeSelection.fiveDays),
                    ),
                    ChoiceChip(
                      label: const Text("1 Month"),
                      selected:
                          dateRangeSelection == DateRangeSelection.oneMonth,
                      onSelected: (value) =>
                          setDateRangeSelection(DateRangeSelection.oneMonth),
                    ),
                    ChoiceChip(
                      label: const Text("3 Month"),
                      selected:
                          dateRangeSelection == DateRangeSelection.threeMonths,
                      onSelected: (value) =>
                          setDateRangeSelection(DateRangeSelection.threeMonths),
                    ),
                    ChoiceChip(
                      label: const Text("1 Year"),
                      selected:
                          dateRangeSelection == DateRangeSelection.oneYear,
                      onSelected: (value) =>
                          setDateRangeSelection(DateRangeSelection.oneYear),
                    ),
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
