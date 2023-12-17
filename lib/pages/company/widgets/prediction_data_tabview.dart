import 'dart:math';

import 'package:finance_fate/pages/company/widgets/header.dart';
import 'package:finance_fate/pages/company/widgets/legend_symbol.dart';
import 'package:finance_fate/pages/company/widgets/selection_enums.dart';
import 'package:finance_fate/pages/home/widgets/company_data_tile.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PredictionDataTabView extends StatefulWidget {
  const PredictionDataTabView({
    super.key,
    required this.company,
    required this.showChart,
  });

  final Company company;
  final bool showChart;

  @override
  State<PredictionDataTabView> createState() => _PredictionDataTabViewState();
}

class _PredictionDataTabViewState extends State<PredictionDataTabView> {
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

  List<FlSpot> predictionData() {
    List<FlSpot> data = List<FlSpot>.generate(
      widget.company.data.length,
      (index) {
        CompanyData data = widget.company.data[index];
        int x = data.date.millisecondsSinceEpoch;
        double y = getY(data) + (Random().nextInt(21) - 10);
        y = y < 0 ? 0 : y;

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                    width: 8,
                  ),
                  AspectRatio(
                    aspectRatio: 2,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          enabled: true,
                          getTouchedSpotIndicator:
                              (LineChartBarData barData, List<int> indicators) {
                            return indicators.map(
                              (int index) {
                                const line = FlLine(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  // dashArray: [2, 4],
                                );
                                return const TouchedSpotIndicatorData(
                                  line,
                                  FlDotData(show: false),
                                );
                              },
                            ).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                            tooltipRoundedRadius: 20.0,
                            fitInsideVertically: true,
                            showOnTopOfTheChartBoxArea: true,
                            fitInsideHorizontally: true,
                            tooltipMargin: 0,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map(
                                (LineBarSpot touchedSpot) {
                                  CompanyData data = widget
                                      .company.data[touchedSpot.spotIndex];

                                  return LineTooltipItem(
                                    "${DateFormat('dd MMM yyyy').format(data.date)}\n${getY(data)}",
                                    const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ).toList();
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              color: Colors.white12,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 20,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final DateTime date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());

                                const TextStyle style = TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                );

                                DateFormat dateFormatter = dateRangeSelection ==
                                        DateRangeSelection.oneYear
                                    ? DateFormat.MMM()
                                    : DateFormat('dd MMM');

                                return Text(
                                  dateFormatter.format(date),
                                  style: style,
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 60,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  NumberFormat.compactCurrency(
                                          symbol: '\$', decimalDigits: 0)
                                      .format(value),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData(),
                            color: Colors.green,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: predictionData(),
                            color: Colors.purple.shade400,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16, width: 16),
                      const SectionHeader(header: 'Legend'),
                      const SizedBox(height: 12, width: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LegendSymbol(
                            legendLabel: 'Actual data',
                            legendColor: Colors.green,
                          ),
                          const SizedBox(width: 40),
                          LegendSymbol(
                            legendLabel: 'Predicted data',
                            legendColor: Colors.purple.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: SectionHeader(header: 'Stock pricing'),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      ChoiceChip(
                          onSelected: (value) =>
                              setPricingSelection(PricingSelection.opening),
                          label: const Text('Open'),
                          selected:
                              pricingSelection == PricingSelection.opening),
                      ChoiceChip(
                          onSelected: (value) =>
                              setPricingSelection(PricingSelection.closing),
                          label: const Text('Close'),
                          selected:
                              pricingSelection == PricingSelection.closing),
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
                          selected:
                              pricingSelection == PricingSelection.volume),
                    ],
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 4.0),
                    child: SectionHeader(header: "Date range"),
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
                        selected: dateRangeSelection ==
                            DateRangeSelection.threeMonths,
                        onSelected: (value) => setDateRangeSelection(
                            DateRangeSelection.threeMonths),
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
